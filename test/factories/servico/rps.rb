FactoryGirl.define do
	factory :br_nfe_rps, class:  BrNfe::Servico::Rps do
		destinatario                 { FactoryGirl.build(:destinatario) }
		numero                       556
		serie                        'SN'
		tipo                         '1'
		data_emissao                 DateTime.now
		status                       '1'
		competencia                  Date.today
		valor_servicos               '349.00'
		valor_deducoes               '0.0'
		valor_pis                    '0.0'
		valor_cofins                 '0.0'
		valor_inss                   '0.0'
		valor_ir                     '0.0'
		valor_csll                   '0.0'
		outras_retencoes             '0.0'
		valor_iss                    '6.98'
		aliquota                     '0.02'
		base_calculo                 '349.00'
		desconto_incondicionado      '0.0'
		desconto_condicionado        '0.0'
		iss_retido                   '2'
		responsavel_retencao         ''
		item_lista_servico           '0107'
		discriminacao                "MENSALIDADE PLANO PRO. 349,00 \n\nValor Aprox dos Tributos: R$ 6,59 Federal, R$ 0,00 Estadual e R$ 1,62 Municipal \n Fonte: IBPT/FECOMERCIO SC 5oi7eW"
		exigibilidade_iss            ''
		codigo_municipio             '4204202'
		numero_processo              ''
		codigo_cnae                  '6202300'

		trait :completo do
			codigo_tributacao_municipio '6699'
			condicao_pagamento        { FactoryGirl.build(:condicao_pagamento, :a_prazo) }
		end
	end
end