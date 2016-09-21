module BrNfe
	module Service
		module Association
			module HaveIntermediario
				def intermediario
					yield(intermediario || new_intermediario) if block_given?
					@intermediario.is_a?(BrNfe.intermediario_service_class) ? @intermediario : nil
				end

				def intermediario=(value)
					if value.is_a?(BrNfe.intermediario_service_class) || value.nil? 
						@intermediario = value
					elsif value.is_a?(Hash)
						intermediario ? intermediario.assign_attributes(value) : new_intermediario(value)
					end
				end
				
			protected

				def new_intermediario(params={})
					@intermediario = BrNfe.intermediario_service_class.new(params)
				end
			end
		end
	end
end