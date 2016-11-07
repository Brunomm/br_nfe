FactoryGirl.define do
	factory :product_transporte_base, class:  BrNfe::Product::Transporte::Base do
		veiculo { FactoryGirl.build(:product_transporte_veiculo) }
	end
end