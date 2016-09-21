FactoryGirl.define do
	factory :service_sc_floripa_base, class:  BrNfe::Service::SC::Florianopolis::Base do
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end