FactoryGirl.define do
	factory :br_nfe_servico_base, class:  BrNfe::Service::Base do
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end