FactoryGirl.define do
	factory :product_item_tax_icms, class:  BrNfe::Product::Nfe::ItemTax::Icms do
		codigo_cst              101
		modalidade_base_calculo 3
		total_base_calculo      150.48
		aliquota                17.0
		mva_st                  14.2
	end
end