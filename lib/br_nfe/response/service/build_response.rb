module BrNfe
	module Response
		module Service
			class BuildResponse  < BrNfe::ActiveModelBase
				# 1: A resposta da requisição soap
				attr_accessor :savon_response
				
				# 2: O module que será incluido contendo os métodos com os
				#    caminhos das chaves para encontrar cada valor
				attr_accessor :module_methods
				
				# 3: Um array com o caminho inicial padrão da requisição de retorno
				attr_accessor :keys_root_path

				# 4: Caminho para encontrar o XML da NF-e
				attr_accessor :nfe_xml_path				

				# 5: Alguns Webservices trazem dentro do body da resposta SOAp
				# outro XML com as informações necessárias.
				# Quando isso aocntece é preciso converter esse XML para um HASH
				# para que possamos encontrar os valores necessários.
				attr_accessor :body_xml_path
				
				def initialize(attributes = {})
					super(attributes)
					include_module!
				end

				# Método utilizado para incluir módules dinâmicos
				#
				def include_module!
					self.class.send(:include, module_methods) if module_methods
				end

				def response
					@response ||= BrNfe::Response::Service::Default.new({
						error_messages:   get_message_for_path(message_errors_path),
						notas_fiscais:    get_invoices,
						protocolo:        get_protocol,
						data_recebimento: get_received_date,
						numero_lote:      get_lot_number,
						situation:        get_situation,
						original_xml:     savon_response.xml,
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
							find_value_for_keys(savon_response.try(:body), body_xml_path)
						).deep_transform_keys!{|k| k.to_s.underscore.to_sym}
					else
						@savon_body = savon_response.try(:body) || {}
					end
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
						_messages.map{|msg| messages << get_message_for_hash(msg) }
					elsif _messages.present?
						messages << _messages
					end
					messages
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
					_inoices = find_value_for_keys(savon_body, path_with_root(invoices_path))
					if _inoices.is_a?(Hash)
						invoices << instance_invoice(_inoices)
					elsif _inoices.is_a?(Array)
						_inoices.map{|inv| invoices << instance_invoice(inv) }
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
				#
				# <b>Tipo de retorno: </b> _String_
				#
				def get_xml_nf
					canonicalize( savon_response.xpath(nfe_xml_path).to_xml )
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
					BrNfe::Response::Service::NotaFiscal.new({
						xml_nf:                           get_xml_nf,
						numero_nf:                        find_value_for_keys(invoice_hash, invoice_numero_nf_path                       ),
						codigo_verificacao:               find_value_for_keys(invoice_hash, invoice_codigo_verificacao_path              ),
						data_emissao:                     find_value_for_keys(invoice_hash, invoice_data_emissao_path                    ),
						url_nf:                           find_value_for_keys(invoice_hash, invoice_url_nf_path                          ),
						rps_numero:                       find_value_for_keys(invoice_hash, invoice_rps_numero_path                      ),
						rps_serie:                        find_value_for_keys(invoice_hash, invoice_rps_serie_path                       ),
						rps_tipo:                         find_value_for_keys(invoice_hash, invoice_rps_tipo_path                        ),
						rps_situacao:                     find_value_for_keys(invoice_hash, invoice_rps_situacao_path                    ),
						rps_substituido_numero:           find_value_for_keys(invoice_hash, invoice_rps_substituido_numero_path          ),
						rps_substituido_serie:            find_value_for_keys(invoice_hash, invoice_rps_substituido_serie_path           ),
						rps_substituido_tipo:             find_value_for_keys(invoice_hash, invoice_rps_substituido_tipo_path            ),
						data_emissao_rps:                 find_value_for_keys(invoice_hash, invoice_data_emissao_rps_path                ),
						competencia:                      find_value_for_keys(invoice_hash, invoice_competencia_path                     ),
						outras_informacoes:               find_value_for_keys(invoice_hash, invoice_outras_informacoes_path              ),
						item_lista_servico:               find_value_for_keys(invoice_hash, invoice_item_lista_servico_path              ),
						cnae_code:                        find_value_for_keys(invoice_hash, invoice_cnae_code_path                       ),
						description:                      find_value_for_keys(invoice_hash, invoice_description_path                     ),
						codigo_municipio:                 find_value_for_keys(invoice_hash, invoice_codigo_municipio_path                ),
						total_services:                   find_value_for_keys(invoice_hash, invoice_total_services_path                  ),
						deductions:                       find_value_for_keys(invoice_hash, invoice_deductions_path                      ),
						valor_pis:                        find_value_for_keys(invoice_hash, invoice_valor_pis_path                       ),
						valor_cofins:                     find_value_for_keys(invoice_hash, invoice_valor_cofins_path                    ),
						valor_inss:                       find_value_for_keys(invoice_hash, invoice_valor_inss_path                      ),
						valor_ir:                         find_value_for_keys(invoice_hash, invoice_valor_ir_path                        ),
						valor_csll:                       find_value_for_keys(invoice_hash, invoice_valor_csll_path                      ),
						iss_retained:                     find_value_for_keys(invoice_hash, invoice_iss_retained_path                    ),
						outras_retencoes:                 find_value_for_keys(invoice_hash, invoice_outras_retencoes_path                ),
						total_iss:                        find_value_for_keys(invoice_hash, invoice_total_iss_path                       ),
						base_calculation:                 find_value_for_keys(invoice_hash, invoice_base_calculation_path                ),
						iss_tax_rate:                     find_value_for_keys(invoice_hash, invoice_iss_tax_rate_path                    ),
						valor_liquido:                    find_value_for_keys(invoice_hash, invoice_valor_liquido_path                   ),
						desconto_condicionado:            find_value_for_keys(invoice_hash, invoice_desconto_condicionado_path           ),
						desconto_incondicionado:          find_value_for_keys(invoice_hash, invoice_desconto_incondicionado_path         ),
						responsavel_retencao:             find_value_for_keys(invoice_hash, invoice_responsavel_retencao_path            ),
						numero_processo:                  find_value_for_keys(invoice_hash, invoice_numero_processo_path                 ),
						municipio_incidencia:             find_value_for_keys(invoice_hash, invoice_municipio_incidencia_path            ),
						orgao_gerador_municipio:          find_value_for_keys(invoice_hash, invoice_orgao_gerador_municipio_path         ),
						orgao_gerador_uf:                 find_value_for_keys(invoice_hash, invoice_orgao_gerador_uf_path                ),
						cancelamento_codigo:              find_value_for_keys(invoice_hash, invoice_cancelamento_codigo_path             ),
						cancelamento_numero_nf:           find_value_for_keys(invoice_hash, invoice_cancelamento_numero_nf_path          ),
						cancelamento_cnpj:                find_value_for_keys(invoice_hash, invoice_cancelamento_cnpj_path               ),
						cancelamento_inscricao_municipal: find_value_for_keys(invoice_hash, invoice_cancelamento_inscricao_municipal_path),
						cancelamento_municipio:           find_value_for_keys(invoice_hash, invoice_cancelamento_municipio_path          ),
						cancelamento_sucesso:             find_value_for_keys(invoice_hash, invoice_cancelamento_sucesso_path            ),
						cancelamento_data_hora:           find_value_for_keys(invoice_hash, invoice_cancelamento_data_hora_path          ),
						nfe_substituidora:                find_value_for_keys(invoice_hash, invoice_nfe_substituidora_path               ),
						codigo_obra:                      find_value_for_keys(invoice_hash, invoice_codigo_obra_path                     ),
						codigo_art:                       find_value_for_keys(invoice_hash, invoice_codigo_art_path                      )
					})
				end

			end
		end
	end
end