module BrNfe
	module Product
		module Nfe
			class DeclaracaoImportacao < BrNfe::ActiveModelBase
				# Numero do Documento de Importação DI/DSI/DA/DRI-E (DI/DSI/DA/DRI-E) 
				# (NT2011/004)
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _DOC123_
				# <b>Length:   </b> _max: 12_
				# <b>tag:      </b> nDI
				#
				attr_accessor :numero_documento
				alias_attribute :nDI, :numero_documento


				# Data de Registro do documento
				# 
				# <b>Type:     </b> _Date_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _Date.current_
				# <b>tag:      </b> dDI
				#
				attr_accessor :data_registro
				def data_registro
					convert_to_date(@data_registro)
				end
				alias_attribute :dDI, :data_registro
				
				# Local de desembaraço
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _Pier 12_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> xLocDesemb
				#
				attr_accessor :local_desembaraco
				alias_attribute :xLocDesemb, :local_desembaraco

				# UF do desembaraço
				# Sigla da UF onde ocorreu o Desembaraço Aduaneiro
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _SP_
				# <b>Length:   </b> _max: 2_
				# <b>tag:      </b> UFDesemb
				#
				attr_accessor :uf_desembaraco
				alias_attribute :UFDesemb, :uf_desembaraco

				# Data do Desembaraço Aduaneiro
				# 
				# <b>Type:     </b> _Date_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _Date.current_
				# <b>tag:      </b> dDesemb
				#
				attr_accessor :data_desembaraco
				def data_desembaraco
					convert_to_date(@data_desembaraco)
				end
				alias_attribute :dDesemb, :data_desembaraco

				# Via de transporte internacional informada na 
				# Declaração de Importação (DI)
				#
				# 1=Marítima;    |   7=Rodoviária;
				# 2=Fluvial;     |   8=Conduto / Rede Transmissão;
				# 3=Lacustre;    |   9=Meios Próprios;
				# 4=Aérea;       |   10=Entrada / Saída ficta.
				# 5=Postal       |   11=Courier;
				# 6=Ferroviária; |   12=Handcarry. (NT 2013/005 v 1.10)
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _7_ OR _07_
				# <b>Default:  </b> _1_
				# <b>Length:   </b> _max: 2_
				# <b>tag:      </b> tpViaTransp
				#
				attr_accessor :via_transporte
				def via_transporte
					@via_transporte.to_i if @via_transporte.present?
				end
				alias_attribute :tpViaTransp, :via_transporte

				# Valor da AFRMM - Adicional ao Frete para Renovação da Marinha Mercante
				# A tag deve ser informada no caso da via de transporte marítima
				# 
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_ (Yes if via_transporte == 1)
				# <b>Example:  </b> _1550.00_
				# <b>Length:   </b> _precision: 2_
				# <b>tag:      </b> vAFRMM
				#
				attr_accessor :valor_afrmm
				alias_attribute :vAFRMM, :valor_afrmm

				# Forma de importação quanto a intermediação
				#
				# 1=Importação por conta própria;
				# 2=Importação por conta e ordem;
				# 3=Importação por encomenda;
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _2_
				# <b>Default:  </b> _1_
				# <b>Length:   </b> _max: 1_
				# <b>tag:      </b> tpIntermedio
				#
				attr_accessor :tipo_intermediacao
				def tipo_intermediacao
					@tipo_intermediacao.to_i if @tipo_intermediacao.present?
				end
				alias_attribute :tpIntermedio, :tipo_intermediacao

				# CNPJ do adquirente ou do encomendante
				# Obrigatória a informação no caso de importação por conta e
				# ordem ou por encomenda. Informar os zeros não significativos
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _No_ (Yes if tipo_intermediacao IN 2, 3)
				# <b>Example:  </b> _07.123.456/0001-88_
				# <b>Length:   </b> _max: 14_
				# <b>tag:      </b> CNPJ
				#
				attr_accessor :cnpj_adquirente
				def cnpj_adquirente
					return "" unless @cnpj_adquirente.present?
					BrNfe::Helper::CpfCnpj.new(@cnpj_adquirente).sem_formatacao
				end
				alias_attribute :CNPJ, :cnpj_adquirente

				# Sigla da UF do adquirente ou do encomendante
				# Obrigatória a informação no caso de importação por conta e
				# ordem ou por encomenda. Não aceita o valor "EX".
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_ (Yes if tipo_intermediacao IN 2, 3)
				# <b>Example:  </b> _SP_
				# <b>Length:   </b> _max: 2_
				# <b>tag:      </b> UFTerceiro
				#
				attr_accessor :uf_terceiro
				alias_attribute :UFTerceiro, :uf_terceiro

				# Código do Exportador
				# Código do Exportador, usado nos sistemas internos de
				# informação do emitente da NF-e
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _945123_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> cExportador
				#
				attr_accessor :codigo_exportador
				alias_attribute :cExportador, :codigo_exportador

				# Array com as adicoes utilizadas
				# Pode ser adicionado os dados das adicoes em forma de `Hash` ou
				# O próprio objeto da classe Veiculo.
				#
				# Exemplo com Hash:
				#    self.adicoes = [{numero_adicao: 'XXX6644', sequencial: '3', ...},{numero_adicao: 'XXX6644', sequencial: '4', ...}]
				#    self.adicoes << {numero_adicao: 'XXX6644', sequencial: '5', ...}
				#    self.adicoes << {numero_adicao: 'XXX6644', sequencial: '6', ...}
				#
				# Exemplo com Objetos:
				#    self.adicoes = [BrNfe::Product::Nfe::Transporte::Veiculo.new({numero_adicao: 'XXX6644', sequencial: '7', ...}),{numero_adicao: 'XXX6644', sequencial: '8', ...}]
				#    self.adicoes << BrNfe::Product::Nfe::Transporte::Veiculo.new({numero_adicao: 'XXX6644', sequencial: '9', ...})
				#    self.adicoes << {numero_adicao: 'XXX6644', sequencial: '10', ...}
				#
				# Sempre vai retornar um Array de objetos da class configurada em `BrNfe.adicao_importacao_product_class`
				#
				# <b>Type:     </b> _BrNfe.adicao_importacao_product_class_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _{numero_adicao: 123}_
				# <b>Length:   </b> _min: 1, max: 100_
				# <b>tag:      </b> nAdicao
				#
				has_many :adicoes, 'BrNfe.adicao_importacao_product_class'
				alias_attribute :nAdicao, :adicoes
				

				def default_values
					{
						via_transporte:     1, # 1=Marítima;
						tipo_intermediacao: 1, # 1=Importação por conta própria;
					}
				end

				validates :numero_documento,   presence: true
				validates :numero_documento,   length: {maximum: 12}
				validates :data_registro,      presence: true
				validates :local_desembaraco,  presence: true
				validates :local_desembaraco,  length: {maximum: 60}
				validates :uf_desembaraco,     presence: true
				validates :uf_desembaraco,     inclusion: { in: BrNfe::Constants::SIGLAS_UF}, allow_blank: true
				validates :data_desembaraco,   presence: true
				validates :via_transporte,     presence: true
				validates :valor_afrmm,        presence: true, if: lambda{|r| r.via_transporte == 1}
				validates :via_transporte,     inclusion: { in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]}, allow_blank: true
				validates :tipo_intermediacao, presence: true
				validates :tipo_intermediacao, inclusion: { in: [1, 2, 3]}, allow_blank: true
				validates :cnpj_adquirente,    presence: true, if: lambda{|r| r.tipo_intermediacao.to_i.in?([2,3]) }
				validates :uf_terceiro,        presence: true, if: lambda{|r| r.tipo_intermediacao.to_i.in?([2,3]) }
				validates :uf_terceiro,        inclusion: { in: BrNfe::Constants::SIGLAS_UF-['EX']}, allow_blank: true
				validates :codigo_exportador,  presence: true
				validates :codigo_exportador,  length: {maximum: 60}
				validate_has_many :adicoes,    message: :invalid_adicao
				validates :adicoes,            length: {in: 1..100}

			end
		end
	end
end