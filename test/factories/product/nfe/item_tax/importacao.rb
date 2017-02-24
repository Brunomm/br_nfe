FactoryGirl.define do
	factory :product_item_tax_importacao, class:  BrNfe::Product::Nfe::ItemTax::Importacao do
		total_base_calculo        450.20
		total_despesas_aduaneiras 100.30
		total_imposto             60.40
		total_iof                 70.5
	end
end