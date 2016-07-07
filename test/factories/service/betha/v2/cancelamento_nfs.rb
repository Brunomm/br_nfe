FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_cancelamento_nfs, class:  BrNfe::Service::Betha::V2::CancelamentoNfs do
		emitente  { FactoryGirl.build(:emitente) }
		numero_nfse '5664' 
		codigo_cancelamento  '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end