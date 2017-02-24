FactoryGirl.define do
	factory :service_pe_recife_v1_recepcao_lote_rps, class:  BrNfe::Service::PE::Recife::V1::RecepcaoLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		numero_lote_rps '123'
		operacao        '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end