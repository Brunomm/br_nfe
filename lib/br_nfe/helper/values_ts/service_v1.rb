module BrNfe
	module Helper
		module ValuesTs
			module ServiceV1
				
				# Número da Nota Fiscal de Serviço Eletrônica,
				# formado pelo ano com 04 (quatro) dígitos e um
				# número seqüencial com 11 posições – Formato
				# AAAANNNNNNNNNNN.
				#
				def ts_numero_nfse value
					BrNfe::Helper.only_number(value).max_size(15)
				end

				# Código de verificação do número da nota
				#
				def ts_codigo_verificacao value
					"#{value}".max_size(9)
				end

				# Código de status do RPS
				# 1 – Normal
				# 2 – Cancelado
				#
				def ts_status_rps value
					BrNfe::Helper.only_number(value).max_size(1)
				end

				# Código de status do NFS-e
				# 1 – Normal
				# 2 – Cancelado
				#
				def ts_status_nfse value
					BrNfe::Helper.only_number(value).max_size(1)
				end

				# Código de natureza da operação
				# 1 – Tributação no município
				# 2 - Tributação fora do município
				# 3 - Isenção
				# 4 - Imune
				# 5 –Exigibilidade suspensa por decisão judicial
				# 6 – Exigibilidade suspensa por procedimento administrativo
				#
				def ts_natureza_operacao value
					BrNfe::Helper.only_number(value).max_size(2)
				end

				# Código de identificação do regime especial de tributação
				#  1 – Microempresa municipal
				#  2 - Estimativa
				#  3 – Sociedade de profissionais
				#  4 – Cooperativa
				#
				def ts_regime_especial_tributacao value
					BrNfe::Helper.only_number(value).max_size(2)
				end

				# Identificação de Sim/Não
				#  1 - Sim
				#  2 - Não
				#
				def ts_sim_nao value
					value_true_false(value)
				end

				# Quantidade de RPS do Lote
				#
				def ts_quantidade_rps value
					BrNfe::Helper.only_number(value).max_size(4)
				end

				# Número do RPS
				#
				def ts_numero_rps value
					BrNfe::Helper.only_number(value).max_size(15)
				end

				# Número de série do RPS
				#
				def ts_serie_rps value
					"#{value}".max_size(5)
				end

				# Código de tipo de RPS
				#  1 - RPS
				#  2 – Nota Fiscal Conjugada (Mista)
				#  3 – Cupom
				#
				def ts_tipo_rps value
					BrNfe::Helper.only_number(value).max_size(1)
				end

				# Informações adicionais ao documento.
				#
				def ts_outras_informacoes value
					"#{value}".max_size(255)
				end

				# Valor monetário.
				#  Formato: 0.00 (ponto separando casa decimal)
				#  Ex: 1.234,56 = 1234.56
				#  1.000,00 = 1000.00
				#  1.000,00 = 1000
				#
				def ts_valor value
					"#{value_monetary(value, 2)}".max_size(17)
				end

				# Código de item da lista de serviço
				#
				def ts_item_lista_servico value
					BrNfe::Helper.only_number(value).max_size(5).rjust(4, '0')
				end

				# Código CNAE
				#
				def ts_codigo_cnae value
					BrNfe::Helper.only_number(value).max_size(7)
				end

				# Código de Tributação
				#
				def ts_codigo_tributacao value
					"#{value}".max_size(20)
				end

				# Alíquota. Valor percentual.
				#  Formato: 0.0000
				#  Ex: 1% = 0.01
				#  25,5% = 0.255
				#  100% = 1.0000 ou 1
				#
				def ts_aliquota value
					"#{value_monetary(value, 4)}".max_size(9)
				end

				# Discriminação do conteúdo da NFS-e
				#
				def ts_discriminacao value
					"#{value}".max_size(2_000).remove_accents
				end

				# Código de identificação do município conforme tabela do IBGE
				#
				def ts_codigo_municipio_ibge value
					BrNfe::Helper.only_number(value).max_size(7)
				end

				# Número de inscrição municipal
				#
				def ts_inscricao_municipal value
					"#{value}".max_size(15)
				end

				# Razão Social do contribuinte
				#
				def ts_razao_social value
					"#{value}".max_size(115)
				end

				# Nome fantasia
				#
				def ts_nome_fantasia value
					"#{value}".max_size(60)
				end

				# Número CNPJ
				#
				def ts_cnpj value
					"#{BrNfe::Helper::CpfCnpj.new(value).sem_formatacao}".max_size(14)
				end

				# Endereço / rua
				#
				def ts_endereco value
					"#{value}".max_size(125)
				end

				# Número do endereço
				#
				def ts_numero_endereco value
					"#{value}".max_size(10)
				end

				# Complemento de endereço
				#
				def ts_complemento_endereco value
					"#{value}".max_size(60)
				end

				# Bairro
				#
				def ts_bairro value
					"#{value}".max_size(60)
				end

				# Sigla da unidade federativa
				#
				def ts_uf value
					"#{value}".max_size(2)
				end

				# Número do CEP
				#
				def ts_cep value
					BrNfe::Helper.only_number(value).max_size(8)
				end

				# E-mail
				#
				def ts_email value
					"#{value}".max_size(80)
				end

				# Telefone
				#
				def ts_telefone value
					"#{value}".max_size(11)
				end

				# Número CPF
				#
				def ts_cpf value
					"#{BrNfe::Helper::CpfCnpj.new(value).sem_formatacao}".max_size(11)
				end

				# Indicador de uso de CPF ou CNPJ
				#  1 – CPF
				#  2 – CNPJ
				#  3 – Não Informado
				#
				def ts_indicacao_cpf_cnpj
					BrNfe::Helper.only_number(value).max_size(1)
				end

				# Código de Obra
				#
				def ts_codigo_obra value
					"#{value}".max_size(15)
				end

				# Código ART
				#
				def ts_art value
					"#{value}".max_size(15)
				end

				# Número do Lote de RPS
				#
				def ts_numero_lote value
					BrNfe::Helper.only_number(value).max_size(15)
				end

				# Número do protocolo de recebimento do RPS
				#
				def ts_numero_protocolo value
					"#{value}".max_size(50)
				end

				# Código de situação de lote de RPS
				#  1 – Não Recebido
				#  2 – Não Processado
				#  3 – Processado com Erro
				#  4 – Processado com Sucesso
				#
				def ts_situacao_lote_rps value
					BrNfe::Helper.only_number(value).max_size(1)
				end

				# Código de mensagem de retorno de serviço.
				#
				def ts_codigo_mensagem_alerta value
					"#{value}".max_size(4)
				end

				# Descrição da mensagem de retorno de serviço.
				#
				def ts_descricao_mensagem_alerta value
					"#{value}".max_size(200)
				end

				# Código de cancelamento com base na tabela de Erros e alertas.
				#
				def ts_codigo_cancelamento_nfse value
					"#{value}".max_size(4)
				end

				# Atributo de identificação da tag a ser assinada no documento XML
				#
				def ts_id_tag value
					"#{value}".max_size(255)
				end

				# Atributo do formato Datetime
				# Não está identificado na documentação porém é utilizado
				# para identificar valores Datetime
				#
				def ts_datetime value
					value_date_time(value)
				end

				# Atributo do formato Date
				# Não está identificado na documentação porém é utilizado
				# para identificar valores Date
				#
				def ts_date value
					value_date(value)
				end
			end
		end
	end
end