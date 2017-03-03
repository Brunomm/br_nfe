FactoryGirl.define do
	factory :service_pe_recife_v1_base, class:  BrNfe::Service::PE::Recife::V1::Base do
		emitente  { FactoryGirl.build(:service_emitente) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end