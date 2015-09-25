FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_recepcao_lote_rps, class:  BrNfe::Servico::Betha::V2::RecepcaoLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
	end
end