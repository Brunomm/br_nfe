# GRUPO IMPOSTO DE IMPORTAÇÃO
# Informar apenas quando o item for sujeito ao II
#
module BrNfe
	module Product
		module Nfe
			module ItemTax
				class Importacao < BrNfe::ActiveModelBase
					
					# VALOR BC DO IMPOSTO DE IMPORTAÇÃO
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _120.00_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBC, :total_base_calculo

					# VALOR DESPESAS ADUANEIRAS
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _120.00_
					# <b>tag:      </b> vDespAdu
					# 
					attr_accessor :total_despesas_aduaneiras
					alias_attribute :vDespAdu, :total_despesas_aduaneiras

					# VALOR IMPOSTO DE IMPORTAÇÃO
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _120.00_
					# <b>tag:      </b> vII
					# 
					attr_accessor :total_imposto
					alias_attribute :vII, :total_imposto

					# VALOR IMPOSTO SOBRE OPERAÇÕES FINANCEIRAS
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _120.00_
					# <b>tag:      </b> vIOF
					# 
					attr_accessor :total_iof
					alias_attribute :vIOF, :total_iof

					validates :total_base_calculo, :total_despesas_aduaneiras,
					          :total_imposto, :total_iof,
					          presence: true

					validates :total_base_calculo, :total_despesas_aduaneiras,
					          :total_imposto,     :total_iof,
					          numericality: {greater_than_or_equal_to: 0.0}, 
					          allow_blank: true
				end
			end
		end
	end
end