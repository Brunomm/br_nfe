module BrNfe
	module Product
		module Gateway
			class WebServiceMT < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
						end
					end
					def operation_status_servico
						:nfe_status_servico_nf2
					end
					def version_xml_status_servico
						env_production? ? :v3_10 : :v2_00
					end
					def url_xmlns_status_servico
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2'
					end
					def ssl_version_status_servico
						env_production? ? :SSLv3 : :TLSv1
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					def wsdl_autorizacao
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'
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
						env_production? ? :SSLv3 : :TLSv1
					end

				##########################################################################################
				################################  NFE RETORNO AUTORIZAÇÃO  ###############################
					def wsdl_retorno_autorizacao
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl'
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
						env_production? ? :SSLv3 : :TLSv1
					end

				##########################################################################################
				################################  NFE CONSULTA PROTOCOLO  ################################
					def wsdl_consulta_protocolo
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl'
						end
					end
					def operation_consulta_protocolo
						:nfe_consulta_nf2
					end
					def version_xml_consulta_protocolo
						env_production? ? :v3_10 : :v2_00
					end
					def url_xmlns_consulta_protocolo
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2'
					end
					def ssl_version_consulta_protocolo
						env_production? ? :SSLv3 : :TLSv1
					end

				##########################################################################################
				################################  NFE INUTILIZAÇÃO  ######################################
					def wsdl_inutilizacao
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl'
						end
					end
					def operation_inutilizacao
						:nfe_inutilizacao_nf2
					end
					def version_xml_inutilizacao
						env_production? ? :v3_10 : :v2_00
					end
					def url_xmlns_inutilizacao
						'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2'
					end
					def ssl_version_inutilizacao
						env_production? ? :SSLv3 : :TLSv1
					end

				##########################################################################################
				################################  NFE RECEPÇÃO EVENTO  ###################################
					def wsdl_recepcao_evento
						if env_production?
							'https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl'
						else
							'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl'
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
						env_production? ? :SSLv3 : :TLSv1
					end
			end
		end
	end
end