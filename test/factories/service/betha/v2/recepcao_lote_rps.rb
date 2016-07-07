FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_recepcao_lote_rps, class:  BrNfe::Service::Betha::V2::RecepcaoLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end