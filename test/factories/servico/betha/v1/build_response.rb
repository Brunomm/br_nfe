FactoryGirl.define do
	factory :betha_v1_build_response, class:  BrNfe::Servico::Betha::V1::BuildResponse do
		hash       { {first_key_resposta: {protocolo: '123', data_recebimento: Date.today, numero_lote: '111'} } }
		nfe_method :first_key
	end
end