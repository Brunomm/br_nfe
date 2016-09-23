module BrNfe
	module Product
		module Gateway
			class WebServiceSVRS < Base

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					def wsdl_status_servico
						if env_production?
							'https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
						else
							'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
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

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					# def wsdl_autorizacao
						# 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
					# end
					# def operation_autorizacao
						# :nfe_autorizacao_lote
					# end
					# def version_xml_autorizacao
						# :v3_10
					# end
			end
		end
	end
end