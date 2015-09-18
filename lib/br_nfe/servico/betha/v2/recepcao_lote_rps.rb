module BrNfe
	module Servico
		module Betha
			module V2
				class RecepcaoLoteRps < BrNfe::Servico::Betha::V2::Gateway
					def method_wsdl
						:recepcionar_lote_rps
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.EnviarLoteRpsEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml_lote_rps = lote_rps_xml.doc.root

								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_lote_rps.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_lote_rps.to_s, "#lote#{numero_lote_rps}") )
							}
						end.doc.root
						
						canonicalize xml
					end

					
					def lote_rps_xml
						xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.LoteRps("Id" => "lote#{numero_lote_rps}", versao: "2.02"){
								xml.NumeroLote BrNfe::Helper.only_number(numero_lote_rps).max_size(15)
								xml.CpfCnpj {
									tag_cpf_cnpj(xml, emitente.cnpj)
								}
								# O Ambiente de homologação da Betha não aceita Inscrição Municipal (baita ambiente de homologação)
								xml.InscricaoMunicipal emitente.inscricao_municipal.max_size(15) if !emitente.inscricao_municipal.blank? && env == :production

								xml.QuantidadeRps lote_rps.size
								xml.ListaRps {
									lote_rps.each do |obj_rps|
										xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_rps_assinado(obj_rps).doc.root.to_s)
									end
								}
							}						
						end
					end
				end
			end
		end
	end
end