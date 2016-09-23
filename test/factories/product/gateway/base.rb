FactoryGirl.define do
	factory :product_gateway_base, class:  BrNfe::Product::Gateway::Base do
		env :test
	end
end