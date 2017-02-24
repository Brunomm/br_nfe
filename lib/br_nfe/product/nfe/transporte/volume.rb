module BrNfe
	module Product
		module Nfe
			module Transporte
				class Volume < BrNfe::ActiveModelBase
					# Quantidade de volumes transportados
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>tag:      </b> qVol
					#
					attr_accessor :quantidade
					alias_attribute :qVol, :quantidade

					# Espécie dos volumes transportados
					# Exemplo: 'CAIXA', 'SACOLA', 'MALOTE'
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>tag:      </b> esp
					#
					attr_accessor :especie
					alias_attribute :esp, :especie

					# Marca dos volumes transportados
					# Exemplo: 'LINDOYA', 'NIKE', 'COCA COLA'
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>tag:      </b> marca
					#
					attr_accessor :marca

					# Numeração dos volumes transportados
					# Exemplo: 'EXT12124', '500'
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_
					# <b>tag:      </b> nVol
					#
					attr_accessor :numercao
					alias_attribute :nVol, :numercao

					# Peso líquido do volume EM Kg
					# Exemplo: 
					#   13.5 = 13 Kilos e 500 gramas
					#   100.003 = 100 Kilos e 3 gramas
					#
					# <b>Type: </b> _Number_
					# <b>Required: </b> _No_
					# <b>tag:      </b> pesoL
					#
					attr_accessor :peso_liquido
					alias_attribute :pesoL, :peso_liquido

					# Peso bruto do volume EM Kg
					# Exemplo: 
					#   13.5 = 13 Kilos e 500 gramas
					#   100.003 = 100 Kilos e 3 gramas
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>tag:      </b> pesoB
					#
					attr_accessor :peso_bruto
					alias_attribute :pesoB, :peso_bruto

					# Número dos Lacres (NT 2012/003)
					# Exemplo: 
					#   ['XYZ10231486', 123456879]
					#
					# <b>Type:     </b> _Array_
					# <b>Required: </b> _No_
					# <b>Length:   </b> _max: 5000_
					# <b>tag:      </b> lacres
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