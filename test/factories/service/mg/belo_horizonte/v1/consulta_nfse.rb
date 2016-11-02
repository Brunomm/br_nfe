FactoryGirl.define do
	factory :br_nfe_service_mg_bh_v1_consulta_nfse, class:  BrNfe::Service::MG::BeloHorizonte::V1::ConsultaNfse do
		emitente  { FactoryGirl.build(:service_emitente) }
		nfe_number  '5566778'
		start_date { Date.yesterday }
		end_date   { Date.today }
	end
end