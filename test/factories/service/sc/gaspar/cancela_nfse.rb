FactoryGirl.define do
	factory :service_sc_gaspar_cancela_nfse, class:  BrNfe::Service::SC::Gaspar::CancelaNfse do
		nfe_number '3365'
		codigo_cancelamento '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
		emitente  { FactoryGirl.build(:emitente) }
	end
end