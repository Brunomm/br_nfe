module BrNfe
	module Service
		module Betha
			module V1
				class ConsultaNfsPorRps < BrNfe::Service::Betha::V1::Gateway
					include BrNfe::Helper::HaveRps

					validate :validar_rps # metodo definido no module BrNfe::Helper::HaveRps

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfsePorRps?wsdl"
					end

					def method_wsdl
						:consultar_nfse_por_rps
					end

					def xml_builder
						Nokogiri::XML::Builder.new do |xml|
							xml.Temp {
								# Identificação RPS
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_identificacao_rps(rps).doc.root.to_s )

								# Pestador / Emitente
								xml.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( xml_prestador.doc.root.to_s )
							}
						end.doc.root
					end

					def set_response(resp)
						@response = BrNfe::Service::Betha::V1::BuildResponse.new(hash: resp.hash[:envelope][:body][:consultar_nfse_por_rps_envio_response], nfe_method: :consultar_nfse_rps).response
					end
				end
			end
		end
	end
end