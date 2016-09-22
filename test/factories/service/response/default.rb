FactoryGirl.define do
	factory :response_service_default, class:  BrNfe::Service::Response::Default do
		status          :success
		error_messages   { [] }
	end
end