FactoryGirl.define do
	factory :product_operation_nfe_autorizacao, class:  BrNfe::Product::Operation::NfeAutorizacao do
		env                         :test
		emitente                    { FactoryGirl.build(:product_emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'
		numero_lote                 '550'

		trait :complete do
			notas_fiscais   { FactoryGirl.build(:product_nota_fiscal, invoice_params.merge(emitente: emitente) ) }
		end
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
			invoice_params {{
				destinatario: {
					cpf_cnpj: "907.424.030-50",
					email: "eduardo.lucas.mendes@greenbikeshop.com.br",
					endereco: {
						bairro: "Piratini",
						cep: "94838-420",
						codigo_municipio: 4300604,
						codigo_pais: "1058",
						complemento: "LETRA E",
						logradouro: "Rua Marechal Floriano",
						nome_municipio: "Alvorada",
						nome_pais: "BRASIL",
						numero: "969",
						uf: "RS"
					},
					inscricao_estadual: "9354885042",
					inscricao_municipal: "",
					nome_fantasia: "EDUARDO LUCAS MENDES",
					razao_social: "EDUARDO LUCAS MENDES",
					telefone: "49 2049-3900"
				},
				codigo_tipo_emissao: 1, #Emissão normal (não em contingência);
				codigo_nf:           20160101,
				serie:               1,
				numero_nf:           2,
				natureza_operacao:   'Venda', #Default
				forma_pagamento:     0,  # Pagamento à vista; (Default)
				modelo_nf:           55, # Default
				data_hora_emissao:   Time.current, 
				data_hora_expedicao: Time.current,
				tipo_operacao:       1, # Saída - Default
				tipo_impressao:      1, # DANFE normal, Retrato; (Default)
				finalidade_emissao:  1, # NF-e normal; (Default)
				consumidor_final:    true, # Consumidor final - o Default é false (Normal)
				presenca_comprador:  9, # Operação não presencial, outros. (Default)
				processo_emissao:    0, # Emissão de NF-e com aplicativo do contribuinte; (Default)
				versao_aplicativo:   0, # Default
				endereco_retirada:   {
					bairro:           "São Cristóvão",
					cep:              "89804-023",
					codigo_municipio: '4204202',
					codigo_pais:      "1058",
					complemento:      "D",
					logradouro:       "Rua Afonso Pena - D",
					nome_municipio:   "Chapecó",
					nome_pais:        "BRASIL",
					numero:           "420",
					uf:               "SC"
				},
				endereco_retirada_cpf_cnpj: '23.020.443/0001-40',
				endereco_entrega:    {
					bairro:           "São Cristóvão",
					cep:              "89804-022",
					codigo_municipio: '4204202',
					codigo_pais:      "1058",
					complemento:      "D",
					logradouro:       "Rua Afonso Pena - D",
					nome_municipio:   "Chapecó",
					nome_pais:        "BRASIL",
					numero:           "520",
					uf:               "SC"
				},
				endereco_entrega_cpf_cnpj: '07456193983',
				autorizados_download_xml:  ['07456193983'],
				transporte: {
					modalidade_frete: 1, # Por conta do destinatário/remetente (O Default é 9=Sem frete)
					retencao_valor_sevico:      0.0,
					retencao_base_calculo_icms: 0.0,
					retencao_aliquota:          0.0,
					retencao_valor_icms:        0.0,
					retencao_cfop:              nil,
					retencao_codigo_municipio:  nil,
					forma_transporte:           :veiculo, # Default
					veiculo: {
						placa: 'UJC-5786',
						uf:    'SC',
						rntc:  '215423',
					},
					identificacao_balsa:        nil,
					identificacao_vagao:        nil,
					reboques: [
						{placa: 'UJC-5786',uf: 'SC',rntc: '215423'},
						{placa: 'DUO-1107',uf: 'RS',rntc: '654899'},
					],
					volumes: [
						{
							quantidade: 5, especie: 'CAIXA', marca: 'DUO',
							numercao:   1, peso_liquido: 10.0, peso_bruto: 11.0,
							lacres: ['LAC001','LAC002']
						},
						{
							quantidade: 10, especie: 'SACOLA', marca: 'BR',
							numercao:   2, peso_liquido: 2.0, peso_bruto: 2.25,
							lacres: ['LAC003','LAC004']
						}
					],
					transportador: {
						cpf_cnpj:      '15.114.195/0001-78',
						razao_social:  'Sarah e Valentina Alimentos Ltda',
						nome_fantasia: 'S&V Alimentos',
						telefone:      '(95) 3916-4683',
						email:         'contabilidade@calebethales.com.br',
						endereco: {
							logradouro:       'Rua Itajaí',
							numero:           '453',
							complemento:      '',
							bairro:           'Capibaribe',
							nome_municipio:   'São Lourenço da Mata',
							uf:               'PE',
							cep:              '54705-620',
						}
					},
				},
				fatura: {
					numero_fatura: 'FAT646498',
					valor_original: 2_000.00,
					valor_desconto: 199.50,
					valor_liquido:  1_800.50,
					duplicatas: [
						{numero_duplicata: 'DUP646498', total: 900.25, vencimento: Time.current.since(1.month)},
						{numero_duplicata: 'DUP646499', total: 900.25, vencimento: Time.current.since(2.months)},
					]
				},
				itens: [
					{
						tipo_produto:   :product,
						codigo_produto: 'PD854KL',
						codigo_ean:     '',
						descricao_produto: 'MICROCOMPUTADOR DELL ALL IN ONE INSPIRON 20 3059',
						codigo_ncm:        '84715010',
						codigos_nve:       [],
						codigo_extipi:     nil,
						cfop:              '6101',
						unidade_comercial:    'UN',
						quantidade_comercial: 1.0,
						valor_unitario_comercial: 1_400.50,
						valor_total_produto:      1_400.50,
						codigo_ean_tributavel:    nil,
						unidade_tributavel:       'UN',
						quantidade_tributavel:    1.0,
						valor_unitario_tributavel: 1_400.50,
						total_frete:              50.0,
						total_seguro:             0.0,
						total_desconto:           199.50,
						total_outros:             0.0,
						soma_total_nfe:           true, # Default
						codigo_cest:              nil,
						declaracoes_importacao:   {
							numero_documento:      'DOC123',
							data_registro:         Date.current,
							local_desembaraco:     'Pier 12',
							uf_desembaraco:        'SC',
							data_desembaraco:      Date.current.ago(1.week),
							via_transporte:        1, # Marítima - Default
							valor_afrmm:           150.0,
							tipo_intermediacao:    '3', # encomenda (O default é 1=Importação por conta própria;)
							cnpj_adquirente:       '85.956.707/0001-29',
							uf_terceiro:           'PR',
							codigo_exportador:     '945123',
							adicoes: [
								{
									numero_adicao:     123,
									sequencial:        1,
									codigo_fabricante: 'XINGLING',
									valor_desconto:    0.0,
									numero_drawback:   '20160000012',
								}
							]
						},
						detalhes_exportacao: {
							numero_drawback:    '201612347',
							numero_registro:    '201612347001',
							chave_nfe_recebida: '42000082176985000186540000000000006313331836',
							quantidade:         147.0,
						},
						numero_pedido_compra: 'ETR79813168',
						item_pedido_compra:    1,
						numero_fci: 'B01F70AF-10BF-4B1F-848C-65FF57F616FE',
						total_tributos: 147.87,
						icms: {
							origem: 0, # Nacional - Default
							codigo_cst: 102,
							modalidade_base_calculo: '0',
							reducao_base_calculo:    0.0,
							total_base_calculo:      1400.5,
							aliquota:                12.0,
							total:                   216.06,
							modalidade_base_calculo_st: 0,
							mva_st:                  0.0,
							reducao_base_calculo_st: 0.0,
							total_base_calculo_st:   0.0,
							aliquota_st:             0.0,
							total_st:                0.0,
							total_desoneracao:       0.0,
							motivo_desoneracao:      5,
							total_icms_operacao:     0.0,
							percentual_diferimento:  0.0,
							total_icms_diferido:     0.0,
							total_base_calculo_st_retido:  0.0,
							total_st_retido:         0.0,
							aliquota_credito_sn:     0.0,
							total_credito_sn:        0.0,
						},
						ipi: {
							codigo_cst: '50',
							classe_enquadramento: 'C1324',
							cnpj_produtor:        '00916702000110',
							codigo_selo:          'SEL8724',
							quantidade_selo:      10,
							codigo_enquadramento: 999, # Default
							base_calculo:         1400.5,
							aliquota:             2.5,
							quantidade_unidade:   1,
							total_unidade:        1400.0,
							total:                45.01,
						},
						importacao: {
							total_base_calculo:        1400.50,
							total_despesas_aduaneiras: 300.0,
							total_imposto:             300.0,
							total_iof:                 34.70,
						},
						pis: {
							codigo_cst:         '04',
							total_base_calculo: 1400.50,
							aliquota:           3.0,
							total:              54.02,
							quantidade_vendida: 1,
							total_aliquota:     0.0,
						},
						pis_st: {
							total_base_calculo: 1400.50,
							aliquota:           3.0,
							total:              54.02,
							quantidade_vendida: 1,
							total_aliquota:     0.0,
						},
						cofins: {
							codigo_cst:         '01',
							total_base_calculo: 1400.50,
							aliquota:           3.0,
							total:              54.02,
							quantidade_vendida: 1,
							total_aliquota:     0.0,
						},
						cofins_st: {
							total_base_calculo: 1400.50,
							aliquota:           3.0,
							total:              54.02,
							quantidade_vendida: 1,
							total_aliquota:     0.0,
						},
						issqn:{
							total_base_calculo:          200.0,
							aliquota:                    2.0,
							total:                       20.0,
							municipio_ocorrencia:        4201534,
							codigo_servico:              '12.04',
							total_deducao_bc:            0.0,
							total_outras_retencoes:      0.0,
							total_desconto_incondicionado: 0.0,
							total_desconto_condicionado: 0.0,
							total_iss_retido:            0.0,
							indicador_iss:               1, # Exigível (Default)
							codigo_servico_municipio:    216461,
							municipio_incidencia:        4253214,
							numero_processo:             '12313',
							incentivo_fiscal:            false
						},
						icms_uf_destino: {
							total_base_calculo:          1400.50,
							percentual_fcp:              1.5,
							aliquota_interna_uf_destino: 12.0,
							aliquota_interestadual:      12.0,
							percentual_partilha_destino: 80.0,
							total_fcp_destino:           27.01,
							total_destino:               244.87,
							total_origem:                61.22,
						},
						informacoes_adicionais: 'OBSERVAÇÕES DO PRODUTO 1'
					},
					{
						tipo_produto:   :product,
						codigo_produto: 'PD854KM',
						descricao_produto: 'MEMÓRIA RAM 8 GB DELL 1333GHz',
						codigo_ncm:        '84715010',
						cfop:              '6101',
						unidade_comercial:    'UN',
						quantidade_comercial: 1.0,
						valor_unitario_comercial: 399.50,
						valor_total_produto:      399.50,
						unidade_tributavel:       'UN',
						quantidade_tributavel:    1.0,
						valor_unitario_tributavel: 399.50,
						total_frete:              50.0,
						numero_pedido_compra: 'ETR79813168',
						item_pedido_compra:    2,
						total_tributos: 10.0,
						icms: {
							codigo_cst: 102,
							modalidade_base_calculo: '0',
							reducao_base_calculo:    0.0,
							total_base_calculo:      399.5,
							aliquota:                12.0,
							total:                   47.94,
							motivo_desoneracao:      5,
						},
						informacoes_adicionais: 'OBSERVAÇÕES DO PRODUTO 2'
					}
				],
				total_icms_base_calculo:    0.0,
				total_icms:                 0.00,
				total_icms_desonerado:      0.0,
				total_icms_fcp_uf_destino:  0.0,
				total_icms_uf_destino:      0.0,
				total_icms_uf_origem:       0.0,
				total_icms_base_calculo_st: 0.0,
				total_icms_st:              0.0,
				total_produtos:             1_800.00,
				total_frete:                100.0,
				total_seguro:               0.0,
				total_desconto:             199.50,
				total_imposto_importacao:   0.0,
				total_ipi:                  0.0,
				total_pis:                  0.0,
				total_cofins:               0.0,
				total_outras_despesas:      0.0,
				total_nf:                   1700.50,
				total_tributos:             157.87,
				total_servicos: 0.0,
				total_servicos_base_calculo: 0.0,
				total_servicos_iss: 0.0,
				total_servicos_pis: 0.0,
				total_servicos_cofins: 0.0,
				servicos_data_prestacao: Date.current,
				total_servicos_deducao: 0.0,
				total_servicos_outras_retencoes: 0.0,
				total_servicos_desconto_incondicionado: 0.0,
				total_servicos_desconto_condicionado: 0.0,
				total_servicos_iss_retido: 0.0,
				regime_tributario_servico: 1, # Microempresa Municipal (Default)
				total_retencao_pis: 0.0,
				total_retencao_cofins: 0.0,
				total_retencao_csll: 0.0,
				total_retencao_base_calculo_irrf: 0.0,
				total_retencao_irrf: 0.0,
				total_retencao_base_calculo_previdencia: 0.0,
				total_retencao_previdencia: 0.0,
				informacoes_fisco: 'INFO ao Fisco',
				informacoes_contribuinte: 'Info ao Contribuinte',
				processos_referenciados: [{numero_processo: '13132', indicador: 1}],
				exportacao_uf_saida: 'SC',
				exportacao_local_embarque: 'Porto São Francisco do Sul',
				exportacao_local_despacho: 'Pier 2'
			}}
		end

		trait :for_signature_test do
			ibge_code_of_issuer_uf      '42'
			numero_lote    1
			emitente { emitente_sign_params }
			notas_fiscais   { [FactoryGirl.build(:product_nota_fiscal, nfe_params ), FactoryGirl.build(:product_nota_fiscal, nfe_params.merge({numero_nf: 50}) )] }
			transient do
				emitente_sign_params {{
					cnpj:  "66622465000192",
					email: "brunomergen@gmail.com",
					endereco: {
						bairro: "Centro",
						cep: "89805-000",
						codigo_municipio: '4204202',
						codigo_pais: "1058",
						complemento: "D",
						logradouro: "AV. GETÚLIO VARGAS - N",
						nome_municipio: "Chapecó",
						nome_pais: "BRASIL",
						numero: "3425",
						uf: "SC"
					},
					incentivo_fiscal: false,
					inscricao_municipal: "326070",
					inscricao_estadual: "255422890",
					natureza_operacao: 1,
					nome_fantasia: "EMPRESA & COMPANIA DE TESTE",
					codigo_regime_tributario: 1,
					razao_social: "EMPRESA & COMPANIA DE TESTE LTDA",
					regime_especial_tributacao: "1",
					telefone: "(49) 3316-3333"
				}}
				nfe_params {{
					emitente: emitente_sign_params,
					destinatario: {
						cpf_cnpj: "907.424.030-50",
						email: "eduardo.lucas.mendes@greenbikeshop.com.br",
						endereco: {
							bairro: "Piratini",
							cep: "94838-420",
							codigo_municipio: 4300604,
							codigo_pais: "1058",
							complemento: "LETRA E",
							logradouro: "Rua Marechal Floriano",
							nome_municipio: "Alvorada",
							nome_pais: "BRASIL",
							numero: "969",
							uf: "RS"
						},
						inscricao_municipal: "",
						nome_fantasia: "EDUARDO LUCAS MENDES",
						razao_social: "EDUARDO LUCAS MENDES",
						telefone: "49 2049-3900"
					},
					codigo_tipo_emissao: 1, #Emissão normal (não em contingência);
					codigo_nf:           20160101,
					serie:               1,
					numero_nf:           2,
					natureza_operacao:   'Venda', #Default
					forma_pagamento:     0,  # Pagamento à vista; (Default)
					modelo_nf:           55, # Default
					data_hora_emissao:   Time.parse('25/12/2016 12:00:00 -0300'), 
					data_hora_expedicao: Time.parse('25/12/2016 12:00:00 -0300'),
					tipo_operacao:       1, # Saída - Default
					tipo_impressao:      1, # DANFE normal, Retrato; (Default)
					finalidade_emissao:  1, # NF-e normal; (Default)
					consumidor_final:    true, # Consumidor final - o Default é false (Normal)
					presenca_comprador:  9, # Operação não presencial, outros. (Default)
					processo_emissao:    0, # Emissão de NF-e com aplicativo do contribuinte; (Default)
					versao_aplicativo:   0, # Default
					endereco_retirada:   {
						bairro:           "São Cristóvão",
						cep:              "89804-023",
						codigo_municipio: '4204202',
						codigo_pais:      "1058",
						complemento:      "D",
						logradouro:       "Rua Afonso Pena - D",
						nome_municipio:   "Chapecó",
						nome_pais:        "BRASIL",
						numero:           "420",
						uf:               "SC"
					},
					endereco_retirada_cpf_cnpj: '23.020.443/0001-40',
					endereco_entrega:    {
						bairro:           "São Cristóvão",
						cep:              "89804-022",
						codigo_municipio: '4204202',
						codigo_pais:      "1058",
						complemento:      "D",
						logradouro:       "Rua Afonso Pena - D",
						nome_municipio:   "Chapecó",
						nome_pais:        "BRASIL",
						numero:           "520",
						uf:               "SC"
					},
					endereco_entrega_cpf_cnpj: '07456193983',
					autorizados_download_xml:  ['07456193983'],
					transporte: {
						modalidade_frete: 1, # Por conta do destinatário/remetente (O Default é 9=Sem frete)
						veiculo: {
							placa: 'UJC-5786',
							uf:    'SC',
							rntc:  '215423',
						},
						reboques: [
							{placa: 'UJC-5786',uf: 'SC',rntc: '215423'},
							{placa: 'DUO-1107',uf: 'RS',rntc: '654899'},
						],
						volumes: [
							{
								quantidade: 5, especie: 'CAIXA', marca: 'DUO',
								numercao:   1, peso_liquido: 10.0, peso_bruto: 11.0,
								lacres: ['LAC001','LAC002']
							},
							{
								quantidade: 10, especie: 'SACOLA', marca: 'BR',
								numercao:   2, peso_liquido: 2.0, peso_bruto: 2.25,
								lacres: ['LAC003','LAC004']
							}
						],
						transportador: {
							cpf_cnpj:      '15.114.195/0001-78',
							razao_social:  'Sarah e Valentina Alimentos Ltda',
							nome_fantasia: 'S&V Alimentos',
							telefone:      '(95) 3916-4683',
							email:         'contabilidade@calebethales.com.br',
							endereco: {
								logradouro:       'Rua Itajaí',
								numero:           '453',
								complemento:      '',
								bairro:           'Capibaribe',
								nome_municipio:   'São Lourenço da Mata',
								uf:               'PE',
								cep:              '54705-620',
							}
						},
					},
					fatura: {
						numero_fatura: 'FAT646498',
						valor_original: 2_000.00,
						valor_desconto: 199.50,
						valor_liquido:  1_800.50,
						duplicatas: [
							{numero_duplicata: 'DUP646498', total: 900.25, vencimento: Time.parse('25/12/2016 12:00:00 -0300').since(1.month)},
							{numero_duplicata: 'DUP646499', total: 900.25, vencimento: Time.parse('25/12/2016 12:00:00 -0300').since(2.months)},
						]
					},
					itens: [
						{
							tipo_produto:   :product,
							codigo_produto: 'PD854KL',
							codigo_ean:     '',
							descricao_produto: 'MICROCOMPUTADOR DELL ALL IN ONE INSPIRON 20 3059',
							codigo_ncm:        '84715010',
							cfop:              '6101',
							unidade_comercial:    'UN',
							quantidade_comercial: 1.0,
							valor_unitario_comercial: 1_400.50,
							valor_total_produto:      1_400.50,
							unidade_tributavel:       'UN',
							quantidade_tributavel:    1.0,
							valor_unitario_tributavel: 1_400.50,
							total_frete:              50.0,
							total_desconto:           199.50,
							numero_pedido_compra: 'ETR79813168',
							item_pedido_compra:    1,
							total_tributos: 147.87,
							icms: {
								codigo_cst: 102,
								reducao_base_calculo:    0.0,
								total_base_calculo:      1400.5,
								aliquota:                12.0,
								total:                   216.06,
								motivo_desoneracao:      5,
							},
							informacoes_adicionais: 'OBSERVAÇÕES DO PRODUTO 1'
						},
						{
							tipo_produto:   :product,
							codigo_produto: 'PD854KM',
							descricao_produto: 'MEMÓRIA RAM 8 GB DELL 1333GHz',
							codigo_ncm:        '84715010',
							cfop:              '6101',
							unidade_comercial:    'UN',
							quantidade_comercial: 1.0,
							valor_unitario_comercial: 399.50,
							valor_total_produto:      399.50,
							unidade_tributavel:       'UN',
							quantidade_tributavel:    1.0,
							valor_unitario_tributavel: 399.50,
							total_frete:              50.0,
							numero_pedido_compra: 'ETR79813168',
							item_pedido_compra:    2,
							total_tributos: 10.0,
							icms: {
								codigo_cst: 102,
								modalidade_base_calculo: '0',
								total_base_calculo:      399.5,
								aliquota:                12.0,
								total:                   47.94,
								motivo_desoneracao:      5,
							},
							informacoes_adicionais: 'OBSERVAÇÕES DO PRODUTO 2'
						}
					],
					total_produtos:             1_800.00,
					total_frete:                100.0,
					total_desconto:             199.50,
					total_nf:                   1700.50,
					total_tributos:             157.87,
					servicos_data_prestacao:    Date.parse('2016-12-25'),
					regime_tributario_servico: 1, # Microempresa Municipal (Default)
					informacoes_fisco: 'INFO ao Fisco',
					informacoes_contribuinte: 'Info ao Contribuinte'
				}}
			end
		end
	end
end