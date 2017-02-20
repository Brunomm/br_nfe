module BrNfe
	module Product
		module Gateway
			class WebServiceSVAN < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
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
						:TLSv1
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					def wsdl_autorizacao
						if env_production?
							'https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
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
							'https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx?wsdl'
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
							'https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx?wsdl'
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
						:TLSv1
					end

				##########################################################################################
				################################  NFE INUTILIZAÇÃO  ######################################
					def wsdl_inutilizacao
						if env_production?
							'https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl'
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
						:TLSv1
					end

				##########################################################################################
				################################  NFE RECEPÇÃO EVENTO  ###################################
					def wsdl_recepcao_evento
						if env_production?
							'https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx?wsdl'
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

				##########################################################################################
				#################################  NFE DOWNLOAD NF  ######################################
					def wsdl_download_nf
						if env_production?
							'https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
						else
							'https://hom.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
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