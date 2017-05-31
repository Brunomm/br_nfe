module BrNfe
	module Product
		module Response
			class NfeAutorizacao < Base
				has_many :notas_fiscais, 'BrNfe.nota_fiscal_product_class'

				attr_accessor :average_time
				alias_attribute :tempo_medio, :average_time
				alias_attribute :tMed, :average_time
			end
		end
	end
end