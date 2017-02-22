FactoryGirl.define do
	factory :service_ginfes_v1_consulta_nfs_por_rps, class:  BrNfe::Service::Ginfes::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end