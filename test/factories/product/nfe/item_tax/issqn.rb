FactoryGirl.define do
	factory :product_item_tax_issqn, class:  BrNfe::Product::Nfe::ItemTax::Issqn do
		codigo_servico        1234567
		total_base_calculo    300.50
		aliquota              2.5
		total                 308.01
		municipio_ocorrencia  4216008
	end
end