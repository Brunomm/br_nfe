module BrNfe
	module Product
		module Gateway
			class Base < BrNfe::ActiveModelBase

				attr_accessor :env

				def env_production?; env == :production end

				##########################################################################################
				##################################  NFE DOWNLOAD NF  #####################################
					def wsdl_download_nf
						if env_production?
							'https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
						else
							'https://hom.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx?wsdl'
						end
					end
					def operation_download_nf
						:nfe_download_nf
					end
					def version_xml_download_nf
						:v3_10
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