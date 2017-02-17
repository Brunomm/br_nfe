FactoryGirl.define do
	factory :product_gateway_web_service_ba, class:  BrNfe::Product::Gateway::WebServiceBA do
		env :test
	end
end