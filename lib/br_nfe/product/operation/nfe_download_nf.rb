module BrNfe
	module Product
		module Operation
			class NfeDownloadNf < Base
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

				def gateway_settings
					@gateway_settings ||= case force_gateway
					when :SVAN
						BrNfe.settings[:nfe][nfe_version][:gateway][:svan]
					when :AN
						BrNfe.settings[:nfe][nfe_version][:gateway][:sc] # Santa catarina utiliza o webservice do AN para download de nf
					else
						super
					end
				end

				def operation_name
					:download_nf
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeDownloadNf'
				end
			end
		end
	end
end