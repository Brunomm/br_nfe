FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_consulta_lote_rps, class:  BrNfe::Service::Betha::V2::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
		protocolo  '65987946798'
		certificate_pkcs12_password 'associacao'
		certificate_pkcs12_path {   "#{BrNfe.root}/test/cert.pfx" }
	end
end