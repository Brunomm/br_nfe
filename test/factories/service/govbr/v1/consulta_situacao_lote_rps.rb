FactoryGirl.define do
	factory :service_govbr_v1_consulta_situacao_lote_rps, class:  BrNfe::Service::Govbr::V1::ConsultaSituacaoLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		protocolo '1234567890'
	end
end