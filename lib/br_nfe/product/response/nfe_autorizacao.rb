module BrNfe
	module Product
		module Response
			class NfeAutorizacao < Base
				has_many :notas_fiscais, 'BrNfe.nota_fiscal_product_class'

				attr_accessor :tempo_medio
				alias_attribute :tMed, :tempo_medio
			end
		end
	end
end