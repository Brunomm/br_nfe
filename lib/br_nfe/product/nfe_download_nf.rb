module BrNfe
	module Product
		class NfeDownloadNf < BrNfe::Product::Base
			# UTILIZADO PARA FORÇAR A UTILIZAÇÃO DE OUTRO GATEWAY
			#  O Gateway padrão da GEM para o download da NF é o
			#  webservice do AN(Ambiente Nacional) (Exceto para o estado do
			#  Ceará(CE), na qual possui url própria para download da NF).
			#  Outro Webservice que pode ser utilizado é do SVAN (Servidor Virtual do
			#  Ambiente Nacional).
			#  Pode ser modificado o servidor passando o attr :force_gateway com 
			#  um dos seguintes valores:
			#  - :SVAN - Na qual irá forçar o uso do Servidor Virtual do Ambiente Nacional
			#  - :AN - Na qual irá forçar o uso do Ambiente Nacional (apenas para o estado
			#          do Ceará, já que esse é o servidor padrão para os demais estados)
			# 
			# <b>Type:     </b> _Symbol_
			# <b>Required: </b> _No_
			# <b>Example:  </b> _:SVAN_
			# <b>Default:  </b> _nil_
			#
			attr_accessor :force_gateway
			def force_gateway=(value)
				@force_gateway = "#{value}".to_sym
			end

			# CHAVE DE ACESSO DA NF-E.
			# 
			# <b>Type:     </b> _Number_
			# <b>Required: </b> _Yes_
			# <b>Example:  </b> _42000082176983000186550000000000006313331836_
			# <b>Length:   </b> _44_
			# <b>tag:      </b> chNFe
			#
			attr_accessor :chave_nfe
			alias_attribute :chNFe, :chave_nfe

			validates :chave_nfe, presence: true
			validates :chave_nfe, length: {is: 44}

			def gateway
				@gateway ||= case force_gateway
				when :SVAN
					BrNfe::Product::Gateway::WebServiceSVAN.new({env: env})
				when :AN
					BrNfe::Product::Gateway::Base.new({env: env})
				else
					super
				end
			end


			# URL do webservice para enviar as informações.
			def wsdl
				gateway.wsdl_download_nf
			end

			# Método SOAP que será chamado para enviar o XML
			def method_wsdl
				gateway.operation_download_nf
			end

			# Versão utilizada pelo webservice do  estado para determinada ação.
			def gateway_xml_version
				gateway.version_xml_download_nf
			end

			# URL que será setada no atribto xmlns do XML;
			def url_xmlns
				gateway.url_xmlns_download_nf
			end

			# Versão SSL utilizada pelo webservice
			def ssl_version
				gateway.ssl_version_download_nf
			end

			# XML que será enviado no body da requisição SOAP contendo as informações
			# específicas de cada operação.
			def xml_builder
				# render_xml 'nfe_consulta_autorizacao'
			end
		end
	end
end