
FactoryGirl.define do
	factory :service_sc_gaspar_consulta_lote_rps, class:  BrNfe::Service::SC::Gaspar::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
		protocolo '1234567890'
	end
end