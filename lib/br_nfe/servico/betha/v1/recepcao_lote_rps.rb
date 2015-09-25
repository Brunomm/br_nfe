module BrNfe
	module Servico
		module Betha
			module V1
				class RecepcaoLoteRps < BrNfe::Servico::Betha::V1::Gateway
					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/recepcionarLoteRps?wsdl"
					end
					def method_wsdl
						:enviar_lote_rps
					end

					def certificado_obrigatorio?
						true
					end

					validates :numero_lote_rps, presence: true
					validate  :validar_lote_rps

					def xml_builder
						xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.Temp {
								xml_lote_rps = lote_rps_xml.doc.root
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_lote_rps.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_lote_rps.to_s, "#lote#{numero_lote_rps}") )
							}
						end.doc
						
						canonicalize(xml.root())
					end
					
					def lote_rps_xml
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.LoteRps("Id" => "lote#{numero_lote_rps}"){
								xml.NumeroLote BrNfe::Helper.only_number(numero_lote_rps).max_size(15)
								tag_cpf_cnpj(xml, emitente.cnpj)
								
								xml.InscricaoMunicipal "#{emitente.inscricao_municipal}".max_size(15) if env == :production

								xml.QuantidadeRps lote_rps.size
								xml.ListaRps {
									xml.Rps do |xml_rps|
										lote_rps.each do |rps|
											xml_informacao_rps = xml_inf_rps(rps).doc.root
											xml_rps.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_informacao_rps.to_s ) 
											xml_rps.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml( xml_informacao_rps.to_s, "#rps#{rps.numero}" ) )
										end
									end
								}
							}
						end
					end

					def xml_inf_rps(rps)
						Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
							xml.InfRps('Id' => "rps#{rps.numero}") {
								
								# Identificação RPS
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_identificacao_rps(rps).doc.root.to_s )

								xml.DataEmissao              value_date_time(rps.data_emissao)
								xml.NaturezaOperacao         "#{emitente.natureza_operacao}".max_size(2)
								xml.RegimeEspecialTributacao "#{emitente.regime_especial_tributacao}".max_size(2) unless emitente.regime_especial_tributacao.blank? # Código de identificação do regime especial de tributação: (1)Microempresa municipal, (2)Estimativa, (3)Sociedade de profissionais, (4)Cooperativa, (5)Microempresário Individual (MEI), (6)Microempresário e Empresa de Pequeno Porte (ME EPP) , 
								xml.OptanteSimplesNacional   value_true_false(emitente.optante_simples_nacional?)   # (1)sim ----- (2)não -----
								xml.IncentivadorCultural     value_true_false(emitente.incentivo_fiscal?)           # (1)sim ----- (2)não -----
								xml.Status                   "#{rps.status}".max_size(1)

								# RPS subistituido
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_rps_substituido(rps).doc.root.to_s )
								
								# Dados do(s) serviço(s)
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_dados_servico(rps).doc.root.to_s )

								# Pestador / Emitente
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_prestador.doc.root.to_s )

								# Tomador / Destinatário
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_dados_tomador(rps.destinatario).doc.root.to_s )

								# Intermediario
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_intermediario_servico(rps.intermediario).doc.root.to_s )

								# Dados Construção Civil
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_dados_construcao_civil(rps).doc.root.to_s )

								xml.OutrasInformacoes "#{rps.outras_informacoes}".max_size(255) unless rps.outras_informacoes.blank?

								# Condição de pagamento
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_condicao_pagamento(rps).doc.root.to_s )
							}
						end
					end
				end
			end
		end
	end
end