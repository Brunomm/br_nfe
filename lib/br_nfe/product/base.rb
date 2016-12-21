module BrNfe
	module Product
		class Base < BrNfe::Base
			include NfXmlValue

			# Serve para saber se vai usar o módo de contingência, e se usar,
			# serve para saber qual o tipo de contingência será utilizado.
			# Options: [:normal, :svc]
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _:normal_
			#
			attr_accessor :tipo_emissao

			# Informações que devem ser informadas quando a operação for em contingência.
			#
			attr_accessor :motivo_contingencia
			attr_accessor :inicio_contingencia # Data e hora do início da contingência
			def inicio_contingencia
				convert_to_time(@inicio_contingencia)
			end
			
			validates :tipo_emissao, inclusion: {in: [:normal, :svc]}
			validates :inicio_contingencia, presence: true,                        if: :contingencia?
			validates :motivo_contingencia, length: { minimum: 15, maximum: 256 }, if: :contingencia?

			def default_values
				{
					tipo_emissao:   :normal,
				}
			end

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
				@gateway ||= case tipo_emissao
				when :normal
					get_gateway_by_normal_operation
				when :svc
					get_gateway_by_svc_operation					
				end
			end

			# WebServices utilizados para contingência em SVC (Servidor Virtual de Contingência)
			# Existe 2 servidores de contingência para SVC: O `SVC-AN` e `SVC-RS`
			# Cada estado(UF) é autorizado a emitir notas em contingência em apenas 1 dos servidores.
			# Esse método é responsável em setar qual o WebService será utilizado para cada UF.
			#
			# <b>Tipo de retorno: </b> _Object (::WebServiceSvcRS ou ::WebServiceSvcAN)_
			#
			def get_gateway_by_svc_operation
				case ibge_code_of_issuer_uf
				#    'AM', 'BA', 'CE', 'GO', 'MA', 'MS', 'MT', 'PA', 'PE', 'PI', 'PR'
				when '13', '29', '23', '52', '21', '50', '51', '15', '26', '22', '41'
					BrNfe::Product::Gateway::WebServiceSvcRS.new({env: env})
				else # AC, AL, AP, DF, ES, MG, PB, RJ, RN, RO, RR, RS, SC, SE, SP, TO 
					BrNfe::Product::Gateway::WebServiceSvcAN.new({env: env})					
				end
			end

			# Seta o WebService quando o tipo de emissão for normal para cada UF
			#
			# <b>Tipo de retorno: </b> _Object (Gateway::Base ou derivados)_
			#
			def get_gateway_by_normal_operation				
				case ibge_code_of_issuer_uf
				when '13'
					BrNfe::Product::Gateway::WebServiceAM.new({env: env})
				when '29'
					BrNfe::Product::Gateway::WebServiceBA.new({env: env})
				when '23'
					BrNfe::Product::Gateway::WebServiceCE.new({env: env})
				when '52'
					BrNfe::Product::Gateway::WebServiceGO.new({env: env})
				when '31'
					BrNfe::Product::Gateway::WebServiceMG.new({env: env})
				when '50'
					BrNfe::Product::Gateway::WebServiceMS.new({env: env})
				when '51'
					BrNfe::Product::Gateway::WebServiceMT.new({env: env})
				when '26'
					BrNfe::Product::Gateway::WebServicePE.new({env: env})
				when '41'
					BrNfe::Product::Gateway::WebServicePR.new({env: env})
				when '43'
					BrNfe::Product::Gateway::WebServiceRS.new({env: env})
				when '35'
					BrNfe::Product::Gateway::WebServiceSP.new({env: env})
				when '21', '15', '22'
					BrNfe::Product::Gateway::WebServiceSVAN.new({env: env})
				else
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
					if gateway.is_a?(BrNfe::Product::Gateway::WebServiceSvcAN) # SVC-AN
						6
					else # SVC-RS
						7
					end
				end
			end


			def request
				client_wsdl.call(method_wsdl, xml: soap_xml)
			end

		private

			def emitente_class
				BrNfe.emitente_product_class
			end
		end
	end
end