module BrNfe
	module Servico
		module Betha
			module V1
				class ConsultaNfsPorRps < BrNfe::Servico::Betha::V1::Gateway

					def wsdl
						"http://e-gov.betha.com.br/e-nota-contribuinte-#{'test-' if env == :test}ws/consultarNfsePorRps?wsdl"
					end

					def method_wsdl
						:consultar_nfse_por_rps
					end

					################################ DADOS DO RPS ###############################
					def rps
						yield rps if block_given?
						@rps.is_a?(BrNfe::Servico::Rps) ? @rps : (@rps = BrNfe::Servico::Rps.new)
					end

					def rps=(value)
						if value.is_a?(BrNfe::Servico::Rps) || value.nil? 
							@rps = value
						elsif value.is_a?(Hash)
							rps.assign_attributes(value)
						end
					end
					#############################################################################

					def xml_builder
						Nokogiri::XML::Builder.new do |xml|
							xml.Temp {
								tag_identificacao_rps(xml, rps)
								tag_prestador(xml)								
							}
						end.doc.root
					end

					def set_response(resp)
						@response = BrNfe::Servico::Betha::V1::Response.new(xml: resp.hash[:envelope][:body][:consultar_nfse_por_rps_envio_response], nfe_method: :consultar_nfse_rps)
					end
					
				end
			end
		end
	end
end