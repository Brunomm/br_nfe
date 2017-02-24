FactoryGirl.define do
	factory :service_pe_recife_v1_consulta_situacao_lote_rps, class:  BrNfe::Service::PE::Recife::V1::ConsultaSituacaoLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		protocolo '1234567890'
	end
end