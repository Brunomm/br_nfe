require 'test_helper'

describe BrNfe::Servico::Betha::V1::BuildResponse do
	subject { FactoryGirl.build(:betha_v1_build_response) }

	describe "#messages" do
		it "deve retornar o resultado da key do hash conforme o atributo nfe_method com _resposta no fim" do
			subject.nfe_method = :algo
			subject.hash = {algo_resposta: {valor_a: 1}}
			subject.messages.must_equal({valor_a: 1})
		end
	end

	describe "#success?" do
		it "deve ser true quanto não tem mensagem de retorno" do
			subject.stubs(:messages).returns({lista_mensagem_retorno: nil})
			subject.success?.must_equal true
		end

		it "deve ser false quanto tem alguma mensagem de retorno" do
			subject.stubs(:messages).returns({lista_mensagem_retorno: {codigo: 1} })
			subject.success?.must_equal false
		end
	end

	describe "#error_messages" do
		before do
			subject.nfe_method = :key
			subject.hash = {key_resposta: {
				lista_mensagem_retorno: {mensagem_retorno: {
					codigo: "999",
					mensagem: "A mensagem",
					correcao: "A correcao"
				}}
			}}
		end
		it "se ja tem valor na variavel @error_messages deve retornar o conteudo da variavel" do
			subject.instance_variable_set(:@error_messages, [123])
			subject.error_messages.must_equal([123])
		end
		it "se for success? então deve retornar um valor vazio" do
			subject.stubs(:success?).returns(true)
			subject.error_messages.must_equal([])
		end

		it "deve retornar um vetor com um hash com as mensagens quando houver apenas 1 mensagem em um hash" do
			subject.error_messages.size.must_equal 1
			subject.error_messages.class.must_equal Array

			subject.error_messages[0][:codigo].must_equal '999'
			subject.error_messages[0][:mensagem].must_equal 'A mensagem'
			subject.error_messages[0][:correcao].must_equal 'A correcao'
		end

		it "deve retornar todas as mensagens quando houver mais que uma" do
			subject.hash = {key_resposta: {
				lista_mensagem_retorno: {mensagem_retorno: [
					{codigo: "111", mensagem: "A mensagem 1", correcao: "A correcao 1"},
					{codigo: "222", mensagem: "A mensagem 2", correcao: "A correcao 2"},
				]}
			}}

			subject.error_messages[0][:codigo].must_equal   '111'
			subject.error_messages[0][:mensagem].must_equal 'A mensagem 1'
			subject.error_messages[0][:correcao].must_equal 'A correcao 1'

			subject.error_messages[1][:codigo].must_equal   '222'
			subject.error_messages[1][:mensagem].must_equal 'A mensagem 2'
			subject.error_messages[1][:correcao].must_equal 'A correcao 2'		
		end
	end


	describe "#response" do
		context "deve instanciar um objeto Response Default" do
			it "com o hash completo" do
				subject.nfe_method = :key
				subject.hash ={ key_resposta: hash_resposta_completa}
				
				response = subject.response
				response.success.must_equal            false
				response.error_messages.size.must_equal 2
				response.error_messages[0][:codigo].must_equal   '111'
				response.error_messages[0][:mensagem].must_equal 'Msg 1'
				response.error_messages[0][:correcao].must_equal 'corr 1'
				response.error_messages[1][:codigo].must_equal   '222'
				response.error_messages[1][:mensagem].must_equal 'Msg 2'
				response.error_messages[1][:correcao].must_equal 'corr 2'
				
				response.numero_lote.must_equal      "333332"
				response.protocolo.must_equal        "5566633548"
				response.data_recebimento.must_equal DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300")

				response.notas_fiscais.size.must_equal 1
				nota_fiscal = response.notas_fiscais.first

				nota_fiscal.numero_nf.must_equal                        "1111"
				nota_fiscal.codigo_verificacao.must_equal               "ASDAD"
				nota_fiscal.data_emissao.must_equal                     DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300")
				nota_fiscal.rps_numero.must_equal                       "11111"
				nota_fiscal.rps_serie.must_equal                        "SN"
				nota_fiscal.rps_tipo.must_equal                         "1"
				nota_fiscal.rps_situacao.must_be_nil
				nota_fiscal.data_emissao_rps.must_equal                 DateTime.parse("Fri, 04 Sep 2015 09:56:17 -0300")
				nota_fiscal.competencia.must_equal                      DateTime.parse("Tue, 01 Sep 2015 00:00:00 -0300")
				nota_fiscal.outras_informacoes.must_equal               "http://e-gov.betha.com.br/e-nota"
				nota_fiscal.item_lista_servico.must_equal               "111"
				nota_fiscal.codigo_cnae.must_equal                      "6202300"
				nota_fiscal.discriminacao.must_equal                    "discriminacao"
				nota_fiscal.codigo_municipio.must_equal                 "4204202"
				nota_fiscal.valor_servicos.must_equal                   "111"
				nota_fiscal.valor_deducoes.must_equal                   "0"
				nota_fiscal.valor_pis.must_equal                        "0.00"
				nota_fiscal.valor_cofins.must_equal                     "0.00"
				nota_fiscal.valor_inss.must_equal                       "0.00"
				nota_fiscal.valor_ir.must_equal                         "0.00"
				nota_fiscal.valor_csll.must_equal                       "0.00"
				nota_fiscal.iss_retido.must_equal                       "2"
				nota_fiscal.valor_iss.must_equal                        "0"
				nota_fiscal.base_calculo.must_equal                     "111"
				nota_fiscal.aliquota.must_equal                         "1.0000"
				nota_fiscal.desconto_condicionado.must_equal            "desconto_condicionado"
				nota_fiscal.desconto_incondicionado.must_equal          "desconto_incondicionado"
				nota_fiscal.orgao_gerador_municipio.must_equal          "0"
				nota_fiscal.orgao_gerador_uf.must_equal                 "SC"
				nota_fiscal.cancelamento_codigo.must_equal              "123"
				nota_fiscal.cancelamento_numero_nf.must_equal           "123"
				nota_fiscal.cancelamento_cnpj.must_equal                "12345678901234"
				nota_fiscal.cancelamento_inscricao_municipal.must_equal "INSCRICAO CANCELAMENTO"
				nota_fiscal.cancelamento_municipio.must_equal           "99999999"
				nota_fiscal.cancelamento_sucesso.must_equal             true
				nota_fiscal.cancelamento_data_hora.must_equal           DateTime.parse("Fri, 05 Sep 2015 09:56:17 -0300")
				nota_fiscal.nfe_substituidora.must_equal                "663322"
				nota_fiscal.codigo_obra.must_equal                      "3333"
				nota_fiscal.codigo_art.must_equal                       "4444"

				#Intermediario
				nota_fiscal.intermediario.razao_social.must_equal        "RAZAO_SOCIAL INTERMEDIARIO"
				nota_fiscal.intermediario.cpf_cnpj.must_equal            "cpf intermediario"
				nota_fiscal.intermediario.inscricao_municipal.must_equal "inscricao_municipal intermediario"

				# Emitente / prestador
				nota_fiscal.emitente.cnpj.must_equal                       "18113831000135"
				nota_fiscal.emitente.inscricao_municipal.must_equal        "inscricao_municipal prestador"
				nota_fiscal.emitente.razao_social.must_equal               "EMPRESA NACIONAL LTDA - ME"
				nota_fiscal.emitente.nome_fantasia.must_equal              "EMPRESA NACIONAL"
				nota_fiscal.emitente.telefone.must_equal                   "123456"
				nota_fiscal.emitente.email.must_equal                      "email@prestador"
				nota_fiscal.emitente.regime_especial_tributacao.must_be_nil
				nota_fiscal.emitente.optante_simples_nacional.must_equal   "emitente optante_simples_nacional"
				nota_fiscal.emitente.incentivo_fiscal.must_be_nil
				nota_fiscal.emitente.natureza_operacao.must_equal          "1"

				# Destinatario / Tomador
				nota_fiscal.destinatario.cpf_cnpj.must_equal            "12345678901"
				nota_fiscal.destinatario.inscricao_estadual.must_equal  "tomador inscricao_estadual"
				nota_fiscal.destinatario.inscricao_municipal.must_equal "tomador inscricao_municipal"
				nota_fiscal.destinatario.razao_social.must_equal        "TOMADOR SERVICO"
				nota_fiscal.destinatario.telefone.must_equal            "336644557"
				nota_fiscal.destinatario.email.must_equal               "mail@prestador.com"
			end

			it "com o hash parcial e mais de uma nota" do
				subject.nfe_method = :key
				subject.hash ={ key_resposta: hash_resposta_parcial}
				
				response = subject.response
				response.success.must_equal            true
				response.error_messages.size.must_equal 0
				
				response.numero_lote.must_be_nil
				response.protocolo.must_be_nil
				response.data_recebimento.must_be_nil

				response.notas_fiscais.size.must_equal 2
				nota_fiscal_1 = response.notas_fiscais.first
				nota_fiscal_2 = response.notas_fiscais.last

				nota_fiscal_1.numero_nf.must_equal                        "1111"
				nota_fiscal_1.codigo_verificacao.must_equal               "ASDAD"
				nota_fiscal_1.data_emissao.must_equal                     DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300")
				nota_fiscal_1.rps_numero.must_equal                       "11111"
				nota_fiscal_1.rps_serie.must_equal                        "SN"
				nota_fiscal_1.rps_tipo.must_equal                         "1"
				nota_fiscal_1.rps_situacao.must_be_nil
				nota_fiscal_1.data_emissao_rps.must_equal                 DateTime.parse("Fri, 04 Sep 2015 09:56:17 -0300")
				nota_fiscal_1.competencia.must_equal                      DateTime.parse("Tue, 01 Sep 2015 00:00:00 -0300")
				nota_fiscal_1.outras_informacoes.must_equal               "http://e-gov.betha.com.br/e-nota"
				nota_fiscal_1.item_lista_servico.must_equal               "111"
				nota_fiscal_1.codigo_cnae.must_equal                      "6202300"
				nota_fiscal_1.discriminacao.must_equal                    "discriminacao"
				nota_fiscal_1.codigo_municipio.must_equal                 "4204202"
				nota_fiscal_1.valor_servicos.must_equal                   "111"
				nota_fiscal_1.valor_deducoes.must_equal                   "0"
				nota_fiscal_1.valor_pis.must_equal                        "0.00"
				nota_fiscal_1.valor_cofins.must_equal                     "0.00"
				nota_fiscal_1.valor_inss.must_equal                       "0.00"
				nota_fiscal_1.valor_ir.must_equal                         "0.00"
				nota_fiscal_1.valor_csll.must_equal                       "0.00"
				nota_fiscal_1.iss_retido.must_equal                       "2"
				nota_fiscal_1.valor_iss.must_equal                        "0"
				nota_fiscal_1.base_calculo.must_equal                     "111"
				nota_fiscal_1.aliquota.must_equal                         "1.0000"
				nota_fiscal_1.desconto_condicionado.must_equal            "desconto_condicionado"
				nota_fiscal_1.desconto_incondicionado.must_equal          "desconto_incondicionado"
				nota_fiscal_1.orgao_gerador_municipio.must_equal          "0"
				nota_fiscal_1.orgao_gerador_uf.must_equal                 "SC"
				nota_fiscal_1.cancelamento_codigo.must_equal              "123"
				nota_fiscal_1.cancelamento_numero_nf.must_equal           "123"
				nota_fiscal_1.cancelamento_cnpj.must_equal                "12345678901234"
				nota_fiscal_1.cancelamento_inscricao_municipal.must_equal "INSCRICAO CANCELAMENTO"
				nota_fiscal_1.cancelamento_municipio.must_equal           "99999999"
				nota_fiscal_1.cancelamento_sucesso.must_equal             true
				nota_fiscal_1.cancelamento_data_hora.must_equal           DateTime.parse("Fri, 05 Sep 2015 09:56:17 -0300")
				nota_fiscal_1.nfe_substituidora.must_equal                "663322"
				nota_fiscal_1.codigo_obra.must_equal                      "3333"
				nota_fiscal_1.codigo_art.must_equal                       "4444"

				nota_fiscal_2.numero_nf.must_equal                        "NOTA2 numero_nf"
				nota_fiscal_2.codigo_verificacao.must_equal               "NOTA2 codigo_verificacao"
				nota_fiscal_2.data_emissao.must_equal                     "NOTA2 data_emissao"
				nota_fiscal_2.rps_numero.must_equal                       "NOTA2 rps_numero"
				nota_fiscal_2.rps_serie.must_equal                        "NOTA2 rps_serie"
				nota_fiscal_2.rps_tipo.must_equal                         "NOTA2 rps_tipo"
				nota_fiscal_2.data_emissao_rps.must_equal                 "NOTA2 data_emissao_rps"
				nota_fiscal_2.competencia.must_equal                      "NOTA2 competencia"
				nota_fiscal_2.outras_informacoes.must_equal               "NOTA2 outras_informacoes"
				nota_fiscal_2.item_lista_servico.must_equal               "NOTA2 item_lista_servico"
				nota_fiscal_2.discriminacao.must_equal                    "NOTA2 discriminacao"
				nota_fiscal_2.codigo_municipio.must_equal                 "NOTA2 codigo_municipio"
				nota_fiscal_2.valor_servicos.must_equal                   "NOTA2 valor_servicos"
				nota_fiscal_2.base_calculo.must_equal                     "NOTA2 base_calculo"
				nota_fiscal_2.aliquota.must_equal                         "NOTA2 aliquota"
				nota_fiscal_2.codigo_cnae.must_be_nil
				nota_fiscal_2.valor_deducoes.must_be_nil
				nota_fiscal_2.valor_pis.must_be_nil
				nota_fiscal_2.valor_cofins.must_be_nil
				nota_fiscal_2.valor_inss.must_be_nil
				nota_fiscal_2.valor_ir.must_be_nil
				nota_fiscal_2.valor_csll.must_be_nil
				nota_fiscal_2.iss_retido.must_be_nil
				nota_fiscal_2.valor_iss.must_be_nil
				nota_fiscal_2.desconto_condicionado.must_be_nil
				nota_fiscal_2.desconto_incondicionado.must_be_nil
				nota_fiscal_2.orgao_gerador_municipio.must_be_nil
				nota_fiscal_2.orgao_gerador_uf.must_be_nil
				nota_fiscal_2.cancelamento_codigo.must_be_nil
				nota_fiscal_2.cancelamento_numero_nf.must_be_nil
				nota_fiscal_2.cancelamento_cnpj.must_be_nil
				nota_fiscal_2.cancelamento_inscricao_municipal.must_be_nil
				nota_fiscal_2.cancelamento_municipio.must_be_nil
				nota_fiscal_2.cancelamento_sucesso.must_be_nil
				nota_fiscal_2.cancelamento_data_hora.must_be_nil
				nota_fiscal_2.nfe_substituidora.must_be_nil
				nota_fiscal_2.codigo_obra.must_be_nil
				nota_fiscal_2.codigo_art.must_be_nil
			end

		end
	end


	def hash_resposta_completa
		{
			protocolo: "5566633548",
			data_recebimento: DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300"),
			numero_lote: '333332',
			lista_nfse: {
				compl_nfse: {
					nfse: {
						inf_nfse: {
							numero: "1111",
							codigo_verificacao: "ASDAD",
							data_emissao: DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300"),
							identificacao_rps: {
								numero: "11111",
								serie: "SN",
								tipo: "1"
							},
							data_emissao_rps: DateTime.parse("Fri, 04 Sep 2015 09:56:17 -0300"),
							natureza_operacao: "1",
							optante_simples_nacional: "emitente optante_simples_nacional",
							competencia: DateTime.parse("Tue, 01 Sep 2015 00:00:00 -0300"),
							outras_informacoes: "http://e-gov.betha.com.br/e-nota",
							servico: {
								valores: {
									valor_servicos: "111",
									valor_deducoes: "0",
									valor_pis:      "0.00",
									valor_cofins:   "0.00",
									valor_inss:     "0.00",
									valor_ir:       "0.00",
									valor_csll:     "0.00",
									iss_retido:     "2",
									valor_iss:      "0",
									base_calculo:   "111",
									aliquota:       "1.0000",
									desconto_condicionado: "desconto_condicionado",
									desconto_incondicionado: "desconto_incondicionado"
								},
								item_lista_servico: "111",
								codigo_cnae: "6202300",
								discriminacao: "discriminacao",
								codigo_municipio: "4204202"
							},
							intermediario_servico: {
								razao_social:        "razao_social intermediario",
								cpf_cnpj:            {cpf: 'cpf intermediario'},
								inscricao_municipal: "inscricao_municipal intermediario"

							},
							prestador_servico: {
								identificacao_prestador: {
									cnpj: "18113831000135",
									inscricao_municipal: "inscricao_municipal prestador",
								},
								razao_social: "EMPRESA NACIONAL LTDA - ME",
								nome_fantasia: "EMPRESA NACIONAL",
								endereco: {
									endereco: "RUA PRESTADOR",
									numero: "111",
									complemento: "COMPLEMENTO PRESTADOR",
									bairro: "BAIRRO PRESTADOR",
									codigo_municipio: "4204202",
									uf: "SC",
									cep: "89805675"
								},
								contato: {
									telefone: "123456",
									email: "email@prestador",
								}
							},
							tomador_servico: {
								identificacao_tomador: {
									cpf_cnpj: {
										cpf: "12345678901",
									},
									inscricao_estadual:  "tomador inscricao_estadual",
									inscricao_municipal: "tomador inscricao_municipal"
								},
								razao_social: "TOMADOR SERVIcO",
								endereco: {
									endereco: "RUA TOMADOR",
									numero: "99999",
									complemento: "COMPLEMENTO TOMADOR",
									bairro: "BAIRRO TOMADOR",
									codigo_municipio: "4204202",
									uf: "SC",
									cep: "89805675"
								},
								contato: {
									telefone: "336644557",
									email: "mail@prestador.com"
								}
							},
							orgao_gerador: {
								codigo_municipio: "0",
								uf: "SC"
							},
							construcao_civil: {
								codigo_obra: '3333',
								art: '4444'
							}
						}
					},
					nfse_cancelamento: {
						confirmacao: {
							pedido: {
								inf_pedido_cancelamento: {
									codigo_cancelamento: '123',
									identificacao_nfse: {
										numero: '123',
										cnpj: '12345678901234',
										inscricao_municipal: 'INSCRICAO CANCELAMENTO',
										codigo_municipio: '99999999'
									}
								},
								signature: nil
							},
							inf_confirmacao_cancelamento: {
								sucesso: true,
								data_hora: DateTime.parse("Fri, 05 Sep 2015 09:56:17 -0300")
							}
						}
					},
					nfse_substituicao: {
						substituicao_nfse: {
							nfse_substituidora: '663322'
						}
					}
				}
			},
			lista_mensagem_retorno: {
				mensagem_retorno: [
					{codigo: '111', mensagem: 'Msg 1', correcao: 'corr 1'},
					{codigo: '222', mensagem: 'Msg 2', correcao: 'corr 2'}
				]
			}
		}
	end

	def hash_resposta_parcial
		{
			lista_nfse: {
				compl_nfse: [
					{
						nfse: {
							inf_nfse: {
								numero: "1111",
								codigo_verificacao: "ASDAD",
								data_emissao: DateTime.parse("Fri, 04 Sep 2015 09:56:22 -0300"),
								identificacao_rps: {
									numero: "11111",
									serie: "SN",
									tipo: "1"
								},
								data_emissao_rps: DateTime.parse("Fri, 04 Sep 2015 09:56:17 -0300"),
								natureza_operacao: "1",
								optante_simples_nacional: "1",
								competencia: DateTime.parse("Tue, 01 Sep 2015 00:00:00 -0300"),
								outras_informacoes: "http://e-gov.betha.com.br/e-nota",
								servico: {
									valores: {
										valor_servicos: "111",
										valor_deducoes: "0",
										valor_pis:      "0.00",
										valor_cofins:   "0.00",
										valor_inss:     "0.00",
										valor_ir:       "0.00",
										valor_csll:     "0.00",
										iss_retido:     "2",
										valor_iss:      "0",
										base_calculo:   "111",
										aliquota:       "1.0000",
										desconto_condicionado: "desconto_condicionado",
										desconto_incondicionado: "desconto_incondicionado"
									},
									item_lista_servico: "111",
									codigo_cnae: "6202300",
									discriminacao: "discriminacao",
									codigo_municipio: "4204202"
								},
								prestador_servico: {
									identificacao_prestador: {
										cnpj: "18113831000135"
									},
									razao_social: "EMPRESA NACIONAL LTDA - ME",
									nome_fantasia: "EMPRESA NACIONAL",
									endereco: {
										endereco: "RUA PRESTADOR",
										numero: "111",
										complemento: "COMPLEMENTO PRESTADOR",
										bairro: "BAIRRO PRESTADOR",
										codigo_municipio: "4204202",
										uf: "SC",
										cep: "89805675"
									},
									contato: {
										email: "email@prestador",
										telefone: "123456"
									}
								},
								tomador_servico: {
									identificacao_tomador: {
										cpf_cnpj: {
											cnpj: "12345678901234"
										}
									},
									razao_social: "TOMADOR SERVIÇO",
									endereco: {
										endereco: "RUA TOMADOR",
										numero: "99999",
										complemento: "COMPLEMENTO TOMADOR",
										bairro: "BAIRRO TOMADOR",
										codigo_municipio: "4204202",
										uf: "SC",
										cep: "89805675"
									},
									contato: {
										telefone: "336644557",
										email: "mail@prestador.com"
									}
								},
								orgao_gerador: {
									codigo_municipio: "0",
									uf: "SC"
								},
								construcao_civil: {
									codigo_obra: '3333',
									art: '4444'
								}
							}
						},
						nfse_cancelamento: {
							confirmacao: {
								pedido: {
									inf_pedido_cancelamento: {
										codigo_cancelamento: '123',
										identificacao_nfse: {
											numero: '123',
											cnpj: '12345678901234',
											inscricao_municipal: 'INSCRICAO CANCELAMENTO',
											codigo_municipio: '99999999'
										}
									},
									signature: nil
								},
								inf_confirmacao_cancelamento: {
									sucesso: true,
									data_hora: DateTime.parse("Fri, 05 Sep 2015 09:56:17 -0300")
								}
							}
						},
						nfse_substituicao: {
							substituicao_nfse: {
								nfse_substituidora: '663322'
							}
						}
					},
					{
						nfse: {
							inf_nfse: {
								numero: "NOTA2 numero_nf",
								codigo_verificacao: "NOTA2 codigo_verificacao",
								data_emissao: "NOTA2 data_emissao",
								identificacao_rps: {
									numero: "NOTA2 rps_numero",
									serie:  "NOTA2 rps_serie",
									tipo:   "NOTA2 rps_tipo"
								},
								data_emissao_rps: "NOTA2 data_emissao_rps",
								natureza_operacao: "NOTA2 natureza_operacao",
								optante_simples_nacional: "NOTA2 optante_simples_nacional",
								competencia: "NOTA2 competencia",
								outras_informacoes: "NOTA2 outras_informacoes",
								servico: {
									valores: {
										valor_servicos: "NOTA2 valor_servicos",
										base_calculo:   "NOTA2 base_calculo",
										aliquota:       "NOTA2 aliquota"
									},
									item_lista_servico: "NOTA2 item_lista_servico",
									discriminacao: "NOTA2 discriminacao",
									codigo_municipio: "NOTA2 codigo_municipio"
								},
							}
						},
						nfse_cancelamento: {
							confirmacao: nil
						},
						nfse_substituicao: nil
					}
				]
			},
			lista_mensagem_retorno: nil
		}
	end
end