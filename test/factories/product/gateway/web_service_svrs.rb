FactoryGirl.define do
	factory :product_gateway_web_service_svrs, class:  BrNfe::Product::Gateway::WebServiceSVRS do
		env :test
	end
end