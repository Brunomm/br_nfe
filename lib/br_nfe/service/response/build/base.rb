#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class Base  < BrNfe::ActiveModelBase
					# 1: A resposta da requisição soap
					attr_accessor :savon_response
					
					# 2: Um array com o caminho inicial padrão da requisição de retorno
					attr_accessor :keys_root_path

					# 3: Caminho para encontrar o XML da NF-e
					attr_accessor :nfe_xml_path

					# 4: Alguns Webservices trazem dentro do body da resposta SOAp
					# outro XML com as informações necessárias.
					# Quando isso aocntece é preciso converter esse XML para um HASH
					# para que possamos encontrar os valores necessários.
					attr_accessor :body_xml_path

					# 5: Codificação original do XML de resposta para que seja convertido 
					#    para UTF-8
					attr_accessor :xml_encode

					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
						#                                                                     Caminho para encontrar
						attr_accessor :lot_number_path                                     # o numero do lote
						attr_accessor :protocol_path                                       # o protocolo
						attr_accessor :received_date_path                                  # a data de recebimento do xml
						attr_accessor :situation_path                                      # a situação do lote rps
						attr_accessor :situation_key_values                                # 
						def situation_key_values
							@situation_key_values.is_a?(Hash) ? @situation_key_values : {
								'1' =>  :unreceived, # Não Recebido
								'2' =>  :unprocessed,# Não Processado
								'3' =>  :error,      # Processado com Erro
								'4' =>  :success,    # Processado com Sucesso
							}
						end
						attr_accessor :cancelation_date_time_path                          # data e hora do cancelamento da nf
						attr_accessor :message_errors_path                                 # local para encontrar as mensagens de erro
						attr_accessor :message_code_key                                    # chave que representa o codigo do erro
						attr_accessor :message_msg_key                                     # chave que representa a mensagem do erro
						attr_accessor :message_solution_key                                # chave que representa a solução do erro
						attr_accessor :invoices_path                                       # o caminho para listar as notas fiscais
						attr_accessor :invoice_numero_nf_path                              # numero da nota fiscal
						attr_accessor :invoice_codigo_verificacao_path                     # código de verificação
						attr_accessor :invoice_data_emissao_path                           # Data de emissão da NF
						attr_accessor :invoice_url_nf_path                                 # URL para visualizar a DANFE (apenas alguns emissores disponibilizam isso)
						attr_accessor :invoice_rps_numero_path                             # Número do RPS da nota
						attr_accessor :invoice_rps_serie_path                              # Número da série do RPS da nota
						attr_accessor :invoice_rps_tipo_path                               # Tipo do RPS
						attr_accessor :invoice_rps_situacao_path                           # Situação da NF
						attr_accessor :invoice_rps_substituido_numero_path                 # Número do RPS da nota substituido
						attr_accessor :invoice_rps_substituido_serie_path                  # Número da série do RPS da nota substituido
						attr_accessor :invoice_rps_substituido_tipo_path                   # Tipo do RPS substituido
						attr_accessor :invoice_data_emissao_rps_path                       # Data de emissão do RPS
						attr_accessor :invoice_competencia_path                            # Competência da nf
						attr_accessor :invoice_natureza_operacao_path                      # natureza de operação
						attr_accessor :invoice_regime_especial_tributacao_path             # Regime especial de tributação
						attr_accessor :invoice_optante_simples_nacional_path               # Se é optante do simples
						attr_accessor :invoice_incentivador_cultural_path                  # Incentivo cultural
						attr_accessor :invoice_outras_informacoes_path                     # Outras informações da nf
						attr_accessor :invoice_item_lista_servico_path                     # Código do serviço prestado
						attr_accessor :invoice_cnae_code_path                              # CNAE utilizado na nf
						attr_accessor :invoice_description_path                            # Descrição da nf
						attr_accessor :invoice_codigo_municipio_path                       # Código do municipio prestador do serviço
						attr_accessor :invoice_total_services_path                         # Valor total dos serviços
						attr_accessor :invoice_deductions_path                             # Valor das deduções
						attr_accessor :invoice_valor_pis_path                              # Valor do PIS
						attr_accessor :invoice_valor_cofins_path                           # Valor do COFINS
						attr_accessor :invoice_valor_inss_path                             # Valor do INSS
						attr_accessor :invoice_valor_ir_path                               # Valor do IR
						attr_accessor :invoice_valor_csll_path                             # Valor da CSLL
						attr_accessor :invoice_iss_retained_path                           # Se o ISS está retido
						attr_accessor :invoice_outras_retencoes_path                       # Valor Outras retenções
						attr_accessor :invoice_total_iss_path                              # Valor total de ISS
						attr_accessor :invoice_base_calculation_path                       # Valor da base de cálculo
						attr_accessor :invoice_iss_tax_rate_path                           # Percentual do imposto de ISS
						attr_accessor :invoice_valor_liquido_path                          # Valor liquido da NFS
						attr_accessor :invoice_desconto_condicionado_path                  # Valor do desconto condicionado
						attr_accessor :invoice_desconto_incondicionado_path                # Valor do desconto incondicionado
						attr_accessor :invoice_responsavel_retencao_path                   # Responsável pela retenção
						attr_accessor :invoice_numero_processo_path                        # Número do processo da NF
						attr_accessor :invoice_municipio_incidencia_path                   # Código do municipio em que o serviço foi prestado
						attr_accessor :invoice_orgao_gerador_municipio_path                # Órgão gerador municipal da NFS
						attr_accessor :invoice_orgao_gerador_uf_path                       # Órgão gerador estadual da NFS
						attr_accessor :invoice_cancelamento_codigo_path                    # Código do cancelamento da NFS
						attr_accessor :invoice_cancelamento_numero_nf_path                 # Número da NFS cancelada
						attr_accessor :invoice_cancelamento_cnpj_path                      # CNPJ da NF cancelada
						attr_accessor :invoice_cancelamento_municipio_path                 # Municipo da nota cancelada
						attr_accessor :invoice_cancelamento_data_hora_path                 # Data e hora do cancelamento
						attr_accessor :invoice_cancelamento_inscricao_municipal_path       # Inscrição municipal da nota cancelada
						attr_accessor :invoice_nfe_substituidora_path                      # Número da NFS substituidora
						attr_accessor :invoice_codigo_obra_path                            # Código obra
						attr_accessor :invoice_codigo_art_path                             # Código art
						attr_accessor :invoice_emitente_cnpj_path                          # Cnpj do emitente da NFS
						attr_accessor :invoice_emitente_inscricao_municipal_path           # Inscricao municipal do emitente da NFS
						attr_accessor :invoice_emitente_razao_social_path                  # Razao social do emitente da NFS
						attr_accessor :invoice_emitente_nome_fantasia_path                 # Nome fantasia do emitente da NFS
						attr_accessor :invoice_emitente_telefone_path                      # Telefone do emitente da NFS
						attr_accessor :invoice_emitente_email_path                         # Email do emitente da NFS
						attr_accessor :invoice_emitente_endereco_logradouro_path           # Logradouro do emitente da NFS
						attr_accessor :invoice_emitente_endereco_numero_path               # Numero do emitente da NFS
						attr_accessor :invoice_emitente_endereco_complemento_path          # Complemento do emitente da NFS
						attr_accessor :invoice_emitente_endereco_bairro_path               # Bairro do emitente da NFS
						attr_accessor :invoice_emitente_endereco_codigo_municipio_path     # Codigo_municipio do emitente da NFS
						attr_accessor :invoice_emitente_endereco_uf_path                   # Uf do emitente da NFS
						attr_accessor :invoice_emitente_endereco_cep_path                  # Cep do emitente da NFS
						attr_accessor :invoice_destinatario_cpf_path                       # Cpf do destinatário da NFS
						attr_accessor :invoice_destinatario_cnpj_path                      # Cnpj do destinatário da NFS
						attr_accessor :invoice_destinatario_inscricao_municipal_path       # Inscricao municipal do destinatário da NFS
						attr_accessor :invoice_destinatario_inscricao_estadual_path        # Inscricao estadual do destinatário da NFS
						attr_accessor :invoice_destinatario_inscricao_suframa_path         # Inscricao suframa do destinatário da NFS
						attr_accessor :invoice_destinatario_razao_social_path              # Razao social do destinatário da NFS
						attr_accessor :invoice_destinatario_telefone_path                  # Telefone do destinatário da NFS
						attr_accessor :invoice_destinatario_email_path                     # Email do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_logradouro_path       # Logradouro do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_numero_path           # Numero do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_complemento_path      # Complemento do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_bairro_path           # Bairro do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_codigo_municipio_path # Codigo_municipio do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_uf_path               # Uf do destinatário da NFS
						attr_accessor :invoice_destinatario_endereco_cep_path              # Cep do destinatário da NFS
					
					#######################   FIM DA DEFINIÇÃO DOS CAMINHOS   ############################
					######################################################################################
					
					def response
						@response ||= BrNfe::Service::Response::Default.new({
							error_messages:   get_message_for_path(message_errors_path),
							notas_fiscais:    get_invoices,
							protocolo:        get_protocol,
							data_recebimento: get_received_date,
							numero_lote:      get_lot_number,
							situation:        get_situation,
							original_xml:     savon_response.xml.force_encoding('UTF-8'),
							cancelation_date_time: get_cancelation_date_time
						})
					end

					# Retorna o valor encontrado no body da resposta Savon
					# em formato de hash
					#
					# <b>Tipo de retorno: </b> _Hash_
					#
					def savon_body
						return @savon_body if @savon_body.present?
						if body_xml_path.present?
							@savon_body = Nori.new.parse(
								body_converted_to_xml
							).deep_transform_keys!{|k| k.to_s.underscore.to_sym}
						else
							@savon_body = savon_response.try(:body) || {}
						end
					end

					# Converte o body da requisição em XML (String)
					# Isso é necessário quando dentro do body vem a resposta com outro XML
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def body_converted_to_xml
						@body_converted_to_xml ||= canonicalize("#{find_value_for_keys(savon_response.try(:body), body_xml_path)}".encode(xml_encode).force_encoding('UTF-8'))
					end

					# Método utilizado para encontrar valores em um Hash
					# passando o caminho do valor em um array onde contém as chaves
					# ordenadas.
					# Recebe 2 parêmntros:
					# 1º um o hash onde contém o valor a ser encontrado
					# 2º um array com as chaves em sequencia formando o caminho para encontrar o valor.
					#
					# A funcionalidade desse método funciona parecido com o `.dig` da classe Hash do
					# Ruby 2.3.0. 
					# A diferença é que no caso de exmeplo a seguir não apresenta uma excessão par ao usuário
					# hash = {v1: {v2: 'valor string'}}
					# hash.dig(:v1, :v2, :v3) <- Dá erro
					# find_value_for_keys(hash, [:v1, :v2, :v3] <- Retorna nil e não da erro
					#
					# <b>Tipo de retorno: </b> _Anything_
					#
					def find_value_for_keys(hash, keys)
						return if keys.blank?
						keys = [keys] unless keys.is_a?(Array)
						
						result = hash
						keys.each do |key|
							if result.is_a?(Hash)
								result = result[key]
							else
								result = nil
								break
							end
						end
						result
					end

					# Quando para encontrar o valor de uma determinada chave
					# é necessaŕio percorer o hash de retorno dês do inicio do mesmo.
					# Como a mensagem tem uma chave 'root' padrão e pode ser diferente 
					# para cada orgaao emissor, é setado uma valor na variavel keys_root_path
					# para que não seja necessário ficar setando a mesma chave em todos os 
					# métodos utilizados para encontrar determinado valor
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def path_with_root(path)
						return if path.blank?
						keys_root_path + [path].flatten
					end

					# Método que retorna as mensagens de retorno da requisição
					# Quando procurar a mensagem a mesma pode retornar em 3 formatos:
					# Hash: Onde encontrou apenas 1 mensagem com Codigo, Mensagem e Solução
					# Array: Onde encontrou mais de uma mensagem com Codigo, Mensagem e Solução
					# String: Onde encontrou uma unica mensagem de texto
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def get_message_for_path(msg_path)
						messages = []
						_messages = find_value_for_keys(savon_body, path_with_root(msg_path) )
						if _messages.is_a?(Hash)
							messages << get_message_for_hash(_messages)
						elsif _messages.is_a?(Array)
							_messages.map{|msg| messages << get_message_for_hash(msg) if msg.present? }
						elsif _messages.present?
							messages << _messages
						end
						messages.uniq
					end

					# Método utilizado para quando encontrar uam mensagem que seja um HAsh,
					# onde nesse caso a mensagem terá um codigo de erro, uma mensagem, e uma 
					# mensagem de solução
					#
					# <b>Tipo de retorno: </b> _hash_
					#
					def get_message_for_hash(msg_hash)
						{
							code:     find_value_for_keys(msg_hash, message_code_key),
							message:  find_value_for_keys(msg_hash, message_msg_key),
							solution: find_value_for_keys(msg_hash, message_solution_key)
						}
					end

					# Método que retorna as notas fiscais emitidas.
					# Como pode ser que retorne mais de uma NF, a busca pela NF
					# pode retornar um Array ou um Hash.
					# Se retornar um array é porque existe mais de uma NFE, então é necessario
					# percorer com um loop e instanciar cada nota com seus valores.
					# Se retornar um Hash é porque tem apenas uma NFe, e nesse caso 
					# irá instanciar apenas a nfe encontrada.
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def get_invoices
						invoices = []
						_invoices = find_value_for_keys(savon_body, path_with_root(invoices_path))
						if _invoices.is_a?(Hash)
							invoices << instance_invoice(_invoices)
						elsif _invoices.is_a?(Array)
							_invoices.map{|inv| invoices << instance_invoice(inv) }
						end
						invoices
					end

					# Método utilizado para pegar protocolo de solicitação de
					# processamento do RPS.
					# Esse protocolo é utilizado posteriormente para consultar se
					# o RPS já foi processado
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_protocol
						find_value_for_keys(savon_body, path_with_root(protocol_path))
					end

					# Método utilizado para pegar a situação do RPS
					#
					# <b>Tipo de retorno: </b> _Symbol_
					#
					def get_situation
						situation_value = find_value_for_keys(savon_body, path_with_root(situation_path))
						situation_value = situation_key_values[situation_value.to_s.strip] if situation_value.present?
						situation_value
					end

					# Método utilizado para pegar a data de recebimento do lote
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_received_date
						find_value_for_keys(savon_body, path_with_root(received_date_path))
					end

					# Método utilizado para pegar o número do lote RPS
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_lot_number
						find_value_for_keys(savon_body, path_with_root(lot_number_path))
					end

					# Método utilizado para pegar o XML da NF
					# É necessário canonicalizar o document para que seja colocado os
					# namespaces nas tags corretas. Caso contrário o XML não irá abrir.
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_xml_nf
						if body_xml_path.present?
							canonicalize(Nokogiri::XML.parse( body_converted_to_xml , nil, 'UTF-8').xpath(nfe_xml_path).to_xml)
						else
							canonicalize(Nokogiri::XML.parse(canonicalize(savon_response.doc.to_s), nil, 'UTF-8').xpath(nfe_xml_path).to_xml)
						end
					rescue
						savon_response.xml
					end

					# Método utilizado para pegar o valor da data e hora de cancelmaento
					# Só é utilizado para cancelar a NF-e
					#
					# <b>Tipo de retorno: </b> _DateTime_ OU _Nil_ OU _String_
					#
					def get_cancelation_date_time
						find_value_for_keys(savon_body, path_with_root(cancelation_date_time_path)) if cancelation_date_time_path.present?
					end

					# Método responsável por instanciar a nota fiscal de acordo com o hash 
					#   passado por parêmetro
					# O parâmetro recebido deve ser o Hash representado pelo tipo de dados tcCompNfse(do manual NFS-e v1)
					#
					def instance_invoice(invoice_hash)
						nfe = BrNfe::Service::Response::NotaFiscal.new({
							xml_nf:                           get_xml_nf.force_encoding('UTF-8'),
							numero_nf:                        find_value_for_keys(invoice_hash, invoice_numero_nf_path                       ),
							codigo_verificacao:               find_value_for_keys(invoice_hash, invoice_codigo_verificacao_path              ),
							data_emissao:                     find_value_for_keys(invoice_hash, invoice_data_emissao_path                    ),
							url_nf:                           find_value_for_keys(invoice_hash, invoice_url_nf_path                          ),
							competencia:                      find_value_for_keys(invoice_hash, invoice_competencia_path                     ),
							natureza_operacao:                find_value_for_keys(invoice_hash, invoice_natureza_operacao_path               ),
							regime_especial_tributacao:       find_value_for_keys(invoice_hash, invoice_regime_especial_tributacao_path      ),
							optante_simples_nacional:         find_value_for_keys(invoice_hash, invoice_optante_simples_nacional_path        ),
							incentivador_cultural:            find_value_for_keys(invoice_hash, invoice_incentivador_cultural_path           ),
							outras_informacoes:               find_value_for_keys(invoice_hash, invoice_outras_informacoes_path              ),
							item_lista_servico:               find_value_for_keys(invoice_hash, invoice_item_lista_servico_path              ),
							cnae_code:                        find_value_for_keys(invoice_hash, invoice_cnae_code_path                       ),
							description:                      find_value_for_keys(invoice_hash, invoice_description_path                     ),
							codigo_municipio:                 find_value_for_keys(invoice_hash, invoice_codigo_municipio_path                ),
							responsavel_retencao:             find_value_for_keys(invoice_hash, invoice_responsavel_retencao_path            ),
							numero_processo:                  find_value_for_keys(invoice_hash, invoice_numero_processo_path                 ),
							municipio_incidencia:             find_value_for_keys(invoice_hash, invoice_municipio_incidencia_path            ),
							orgao_gerador_municipio:          find_value_for_keys(invoice_hash, invoice_orgao_gerador_municipio_path         ),
							orgao_gerador_uf:                 find_value_for_keys(invoice_hash, invoice_orgao_gerador_uf_path                ),
							codigo_obra:                      find_value_for_keys(invoice_hash, invoice_codigo_obra_path                     ),
							codigo_art:                       find_value_for_keys(invoice_hash, invoice_codigo_art_path                      ),
						})

						build_rps_fields_nfe(nfe, invoice_hash)
						build_cancelation_fields_nfe(nfe, invoice_hash)
						build_values_nfe(nfe, invoice_hash)
						build_emitente_nfe(nfe, invoice_hash)
						build_destinatario_nfe(nfe, invoice_hash)
						nfe
					end
					
					def build_rps_fields_nfe(nfe, invoice_hash)
						nfe.assign_attributes({
							rps_numero:                       find_value_for_keys(invoice_hash, invoice_rps_numero_path                      ),
							rps_serie:                        find_value_for_keys(invoice_hash, invoice_rps_serie_path                       ),
							rps_tipo:                         find_value_for_keys(invoice_hash, invoice_rps_tipo_path                        ),
							rps_situacao:                     find_value_for_keys(invoice_hash, invoice_rps_situacao_path                    ),
							rps_substituido_numero:           find_value_for_keys(invoice_hash, invoice_rps_substituido_numero_path          ),
							rps_substituido_serie:            find_value_for_keys(invoice_hash, invoice_rps_substituido_serie_path           ),
							rps_substituido_tipo:             find_value_for_keys(invoice_hash, invoice_rps_substituido_tipo_path            ),
							data_emissao_rps:                 find_value_for_keys(invoice_hash, invoice_data_emissao_rps_path                ),
						})
					end

					def build_cancelation_fields_nfe(nfe, invoice_hash)
						nfe.assign_attributes({
							cancelamento_codigo:              find_value_for_keys(invoice_hash, invoice_cancelamento_codigo_path             ),
							cancelamento_numero_nf:           find_value_for_keys(invoice_hash, invoice_cancelamento_numero_nf_path          ),
							cancelamento_cnpj:                find_value_for_keys(invoice_hash, invoice_cancelamento_cnpj_path               ),
							cancelamento_inscricao_municipal: find_value_for_keys(invoice_hash, invoice_cancelamento_inscricao_municipal_path),
							cancelamento_municipio:           find_value_for_keys(invoice_hash, invoice_cancelamento_municipio_path          ),
							cancelamento_data_hora:           find_value_for_keys(invoice_hash, invoice_cancelamento_data_hora_path          ),
							nfe_substituidora:                find_value_for_keys(invoice_hash, invoice_nfe_substituidora_path               ),
						})
					end

					def build_values_nfe(nfe, invoice_hash)
						nfe.assign_attributes({
							total_services:          find_value_for_keys(invoice_hash, invoice_total_services_path                  ),
							deductions:              find_value_for_keys(invoice_hash, invoice_deductions_path                      ),
							valor_pis:               find_value_for_keys(invoice_hash, invoice_valor_pis_path                       ),
							valor_cofins:            find_value_for_keys(invoice_hash, invoice_valor_cofins_path                    ),
							valor_inss:              find_value_for_keys(invoice_hash, invoice_valor_inss_path                      ),
							valor_ir:                find_value_for_keys(invoice_hash, invoice_valor_ir_path                        ),
							valor_csll:              find_value_for_keys(invoice_hash, invoice_valor_csll_path                      ),
							iss_retained:            find_value_for_keys(invoice_hash, invoice_iss_retained_path                    ),
							outras_retencoes:        find_value_for_keys(invoice_hash, invoice_outras_retencoes_path                ),
							total_iss:               find_value_for_keys(invoice_hash, invoice_total_iss_path                       ),
							base_calculation:        find_value_for_keys(invoice_hash, invoice_base_calculation_path                ),
							iss_tax_rate:            find_value_for_keys(invoice_hash, invoice_iss_tax_rate_path                    ),
							valor_liquido:           find_value_for_keys(invoice_hash, invoice_valor_liquido_path                   ),
							desconto_condicionado:   find_value_for_keys(invoice_hash, invoice_desconto_condicionado_path           ),
							desconto_incondicionado: find_value_for_keys(invoice_hash, invoice_desconto_incondicionado_path         ),
						})
					end

					def build_emitente_nfe(nfe, invoice_hash)
						nfe.assign_attributes({
							emitente: {
								cnpj:                find_value_for_keys(invoice_hash, invoice_emitente_cnpj_path                  ),
								inscricao_municipal: find_value_for_keys(invoice_hash, invoice_emitente_inscricao_municipal_path   ),
								razao_social:        find_value_for_keys(invoice_hash, invoice_emitente_razao_social_path          ),
								nome_fantasia:       find_value_for_keys(invoice_hash, invoice_emitente_nome_fantasia_path         ),
								telefone:            find_value_for_keys(invoice_hash, invoice_emitente_telefone_path              ),
								email:               find_value_for_keys(invoice_hash, invoice_emitente_email_path                 ),
								endereco: {
									logradouro:       find_value_for_keys(invoice_hash, invoice_emitente_endereco_logradouro_path         ),
									numero:           find_value_for_keys(invoice_hash, invoice_emitente_endereco_numero_path             ),
									complemento:      find_value_for_keys(invoice_hash, invoice_emitente_endereco_complemento_path        ),
									bairro:           find_value_for_keys(invoice_hash, invoice_emitente_endereco_bairro_path             ),
									codigo_municipio: find_value_for_keys(invoice_hash, invoice_emitente_endereco_codigo_municipio_path   ),
									uf:               find_value_for_keys(invoice_hash, invoice_emitente_endereco_uf_path                 ),
									cep:              find_value_for_keys(invoice_hash, invoice_emitente_endereco_cep_path                ),
								}
							}
						})
					end

					def build_destinatario_nfe(nfe, invoice_hash)
						nfe.assign_attributes({
							destinatario: {
								cpf_cnpj: (find_value_for_keys(invoice_hash, invoice_destinatario_cpf_path) || find_value_for_keys(invoice_hash, invoice_destinatario_cnpj_path)),
								inscricao_municipal:       find_value_for_keys(invoice_hash, invoice_destinatario_inscricao_municipal_path),
								inscricao_estadual:        find_value_for_keys(invoice_hash, invoice_destinatario_inscricao_estadual_path),
								inscricao_suframa:         find_value_for_keys(invoice_hash, invoice_destinatario_inscricao_suframa_path),
								razao_social:              find_value_for_keys(invoice_hash, invoice_destinatario_razao_social_path),
								telefone:                  find_value_for_keys(invoice_hash, invoice_destinatario_telefone_path),
								email:                     find_value_for_keys(invoice_hash, invoice_destinatario_email_path),
								endereco: {
									logradouro:             find_value_for_keys(invoice_hash, invoice_destinatario_endereco_logradouro_path),
									numero:                 find_value_for_keys(invoice_hash, invoice_destinatario_endereco_numero_path),
									complemento:            find_value_for_keys(invoice_hash, invoice_destinatario_endereco_complemento_path),
									bairro:                 find_value_for_keys(invoice_hash, invoice_destinatario_endereco_bairro_path),
									codigo_municipio:       find_value_for_keys(invoice_hash, invoice_destinatario_endereco_codigo_municipio_path),
									uf:                     find_value_for_keys(invoice_hash, invoice_destinatario_endereco_uf_path),
									cep:                    find_value_for_keys(invoice_hash, invoice_destinatario_endereco_cep_path),
								}
							}
						})
					end
				end
			end
		end
	end
end