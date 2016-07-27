FactoryGirl.define do
	factory :service_sc_gaspar_consulta_situacao_lote_rps, class:  BrNfe::Service::SC::Gaspar::ConsultaSituacaoLoteRps do
		protocolo '1234567890'
		emitente  { FactoryGirl.build(:emitente) }
	end
end