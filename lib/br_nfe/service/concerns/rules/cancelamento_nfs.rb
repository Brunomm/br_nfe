module BrNfe
	module Service
		module Concerns
			module Rules
				module CancelamentoNfs
					extend ActiveSupport::Concern

					included do
						
						attr_accessor :nfe_number
						attr_accessor :codigo_cancelamento

						validates :nfe_number, :codigo_cancelamento, presence: true
					end
				end
			end
		end
	end
end
		