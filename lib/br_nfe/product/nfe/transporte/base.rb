module BrNfe
	module Product
		module Nfe
			module Transporte
				class Base < BrNfe::ActiveModelBase
					
					# Modalidade do frete
					# 0- Por conta do emitente; 
					# 1- Por conta do destinatário/remetente; 
					# 2- Por conta de terceiros; 
					# 9- Sem frete
					# 
					# <b>Type: </b> _Number_
					# <b>Max: </b> _1_
					# <b>Required: </b> _Yes_
					# <b>Default: </b> _9_
					#
					attr_accessor :modalidade_frete

					##############################################################################
					#################### Dados da retenção ICMS do Transporte ####################
						
						# Método para saber se há retenção de ICMS, e se houver,
						# aplica as validações e adiciona a tag no XML
						#
						# <b>Type: </b> _Boolean_
						#
						def retencao_icms?
							retencao_valor_sevico.to_f > 0.0
						end

						# Valor do serviço
						#
						# <b>Type: </b> _Float_
						# <b>Required: </b> _No_
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_valor_sevico

						# Base de Cálculo da Retenção do ICMS
						#
						# <b>Type: </b> _Float_
						# <b>Required: </b> _No_
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_base_calculo_icms

						# Percentual de aliquota da retenção do ICMS
						# Exemplo: 
						#  Se a aliquota for de 2,56% então deve setar o valor para
						#  o atrubuto assim: self.retencao_aliquota = 2.56
						#
						# <b>Type: </b> _Float_
						# <b>Required: </b> _No_
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_aliquota

						# Valor do ICMS Retido
						# Caso não seja setado nenhum valor, irá calcular automaticamente
						# através dos atributos 'retencao_base_calculo_icms' e 'retencao_aliquota'
						#
						# <b>Type: </b> _Float_
						# <b>Required: </b> _No_
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_valor_icms
						def retencao_valor_icms
							@retencao_valor_icms || calculate_retencao_valor_icms
						end

						# CFOP de Serviço de Transporte
						#
						# <b>Type: </b> _Number_
						# <b>Required: </b> _No_ (Yes if retencao_icms?)
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_cfop

						# Código do município de ocorrência do fato gerador 
						# do ICMS do transporte
						#
						# <b>Type: </b> _Number_
						# <b>Required: </b> _No_ (Yes if retencao_icms?)
						# <b>Default: </b> _nil_
						#
						attr_accessor :retencao_codigo_municipio

					# Attr utilizado para saber como será validado os dados do 
					# 'veiculo' utilizado para transportar a carga.
					#
					# <b>Type: </b> _Symbol_
					# <b>Required: </b> _Yes_
					# <b>Default: </b> _:veiculo_
					# <b>Permited values: </b> _:veiculo, :balsa, :vagao_
					#
					attr_accessor :forma_transporte

					# Veículo de transporte
					# Utilizado quando a forma de transporte for com :veiculo
					#
					# <b>Type: </b> _BrNfe.veiculo_product_class_
					# <b>Required: </b> _No_ (Yes if forma_transporte == :veiculo)
					# <b>Default: </b> _nil_
					#
					def veiculo
						yield(veiculo_force_instance) if block_given?
						@veiculo.is_a?(BrNfe.veiculo_product_class) ? @veiculo : nil
					end
					def veiculo=(value)
						if value.is_a?(BrNfe.veiculo_product_class) 
							@veiculo = value
						elsif value.is_a?(Hash)
							veiculo_force_instance.assign_attributes(value)
						elsif value.blank?
							@veiculo = nil
						end
					end

					# Identificação da balsa (v2.0)
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_ (Yes if forma_transporte == :balsa)
					#
					attr_accessor :identificacao_balsa

					# Identificação do vagao (v2.0)
					#
					# <b>Type: </b> _String_
					# <b>Required: </b> _No_ (Yes if forma_transporte == :vagao)
					#
					attr_accessor :identificacao_vagao

					# Array com os reboques utilizados para transportar a carga
					# Pode ser adicionado os dados dos reboques em forma de `Hash` ou
					# O próprio objeto da classe Veiculo.
					#
					# Exemplo com Hash:
					#    self.reboques = [{placa: 'XXX6644', uf: 'SP', ...},{placa: 'XXX6644', uf: 'SC', ...}]
					#    self.reboques << {placa: 'XXX6644', uf: 'MG', ...}
					#    self.reboques << {placa: 'XXX6644', uf: 'GO', ...}
					#
					# Exemplo com Objetos:
					#    self.reboques = [BrNfe::Product::Nfe::Transporte::Veiculo.new({placa: 'XXX6644', uf: 'PI', ...}),{placa: 'XXX6644', uf: 'RS', ...}]
					#    self.reboques << BrNfe::Product::Nfe::Transporte::Veiculo.new({placa: 'XXX6644', uf: 'PR', ...})
					#    self.reboques << {placa: 'XXX6644', uf: 'DF', ...}
					#
					# Sempre vai retornar um Array de objetos da class configurada em `BrNfe.veiculo_product_class`
					#
					# <b>Tipo: </b> _BrNfe.veiculo_product_class (BrNfe::Product::Nfe::Transporte::Veiculo)_
					# <b>Min: </b> _0_
					# <b>Max: </b> _5_
					# <b>Default: </b> _[]_
					#
					has_many :reboques, 'BrNfe.veiculo_product_class', 
					         validations: :invalid_reboque, 
					         length: {maximum: 5}
					
					# Array com os volumes utilizados para transportar a carga
					# Pode ser adicionado os dados dos volumes em forma de `Hash` ou
					# O próprio objeto da classe Volume.
					#
					# Exemplo com Hash:
					#    self.volumes = [{marca: 'XXX6644', quantidade: 8, ...},{marca: 'XXX6644', quantidade: 9, ...}]
					#    self.volumes << {marca: 'XXX6644', quantidade: 10, ...}
					#    self.volumes << {marca: 'XXX6644', quantidade: 11, ...}
					#
					# Exemplo com Objetos:
					#    self.volumes = [BrNfe::Product::Nfe::Transporte::Volume.new({marca: 'XXX6644', quantidade: 12, ...}),{marca: 'XXX6644', quantidade: 13, ...}]
					#    self.volumes << BrNfe::Product::Nfe::Transporte::Volume.new({marca: 'XXX6644', quantidade: 14, ...})
					#    self.volumes << {marca: 'XXX6644', quantidade: 15, ...}
					#
					# Sempre vai retornar um Array de objetos da class configurada em `BrNfe.volume_transporte_product_class`
					#
					# <b>Tipo: </b> _BrNfe.volume_transporte_product_class (BrNfe::Product::Nfe::Transporte::Volume)_
					# <b>Default: </b> _[]_
					#
					has_many :volumes, 'BrNfe.volume_transporte_product_class', 
					         validations: :invalid_volume, 
					         length: {maximum: 5}


					# Transportador da mercadoria
					# Dados da transportadora que irá `transportar` a mercadoria.
					#
					# <b>Type: </b> _BrNfe.transportador_product_class_
					# <b>Required: </b> _No_
					# <b>Default: </b> _nil_
					#
					def transportador
						yield(transportador_force_instance) if block_given?
						@transportador.is_a?(BrNfe.transportador_product_class) ? @transportador : nil
					end
					def transportador=(value)
						if value.is_a?(BrNfe.transportador_product_class) 
							@transportador = value
						elsif value.is_a?(Hash)
							transportador_force_instance.assign_attributes(value)
						elsif value.blank?
							@transportador = nil
						end
					end
					
					def default_values
						{
							modalidade_frete: 9,        # 9 = Sem frete
							forma_transporte: :veiculo, # Define qualer tipo de veículo terrestre (Caminhão, van, etc..)
						}
					end

					validates :modalidade_frete, inclusion: [0, '0', 1, '1', 2, '2', 9, '9']
					validates :forma_transporte, presence: true
					validates :forma_transporte, inclusion: [:veiculo, :balsa, :vagao]
					validate  :transportador_validation, if: :transportador

					with_options if: :forma_transporte_veiculo? do |record|
						record.validates :veiculo, presence: true
						record.validate  :veiculo_validation
					end
					validates :identificacao_balsa, presence: true, if: :forma_transporte_balsa?
					validates :identificacao_vagao, presence: true, if: :forma_transporte_vagao?

					with_options if: :retencao_icms? do |record|
						record.validates :retencao_codigo_municipio, :retencao_cfop, presence: true
						record.validates :retencao_base_calculo_icms, numericality: true,             allow_blank: true
						record.validates :retencao_aliquota,          numericality: {less_than: 100}, allow_blank: true
						record.validates :retencao_valor_icms,        numericality: true,             allow_blank: true
					end


					def forma_transporte_veiculo?
						forma_transporte == :veiculo
					end

					def forma_transporte_balsa?
						forma_transporte == :balsa
					end

					def forma_transporte_vagao?
						forma_transporte == :vagao
					end

				private

					##################################  CÁLCULOS  ##################################
					# Método utilizado apra calcular o valor do ICMS retido no caso
					# de não informar o valor manualmente.
					# O Cálculo é em base do valor da base de cálculo multiplicado
					# pelo percentual da aliquota de retenção.
					#
					def calculate_retencao_valor_icms
						((retencao_aliquota.to_f/100.0)*retencao_base_calculo_icms.to_f).round(2)
					end

					############################  VEÍCULO DE TRANSPORTE  ############################
					# Utilizado para validar se o veículo está valido.
					# Só irá validar caso o veículo de entrega seja preenchido.
					#
					def veiculo_validation
						if veiculo.try(:invalid?)
							veiculo.errors.full_messages.each { |msg| errors.add(:base, "Veículo: #{msg}") }
						end
					end
					# Instancía um veículo e seta na variavel  @veiculo.
					# É utilizado quando setar o veículo em forma da Hash ou Block
					# Pois nesse caso deve sempre ter um objeto instanciado para setar os valores.
					#
					def veiculo_force_instance
						@veiculo = BrNfe.veiculo_product_class.new unless @veiculo.is_a?(BrNfe.veiculo_product_class)
						@veiculo
					end
					##############################  TRANSPORTADOR  ##############################
					# Utilizado para validar se o transportador está valido.
					# Só irá validar caso o transportador da entrega seja preenchido.
					#
					def transportador_validation
						if transportador.invalid?
							transportador.errors.full_messages.each { |msg| errors.add(:base, :invalid_transportador, {error_message: msg}) }
						end
					end
					# Instancía um transportador e seta na variavel  @transportador.
					# É utilizado quando setar o transportador em forma da Hash ou Block
					# Pois nesse caso deve sempre ter um objeto instanciado para setar os valores.
					#
					def transportador_force_instance
						@transportador = BrNfe.transportador_product_class.new unless @transportador.is_a?(BrNfe.transportador_product_class)
						@transportador
					end
				end
			end
		end
	end
end