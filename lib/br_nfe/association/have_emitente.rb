module BrNfe
	module Association
		module HaveEmitente
			
			def emitente
				yield emitente if block_given?
				@emitente.is_a?(emitente_class) ? @emitente : @emitente = emitente_class.new()
			end


			def emitente=(value)
				if value.is_a?(emitente_class) || value.nil?
					@emitente = value
				elsif value.is_a?(Hash)
					emitente.assign_attributes(value)
				end
			end
		private
			def emitente_class
				raise "O método #emitente_class deve ser implementado na classe #{self.class}"
			end
		end
	end
end