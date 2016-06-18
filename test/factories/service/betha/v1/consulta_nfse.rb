FactoryGirl.define do
	factory :servico_betha_consulta_nfse, class:  BrNfe::Service::Betha::V1::ConsultaNfse do
		numero_nfse  '5566778'
		data_inicial { Date.yesterday }
		data_final   { Date.today }
		emitente     { FactoryGirl.build(:emitente) }
	end
end