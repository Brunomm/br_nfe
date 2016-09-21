FactoryGirl.define do
	factory :servico_betha_consulta_nfse, class:  BrNfe::Service::Betha::V1::ConsultaNfse do
		nfe_number  '5566778'
		start_date { Date.yesterday }
		end_date   { Date.today }
		emitente     { FactoryGirl.build(:service_emitente) }
	end
end