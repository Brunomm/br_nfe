FactoryGirl.define do
	factory :service_ciga_v1_consulta_nfs_por_rps, class:  BrNfe::Service::Ciga::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end