module BrNfe
	module Service
		module Betha
			module V1
				class Gateway < BrNfe::Service::Betha::Base
					def message_namespaces
						{"xmlns:ns1" => "http://www.betha.com.br/e-nota-contribuinte-ws"}
					end

					def soap_namespaces
						super.merge(message_namespaces)
					end

					def namespace_identifier
						'ns1:'
					end
				end
			end
		end
	end
end