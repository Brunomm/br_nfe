FactoryGirl.define do
	factory :product_evento_base, class:  BrNfe::Product::Evento::Base do
		# chave              e
		codigo_orgao   91
		chave_nfe      35130407267118000120550000000001231939233471
		data_hora      { Time.current }
		codigo_evento  110111
	end
end