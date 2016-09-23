FactoryGirl.define do
	factory :service_simpliss_v1_consulta_nfse, class:  BrNfe::Service::Simpliss::V1::ConsultaNfse do
		emitente  { FactoryGirl.build(:service_emitente) }
		nfe_number  '5566778'
		start_date { Date.yesterday }
		end_date   { Date.today }
	end
end