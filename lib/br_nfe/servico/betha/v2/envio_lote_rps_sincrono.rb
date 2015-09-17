module BrNfe
	module Servico
		module Betha
			module V2
				class EnvioLoteRpsSincrono < BrNfe::Servico::Betha::V2::RecepcaoLoteRps					
					def method_wsdl
						:recepcionar_lote_rps_sincrono
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.EnviarLoteRpsSincronoEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml_lote_rps = lote_rps_xml.doc.root

								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_lote_rps.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_lote_rps.to_s, "#lote#{numero_lote_rps}") )
							}
						end.doc.root
						
						canonicalize xml
					end
				end
			end
		end
	end
end