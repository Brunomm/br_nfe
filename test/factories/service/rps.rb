FactoryGirl.define do
	factory :br_nfe_rps, class:  BrNfe::Service::Rps do
		destinatario       { FactoryGirl.build(:destinatario) }
		numero             556
		serie              'SN'
		tipo               '1'
		data_emissao       DateTime.now
		status             '1'
		competencia        Date.today
		total_services     '349.00'
		total_iss          '6.98'
		iss_tax_rate       '0.02'
		base_calculation   '349.00'
		iss_retained       '2'
		item_lista_servico '0107'
		description        "MENSALIDADE PLANO PRO. 349,00 \n\nValor Aprox dos Tributos: R$ 6,59 Federal, R$ 0,00 Estadual e R$ 1,62 Municipal \n Fonte: IBPT/FECOMERCIO SC 5oi7eW"
		codigo_municipio   '4204202'
		cnae_code          '6202300'
		items              { [ FactoryGirl.build(:service_item, unit_value: total_services, quantity: 1) ] }

		trait :completo do
			codigo_tributacao_municipio '6699'
			condicao_pagamento        { FactoryGirl.build(:condicao_pagamento, :a_prazo) }
			intermediario             { FactoryGirl.build(:intermediario) }
			numero_substituicao       '555'
			serie_substituicao        'SN'
			tipo_substituicao         '1'
			codigo_obra               '66'
			codigo_art                '223'
			outras_informacoes        'info a mais'
			total_base_calculation_st 55.77
			total_issqn_st            4.87
			deductions                7.0
			valor_pis                 1.123
			valor_cofins              2.123
			valor_inss                3.123
			valor_ir                  4.123
			valor_csll                5.123
			outras_retencoes          6.123
			desconto_incondicionado   7.123
			desconto_condicionado     8.123
			responsavel_retencao      '1'
			exigibilidade_iss         '5'
			numero_processo           '6546'
			iss_retained              true
			total_iss_retained        5.55
			net_value                 349.00
			municipio_incidencia     '111'
		end
	end
end