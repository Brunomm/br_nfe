FactoryGirl.define do
	factory :service_sc_floripa_cancellation, class:  BrNfe::Service::SC::Florianopolis::Cancellation do
		aedf '123456'
		serie_number 1154
		emitente  { FactoryGirl.build(:emitente) }
	end
end