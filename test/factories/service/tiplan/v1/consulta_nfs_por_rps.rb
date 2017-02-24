FactoryGirl.define do
	factory :service_tiplan_v1_consulta_nfs_por_rps, class:  BrNfe::Service::Tiplan::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end