FactoryGirl.define do
	factory :service_sc_floripa_emission_rps, class:  BrNfe::Service::SC::Florianopolis::EmissionRPS do
		cfps 5525
		aedf 123456
		emitente  { FactoryGirl.build(:emitente) }
	end
end