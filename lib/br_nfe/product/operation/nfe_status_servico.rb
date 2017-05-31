module BrNfe
	module Product
		module Operation
			class NfeStatusServico < Base
				def operation_name
					:status_servico
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeStatusServico'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeStatusServico
				end
			end
		end
	end
end