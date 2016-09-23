FactoryGirl.define do
	factory :servico_betha_consulta_lote_rps, class:  BrNfe::Service::Betha::V1::ConsultaLoteRps do
		protocolo '1234567890'
		emitente  { FactoryGirl.build(:service_emitente) }
	end
end