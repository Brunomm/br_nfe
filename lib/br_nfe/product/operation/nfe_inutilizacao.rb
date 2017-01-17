module BrNfe
	module Product
		module Operation
			class NfeInutilizacao < Base

				# Identificador da TAG a ser assinada formada com:
				# 01-02 = Literal 'ID' (2 posições) +
				# 03-04 = Código da UF (2 posições) + 
				# 05-06 = Ano (2 posições) + 
				# 07-20 = CNPJ (14 posições) +
				# 21-22 = modelo (2 posições) +
				# 23-25 = série (3 posições) + 
				# 26-34 = Numeração inicial (9 posições) +
				# 35-43 = Numeração final (9 posições)
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _ID41140616149400017255001000000002000000002_
				# <b>Length:   </b> _43_
				# <b>tag:      </b> Id
				#
				attr_accessor :chave
				def chave
					@chave = generate_key if @chave.blank?
					@chave
				end
				alias_attribute :Id, :chave

				# ANO DE INUTILIZAÇÃO DA NUMERAÇÃO
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _17_
				# <b>Length:   </b> _2_
				# <b>tag:      </b> Id
				#
				attr_accessor :ano

				# Código do Modelo do Documento Fiscal
				# 55=NF-e emitida em substituição ao modelo 1 ou 1A; (Default)
				# 65=NFC-e, utilizada nas operações de venda no varejo (a critério da UF aceitar este modelo de documento).
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Default:  </b> _55_
				# <b>Length:   </b> _2_
				# <b>tag:      </b> mod
				#
				attr_accessor :modelo_nf
				alias_attribute :mod, :modelo_nf

				# Série da NF-e
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _max: 3_
				# <b>tag:      </b> serie
				#
				attr_accessor :serie

				# Número da NF-e inicial a ser inutilizada
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Length:   </b> _max: 9_
				# <b>tag:      </b> nNFIni
				#
				attr_accessor :numero_nf_inicial
				alias_attribute :nNFIni, :numero_nf_inicial

				# Número da NF-e final a ser inutilizada
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Default:  </b> _self.numero_nf_inicial_
				# <b>Length:   </b> _max: 9_
				# <b>tag:      </b> nNFFin
				#
				attr_accessor :numero_nf_final
				def numero_nf_final
					@numero_nf_final ||= numero_nf_inicial
				end
				alias_attribute :nNFFin, :numero_nf_final

				# Informar a justificativa do pedido de inutilização
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Length:   </b> _min: 15, max: 255_
				# <b>tag:      </b> xJust
				#
				attr_accessor :justificativa
				alias_attribute :xJust, :justificativa

				validates :chave, presence: true
				validates :chave, length: {is: 43}, allow_blank: true
				validates :ano, presence: true
				validates :ano, length: {is: 2}, allow_blank: true

				validates :modelo_nf, presence: true
				validates :modelo_nf, inclusion: [55, 65, '55', '65']

				validates :serie, presence: true
				validates :serie, numericality: { only_integer: true }
				validates :serie, length: { maximum: 3 }

				validates :numero_nf_inicial, :numero_nf_final, presence: true
				validates :numero_nf_inicial, :numero_nf_final, numericality: { only_integer: true }, allow_blank: true
				validates :numero_nf_inicial, :numero_nf_final, length: { maximum: 9 }, allow_blank: true

				validates :justificativa, length: { in: 15..255 }
				
				# URL do webservice para enviar as informações.
				# Ex:
				# https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx?wsdl
				def wsdl
					gateway.wsdl_inutilizacao
				end

				# Método SOAP que será chamado para enviar o XML
				def method_wsdl
					gateway.operation_inutilizacao
				end

				# Versão utilizada pelo webservice do  estado para determinada ação.
				def gateway_xml_version
					gateway.version_xml_inutilizacao
				end

				# URL que será setada no atribto xmlns do XML;
				# Ex:
				# nfeCabecMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
				def url_xmlns
					gateway.url_xmlns_inutilizacao
				end

				# Versão SSL utilizada pelo webservice
				def ssl_version
					gateway.ssl_version_inutilizacao
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeInutilizacao'
				end
			private

				def response_class_builder
					BrNfe::Product::Response::Build::NfeInutilizacao
				end

				def generate_key
					key =  'ID'
					key << ibge_code_of_issuer_uf # 03-04 = Código da UF (2 posições)
					key << "#{ano}".rjust(2, '0') # 05-06 = Ano (2 posições) + 
					key << "#{emitente.cnpj}".rjust(14, '0') # 07-20 = CNPJ (14 posições) +
					key << "#{modelo_nf}" # 21-22 = modelo (2 posições) +
					key << "#{serie}".rjust(3, '0') # 23-25 = série (3 posições) + 
					key << "#{numero_nf_inicial}".rjust(9, '0')# 26-34 = Numeração inicial (9 posições) +
					key << "#{numero_nf_final}".rjust(9, '0')# 35-43 = Numeração final (9 posições)
					key
				end
			end
		end
	end
end