FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_gera_nfse, class:  BrNfe::Service::Betha::V2::GeraNfse do
		emitente  { FactoryGirl.build(:emitente) }
		rps { FactoryGirl.build(:br_nfe_rps) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end