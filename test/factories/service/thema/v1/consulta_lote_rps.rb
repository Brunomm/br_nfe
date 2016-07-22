
FactoryGirl.define do
	factory :service_thema_v1_consulta_lote_rps, class:  BrNfe::Service::Thema::V1::ConsultaLoteRps do
		emitente  { FactoryGirl.build(:emitente) }
		protocolo '1234567890'
	end
end