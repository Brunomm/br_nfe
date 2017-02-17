module BrNfe
	module Product
		module Nfe
			module ItemTax
				class PisSt < BrNfe::ActiveModelBase
					# VALOR DA BASE DE CÁLCULO DO PIS ST
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst in [01 02])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBC, :total_base_calculo

					# ALÍQUOTA DO PIS (EM PERCENTUAL)
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst in [01 02])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> pPIS
					# 
					attr_accessor :aliquota
					alias_attribute :pPIS, :aliquota

					# VALOR DO PIS
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_ (No if cst in [04 05 06 07 08 09])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> vPIS
					# 
					attr_accessor :total
					alias_attribute :vPIS, :total

					# QUANTIDADE VENDIDA
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst is 03)
					# <b>Example:  </b> _10.0_
					# <b>Length:   </b> _12v0-4_
					# <b>tag:      </b> qBCProd
					# 
					attr_accessor :quantidade_vendida
					alias_attribute :qBCProd, :quantidade_vendida

					# ALÍQUOTA DO PIS (EM REAIS)
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst is 03)
					# <b>Example:  </b> _10.0_
					# <b>Length:   </b> _11v0-4_
					# <b>tag:      </b> vAliqProd
					# 
					attr_accessor :total_aliquota
					alias_attribute :vAliqProd, :total_aliquota
					
					validates :total, presence: true
					validates :total,              numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :total_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :aliquota,           numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :quantidade_vendida, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :total_aliquota,     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
				end
			end
		end
	end
end