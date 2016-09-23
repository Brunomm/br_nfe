module BrNfe
	module Product
		class Base < BrNfe::Base
			include ValueNf

			def certificado_obrigatorio?
				true
			end

			# Para as Notas fiscais de produto a autenticação via SSL é obrigatória
			def ssl_request?
				true
			end

			# O Gateway é responsável de identificar o Webservice de acordo com o Estado(UF).
			# Irá identificar o webservice através do valor do método `ibge_code_of_issuer_uf`, 
			# na qual pode ser setado diretamente ou pego através do endereço do emissor.
			# Para ver a lista de WebService por estado acesse: http://www.nfe.fazenda.gov.br/portal/webServices.aspx
			#
			# <b>Tipo de retorno: </b> _Object (Gateway::Base ou derivados)_
			#
			def gateway
				case ibge_code_of_issuer_uf
				when '12', '27', '16', '53', '32', '25', '33', '24', '43', '11', '14', '42', '28', '17'
					BrNfe::Product::Gateway::WebServiceSVRS.new({env: env})
				end
			end

			# Valor utilizado para inserir a url do xmlns nas tags nfeCabecMsg e nfeDadosMsg.
			# Como a url pode variar de acordo com o tipo de serviço e UF, deve ser sobrescrita
			# na subclass de cada serviço.
			#
			# <b>Tipo de retorno: </b> _String_
			#
			def url_xmlns
				raise "O método #url_xmlns deve ser implementar em cada operação"
			end

			# Irá retornar a versão setada de acordo com o serviço e estado.
			# Deve ser sobrescrito para cada serviço e irá pegar a versão do XML
			# de acordo com o Estado e Serviço, conforme descrito em: http://www.nfe.fazenda.gov.br/portal/webServices.aspx
			#
			# <b>Tipo de retorno: </b> _Symbol_
			#
			def gateway_xml_version
				raise "O método #gateway_xml_version deve ser implementar em cada operação"
			end

			# Versão do XML utilizado na requisição.
			# Como a versão do XML pode divergir para cada estado/servidor e serviço,
			# é necessário passar a versão do XML na requisição para o servidor saber qual
			# validação aplicar e como pegar os dados.
			# Esse método tem o intuíto de pegar a versão setada no Gateway de cada UF e serviço
			# e transformar em uma String aplicável no XML.
			# Exemplo:
			#    Se a versão do xml for :v3_10
			#    Esse método irá transformar o valor em '3.10'
			#
			# <b>Tipo de retorno: </b> _String_
			#
			def xml_version
				"#{gateway_xml_version}".gsub('_','.').gsub(/[^\d\.]/,'')
			end

			# Declaro que o método `render_xml` irá verificar os arquivos também presentes
			# nos diretórios especificados
			#
			# <b>Tipo de retorno: </b> _Array_
			def xml_current_dir_path
				["#{BrNfe.root}/lib/br_nfe/product/xml/#{gateway_xml_version}", "#{BrNfe.root}/lib/br_nfe/product/xml"]+super
			end
			
			def request
				client_wsdl.call(method_wsdl, xml: soap_xml)
			end

			def emitente_class
				BrNfe.emitente_product_class
			end
		end
	end
end