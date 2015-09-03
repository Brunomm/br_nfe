module BrNfe
	module Servico
		class Response  < BrNfe::ActiveModelBase
			attr_accessor :xml, :nfe_method

			def messages
				raise "Não implementado"
			end

			def success?
				raise "Não implementado"
			end

			def error_messages
				raise "Não implementado"
			end

			def numero_lote
				messages[:numero_lote]
			end

			def data_recebimento
				messages[:data_recebimento]
			end

			def protocolo
				messages[:protocolo]			
			end

			# def hash
			# 	{lista_nfse: {
			# 		compl_nfse: {
			# 			nfse: {
			# 				inf_nfse: {
			# 					numero: "13",
			# 					codigo_verificacao: "ED3TSVOBR",
			# 					data_emissao: 'Wed,02 Sep 2015 18:39:26 -0300',
			# 					identificacao_rps: {
			# 						numero: "1598",
			# 						serie: "SN",
			# 						tipo: "1"
			# 					},
			# 					data_emissao_rps: 'Wed,02 Sep 2015 18:39:23 -0300',
			# 					natureza_operacao: "1",
			# 					optante_simples_nacional: "1",
			# 					competencia: 'Tue,01 Sep 2015 00:00:00 -0300',
			# 					outras_informacoes: "http://e-gov.betha.com.br/e-nota/visualizarnotaeletronica?link=144122996654213991624752253523013152274867546056251",
			# 					servico: {
			# 						valores: {
			# 						valor_servicos: "49",
			# 						valor_deducoes: "0",
			# 						valor_pis: "0.00",
			# 						valor_cofins: "0.00",
			# 						valor_inss: "0.00",
			# 						valor_ir: "0.00",
			# 						valor_csll: "0.00",
			# 						iss_retido: "2",
			# 						valor_iss: "0",
			# 						base_calculo: "49",
			# 						aliquota: "2.0000",
			# 						desconto_condicionado: "0",
			# 						desconto_incondicionado: "0"
			# 					},
			# 					item_lista_servico: "0107",
			# 					codigo_cnae: "6202300",
			# 					discriminacao: "Descrição: 1 MENSALIDADE PLANO LIGHT. 49,00 \n\n\n\n\nValor Aprox dos Tributos: R$ 6,59 Federal, R$ 0,00 Estadual e R$ 1,62 Municipal \n Fonte: IBPT/FECOMERCIO SC 5oi7eW\nValor: 49",
			# 					codigo_municipio: "4204202",
			# 				},
			# 				prestador_servico: {
			# 					identificacao_prestador: {
			# 						cnpj: "18113831000135"
			# 					},
			# 					razao_social: "TWOWEB AGENCIA DIGITAL LTDA - ME",
			# 					nome_fantasia: "TWOWEB AGENCIA DIGITAL",
			# 					endereco: {
			# 						endereco: "Ambiente de testes não requer endereço",
			# 						codigo_municipio: "0",
			# 						uf: "SC",
			# 						cep: "88888888"
			# 					},
			# 					contato: nil
			# 				},
			# 				tomador_servico: {
			# 					identificacao_tomador: {
			# 						cpf_cnpj: {
			# 							cnpj: "18077391000108"
			# 						}
			# 					},
			# 					razao_social: "I9K SOLUCOES TECNOLOGICAS LTDA",
			# 					endereco: {
			# 						endereco: "R JERUSALEM",
			# 						numero: "61",
			# 						complemento: "E,
			# 						SALAS 06 E 07",
			# 						bairro: "PASSO DOS FORTES",
			# 						codigo_municipio: "4204202",
			# 						uf: "SC",
			# 						cep: "89805675"
			# 					},
			# 					contato: {
			# 						telefone: "336644557",
			# 						email: "mail@mail.com"
			# 					}
			# 				},
			# 				orgao_gerador: {
			# 					codigo_municipio: "0",
			# 					uf: "SC"
			# 				},
			# 				construcao_civil: nil
			# 			}
			# 		},
			# 		nfse_cancelamento: {
			# 			confirmacao: {
			# 				pedido: {
			# 					inf_pedido_cancelamento: nil,
			# 					signature: nil
			# 				},
			# 				inf_confirmacao_cancelamento: {
			# 					sucesso: false
			# 				}
			# 			}
			# 		},
			# 		nfse_substituicao: {
			# 			substituicao_nfse: nil
			# 		}
			# 	}}
			# end
		end
	end
end