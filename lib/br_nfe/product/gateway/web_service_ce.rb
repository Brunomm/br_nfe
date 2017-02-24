module BrNfe
	module Product
		module Gateway
			class WebServiceCE < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl'
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
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl'
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
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl'
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
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl'
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
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl'
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
							'https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl'
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

				##########################################################################################
				#################################  NFE DOWNLOAD NF  ######################################
					def wsdl_download_nf
						if env_production?
							'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl'
						else
							'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl'
						end
					end
					def operation_download_nf
						:nfe_download_nf
					end
					def version_xml_download_nf
						:v1_00
					end
					def url_xmlns_download_nf
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeDownloadNF'
					end
					def ssl_version_download_nf
						:TLSv1
					end
			end
		end
	end
end