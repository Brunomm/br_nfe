module BrNfe
	module Product
		module Response
			class NfeConsultaProtocolo < Base
				has_one :nota_fiscal, 'BrNfe.nota_fiscal_product_class'

				has_many :events, 'BrNfe::Product::Response::Event'

				has_one :main_event, 'BrNfe::Product::Response::Event'
				attr_accessor :vers
			end
		end
	end
end