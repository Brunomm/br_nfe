FactoryGirl.define do
	factory :br_nfe_service_mg_bh_v1_consulta_lote_rps, class:  BrNfe::Service::MG::BeloHorizonte::V1::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		protocolo '1234567890'
	end
end