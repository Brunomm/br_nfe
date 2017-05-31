module BrNfe
	module Product
		module Operation
			class NfeConsultaProtocolo < Base
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
				validates :chave_nfe, length: {is: 44}, allow_blank: true

				def operation_name
					:consulta_protocolo
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeConsultaProtocolo'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeConsultaProtocolo
				end
			end
		end
	end
end