module BrNfe
	module Product
		module Nfe
			module Transporte
				class Transportador  < BrNfe::Person
					
				private
					def validate_regime_tributario?
						false
					end
				end
			end
		end
	end
end