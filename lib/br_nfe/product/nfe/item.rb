module BrNfe
	module Product
		module Nfe
			class Item < BrNfe::ActiveModelBase
				################################################################################
				############################ INFORMAÇÕES DO PRODUTO ############################
					# Utilizado apenas para fins de validação.
					# informa se o item da NF-e é um produto ou um serviço.
					# 
					# <b>Type:      </b> _Symbol_
					# <b>Required:  </b> _Yes_
					# <b>Default:   </b> _:product_
					# <b>Example:   </b> _:service_
					# <b>Avaliable: </b> _one of [:product, :service, :other]_
					#
					attr_accessor :tipo_produto

					# Código do produto ou serviço
					# Preencher com CFOP, caso se trate de itens não relacionados
					# com mercadorias/produtos e que o contribuinte não possua
					# codificação própria. Formato: ”CFOP9999”
					#
					# OBS: Caso não seja preenchido irá pegar automaticamente o valor
					#      da CFOP.
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Default:  </b> _CFOP#{cfop}_
					# <b>Example:  </b> _COD65452_
					# <b>Length:   </b> _max: 60_
					# <b>tag:      </b> cProd
					#
					attr_accessor :codigo_produto
					def codigo_produto
						@codigo_produto = "CFOP#{cfop}" if @codigo_produto.blank? && cfop.present?
						"#{@codigo_produto}"
					end
					alias_attribute :cProd, :codigo_produto

					# GTIN (Global Trade Item Number) do produto, antigo código EAN ou código de barras
					# Preencher com o código GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 
					# (antigos códigos EAN, UPC e DUN-14), não informar o conteúdo da TAG 
					# em caso de o produto não possuir este código.
					#
					# OBS: esse atributo sempre vai retornar apenas os números setados 
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12345678_
					# <b>Length:   </b> _max: 14_
					# <b>tag:      </b> cEAN
					#
					attr_accessor :codigo_ean
					alias_attribute :codigo_gtin, :codigo_ean
					alias_attribute :cEAN, :codigo_ean
					def codigo_ean
						"#{@codigo_ean}".gsub(/[^\d]/,'')
					end

					# Descrição do produto ou serviço
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _COPO DE PLÁSTICO 700 ML PARATA_
					# <b>Length:   </b> _max: 120_
					# <b>tag:      </b> xProd
					#
					attr_accessor :descricao_produto
					alias_attribute :xProd, :descricao_produto

					# Código NCM com 8 dígitos 
					# Obrigatória informação do NCM completo (8 dígitos).
					# Nota: Em caso de item de serviço ou item que não tenham
					# produto (ex. transferência de crédito, crédito do ativo
					# imobilizado, etc.), informar o valor 00 (dois zeros). 
					# (NT 2014/004)
					#
					# OBS: esse atributo sempre vai retornar apenas os números
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _'12345678'_ OR _123454_
					# <b>Length:   </b> _max: 8(:product) OR max: 2(not :product)_
					# <b>tag:      </b> NCM
					#
					attr_accessor :codigo_ncm
					def codigo_ncm
						if not is_product?
							@codigo_ncm = '00' if @codigo_ncm.blank?
						end
						"#{@codigo_ncm}".gsub(/[^\d]/,'')
					end
					alias_attribute :NCM, :codigo_ncm

					# Codificação NVE - Nomenclatura de Valor Aduaneiro e Estatística.
					# Codificação opcional que detalha alguns NCM.
					# Formato: duas letras maiúsculas e 4 algarismos. Se a
					# mercadoria se enquadrar em mais de uma codificação, informar
					# até 8 codificações principais. Vide: Anexo XII.03 - Identificador NVE.
					# 
					# <b>Type:     </b> _Array_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _['AB12324','AB5678'] OU 'AB4567'_
					# <b>Length:   </b> _max: 8_
					#
					# <b>tag:      </b> NVE
					attr_accessor :codigos_nve
					def codigos_nve
						@codigos_nve = [@codigos_nve] unless @codigos_nve.is_a?(Array)
						@codigos_nve.flatten!
						@codigos_nve.compact!
						@codigos_nve
					end
					alias_attribute :NVE, :codigos_nve

					# Código da Tabela de Incidência do IPI - TIPI
					# Preencher de acordo com o código EX da TIPI. Em caso de
					# serviço, não incluir a TAG.
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _123_
					# <b>Length:   </b> _min: 2, max: 3_
					# <b>tag:      </b> EXTIPI
					#
					attr_accessor :codigo_extipi
					alias_attribute :EXTIPI, :codigo_extipi

					# Código Fiscal de Operações e Prestações
					# Utilizar a Tabela de CFOPs para preencher essa informação.
					#
					# OBS: esse atributo sempre vai retornar apenas os números
					#      EX: Se preencher com '5.102' vai retornar '5102'
					# 
					# <b>Type:     </b> _String_ OR _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _'5.102'_ OR _5102_
					# <b>Length:   </b> _4_
					# <b>tag:      </b> CFOP
					#
					attr_accessor :cfop
					def cfop
						"#{@cfop}".gsub(/[^\d]/,'')
					end
					alias_attribute :CFOP, :cfop

					# Unidade Comercial
					# informar a unidade de comercialização do produto 
					# (Ex. pc, und, dz, kg, etc.).
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _KG_
					# <b>Length:   </b> _max: 6_
					# <b>tag:      </b> uCom
					#
					attr_accessor :unidade_comercial
					alias_attribute :uCom, :unidade_comercial

					# Quantidade Comercial
					# Informar a quantidade de comercialização do produto (v2.0).
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _2.5_
					# <b>tag:      </b> qCom
					#
					attr_accessor :quantidade_comercial
					alias_attribute :qCom, :quantidade_comercial

					# Valor Unitário de Comercialização
					# Informar o valor unitário de comercialização do produto, campo
					# meramente informativo, o contribuinte pode utilizar a precisão
					# desejada (0-10 decimais). Para efeitos de cálculo, o valor
					# unitário será obtido pela divisão do valor do produto pela
					# quantidade comercial. (v2.0)
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vUnCom
					#
					attr_accessor :valor_unitario_comercial
					def valor_unitario_comercial
						@valor_unitario_comercial ||= valor_unitario_comercial_calculation
						@valor_unitario_comercial
					end
					alias_attribute :vUnCom, :valor_unitario_comercial

					# Valor Total Bruto dos Produtos ou Serviços
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _3122.55_ OU _100_
					# <b>tag:      </b> vProd
					#
					attr_accessor :valor_total_produto
					alias_attribute :vProd, :valor_total_produto

					# GTIN (Global Trade Item Number) da unidade tributável, 
					# antigo código EAN ou código de barras
					# Preencher com o código GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 
					# (antigos códigos EAN, UPC e DUN-14) da unidade tributável
					# do produto, não informar o conteúdo da TAG em caso de o
					# produto não possuir este código.
					#
					# OBS: esse atributo sempre vai retornar apenas os números setados 
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12345678_
					# <b>Length:   </b> _max: 14_
					# <b>tag:      </b> cEANTrib
					#
					attr_accessor :codigo_ean_tributavel
					alias_attribute :codigo_gtin_tributavel, :codigo_ean_tributavel
					def codigo_ean_tributavel
						"#{@codigo_ean_tributavel}".gsub(/[^\d]/,'')
					end
					alias_attribute :cEANTrib, :codigo_ean_tributavel

					# Unidade Tributável
					# Informar a unidade de tributação do produto 
					# (Ex. pc, und, dz, kg, etc.).
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _KG_
					# <b>Length:   </b> _max: 6_
					# <b>tag:      </b> uTrib
					#
					attr_accessor :unidade_tributavel
					def unidade_tributavel
						@unidade_tributavel ||= unidade_comercial
					end
					alias_attribute :uTrib, :unidade_tributavel

					# Quantidade Tributável
					# Informar a quantidade de tributação do produto (v2.0).
					#
					# NOTA: Por termos diversos casos na legislação onde a tributação 
					#  incide em unidades de produtos diferentes da que ele é costumeiramente 
					#  vendido no mercado, especialmente no atacado. Ou seja, a unidade tributa 
					#  é diferente da unidade comercializada, por este motivo é que foram criados 
					#  os respectivos campos na NF-e (uCom, qCom e vCom)  (uTrib, qTrib e vUnTrib),  
					#  sendo que o resultado  (qCom * uCom) seja igual a (qTrib * uTrib).
					#    Tomemos como exemplo o refrigerante pet de 2 litros que tem 
					#  definido na pauta fiscal a “unidade tributável” como garrafa de 2litros, 
					#  sendo que o fabricante comercializa o mesmo produto em pacote com 6 unidades.
					#  Assim na venda de 2 pacotes, temos como unidade comercial de 2 unidades 
					#  que equivalem a 12 litros (2 x 6), com 2 litros cada.
					#  Na unidade tributável, temos também 12 unidades tributáveis (12 x 1 unidade de 2 litros).
					#    Observem que sempre qCom * uCom = qTrib * uTrib.
					#    É importante ressaltar que na maioria dos casos a unidade comercial e a 
					#  unidade tributável são iguais.
					#  Fonte: http://www.tecnospeed.com.br/forum/o-contador/motivo-da-rejeicao-nos-campos-unidade-tributave-e-unidade-comercial/
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _2.5_
					# <b>tag:      </b> qTrib
					#
					attr_accessor :quantidade_tributavel
					def quantidade_tributavel
						@quantidade_tributavel ||= quantidade_comercial
					end
					alias_attribute :qTrib, :quantidade_tributavel

					# Valor Unitário de tributação
					# Informar o valor unitário de tributação do produto, campo
					# meramente informativo, o contribuinte pode utilizar a precisão
					# desejada (0-10 decimais). Para efeitos de cálculo, o valor
					# unitário será obtido pela divisão do valor do produto pela
					# quantidade tributável (NT 2013/003).
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vUnTrib
					#
					attr_accessor :valor_unitario_tributavel
					def valor_unitario_tributavel
						@valor_unitario_tributavel ||= valor_unitario_tributavel_calculation
						@valor_unitario_tributavel
					end
					alias_attribute :vUnTrib, :valor_unitario_tributavel

					# Valor Total do Frete
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vFrete
					#
					attr_accessor :total_frete
					alias_attribute :vFrete, :total_frete

					# Valor Total do Seguro
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vSeg
					#
					attr_accessor :total_seguro
					alias_attribute :vSeg, :total_seguro

					# Valor do Desconto
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vDesc
					#
					attr_accessor :total_desconto
					alias_attribute :vDesc, :total_desconto

					# Outras despesas acessórias
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _22.5_ OU _2_
					# <b>tag:      </b> vOutro
					#
					attr_accessor :total_outros
					alias_attribute :vOutro, :total_outros

					# Indica se valor do Item (vProd) entra no valor total da NF-e (vProd)
					#   0=Valor do item (vProd) não compõe o valor total da NF-e
					#   1=Valor do item (vProd) compõe o valor total da NF-e (vProd)
					#   (v2.0)
					#
					# Informar true ou false
					#   true  = 1 (compõe o valor total da NF-e)
					#   false = 0 (NÃO compõe o valor total da NF-e)
					#
					# <b>Type:     </b> _Boolean_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _true_
					# <b>Default:  </b> _true_
					# <b>tag:      </b> indTot
					#
					attr_accessor :soma_total_nfe
					alias_attribute :indTot, :soma_total_nfe

					# Código CEST
					# Código Especificador da Substituição Tributária – CEST, que
					# estabelece a sistemática de uniformização e identificação das
					# mercadorias e bens passíveis de sujeição aos regimes de
					# substituição tributária e de antecipação de recolhimento do
					# ICMS
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1234567_
					# <b>Length:   </b> _7_
					# <b>tag:      </b> CEST
					#
					attr_accessor :codigo_cest
					alias_attribute :CEST, :codigo_cest

					# Declaração de Importação
					# Informar dados da importação
					#
					# <b>Type:     </b> _BrNfe.declaracao_importacao_product_class_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _[BrNfe.declaracao_importacao_product_class.new]_
					# <b>Length:   </b> _max: 100_
					# <b>tag:      </b> DI
					#
					has_many :declaracoes_importacao, 'BrNfe.declaracao_importacao_product_class'
					alias_attribute :DI, :declaracoes_importacao
					
					# GRUPO DE INFORMAÇÕES DE EXPORTAÇÃO PARA O ITEM
					# Informar apenas no Drawback e nas exportações
					#
					# <b>Type:     </b> _BrNfe.detalhe_exportacao_product_class
					# <b>Required: </b> _No_
					# <b>Example:  </b> _[BrNfe.detalhe_exportacao_product_class.new]_
					# <b>Length:   </b> _max: 500_
					# <b>tag:      </b> detExport
					#
					has_many :detalhes_exportacao, 'BrNfe.detalhe_exportacao_product_class'
					alias_attribute :detExport, :detalhes_exportacao

					# NÚMERO DO PEDIDO DE COMPRA
					# Informação de interesse do emissor para controle do B2B. (v2.0)
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1234567_
					# <b>Length:   </b> _max: 15_
					# <b>tag:      </b> xPed
					#
					attr_accessor :numero_pedido_compra
					alias_attribute :xPed, :numero_pedido_compra

					# ITEM DO PEDIDO DE COMPRA
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1234567_
					# <b>Length:   </b> _max: 15_
					# <b>tag:      </b> nItemPed
					#
					attr_accessor :item_pedido_compra
					def item_pedido_compra
						"#{@item_pedido_compra}".gsub(/[^\d]/,'')
					end
					alias_attribute :nItemPed, :item_pedido_compra

					# NÚMERO DE CONTROLE DA FCI - FICHA DE CONTEÚDO DE IMPORTAÇÃO
					# Informação relacionada com a Resolução 13/2012 do Senado
					# Federal. Formato: Algarismos, letras maiúsculas de "A" a "F" e o
					# caractere hífen. Exemplo: B01F70AF-10BF-4B1F-848C-65FF57F616FE
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _B01F70AF-10BF-4B1F-848C-65FF57F616FE_
					# <b>Length:   </b> _36_
					# <b>tag:      </b> nFCI
					#
					attr_accessor :numero_fci
					alias_attribute :nFCI, :numero_fci

					# VALOR TOTAL DE TRIBUTOS FEDERAIS, ESTADUAIS E MUNICIPAIS
					# NT 2013/003
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _178.46_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vTotTrib
					#
					attr_accessor :total_tributos
					alias_attribute :vTotTrib, :total_tributos

				#######################################################################
				################################  DEVOLUÇÃO  ###########################
					# PERCENTUAL DA MERCADORIA DEVOLVIDA
					#  O valor máximo deste percentual é 100%, no caso de devolução
					#  total da mercadoria.
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _30.0_
					# <b>Length:   </b> _13v2 - max: 100.0_
					# <b>tag:      </b> pDevol
					#
					attr_accessor :percentual_devolucao
					alias_attribute :pDevol, :percentual_devolucao

					# VALOR DO IPI DEVOLVIDO
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _137.47_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vIPIDevol
					#
					attr_accessor :total_ipi_devolucao
					alias_attribute :vIPIDevol, :total_ipi_devolucao

				#######################################################################
				################################  IMPOSTOS  ###########################
					# INFORMAÇÕES DO ICMS DA OPERAÇÃO PRÓPRIA E ST
					#  Informar apenas um dos grupos de tributação do ICMS
					#  (ICMS00, ICMS10, ...) (v2.0)
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_ (yes if tipo_produto == :product)
					# <b>Example:  </b> _BrNfe.icms_item_tax_product_class.new_
					# <b>tag:      </b> ICMS
					#
					has_one :icms, 'BrNfe.icms_item_tax_product_class', null: false
					alias_attribute :ICMS, :icms
					
					# IMPOSTO SOBRE PRODUTOS INDUSTRIALIZADOS - IPI
					#  Informar apenas quando o item for sujeito ao IPI
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.ipi_item_tax_product_class.new_
					# <b>tag:      </b> IPI
					#
					has_one :ipi, 'BrNfe.ipi_item_tax_product_class'
					alias_attribute :IPI, :ipi
					
					# Imposto de Importação - II
					#  Informar apenas quando o item for sujeito ao II
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.importacao_item_tax_product_class.new_
					# <b>tag:      </b> II
					#
					has_one :importacao,      'BrNfe.importacao_item_tax_product_class'
					alias_attribute :II, :importacao

					# PIS
					#  Informar apenas um dos grupos Q02, Q03, Q04 ou Q05 com
					#  base valor atribuído ao campo Q06 – CST do PIS
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.pis_item_tax_product_class.new_
					# <b>tag:      </b> PIS
					#
					has_one :pis, 'BrNfe.pis_item_tax_product_class', null: false
					alias_attribute :PIS, :pis

					# GRUPO PIS SUBSTITUIÇÃO TRIBUTÁRIA
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.pis_st_item_tax_product_class.new_
					# <b>tag:      </b> PISST
					#
					has_one :pis_st,          'BrNfe.pis_st_item_tax_product_class'
					alias_attribute :PISST, :pis_st
					
					# GRUPO COFINS
					#  Informar apenas um dos grupos S02, S03, S04 ou S04 com
					#  base valor atribuído ao campo de CST da COFINS
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.cofins_item_tax_product_class.new_
					# <b>tag:      </b> COFINS
					#
					has_one :cofins, 'BrNfe.cofins_item_tax_product_class', null: false
					alias_attribute :COFINS, :cofins
					
					# GRUPO COFINS SUBSTITUIÇÃO TRIBUTÁRIA -  COFINS ST
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.cofins_st_item_tax_product_class.new_
					# <b>tag:      </b> COFINSST
					#
					has_one :cofins_st, 'BrNfe.cofins_st_item_tax_product_class'
					alias_attribute :COFINSST, :cofins_st
					
					# GRUPO ISSQN
					#  Campos para cálculo do ISSQN na NF-e conjugada, onde há a
					#  prestação de serviços sujeitos ao ISSQN e fornecimento de
					#  peças sujeitas ao ICMS.
					#  Grupo ISSQN é mutuamente exclusivo com os grupos ICMS, IPI
					#  e II, isto é se ISSQN for informado os grupos ICMS, IPI e II não
					#  serão informados e vice-versa (v2.0).
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.issqn_item_tax_product_class.new_
					# <b>tag:      </b> ISSQN
					#
					has_one :issqn, 'BrNfe.issqn_item_tax_product_class'
					alias_attribute :ISSQN, :issqn
					
					# Grupo de Tributação do ICMS para a UF de destino
					#  Grupo a ser informado nas vendas interestaduais para
					#  consumidor final, não contribuinte do ICMS.
					#
					# <b>Type:     </b> _HasOne_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _BrNfe.icms_uf_destino_item_tax_product_class.new_
					# <b>tag:      </b> ICMSUFDest
					#
					has_one :icms_uf_destino, 'BrNfe.icms_uf_destino_item_tax_product_class'
					alias_attribute :ICMSUFDest, :icms_uf_destino

					# INFORMAÇÕES ADICIONAIS DO PRODUTO (PARA O ITEM DA NF-e)
					# Norma referenciada, informações complementares, etc.
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _'DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONA'_
					# <b>Length:   </b> _max: 500_
					# <b>tag:      </b> infAdProd
					#
					attr_accessor :informacoes_adicionais
					alias_attribute :infAdProd, :informacoes_adicionais


				def default_values
					{
						tipo_produto:   :product,
						soma_total_nfe: true,
					}
				end

				validate_has_one :icms, if: :is_product?
				validate_has_one :pis
				validate_has_one :cofins
				validate_has_one :ipi
				validate_has_one :pis_st
				validate_has_one :cofins_st
				validate_has_one :importacao
				validate_has_one :issqn
				validate_has_one :icms_uf_destino

				validates :tipo_produto, presence: true
				validates :tipo_produto, inclusion: {in: [:product, :service, :other]}

				validates :codigo_produto,    length: {maximum: 60}
				validates :codigo_ean,        length: {maximum: 14}
				validates :descricao_produto, length: {maximum: 120}

				validates :codigo_ncm, presence: true
				validates :codigo_ncm, length: {maximum: 8}, allow_blank: true, if:     :is_product?
				validates :codigo_ncm, length: {maximum: 2}, allow_blank: true, unless: :is_product?

				validates :codigos_nve, length: {maximum: 8}

				validates :codigo_extipi, length: {in: 2..3}, allow_blank: true

				validates :unidade_comercial, presence: true
				validates :unidade_comercial, length: {maximum: 6}, allow_blank: true
				validates :quantidade_comercial,     presence:     true
				validates :quantidade_comercial,     numericality: true
				validates :valor_unitario_comercial, presence:     true
				validates :valor_unitario_comercial, numericality: true
				validates :valor_total_produto,    presence:     true
				validates :valor_total_produto,    numericality: true

				validates :codigo_ean_tributavel,     length: {maximum: 14}
				validates :quantidade_tributavel,     presence: true
				validates :quantidade_tributavel,     numericality: true
				validates :unidade_tributavel,        presence: true
				validates :unidade_tributavel,        length: {maximum: 6}, allow_blank: true
				validates :valor_unitario_tributavel, presence: true
				validates :valor_unitario_tributavel, numericality: true
				
				validates :total_frete,    numericality: true, allow_blank: true
				validates :total_seguro,   numericality: true, allow_blank: true
				validates :total_desconto, numericality: true, allow_blank: true
				validates :total_outros,   numericality: true, allow_blank: true
				
				validates :codigo_cest,    length: {maximum: 7}
				
				validate_has_many :declaracoes_importacao, message: :invalid_declaracao_importacao
				validates :declaracoes_importacao,         length: {maximum: 100}
				validate_has_many :detalhes_exportacao, message: :invalid_detalhe_exportacao
				
				validates :numero_pedido_compra, length: {maximum: 15}
				validates :item_pedido_compra,   length: {maximum: 6}

				validates :numero_fci, format: { with: /\A[A-F\d\-]+\z/ }, allow_blank: true
				validates :numero_fci, length: {is: 36}, allow_blank: true

				validates :icms,  presence: true, if: :is_product?
				validates :issqn, presence: true, if: :is_service?

				validates :informacoes_adicionais, length: {maximum: 500}
				validates :percentual_devolucao, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}, allow_blank: true

				def is_product?
					tipo_produto == :product
				end

				def is_service?
					tipo_produto == :service
				end

			private

				#####################################################################
				############################# CÁLCULOS ##############################
					def valor_unitario_comercial_calculation
						(valor_total_produto.to_f/quantidade_comercial.to_f).round(10) if quantidade_comercial.to_f > 0
					end
					def valor_unitario_tributavel_calculation
						(valor_total_produto.to_f/quantidade_tributavel.to_f).round(10) if quantidade_tributavel.to_f > 0
					end
			end
		end
	end
end