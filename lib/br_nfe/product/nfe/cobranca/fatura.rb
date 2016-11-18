module BrNfe
	module Product
		module Nfe
			module Cobranca
				class Fatura < BrNfe::ActiveModelBase
					# Número da fatura
					# 
					# <b>Type: </b> _String_
					# <b>Max: </b> _60_
					# <b>Required: </b> _No_
					# <b>Exemplo: </b> _FAT646498_
					#
					attr_accessor :numero_fatura

					# Valor original da fatura
					# 
					# <b>Type: </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo: </b> _1500.50_
					#
					attr_accessor :valor_original

					# Valor do desconto da fatura
					# 
					# <b>Type: </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo: </b> _100.25_
					#
					attr_accessor :valor_desconto

					# Valor do liquido da fatura
					# 
					# <b>Type: </b> _Float_
					# <b>Required: </b> _No_
					# <b>Default: </b> _Auto_
					# <b>Exemplo: </b> _1400.25_
					#
					attr_accessor :valor_liquido
					def valor_liquido
						@valor_liquido || calculate_valor_liquido
					end

					has_many :duplicatas, 'BrNfe.duplicata_product_class', 
					         validations: :invalid_duplicata, 
					         length: {maximum: 120}

				private
					def calculate_valor_liquido
						valor_original.to_f - valor_desconto.to_f
					end
				end
			end
		end
	end
end