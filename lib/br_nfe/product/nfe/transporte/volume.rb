module BrNfe
	module Product
		module Nfe
			module Transporte
				class Volume < BrNfe::ActiveModelBase
					# Quantidade de volumes transportados
					#
					# <b>Type: </b> _Number_
					# <b>Required: </b> _No_
					#
					attr_accessor :quantidade

					# Espécie dos volumes transportados
					# Exemplo: 'CAIXA', 'SACOLA', 'MALOTE'
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_
					#
					attr_accessor :especie

					# Marca dos volumes transportados
					# Exemplo: 'LINDOYA', 'NIKE', 'COCA COLA'
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_
					#
					attr_accessor :marca

					# Numeração dos volumes transportados
					# Exemplo: 'EXT12124', '500'
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_
					#
					attr_accessor :numercao

					# Peso líquido do volume EM Kg
					# Exemplo: 
					#   13.5 = 13 Kilos e 500 gramas
					#   100.003 = 100 Kilos e 3 gramas
					#
					# <b>Type: </b> _Number_
					# <b>Required: </b> _No_
					#
					attr_accessor :peso_liquido

					# Peso bruto do volume EM Kg
					# Exemplo: 
					#   13.5 = 13 Kilos e 500 gramas
					#   100.003 = 100 Kilos e 3 gramas
					#
					# <b>Type: </b> _Number_
					# <b>Required: </b> _No_
					#
					attr_accessor :peso_bruto

					# Número dos Lacres (NT 2012/003)
					# Exemplo: 
					#   ['XYZ10231486', 123456879]
					#
					# <b>Type: </b> _Array_
					# <b>Required: </b> _No_
					# <b>Min: </b> _0_
					# <b>Max: </b> _5000_
					#
					attr_accessor :lacres
					def lacres
						@lacres = [@lacres].flatten.reject(&:blank?)
						@lacres
					end

					validates :lacres, length: {maximum: 5_000}
					validates :especie, :marca, :numercao, length: {maximum: 60}
				end
			end
		end
	end
end