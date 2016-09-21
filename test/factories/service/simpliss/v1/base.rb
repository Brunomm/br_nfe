FactoryGirl.define do
	factory :service_simpliss_v1_base, class:  BrNfe::Service::Simpliss::V1::Base do
		emitente  { FactoryGirl.build(:service_emitente) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end