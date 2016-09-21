module BrNfe
	module Association
		module HaveDestinatario
			def destinatario
				yield(destinatario) if block_given?
				@destinatario.is_a?(destinatario_class) ? @destinatario : @destinatario = destinatario_class.new()
			end

			def destinatario=(value)
				if value.is_a?(destinatario_class) || value.nil?
					@destinatario = value
				elsif value.is_a?(Hash)
					destinatario.assign_attributes(value)
				end
			end
		private
			def destinatario_class
				raise "O método #destinatario_class deve ser implementado na class #{self.class}"
			end
		end
	end
end