module BrNfe
	module Association
		module HaveAddress
			
			def validar_endereco
				if endereco.invalid?
					endereco.errors.full_messages.each { |msg| errors.add(:base, "Endereço: #{msg}") }
				end	
			end			

			def endereco
				yield(endereco) if block_given?
				@endereco.is_a?(BrNfe.endereco_class) ? @endereco : @endereco = BrNfe.endereco_class.new()
			end

			def endereco=(value)
				if value.is_a?(BrNfe.endereco_class) 
					@endereco = value
				elsif value.is_a?(Hash)
					endereco.assign_attributes(value)
				end
			end
		end
	end
end