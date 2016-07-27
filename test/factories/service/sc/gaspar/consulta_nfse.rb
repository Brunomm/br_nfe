FactoryGirl.define do
	factory :service_sc_gaspar_consulta_nfse, class:  BrNfe::Service::SC::Gaspar::ConsultaNfse do
		emitente  { FactoryGirl.build(:emitente) }
		nfe_number  '5566778'
		start_date { Date.yesterday }
		end_date   { Date.today }
	end
end