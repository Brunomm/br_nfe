FactoryGirl.define do
	factory :br_nfe_servico_betha_v2_envio_lote_rps_sincrono, class:  BrNfe::Service::Betha::V2::EnvioLoteRpsSincrono do
		emitente  { FactoryGirl.build(:emitente) }
	end
end