FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_gera_nfse, class:  BrNfe::Servico::Betha::V2::GeraNfse do
		emitente  { FactoryGirl.build(:emitente) }
		rps { FactoryGirl.build(:br_nfe_rps) }
	end
end