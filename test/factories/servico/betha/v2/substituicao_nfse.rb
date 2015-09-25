FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_substituicao_nfse, class:  BrNfe::Servico::Betha::V2::SubstituicaoNfse do
		emitente  { FactoryGirl.build(:emitente) }
		rps  { FactoryGirl.build(:br_nfe_rps) }
	end
end