module BrNfe
	module Product
		module Gateway
			class WebServiceMS < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2?wsdl'
						end
					end
					def operation_status_servico
						:nfe_status_servico_nf2
					end
					def version_xml_status_servico
						:v3_10
					end
					def url_xmlns_status_servico
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2'
					end
					def ssl_version_status_servico
						:SSLv3
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					def wsdl_autorizacao
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeAutorizacao?wsdl'
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
						:SSLv3
					end

				##########################################################################################
				################################  NFE RETORNO AUTORIZAÇÃO  ###############################
					def wsdl_retorno_autorizacao
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetAutorizacao?wsdl'
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
						:SSLv3
					end

				##########################################################################################
				################################  NFE CONSULTA PROTOCOLO  ################################
					def wsdl_consulta_protocolo
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2?wsdl'
						end
					end
					def operation_consulta_protocolo
						:nfe_consulta_nf2
					end
					def version_xml_consulta_protocolo
						:v3_10
					end
					def url_xmlns_consulta_protocolo
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2'
					end
					def ssl_version_consulta_protocolo
						:SSLv3
					end

				##########################################################################################
				################################  NFE INUTILIZAÇÃO  ######################################
					def wsdl_inutilizacao
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2?wsdl'
						end
					end
					def operation_inutilizacao
						:nfe_inutilizacao_nf2
					end
					def version_xml_inutilizacao
						:v3_10
					end
					def url_xmlns_inutilizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2'
					end
					def ssl_version_inutilizacao
						:SSLv3
					end

				##########################################################################################
				################################  NFE RECEPÇÃO EVENTO  ###################################
					def wsdl_recepcao_evento
						if env_production?
							'https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento?wsdl'
						else
							'https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento?wsdl'
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
						:SSLv3
					end
			end
		end
	end
end