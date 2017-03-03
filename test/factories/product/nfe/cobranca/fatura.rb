FactoryGirl.define do
	factory :product_cobranca_fatura, class:  BrNfe::Product::Nfe::Cobranca::Fatura do
		numero_fatura  'EX336'
		valor_original 1_500.0
		valor_desconto 100.0
		valor_liquido  1_400.0
	end
end