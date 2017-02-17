FactoryGirl.define do
	factory :product_cobranca_duplicata, class:  BrNfe::Product::Nfe::Cobranca::Duplicata do
		numero_duplicata 'EX336'
		total            1_500.0
		vencimento       Date.tomorrow
	end
end