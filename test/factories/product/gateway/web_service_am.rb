FactoryGirl.define do
	factory :product_gateway_web_service_am, class:  BrNfe::Product::Gateway::WebServiceAM do
		env :test
	end
end