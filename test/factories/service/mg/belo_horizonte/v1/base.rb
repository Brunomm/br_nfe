FactoryGirl.define do
	factory :br_nfe_service_mg_bh_v1_base, class:  BrNfe::Service::MG::BeloHorizonte::V1::Base do
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end