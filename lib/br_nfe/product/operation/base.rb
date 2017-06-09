module BrNfe
	module Product
		module Operation
			class Base < BrNfe::Base
				include NfXmlValue

				# Versão da NF-e que irá pegar as configurações
				attr_accessor :nfe_version

				# Serve para saber se vai usar o módo de contingência, e se usar,
				# serve para saber qual o tipo de contingência será utilizado.
				# Options: [:normal, :svc]
				#
				# <b>Required: </b> _Yes_
				# <b>Default: </b> _:normal_
				#
				attr_accessor :tipo_emissao
				def tipo_emissao= value
					if "#{value}" == '1'
						@tipo_emissao = :normal 
					elsif "#{value}" == '9'
						@tipo_emissao = :offline_nfce
					elsif "#{value}".in?(%w[6 7])
						@tipo_emissao = :svc
					else
						@tipo_emissao = value
					end
				end

				# Informações que devem ser informadas quando a operação for em contingência.
				#
				attr_accessor :motivo_contingencia
				attr_accessor :inicio_contingencia # Data e hora do início da contingência
				def inicio_contingencia
					convert_to_time(@inicio_contingencia)
				end

				# String XML que será aplicado o resultado da resposta do serviço
				# de acordo com a operação.
				# Por exemplo, quando vai consultar o protocolo da emissão de uma nfe,
				# deve ser passado por parâmetro o XML da NF-e para que seja possível obter
				# o XML da nota fiscal junto com o protocolo de autorização.
				# Também quando for cancelar uma nota fiscal deve passar o XML da nota para
				# que seja adicionado o protocolo de confirmação de cancelamento junto a nota.
				#
				# <b>Required: </b> _No_
				# <b>Type:     </b> _String_ XML
				# 
				attr_accessor :original_xml
				
				validates :tipo_emissao, inclusion: {in: [:normal, :svc]}
				validates :inicio_contingencia, presence: true,                        if: :contingencia?
				validates :motivo_contingencia, length: { minimum: 15, maximum: 256 }, if: :contingencia?

				def default_values
					{
						tipo_emissao:   :normal,
						nfe_version:    :v3_10,
					}
				end

				def certificado_obrigatorio?
					true
				end

				# Método utilizado para saber qual Webservice será utilizado.
				# Deve sempre retornar um symbol de acordo com as configurações dos gateways.
				#
				# <b>Tipo de retorno: </b> _Symbol_
				#
				def gateway
					@gateway ||= case tipo_emissao
					when :normal
						get_gateway_by_normal_operation
					when :svc
						get_gateway_by_svc_operation
					end
				end

				# Configurações das operações da nota fiscal de acordo com a versão.
				#
				def nfe_settings
					BrNfe.settings[:nfe][nfe_version]
				end

				# Método que retorna as configurações do Servidor da Sefaz a ser utilziada.
				# Irá retornar um Hash com as seguntes chaves:
				#  - :operation   => Contém qual a versão do XML que é utilizado, qual o método
				#                    da operação e a url do xmlns raiz que será adicionado no XML
				#  - :soap_client => Contém as configurações para instanciar o client Soap com o Savon.
				#  - :xml_paths   => Contém os caminhos com namespace para encontrar os valores dentro dos XMLS
				#
				# <b>Tipo de retorno: </b> _Symbol_ 
				#
				def gateway_settings
					nfe_settings[:gateway][gateway]
				end


				# WebServices utilizados para contingência em SVC (Servidor Virtual de Contingência)
				# Existe 2 servidores de contingência para SVC: O `SVC-AN` e `SVC-RS`
				# Cada estado(UF) é autorizado a emitir notas em contingência em apenas 1 dos servidores.
				# Esse método é responsável em setar qual o WebService será utilizado para cada UF.
				#
				# <b>Tipo de retorno: </b> _Hash_
				#
				def get_gateway_by_svc_operation
					case ibge_code_of_issuer_uf
					#    'AM', 'BA', 'CE', 'GO', 'MA', 'MS', 'MT', 'PA', 'PE', 'PI', 'PR'
					when '13', '29', '23', '52', '21', '50', '51', '15', '26', '22', '41'
						:svc_rs
					else # AC, AL, AP, DF, ES, MG, PB, RJ, RN, RO, RR, RS, SC, SE, SP, TO 
						:svc_an
					end
				end

				# Seta o WebService quando o tipo de emissão for normal para cada UF
				#
				# <b>Tipo de retorno: </b> _Hash_
				#
				def get_gateway_by_normal_operation				
					case "#{ibge_code_of_issuer_uf}"
					when '13'
						:am
					when '29'
						:ba
					when '23'
						:ce
					when '52'
						:go
					when '31'
						:mg
					when '50'
						:ms
					when '51'
						:mt
					when '26'
						:pe
					when '41'
						:pr
					when '43'
						:rs
					when '35'
						:sp
					when '21', '15' # MA, PA
						:svan
					else 
						# AC, AL, AP, ES, DF, PB, RJ, RM, RO, RR, SC, PI
						# 12, 27, 16, 32, 53, 25, 33, 24, 11, 14, 42, 22
						:svrs
					end
				end

				def operation_name
					raise NotImplementedError.new("Not implemented #operation_name in #{self}.")
				end

				# Método SOAP que será chamado para enviar o XML
				#
				# <b>Tipo de retorno: </b> _Symbol_
				#
				def method_wsdl
					gateway_settings[:operation][operation_name][env][:operation_method]
				end

				# Valor utilizado para inserir a url do xmlns nas tags nfeCabecMsg e nfeDadosMsg.
				# URL que será setada no atribto xmlns do XML;
				# Ex:
				#  nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				#
				# <b>Tipo de retorno: </b> _String_
				#
				def url_xmlns
					gateway_settings[:operation][operation_name][env][:url_xmlns]
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				# Irá retornar a versão setada de acordo com o serviço e estado conforme 
				# descrito em: http://www.nfe.fazenda.gov.br/portal/webServices.aspx
				#
				# <b>Tipo de retorno: </b> _Symbol_
				#
				def gateway_xml_version
					gateway_settings[:operation][operation_name][env][:xml_version]
				end

				# Retorna o xmlns utilizada para identificar o envelope da requisição SOAP
				# Normalmente é http://www.w3.org/2003/05/soap-envelope
				#
				# <b>Tipo de retorno: </b> _String_
				#
				def xmlns_soap
					gateway_settings[:operation][operation_name][env][:xmlns_soap]
				end

				# Parâmetros específicos para cada servidor de cada estado para
				# que seja instanciado o Client WSDL savon.
				#
				# <b>Tipo de retorno: </b> _Hash_
				#
				def client_wsdl_params
					super.merge({
						ssl_version:           :SSLv3, # Valores possíveis: [:TLSv1_2, :TLSv1_1, :TLSv1, :SSLv3, :SSLv23]
						ssl_cert:              certificate,
						ssl_cert_key:          certificate_key,
						ssl_cert_key_password: certificate_pkcs12_password,
					}).merge(gateway_settings[:soap_client][operation_name][env])
				end


				# Deve conter o LINK do webservice a ser chamado
				# TODO: Remover método
				#
				def url_wsdl
					''
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
				# nos diretórios especificados.
				# O diretório dos XMLs irá variar de acordo com a operação e a versão do XML utilizado.
				# EX:
				#   Se a versão do XML que a operação utiliza for a versão 2.0, então irá procurar o arquivo
				#   XML primeiro no diretório da v2, caso não encontre vai procurar no diretório da v1.
				#   Já se a versão do XML for a versão 3.1, irá procurar primeiro no diretório v3_10,
				#   se não contrar irá procurar no diretório da v2_00, e se ainda assim não encontrar, vai procurar
				#   no diretório v1_00.
				# Foi construido dessa forma pois algumas tags utilizadas na v3.10 são exatamente iguais
				# da v2.0, e nesse caso não há a necessidade de duplicar o código.
				#
				# <b>Tipo de retorno: </b> _Array_
				def xml_current_dir_path
					return @xml_current_dir_path if @xml_current_dir_path.present?
					paths = ["#{BrNfe.root}/lib/br_nfe/product/xml/v1_00"] # Sempre terá o path da v1_00
					paths << "#{BrNfe.root}/lib/br_nfe/product/xml/v1_10" if gateway_xml_version >= :v1_10
					paths << "#{BrNfe.root}/lib/br_nfe/product/xml/v2_00" if gateway_xml_version >= :v2_00
					paths << "#{BrNfe.root}/lib/br_nfe/product/xml/v2_01" if gateway_xml_version >= :v2_01
					paths << "#{BrNfe.root}/lib/br_nfe/product/xml/v3_10" if gateway_xml_version == :v3_10
					
					@xml_current_dir_path = paths.reverse+["#{BrNfe.root}/lib/br_nfe/product/xml"]+super
				end
				
				# Método utilizado para saber se a operação será em contingência.
				#
				# <b>Tipo de retorno: </b> _Boolean_
				#
				def contingencia?
					tipo_emissao != :normal
				end

				# Código do Tipo de Emissão da NF-e
				#  ✓ 1=Emissão normal (não em contingência);
				#  ✕ 2=Contingência FS-IA, com impressão do DANFE em formulário de segurança;
				#  ✕ 3=Contingência SCAN (Sistema de Contingência do Ambiente Nacional);
				#  ✕ 4=Contingência DPEC (Declaração Prévia da Emissão em Contingência);
				#  ✕ 5=Contingência FS-DA, com impressão do DANFE em formulário de segurança;
				#  ✓ 6=Contingência SVC-AN (SEFAZ Virtual de Contingência do AN);
				#  ✓ 7=Contingência SVC-RS (SEFAZ Virtual de Contingência do RS);
				#  ✓ 9=Contingência off-line da NFC-e (as demais opções de contingência são válidas 
				#      também para a NFC-e).
				#  Para a NFC-e somente estão disponíveis e são válidas as opções de contingência 5 e 9.
				def codigo_tipo_emissao(nfe)
					return 9 if nfe.nfce?
					case tipo_emissao
					when :normal 
						1
					when :svc
						if gateway == :svc_rs
							7 # SVC-RS
						else
							6 # SVC-AN
						end
					end
				end

				def request
					@savon_response = client_wsdl.call(method_wsdl, xml: soap_xml)
				rescue Savon::SOAPFault => error
					return @response = response_class_builder.new.response_class.new(request_status: :soap_error,    request_message_error: error.message)
				rescue Savon::HTTPError => error
					return @response = response_class_builder.new.response_class.new(request_status: :http_error,    request_message_error: error.message)
				rescue Exception => error
					return @response = response_class_builder.new.response_class.new(request_status: :unknown_error, request_message_error: error.message)
				end

				def response
					@response ||= get_response
				end

			private
				def emitente_class
					BrNfe.emitente_product_class
				end

				def response_class_builder
					raise NotImplementedError.new("Not implemented #response_class_builder in #{self}.")
				end

				def builder_response_params
					{}
				end

				def get_response
					builder = response_class_builder.new do |builder|
						builder.savon_response    = @savon_response
						builder.operation         = self
					end
					builder.assign_attributes(builder_response_params)
					builder.response
				end
			end
		end
	end
end