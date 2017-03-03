module BrNfe
	module Product
		module Response
			class NfeRetAutorizacao < Base
				has_many :notas_fiscais, 'BrNfe.nota_fiscal_product_class'
			end
		end
	end
end