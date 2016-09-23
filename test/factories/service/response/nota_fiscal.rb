FactoryGirl.define do
	factory :response_service_nota_fiscal, class:  BrNfe::Service::Response::NotaFiscal do
		intermediario                    { FactoryGirl.build(:intermediario) }
		destinatario                     { FactoryGirl.build(:service_destinatario) }
		emitente                         { FactoryGirl.build(:service_emitente) }
		condicao_pagamento               { FactoryGirl.build(:condicao_pagamento) }
		numero_nf                        "3321"
		codigo_verificacao               "EOSFO55"
		data_emissao                     { DateTime.parse('10/09/2015 03:00:00') }
		rps_numero                       "111"
		rps_serie                        "SN"
		rps_tipo                         "1"
		rps_situacao                     "1"
		data_emissao_rps                 { DateTime.parse('10/09/2015 03:00:00') }
		competencia                      "1"
		outras_informacoes               "outras info"
		item_lista_servico               "0107"
		cnae_code                        ""
		description                      "SERVIÇO SOBRE ALGO"
		codigo_municipio                 "4204202"
		valor_total_servicos                   "100.0"
		deducoes                       "0"
		valor_pis                        "0"
		valor_cofins                     "0"
		valor_inss                       "0"
		valor_ir                         "0"
		valor_csll                       "0"
		iss_retido                     "2"
		total_iss                        "2"
		base_calculo                 "100.0"
		iss_aliquota                     "0.02"
		desconto_condicionado            ""
		desconto_incondicionado          ""
		orgao_gerador_municipio          "4204202"
		orgao_gerador_uf                 "SC"
		cancelamento_codigo              "EDIF222"
		cancelamento_numero_nf           "110"
		cancelamento_cnpj                "12345678901234"
		cancelamento_inscricao_municipal "3333-5"
		cancelamento_municipio           "4204202"
		cancelamento_sucesso             true
		cancelamento_data_hora           { DateTime.parse('11/09/2015 03:00:00') }
		nfe_substituidora                ""
		codigo_obra                      "135"
		codigo_art                       "222"
	end
end