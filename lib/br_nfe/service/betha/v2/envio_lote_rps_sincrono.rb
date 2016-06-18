module BrNfe
	module Service
		module Betha
			module V2
				class EnvioLoteRpsSincrono < BrNfe::Service::Betha::V2::RecepcaoLoteRps					
					def method_wsdl
						:recepcionar_lote_rps_sincrono
					end
					def certificado_obrigatorio?
						true
					end
					
					validates :numero_lote_rps, presence: true
					validate :validar_lote_rps

					def xml_builder
						xml = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
							xml.EnviarLoteRpsSincronoEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								xml_lote_rps = lote_rps_xml.doc.root

								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_lote_rps.to_s )
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( assinatura_xml(xml_lote_rps.to_s, "#lote#{numero_lote_rps}") )
							}
						end
					end
				end
			end
		end
	end
end