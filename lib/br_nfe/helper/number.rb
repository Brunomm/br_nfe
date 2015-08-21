module BrNfe
	module Helper
		class Number
			def initialize(numero)
				@numero = numero
			end

			def formata_valor_monetario(size=13)
				return ''.rjust(size, '0') if @numero.blank?
				sprintf('%.2f', @numero).delete('.').rjust(size, '0')
			end

		end
	end
end