FactoryGirl.define do
	factory :service_thema_v1_consulta_nfs_por_rps, class:  BrNfe::Service::Thema::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end