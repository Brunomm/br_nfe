module BrNfe
	module Product
		module Nfe
			module Cobranca
				class Duplicata < BrNfe::ActiveModelBase
					# Número da duplicata
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Length:   </b> _Max: 60_
					# <b>Exemplo:  </b> _DUP646498_
					# <b>tag:      </b> nDup
					#
					attr_accessor :numero_duplicata
					alias_attribute :nDup, :numero_duplicata

					# Valor da duplicata
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo:  </b> _1500.50_
					# <b>tag:      </b> vDup
					#
					attr_accessor :total
					alias_attribute :vDup, :total

					# Data do vencimento da duplicata
					# 
					# <b>Type:     </b> _Date_
					# <b>Required: </b> _Yes_
					# <b>Exemplo:  </b> _Date.tomorrow_
					# <b>tag:      </b> dVenc
					#
					attr_accessor :vencimento
					alias_attribute :dVenc, :vencimento

					validates :total, presence: true
					validates :total, numericality: {greater_than_or_equal_to: 0.0}
					validates :numero_duplicata, length: {maximum: 60}
				end
			end
		end
	end
end