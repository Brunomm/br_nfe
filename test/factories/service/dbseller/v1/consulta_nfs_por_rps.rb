FactoryGirl.define do
	factory :service_dbseller_v1_consulta_nfs_por_rps, class:  BrNfe::Service::Dbseller::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end