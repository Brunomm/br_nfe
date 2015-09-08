FactoryGirl.define do
	factory :servico_betha_consulta_lote_rps, class:  BrNfe::Servico::Betha::V1::ConsultaLoteRps do
		protocolo '66665498735135768'
		emitente  { FactoryGirl.build(:emitente) }
	end
end