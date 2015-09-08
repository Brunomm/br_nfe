module BrNfe
	module Helper
		module HaveDestinatario
			def destinatario
				yield(destinatario) if block_given?
				@destinatario.is_a?(BrNfe.destinatario_class) ? @destinatario : @destinatario = BrNfe.destinatario_class.new()
			end

			def destinatario=(value)
				if value.is_a?(BrNfe.destinatario_class) || value.nil?
					@destinatario = value
				elsif value.is_a?(Hash)
					destinatario.assign_attributes(value)
				end
			end
		end
	end
end