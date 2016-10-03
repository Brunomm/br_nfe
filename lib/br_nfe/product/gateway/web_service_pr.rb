module BrNfe
	module Product
		module Gateway
			class WebServicePR < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl'
						end
					end
					def operation_status_servico
						:nfe_status_servico_nf
					end
					def version_xml_status_servico
						:v3_10
					end
					def url_xmlns_status_servico
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico3'
					end
					def ssl_version_status_servico
						:SSLv3
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					def wsdl_autorizacao
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl'
						end
					end
					def operation_autorizacao
						:nfe_autorizacao_lote
					end
					def version_xml_autorizacao
						:v3_10
					end
					def url_xmlns_autorizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao3'
					end
					def ssl_version_autorizacao
						:SSLv3
					end

				##########################################################################################
				################################  NFE RETORNO AUTORIZAÇÃO  ###############################
					def wsdl_retorno_autorizacao
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl'
						end
					end
					def operation_retorno_autorizacao
						:nfe_ret_autorizacao
					end
					def version_xml_retorno_autorizacao
						:v3_10
					end
					def url_xmlns_retorno_autorizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao3'
					end
					def ssl_version_retorno_autorizacao
						:SSLv3
					end

				##########################################################################################
				################################  NFE CONSULTA PROTOCOLO  ################################
					def wsdl_consulta_protocolo
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl'
						end
					end
					def operation_consulta_protocolo
						:nfe_consulta_nf
					end
					def version_xml_consulta_protocolo
						:v3_10
					end
					def url_xmlns_consulta_protocolo
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta3'
					end
					def ssl_version_consulta_protocolo
						:SSLv3
					end

				##########################################################################################
				################################  NFE INUTILIZAÇÃO  ######################################
					def wsdl_inutilizacao
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl'
						end
					end
					def operation_inutilizacao
						:nfe_inutilizacao_nf
					end
					def version_xml_inutilizacao
						:v3_10
					end
					def url_xmlns_inutilizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao3'
					end
					def ssl_version_inutilizacao
						:SSLv3
					end

				##########################################################################################
				################################  NFE RECEPÇÃO EVENTO  ###################################
					def wsdl_recepcao_evento
						if env_production?
							'https://nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl'
						else
							'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl'
						end
					end
					def operation_recepcao_evento
						:nfe_recepcao_evento
					end
					def version_xml_recepcao_evento
						:v3_10
					end
					def url_xmlns_recepcao_evento
						'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento'
					end
					def ssl_version_recepcao_evento
						:SSLv3
					end
			end
		end
	end
end