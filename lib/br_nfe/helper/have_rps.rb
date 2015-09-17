module BrNfe
	module Helper
		module HaveRps
			def rps
				yield rps if block_given?
				@rps.is_a?(BrNfe.rps_class) ? @rps : @rps = BrNfe.rps_class.new
			end

			def rps=(value)
				if value.is_a?(BrNfe.rps_class) || value.nil? 
					@rps = value
				elsif value.is_a?(Hash)
					rps.assign_attributes(value)
				end
			end
			
		end
	end
end