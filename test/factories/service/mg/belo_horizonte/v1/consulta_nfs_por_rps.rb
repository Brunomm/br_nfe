FactoryGirl.define do
	factory :br_nfe_service_mg_bh_v1_consulta_nfs_por_rps, class:  BrNfe::Service::MG::BeloHorizonte::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end