
FactoryGirl.define do
	factory :service_tiplan_v1_consulta_lote_rps, class:  BrNfe::Service::Tiplan::V1::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:service_emitente) }
		protocolo '1234567890'
	end
end