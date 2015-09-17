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
								xml.NumeroLote numero_lote_rps
								tag_cpf_cnpj(xml, emitente.cnpj)
								
								xml.InscricaoMunicipal emitente.inscricao_municipal if env == :production

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
								
								tag_identificacao_rps(xml, rps)

								xml.DataEmissao              data_hora_formatada(rps.data_emissao)
								xml.NaturezaOperacao         emitente.natureza_operacao
								xml.RegimeEspecialTributacao emitente.regime_especial_tributacao # Código de identificação do regime especial de tributação: (1)Microempresa municipal, (2)Estimativa, (3)Sociedade de profissionais, (4)Cooperativa, (5)Microempresário Individual (MEI), (6)Microempresário e Empresa de Pequeno Porte (ME EPP) , 
								xml.OptanteSimplesNacional   emitente.optante_simples_nacional   # (1)sim ----- (2)não
								xml.IncentivadorCultural     emitente.incentivo_fiscal           # (1)sim ----- (2)não
								xml.Status                   rps.status

								tag_rps_substituido(xml, rps)
								
								tag_dados_servico(xml, rps)

								tag_prestador(xml)

								tag_dados_tomador(xml, rps.destinatario)

								tag_intermediario_servico(xml, rps.intermediario)

								tag_dados_construcao_civil(xml, rps)

								xml.OutrasInformacoes rps.outras_informacoes unless rps.outras_informacoes.blank?

								tag_condicao_pagamento(xml, rps)
							}
						end
					end
				end
			end
		end
	end
end