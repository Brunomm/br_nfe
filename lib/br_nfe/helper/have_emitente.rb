module BrNfe
	module Helper
		module HaveEmitente
			
			def emitente
				yield emitente if block_given?
				@emitente.is_a?(BrNfe.emitente_class) ? @emitente : @emitente = BrNfe.emitente_class.new()
			end


			def emitente=(value)
				if value.is_a?(BrNfe.emitente_class) || value.nil?
					@emitente = value
				elsif value.is_a?(Hash)
					emitente.assign_attributes(value)
				end
			end
		end
	end
end