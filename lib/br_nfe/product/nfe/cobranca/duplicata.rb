module BrNfe
	module Product
		module Nfe
			module Cobranca
				class Duplicata < BrNfe::ActiveModelBase
					# Número da duplicata
					# 
					# <b>Type: </b> _String_
					# <b>Max: </b> _60_
					# <b>Required: </b> _No_
					# <b>Exemplo: </b> _DUP646498_
					#
					attr_accessor :numero_duplicata

					# Valor da duplicata
					# 
					# <b>Type: </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo: </b> _1500.50_
					#
					attr_accessor :total

					# Data do vencimento da duplicata
					# 
					# <b>Type: </b> _Date_
					# <b>Required: </b> _Yes_
					# <b>Exemplo: </b> _Date.tomorrow_
					#
					attr_accessor :vencimento

					validates :total, presence: true
					validates :total, numericality: {greater_than_or_equal_to: 0.0}
					validates :numero_duplicata, length: {maximum: 60}
				end
			end
		end
	end
end