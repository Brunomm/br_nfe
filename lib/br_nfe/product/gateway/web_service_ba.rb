module BrNfe
	module Product
		module Gateway
			class WebServiceBA < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx?wsdl'
						end
					end
					def operation_status_servico
						:nfe_status_servico_nf
					end
					def version_xml_status_servico
						:v3_10
					end
					def url_xmlns_status_servico
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico'
					end
					def ssl_version_status_servico
						:TLSv1
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					def wsdl_autorizacao
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
						end
					end
					def operation_autorizacao
						:nfe_autorizacao_lote
					end
					def version_xml_autorizacao
						:v3_10
					end
					def url_xmlns_autorizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao'
					end
					def ssl_version_autorizacao
						:TLSv1
					end

				##########################################################################################
				################################  NFE RETORNO AUTORIZAÇÃO  ###############################
					def wsdl_retorno_autorizacao
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
						end
					end
					def operation_retorno_autorizacao
						:nfe_ret_autorizacao_lote
					end
					def version_xml_retorno_autorizacao
						:v3_10
					end
					def url_xmlns_retorno_autorizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao'
					end
					def ssl_version_retorno_autorizacao
						:TLSv1
					end

				##########################################################################################
				################################  NFE CONSULTA PROTOCOLO  ################################
					def wsdl_consulta_protocolo
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx?wsdl'
						end
					end
					def operation_consulta_protocolo
						:nfe_consulta_nf
					end
					def version_xml_consulta_protocolo
						:v3_10
					end
					def url_xmlns_consulta_protocolo
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta'
					end
					def ssl_version_consulta_protocolo
						:TLSv1
					end

				##########################################################################################
				################################  NFE INUTILIZAÇÃO  ######################################
					def wsdl_inutilizacao
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx?wsdl'
						end
					end
					def operation_inutilizacao
						:nfe_inutilizacao_nf
					end
					def version_xml_inutilizacao
						:v3_10
					end
					def url_xmlns_inutilizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao'
					end
					def ssl_version_inutilizacao
						:TLSv1
					end

				##########################################################################################
				################################  NFE RECEPÇÃO EVENTO  ###################################
					def wsdl_recepcao_evento
						if env_production?
							'https://nfe.sefaz.ba.gov.br/webservices/sre/recepcaoevento.asmx?wsdl'
						else
							'https://hnfe.sefaz.ba.gov.br/webservices/sre/recepcaoevento.asmx?wsdl'
						end
					end
					def operation_recepcao_evento
						:nfe_recepcao_evento
					end
					def version_xml_recepcao_evento
						:v1_00
					end
					def url_xmlns_recepcao_evento
						'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento'
					end
					def ssl_version_recepcao_evento
						:TLSv1
					end
			end
		end
	end
end