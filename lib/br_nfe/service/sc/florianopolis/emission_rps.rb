module BrNfe
	module Service
		module SC
			module Florianopolis
				class EmissionRPS < BrNfe::Service::SC::Florianopolis::Base
					attr_accessor :cfps

					validates :cfps, presence: true

					def xml_builder
						render_xml 'inf_requisicao', dir_path: "#{BrNfe.root}/lib/br_nfe/service/sc/florianopolis/xml"
					end
					
				end
			end
		end
	end
end