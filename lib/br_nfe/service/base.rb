module BrNfe
	module Service
		class Base < BrNfe::Base
			include BrNfe::Service::Concerns::ValuesTs::ServiceV1

			# Alguns orgãos emissores necessitam que seja
			# passado junto ao XML o Usuário e Senha do acesso do sistema
			# da prefeitura.
			#
			attr_accessor :username
			attr_accessor :password
			
			# Declaro que o método `render_xml` irá verificar os arquivos também presentes
			# no diretório especificado
			#
			# <b>Tipo de retorno: </b> _Array_
			#
			def xml_current_dir_path
				["#{BrNfe.root}/lib/br_nfe/service/xml/#{xml_version}"]+super
			end

			def response_root_path
				[]
			end

			def nfse_xml_path
				#//Envelope/Body/ConsultarLoteRpsEnvioResponse/ConsultarLoteRpsResposta
				'//*/*/*/*'
			end

			def body_xml_path
				[]
			end

			def id_attribute?
				true
			end

			def request
				set_response( client_wsdl.call(method_wsdl, xml: soap_xml) )
			rescue Savon::SOAPFault => error
				return @response = BrNfe::Service::Response::Default.new(status: :soap_error, error_messages: [error.message])
			rescue Savon::HTTPError => error
				return @response = BrNfe::Service::Response::Default.new(status: :http_error, error_messages: [error.message])
			rescue Exception => error
				return @response = BrNfe::Service::Response::Default.new(status: :unknown_error, error_messages: [error.message])
			end

		private

			def emitente_class
				BrNfe.emitente_service_class
			end

			def set_response(resp)
				@original_response = resp
				@response = BrNfe::Service::Response::BuildResponse.new(
					savon_response: resp, # Rsposta da requisição SOAP
					keys_root_path: response_root_path, # Caminho inicial da resposta / Chave pai principal
					nfe_xml_path:   nfse_xml_path, # Caminho para encontrar a NF dentro do XML
					body_xml_path:  body_xml_path,
					xml_encode:     response_encoding, # Codificação do xml de resposta
					lot_number_path:                                     response_lot_number_path,
					protocol_path:                                       response_protocol_path,
					received_date_path:                                  response_received_date_path,
					situation_path:                                      response_situation_path,
					situation_key_values:                                response_situation_key_values,
					cancelation_date_time_path:                          response_cancelation_date_time_path,
					message_errors_path:                                 response_message_errors_path,
					message_code_key:                                    response_message_code_key,
					message_msg_key:                                     response_message_msg_key,
					message_solution_key:                                response_message_solution_key,
					invoices_path:                                       response_invoices_path,
					invoice_numero_nf_path:                              response_invoice_numero_nf_path,
					invoice_codigo_verificacao_path:                     response_invoice_codigo_verificacao_path,
					invoice_data_emissao_path:                           response_invoice_data_emissao_path,
					invoice_url_nf_path:                                 response_invoice_url_nf_path,
					invoice_rps_numero_path:                             response_invoice_rps_numero_path,
					invoice_rps_serie_path:                              response_invoice_rps_serie_path,
					invoice_rps_tipo_path:                               response_invoice_rps_tipo_path,
					invoice_rps_situacao_path:                           response_invoice_rps_situacao_path,
					invoice_rps_substituido_numero_path:                 response_invoice_rps_substituido_numero_path,
					invoice_rps_substituido_serie_path:                  response_invoice_rps_substituido_serie_path,
					invoice_rps_substituido_tipo_path:                   response_invoice_rps_substituido_tipo_path,
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
					invoice_total_services_path:                         response_invoice_total_services_path,
					invoice_deductions_path:                             response_invoice_deductions_path,
					invoice_valor_pis_path:                              response_invoice_valor_pis_path,
					invoice_valor_cofins_path:                           response_invoice_valor_cofins_path,
					invoice_valor_inss_path:                             response_invoice_valor_inss_path,
					invoice_valor_ir_path:                               response_invoice_valor_ir_path,
					invoice_valor_csll_path:                             response_invoice_valor_csll_path,
					invoice_iss_retained_path:                           response_invoice_iss_retained_path,
					invoice_outras_retencoes_path:                       response_invoice_outras_retencoes_path,
					invoice_total_iss_path:                              response_invoice_total_iss_path,
					invoice_base_calculation_path:                       response_invoice_base_calculation_path,
					invoice_iss_tax_rate_path:                           response_invoice_iss_tax_rate_path,
					invoice_valor_liquido_path:                          response_invoice_valor_liquido_path,
					invoice_desconto_condicionado_path:                  response_invoice_desconto_condicionado_path,
					invoice_desconto_incondicionado_path:                response_invoice_desconto_incondicionado_path,
					invoice_responsavel_retencao_path:                   response_invoice_responsavel_retencao_path,
					invoice_numero_processo_path:                        response_invoice_numero_processo_path,
					invoice_municipio_incidencia_path:                   response_invoice_municipio_incidencia_path,
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
				).response
			end

		end
	end
end