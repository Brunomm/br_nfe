module BrNfe
	module Product
		module Operation
			class NfeRetAutorizacao < Base
				# NÚMERO DO RECIBO/PROTOCOLO
				#  Número gerado pelo Portal da Secretaria de
				#  Fazenda Estadual
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _42201612301355_
				# <b>Length:   </b> _max: 15_
				# <b>tag:      </b> nRec
				#
				attr_accessor :numero_recibo
				alias_attribute :nRec, :numero_recibo

				validates :numero_recibo, presence: true
				validates :numero_recibo, numericality: {only_integer: true}, allow_blank: true
				validates :numero_recibo, length: {maximum: 15}, allow_blank: true

				def operation_name
					:retorno_autorizacao
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeRetAutorizacao'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeRetAutorizacao
				end
			end
		end
	end
end