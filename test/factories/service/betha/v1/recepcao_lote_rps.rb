FactoryGirl.define do
	factory :br_nfe_servico_betha_recepcao_lote_rps, class:  BrNfe::Service::Betha::V1::RecepcaoLoteRps do
		numero_lote_rps '123'
		operacao        '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end