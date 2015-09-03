FactoryGirl.define do
	factory :condicao_pagamento, class:  BrNfe::CondicaoPagamento do
		condicao "A_VISTA"

		trait :a_prazo do
			condicao "A_PRAZO"
			parcelas { [{valor: 10.00, vencimento: Date.parse('15/10/2015')}, {valor: 20.00, vencimento: '15/11/2015'}] }
		end
	end
end