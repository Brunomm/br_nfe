FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_consulta_lote_rps, class:  BrNfe::Servico::Betha::V2::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
		protocolo  '65987946798'
	end
end