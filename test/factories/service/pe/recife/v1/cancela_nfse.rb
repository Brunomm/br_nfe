FactoryGirl.define do
	factory :service_pe_recife_v1_cancela_nfse, class:  BrNfe::Service::PE::Recife::V1::CancelaNfse do
		nfe_number '3365'
		codigo_cancelamento '1'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
		codigo_ibge_municipio_prestacao '4204202'
	end
end