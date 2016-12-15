FactoryGirl.define do
	factory :product_evento_cancelamento, class:  BrNfe::Product::Evento::Cancelamento do
		codigo_orgao   91
		chave_nfe      35130407267118000120550000000001231939233471
		data_hora      { Time.current }
		codigo_evento  110111
		protocolo_nfe  '422345678901234'
		justificativa  'CANCELAMENTO DA NF POR FALTA DE PAGAMENTO'
	end
end