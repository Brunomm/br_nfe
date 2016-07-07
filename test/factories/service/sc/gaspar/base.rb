FactoryGirl.define do
	factory :service_sc_gaspar_base, class:  BrNfe::Service::SC::Gaspar::Base do
		emitente  { FactoryGirl.build(:emitente) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end