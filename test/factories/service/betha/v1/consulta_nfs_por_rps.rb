FactoryGirl.define do
	factory :servico_betha_consulta_nfs_por_rps, class:  BrNfe::Service::Betha::V1::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end