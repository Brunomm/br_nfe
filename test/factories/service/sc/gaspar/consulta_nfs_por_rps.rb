FactoryGirl.define do
	factory :service_sc_gaspar_consulta_nfs_por_rps, class:  BrNfe::Service::SC::Gaspar::ConsultaNfsPorRps do
		rps       { FactoryGirl.build(:br_nfe_rps) }
		emitente  { FactoryGirl.build(:emitente) }
	end
end