# Campos para cálculo do ISSQN na NF-e conjugada, onde há a
# prestação de serviços sujeitos ao ISSQN e fornecimento de
# peças sujeitas ao ICMS.
# Grupo ISSQN é mutuamente exclusivo com os grupos ICMS, IPI
# e II, isto é se ISSQN for informado os grupos ICMS, IPI e II não
# serão informados e vice-versa (v2.0).
#
module BrNfe
	module Product
		module Nfe
			module ItemTax
				class Issqn < BrNfe::ActiveModelBase
					# VALOR DA BASE DE CÁLCULO DO ISSQN
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _350.47_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBC, :total_base_calculo

					# Alíquota do ISSQN
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _2.47_
					# <b>Length:   </b> _3v2-4_
					# <b>tag:      </b> vAliq
					# 
					attr_accessor :aliquota
					alias_attribute :vAliq, :aliquota

					# VALOR DO ISSQN
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _350.47_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vISSQN
					# 
					attr_accessor :total
					alias_attribute :vISSQN, :total

					# CÓDIGO DO MUNICÍPIO DE OCORRÊNCIA DO FATO GERADOR DO ISSQN
					#   Informar o município de ocorrência do fato gerador do ISSQN.
					#   Utilizar a Tabela do IBGE (Anexo IX - Tabela de UF, Município e
					#   País).
					#   Nota 1: Não vincular com o município do fato gerador de ICMS
					#   (id:B12), ou com o município do emitente (id:C10) ou do
					#   destinatário (id:E10).
					#   Nota 2: Pode ser informado 9999999 se a prestação de serviço
					#   for no Exterior.
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _4201534_
					# <b>Length:   </b> _7_
					# <b>tag:      </b> cMunFG
					# 
					attr_accessor :municipio_ocorrencia
					def municipio_ocorrencia
						BrNfe::Helper.only_number(@municipio_ocorrencia)
					end
					alias_attribute :cMunFG, :municipio_ocorrencia

					# ITEM DA LISTA DE SERVIÇOS
					#   Informar o Item da lista de serviços em que se classifica o
					#   serviço no padrão ABRASF (Formato: NN.NN).
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _1204 OR '12.04'_
					# <b>Length:   </b> _5_
					# <b>tag:      </b> cListServ
					# 
					attr_accessor :codigo_servico
					def codigo_servico
						BrNfe::Helper.only_number(@codigo_servico).to_i.to_s.reverse.scan(/.{1,2}/).join('.').reverse if @codigo_servico.present?
					end
					alias_attribute :cListServ, :codigo_servico

					# VALOR DEDUÇÃO PARA REDUÇÃO DA BASE DE CÁLCULO
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vDeducao
					# 
					attr_accessor :total_deducao_bc
					alias_attribute :vDeducao, :total_deducao_bc

					# VALOR OUTRAS RETENÇÕES
					#  Valor declaratório
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vOutro
					# 
					attr_accessor :total_outras_retencoes
					alias_attribute :vOutro, :total_outras_retencoes

					# VALOR DESCONTO INCONDICIONADO
					#  
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vDescIncond
					# 
					attr_accessor :total_desconto_incondicionado
					alias_attribute :vDescIncond, :total_desconto_incondicionado

					# VALOR DESCONTO CONDICIONADO
					#  
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vDescCond
					# 
					attr_accessor :total_desconto_condicionado
					alias_attribute :vDescCond, :total_desconto_condicionado

					# VALOR RETENÇÃO ISS
					#  Valor declaratório
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vISSRet
					# 
					attr_accessor :total_iss_retido
					alias_attribute :vISSRet, :total_iss_retido

					# INDICADOR DA EXIGIBILIDADE DO ISS
					#  1=Exigível, 
					#  2=Não incidência; 
					#  3=Isenção; 
					#  4=Exportação;
					#  5=Imunidade; 
					#  6=Exigibilidade Suspensa por Decisão Judicial;
					#  7=Exigibilidade Suspensa por Processo Administrativo;
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _2_
					# <b>Default:  </b> _1_
					# <b>Length:   </b> _1_
					# <b>tag:      </b> indISS
					# 
					attr_accessor :indicador_iss
					def indicador_iss
						@indicador_iss.to_i if @indicador_iss.present?
					end
					alias_attribute :indISS, :indicador_iss

					# CÓDIGO DO SERVIÇO PRESTADO DENTRO DO MUNICÍPIO
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _216461_
					# <b>Length:   </b> _max: 20_
					# <b>tag:      </b> cServico
					# 
					attr_accessor :codigo_servico_municipio
					alias_attribute :cServico, :codigo_servico_municipio

					# CÓDIGO DO MUNICÍPIO DE INCIDÊNCIA DO IMPOSTO
					# Tabela do IBGE. Informar "9999999" para serviço fora do País.
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _4253214_
					# <b>Length:   </b> _7_
					# <b>tag:      </b> cMun
					# 
					attr_accessor :municipio_incidencia
					alias_attribute :cMun, :municipio_incidencia

					# CÓDIGO DO PAÍS ONDE O SERVIÇO FOI PRESTADO
					#  Tabela do BACEN. Informar somente se o município da
					#  prestação do serviço for "9999999".
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _0142_
					# <b>Length:   </b> _4_
					# <b>tag:      </b> cPais
					# 
					attr_accessor :codigo_pais
					alias_attribute :cPais, :codigo_pais

					# NÚMERO DO PROCESSO JUDICIAL OU ADMINISTRATIVO DE SUSPENSÃO DA EXIGIBILIDADE
					#  Informar somente quando declarada a suspensão da exigibilidade do ISSQN.
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _0142_
					# <b>Length:   </b> _max: 30_
					# <b>tag:      </b> nProcesso
					# 
					attr_accessor :numero_processo
					alias_attribute :nProcesso, :numero_processo

					# INDICADOR DE INCENTIVO FISCAL
					#  true  = Sim(1); 
					#  false = Não;
					# 
					# <b>Type:     </b> _Boolean_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _0142_
					# <b>Default:  </b> _false_
					# <b>Length:   </b> _max: 30_
					# <b>tag:      </b> indIncentivo
					# 
					attr_accessor :incentivo_fiscal
					def incentivo_fiscal
						convert_to_boolean(@incentivo_fiscal)
					end
					alias_attribute :indIncentivo, :incentivo_fiscal

					def default_values
						{
							indicador_iss:    1, # 1=Exigível;
							incentivo_fiscal: false, # Não
						}
					end

					validates :indicador_iss,        presence: true
					validates :codigo_servico,       presence: true
					validates :total_base_calculo,   presence: true
					validates :aliquota,             presence: true
					validates :total,                presence: true
					validates :municipio_ocorrencia, presence: true

					validates :indicador_iss,      inclusion: {in: [1,2,3,4,5,6,7]}, allow_blank: true
					validates :total_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :aliquota,           numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					validates :total,              numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

					validates :codigo_pais,              length: {maximum: 4}
					validates :municipio_ocorrencia,     length: {maximum: 7}
					validates :municipio_incidencia,     length: {maximum: 7}
					validates :codigo_servico_municipio, length: {maximum: 20}
					validates :numero_processo,          length: {maximum: 30}
				end
			end
		end
	end
end