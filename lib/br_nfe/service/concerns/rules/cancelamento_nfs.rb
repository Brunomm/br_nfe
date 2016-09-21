module BrNfe
	module Service
		module Concerns
			module Rules
				module CancelamentoNfs
					extend ActiveSupport::Concern

					included do
						
						attr_accessor :nfe_number
						attr_accessor :codigo_cancelamento
						attr_accessor :id_cancelamento

						validates :nfe_number, :codigo_cancelamento, presence: true

						def id_cancelamento
							@id_cancelamento ||= Time.now.strftime('%Y%m%d%H%M%S%9N')
						end

						def response_class
							BrNfe::Service::Response::Cancelamento
						end
					end
				end
			end
		end
	end
end
		