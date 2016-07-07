FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_substituicao_nfse, class:  BrNfe::Service::Betha::V2::SubstituicaoNfse do
		emitente  { FactoryGirl.build(:emitente) }
		rps  { FactoryGirl.build(:br_nfe_rps) }
		numero_nfse '5526'
		codigo_cancelamento '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end