FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_consulta_nfse_por_rps, class:  BrNfe::Service::Betha::V2::ConsultaNfsePorRps do
		emitente  { FactoryGirl.build(:emitente) }
		rps  { FactoryGirl.build(:br_nfe_rps) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end