module BrNfe
	module Product
		module Nfe
			module Cobranca
				class Fatura < BrNfe::ActiveModelBase
					# Número da fatura
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Length:   </b> _Max: 60_
					# <b>Exemplo:  </b> _FAT646498_
					# <b>tag:      </b> nFat
					#
					attr_accessor :numero_fatura
					alias_attribute :nFat, :numero_fatura

					# Valor original da fatura
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo:  </b> _1500.50_
					# <b>tag:      </b> vOrig
					#
					attr_accessor :valor_original
					alias_attribute :vOrig, :valor_original

					# Valor do desconto da fatura
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Exemplo:  </b> _100.25_
					# <b>tag:      </b> vDesc
					#
					attr_accessor :valor_desconto
					alias_attribute :vDesc, :valor_desconto

					# Valor do liquido da fatura
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Default:  </b> _Auto_
					# <b>Exemplo:  </b> _1400.25_
					# <b>tag:      </b> vLiq
					#
					attr_accessor :valor_liquido
					def valor_liquido
						@valor_liquido || calculate_valor_liquido
					end
					alias_attribute :vLiq, :valor_liquido

					has_many :duplicatas, 'BrNfe.duplicata_product_class'

					validate_has_many :duplicatas, message: :invalid_duplicata
					validates :duplicatas,         length: {maximum: 120}

				private
					def calculate_valor_liquido
						valor_original.to_f - valor_desconto.to_f
					end
				end
			end
		end
	end
end