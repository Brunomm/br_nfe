module BrNfe
	module Service
		module Concerns
			module Rules
				module ConsultaNfsPorRps
					extend ActiveSupport::Concern

					included do					
						include BrNfe::Service::Association::HaveRps

						validate :validate_rps # metodo definido no module BrNfe::Helper::HaveRps
					end					
				end
			end
		end
	end
end
		