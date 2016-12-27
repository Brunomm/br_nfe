# GRUPO DE TRIBUTAÇÃO DO ICMS PARA A UF DE DESTINO
# NT_2015_003_v150
#
# Foi criado um novo grupo de informações no item, para identificar o 
# ICMS Interestadual nas operações de venda para consumidor final, 
# atendendo ao disposto na Emenda Constitucional 87 de 2015.
#
# INFORMAÇÃO DO ICMS INTERESTADUAL
# Grupo a ser informado nas vendas interestaduais para
# consumidor final, não contribuinte do ICMS.
#
module BrNfe
	module Product
		module Nfe
			module ItemTax
				class IcmsUfDestino < BrNfe::ActiveModelBase
					# VALOR DA BC DO ICMS NA UF DE DESTINO
					#  Valor da Base de Cálculo do ICMS na UF de destino.
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _350.47_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vBCUFDest
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBCUFDest, :total_base_calculo

					# PERCENTUAL DO ICMS RELATIVO AO FUNDO DE COMBATE À POBREZA
					# (FCP) NA UF DE DESTINO
					#   Percentual adicional inserido na alíquota interna da UF de
					#   destino, relativo ao Fundo de Combate à Pobreza (FCP) naquela UF.
					#   Nota: Percentual máximo de 2%, conforme a legislação
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _1.47_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pFCPUFDest
					# 
					attr_accessor :percentual_fcp
					alias_attribute :pFCPUFDest, :percentual_fcp

					# ALÍQUOTA INTERNA DA UF DE DESTINO
					#  Alíquota adotada nas operações internas na UF de destino para o
					#  produto / mercadoria. A alíquota do Fundo de Combate a
					#  Pobreza, se existente para o produto / mercadoria, deve ser 
					#  informada no campo próprio (pFCPUFDest) não devendo ser
					#  somada à essa alíquota interna
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _18.0_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pICMSUFDest
					# 
					attr_accessor :aliquota_interna_uf_destino
					alias_attribute :pICMSUFDest, :aliquota_interna_uf_destino

					# ALÍQUOTA INTERESTADUAL DAS UF ENVOLVIDAS
					# - 4% alíquota interestadual para produtos importados;
					# - 7% para os Estados de origem do Sul e Sudeste (exceto ES),
					#      destinado para os Estados do Norte, Nordeste, CentroOeste
					#      e Espírito Santo;
					# - 12% para os demais casos
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _17.0_
					# <b>Length:   </b> _2v2_
					# <b>tag:      </b> pICMSInter
					# 
					attr_accessor :aliquota_interestadual
					alias_attribute :pICMSInter, :aliquota_interestadual

					# PERCENTUAL PROVISÓRIO DE PARTILHA DO ICMS INTERESTADUAL
					#  Percentual de ICMS Interestadual para a UF de destino:
					#  - 40% em 2016;
					#  - 60% em 2017;
					#  - 80% em 2018;
					#  - 100% a partir de 2019.
					# OBS: Caso não seja setado manualmente um valor, será setado
					#      automaticamnete conforme o ano da data atual.
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _40.0_
					# <b>Length:   </b> _2v2_
					# <b>tag:      </b> pICMSInterPart
					# 
					attr_accessor :percentual_partilha_destino
					def percentual_partilha_destino
						@percentual_partilha_destino ||= get_percentual_partilha_destino
					end
					alias_attribute :pICMSInterPart, :percentual_partilha_destino
					
					# VALOR DO ICMS RELATIVO AO FUNDO DE COMBATE À POBREZA (FCP) DA
					# UF DE DESTINO
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _347.54_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vFCPUFDest
					# 
					attr_accessor :total_fcp_destino
					alias_attribute :vFCPUFDest, :total_fcp_destino

					# VALOR DO ICMS INTERESTADUAL PARA A UF DE DESTINO
					#   Valor do ICMS Interestadual para a UF de destino, já
					#   considerando o valor do ICMS relativo ao Fundo de Combate à
					#   Pobreza naquela UF.
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _47.54_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSUFDest
					# 
					attr_accessor :total_destino
					alias_attribute :vICMSUFDest, :total_destino

					# VALOR DO ICMS INTERESTADUAL PARA A UF DO REMETENTE
					#   Valor do ICMS Interestadual para a UF do remetente.
					#   Nota: A partir de 2019, este valor será zero.
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _47.54_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSUFRemet
					#
					attr_accessor :total_origem
					alias_attribute :vICMSUFRemet, :total_origem

					validates :total_base_calculo, presence: true
					validates :total_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :aliquota_interna_uf_destino, presence: true
					validates :aliquota_interna_uf_destino, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :aliquota_interestadual, presence: true
					validates :aliquota_interestadual, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 99.99}, allow_blank: true
					validates :aliquota_interestadual, inclusion: {in: [4.0, 7.0, 12.0]}, allow_blank: true
					validates :percentual_partilha_destino, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}, allow_blank: true
					validates :percentual_fcp,    numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 2.0}, allow_blank: true
					validates :total_fcp_destino, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :total_destino,     presence: true
					validates :total_origem,      presence: true
					validates :total_destino,     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :total_origem,      numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				private

					def get_percentual_partilha_destino
						case Date.current.year
						when 2016
							40.0
						when 2017
							60.0
						when 2018
							80.0
						else
							100.0
						end
					end
				end
			end
		end
	end
end