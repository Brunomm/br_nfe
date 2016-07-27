module BrNfe
	module Service
		module Betha
			module V2
				class ConsultaNfsePorRps < BrNfe::Service::Betha::V2::Gateway
					include BrNfe::Helper::HaveRps
					
					def method_wsdl
						:consultar_nfse_por_rps
					end

					def xml_builder
						xml = Nokogiri::XML::Builder.new do |xml|
							xml.ConsultarNfseRpsEnvio(xmlns: "http://www.betha.com.br/e-nota-contribuinte-ws") {
								# Identificação RPS
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_identificacao_rps(rps).doc.root.to_s )

								# Pestador / Emitente
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_prestador.doc.root.to_s )
							}
						end
					end
				end
			end
		end
	end
end