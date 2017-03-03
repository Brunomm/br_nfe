FactoryGirl.define do
	factory :product_cobranca_pagamento, class:  BrNfe::Product::Nfe::Cobranca::Pagamento do
		forma_pagamento    1
		total              150.70
		cartao_cnpj        '12345678901234'
		cartao_bandeira    1
		cartao_autorizacao '1235456'
	end
end