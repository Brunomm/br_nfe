#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class InvoiceBuild  < BrNfe::Service::Response::Build::Base

					# Módule que contém o caminho padrão para pegar os dados da NFS-e.
					# O Padrão dos caminhos obedece a documentação da ABRASF
					include BrNfe::Service::Response::Paths::V1::TcNfse

					# Caminho para encontrar o XML da NF-e
					attr_accessor :nfe_xml_path

					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
						#                                                                     Caminho para encontrar
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
						attr_accessor :invoice_valor_total_servicos_path                         # Valor total dos serviços
						attr_accessor :invoice_deducoes_path                             # Valor das deduções
						attr_accessor :invoice_valor_pis_path                              # Valor do PIS
						attr_accessor :invoice_valor_cofins_path                           # Valor do COFINS
						attr_accessor :invoice_valor_inss_path                             # Valor do INSS
						attr_accessor :invoice_valor_ir_path                               # Valor do IR
						attr_accessor :invoice_valor_csll_path                             # Valor da CSLL
						attr_accessor :invoice_iss_retido_path                           # Se o ISS está retido
						attr_accessor :invoice_outras_retencoes_path                       # Valor Outras retenções
						attr_accessor :invoice_total_iss_path                              # Valor total de ISS
						attr_accessor :invoice_base_calculo_path                       # Valor da base de cálculo
						attr_accessor :invoice_iss_aliquota_path                           # Percentual do imposto de ISS
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
					
					######################################################################################
					###############   DEFINIÇÃO DOS VALORES PADRÕES PARA O CAMINHO DA NFSE ###############
						def default_values
							super.merge({
								# invoices_path:                                       response_invoices_path,
								invoice_numero_nf_path:                              response_invoice_numero_nf_path,
								invoice_codigo_verificacao_path:                     response_invoice_codigo_verificacao_path,
								invoice_data_emissao_path:                           response_invoice_data_emissao_path,
								# invoice_url_nf_path:                                 response_invoice_url_nf_path,
								invoice_rps_numero_path:                             response_invoice_rps_numero_path,
								invoice_rps_serie_path:                              response_invoice_rps_serie_path,
								invoice_rps_tipo_path:                               response_invoice_rps_tipo_path,
								# invoice_rps_situacao_path:                           response_invoice_rps_situacao_path,
								# invoice_rps_substituido_numero_path:                 response_invoice_rps_substituido_numero_path,
								# invoice_rps_substituido_serie_path:                  response_invoice_rps_substituido_serie_path,
								# invoice_rps_substituido_tipo_path:                   response_invoice_rps_substituido_tipo_path,
								invoice_data_emissao_rps_path:                       response_invoice_data_emissao_rps_path,
								invoice_competencia_path:                            response_invoice_competencia_path,
								invoice_natureza_operacao_path:                      response_invoice_natureza_operacao_path,
								invoice_regime_especial_tributacao_path:             response_invoice_regime_especial_tributacao_path,
								invoice_optante_simples_nacional_path:               response_invoice_optante_simples_nacional_path,
								invoice_incentivador_cultural_path:                  response_invoice_incentivador_cultural_path,
								invoice_outras_informacoes_path:                     response_invoice_outras_informacoes_path,
								invoice_item_lista_servico_path:                     response_invoice_item_lista_servico_path,
								invoice_cnae_code_path:                              response_invoice_cnae_code_path,
								invoice_description_path:                            response_invoice_description_path,
								invoice_codigo_municipio_path:                       response_invoice_codigo_municipio_path,
								invoice_valor_total_servicos_path:                         response_invoice_valor_total_servicos_path,
								invoice_deducoes_path:                             response_invoice_deducoes_path,
								invoice_valor_pis_path:                              response_invoice_valor_pis_path,
								invoice_valor_cofins_path:                           response_invoice_valor_cofins_path,
								invoice_valor_inss_path:                             response_invoice_valor_inss_path,
								invoice_valor_ir_path:                               response_invoice_valor_ir_path,
								invoice_valor_csll_path:                             response_invoice_valor_csll_path,
								invoice_iss_retido_path:                           response_invoice_iss_retido_path,
								invoice_outras_retencoes_path:                       response_invoice_outras_retencoes_path,
								invoice_total_iss_path:                              response_invoice_total_iss_path,
								invoice_base_calculo_path:                       response_invoice_base_calculo_path,
								invoice_iss_aliquota_path:                           response_invoice_iss_aliquota_path,
								invoice_valor_liquido_path:                          response_invoice_valor_liquido_path,
								invoice_desconto_condicionado_path:                  response_invoice_desconto_condicionado_path,
								invoice_desconto_incondicionado_path:                response_invoice_desconto_incondicionado_path,
								# invoice_responsavel_retencao_path:                   response_invoice_responsavel_retencao_path,
								# invoice_numero_processo_path:                        response_invoice_numero_processo_path,
								# invoice_municipio_incidencia_path:                   response_invoice_municipio_incidencia_path,
								invoice_orgao_gerador_municipio_path:                response_invoice_orgao_gerador_municipio_path,
								invoice_orgao_gerador_uf_path:                       response_invoice_orgao_gerador_uf_path,
								invoice_cancelamento_codigo_path:                    response_invoice_cancelamento_codigo_path,
								invoice_cancelamento_numero_nf_path:                 response_invoice_cancelamento_numero_nf_path,
								invoice_cancelamento_cnpj_path:                      response_invoice_cancelamento_cnpj_path,
								invoice_cancelamento_municipio_path:                 response_invoice_cancelamento_municipio_path,
								invoice_cancelamento_data_hora_path:                 response_invoice_cancelamento_data_hora_path,
								invoice_cancelamento_inscricao_municipal_path:       response_invoice_cancelamento_inscricao_municipal_path,
								invoice_nfe_substituidora_path:                      response_invoice_nfe_substituidora_path,
								invoice_codigo_obra_path:                            response_invoice_codigo_obra_path,
								invoice_codigo_art_path:                             response_invoice_codigo_art_path,
								invoice_emitente_cnpj_path:                          response_invoice_emitente_cnpj_path,
								invoice_emitente_inscricao_municipal_path:           response_invoice_emitente_inscricao_municipal_path,
								invoice_emitente_razao_social_path:                  response_invoice_emitente_razao_social_path,
								invoice_emitente_nome_fantasia_path:                 response_invoice_emitente_nome_fantasia_path,
								invoice_emitente_telefone_path:                      response_invoice_emitente_telefone_path,
								invoice_emitente_email_path:                         response_invoice_emitente_email_path,
								invoice_emitente_endereco_logradouro_path:           response_invoice_emitente_endereco_logradouro_path,
								invoice_emitente_endereco_numero_path:               response_invoice_emitente_endereco_numero_path,
								invoice_emitente_endereco_complemento_path:          response_invoice_emitente_endereco_complemento_path,
								invoice_emitente_endereco_bairro_path:               response_invoice_emitente_endereco_bairro_path,
								invoice_emitente_endereco_codigo_municipio_path:     response_invoice_emitente_endereco_codigo_municipio_path,
								invoice_emitente_endereco_uf_path:                   response_invoice_emitente_endereco_uf_path,
								invoice_emitente_endereco_cep_path:                  response_invoice_emitente_endereco_cep_path,
								invoice_destinatario_cpf_path:                       response_invoice_destinatario_cpf_path,
								invoice_destinatario_cnpj_path:                      response_invoice_destinatario_cnpj_path,
								invoice_destinatario_inscricao_municipal_path:       response_invoice_destinatario_inscricao_municipal_path,
								invoice_destinatario_inscricao_estadual_path:        response_invoice_destinatario_inscricao_estadual_path,
								invoice_destinatario_inscricao_suframa_path:         response_invoice_destinatario_inscricao_suframa_path,
								invoice_destinatario_razao_social_path:              response_invoice_destinatario_razao_social_path,
								invoice_destinatario_telefone_path:                  response_invoice_destinatario_telefone_path,
								invoice_destinatario_email_path:                     response_invoice_destinatario_email_path,
								invoice_destinatario_endereco_logradouro_path:       response_invoice_destinatario_endereco_logradouro_path,
								invoice_destinatario_endereco_numero_path:           response_invoice_destinatario_endereco_numero_path,
								invoice_destinatario_endereco_complemento_path:      response_invoice_destinatario_endereco_complemento_path,
								invoice_destinatario_endereco_bairro_path:           response_invoice_destinatario_endereco_bairro_path,
								invoice_destinatario_endereco_codigo_municipio_path: response_invoice_destinatario_endereco_codigo_municipio_path,
								invoice_destinatario_endereco_uf_path:               response_invoice_destinatario_endereco_uf_path,
								invoice_destinatario_endereco_cep_path:              response_invoice_destinatario_endereco_cep_path,
							})
						end
					##############  FIM DEFINIÇÃO DOS VALORES PADRÕES PARA O CAMINHO DA NFSE #############
					######################################################################################
					
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
							valor_total_servicos:          find_value_for_keys(invoice_hash, invoice_valor_total_servicos_path                  ),
							deducoes:              find_value_for_keys(invoice_hash, invoice_deducoes_path                      ),
							valor_pis:               find_value_for_keys(invoice_hash, invoice_valor_pis_path                       ),
							valor_cofins:            find_value_for_keys(invoice_hash, invoice_valor_cofins_path                    ),
							valor_inss:              find_value_for_keys(invoice_hash, invoice_valor_inss_path                      ),
							valor_ir:                find_value_for_keys(invoice_hash, invoice_valor_ir_path                        ),
							valor_csll:              find_value_for_keys(invoice_hash, invoice_valor_csll_path                      ),
							iss_retido:            find_value_for_keys(invoice_hash, invoice_iss_retido_path                    ),
							outras_retencoes:        find_value_for_keys(invoice_hash, invoice_outras_retencoes_path                ),
							total_iss:               find_value_for_keys(invoice_hash, invoice_total_iss_path                       ),
							base_calculo:        find_value_for_keys(invoice_hash, invoice_base_calculo_path                ),
							iss_aliquota:            find_value_for_keys(invoice_hash, invoice_iss_aliquota_path                    ),
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