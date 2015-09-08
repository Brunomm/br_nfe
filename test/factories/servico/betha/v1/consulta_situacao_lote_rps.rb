FactoryGirl.define do
	factory :servico_betha_consulta_situacao_lote_rps, class:  BrNfe::Servico::Betha::V1::ConsultaSituacaoLoteRps do
		protocolo '66665498735135768'
		emitente  { FactoryGirl.build(:emitente) }
	end
end