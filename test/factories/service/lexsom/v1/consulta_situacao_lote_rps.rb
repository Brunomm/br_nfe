FactoryGirl.define do
	factory :service_lexsom_v1_consulta_situacao_lote_rps, class:  BrNfe::Service::Lexsom::V1::ConsultaSituacaoLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		protocolo '1234567890'
	end
end