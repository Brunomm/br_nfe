########################################################################################
#######################################  NOTA 1  #######################################
#   No grupo (ICMSPart) Partilha do ICMS entre a UF de origem e 
#   UF de destino ou a UF na legislação, campos:
#      -pBCOp("Percentual da BC operação própria")
#      - UFST("UF para qual é devido o ICMS ST")
#   -> Refere-se às operações com veículos automotores novos efetuados por meio de 
#      faturamento direto para consumidor, cujo percentual de partilha do ICMS é 
#      definido pelo Convênio ICMS 51/00.
#   ------------------------------------------------------------------------------------   
#   No grupo (ICMSST) ICMS ST - repasse de ICMS ST retido anteriormente em 
#   operações interestaduais com repasses através do Substituto Tributário.
#   -> ICMS ST que foi retido e recolhido antecipadamente pela UF do remetente, 
#   	em operações interestaduais e que será repassado a UF de destino.
#  
#  Os grupos ICMSST e ICMSPart ainda não serão desenvolvidos pois são exclusivamente
#  para venda de "veiculos novos"
#########################################################################################
#
module BrNfe
	module Product
		module Nfe
			module ItemTax
				class Icms < BrNfe::ActiveModelBase
					# ORIGEM DA MERCADORIA
					# 0 - Nacional, exceto as indicadas nos códigos 3, 4, 5 e 8;
					# 1 - Estrangeira - Importação direta, exceto a indicada no código 6;
					# 2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7;
					# 3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior 
					#     a 40% e inferior ou igual a 70%;
					# 4 - Nacional, cuja produção tenha sido feita em conformidade com os processos 
					#     produtivos básicos de que tratam as legislações citadas nos Ajustes;
					# 5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou 
					#     igual a 40%;
					# 6 - Estrangeira - Importação direta, sem similar nacional, constante em 
					#     lista da CAMEX e gás natural;
					# 7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, 
					#     constante lista CAMEX e gás natural.
					# 8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70%;
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _1_
					# <b>Length:   </b> _1_
					# <b>Default:  </b> _0_ <- Fixed if nil
					# <b>tag:      </b> orig
					#
					attr_accessor :origem
					def origem
						@origem.to_i
					end
					alias_attribute :orig, :origem

					# CÓDIGO DA SITUAÇÃO TRIBUTÁRIA (CST) OU
					# CÓDIGO DE SITUAÇÃO DA OPERAÇÃO - SIMPLES NACIONAL (CSOSN)
					#   00  - Tributada integralmente
					#   10  - Tributada e com cobrança do icms por substituição tributária
					#   20  - Com redução de base de cálculo
					#   30  - Isenta ou não tributada e com cobrança do icms por substituição tributária
					#   40  - Isenta
					#   41  - Não tributada
					#   50  - Suspensão
					#   51  - Diferimento
					#   60  - Icms cobrado anteriormente por substituição tributária
					#   70  - Com redução de base de cálculo e cobrança do icms por substituição tributária
					#   90  - Outras
					#   101 - Tributada pelo Simples Nacional com permissão de crédito
					#   102 - Tributada pelo Simples Nacional sem permissão de crédito
					#   103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta
					#   201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por ST
					#   202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por ST
					#   203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por ST
					#   300 - Imune
					#   400 - Não tributada pelo Simples Nacional
					#   500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
					#   900 - Outros
					#
					# <b>Type:     </b> _Number_ <- string
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _00_
					# <b>Length:   </b> _min: 2, max: 3_
					# <b>tag:      </b> CST ou CSOSN
					# 
					attr_accessor :codigo_cst
					def codigo_cst
						"#{@codigo_cst}".rjust(2, '0') if @codigo_cst.present?
					end
					alias_attribute :CST, :codigo_cst
					alias_attribute :CSOSN, :codigo_cst

					# Modalidade de determinação da BC do ICMS
					#  0=Margem Valor Agregado (%);
					#  1=Pauta (Valor);
					#  2=Preço Tabelado Máx. (valor);
					#  3=Valor da operação.
					#
					# Utilizado nos CSTs: [00 10 20 51 90 900]
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _CST: [00 10 20 90]_
					# <b>Example:  </b> _0_
					# <b>Length:   </b> _1_
					# <b>tag:      </b> modBC
					# 
					attr_accessor :modalidade_base_calculo
					def modalidade_base_calculo
						@modalidade_base_calculo.to_i if @modalidade_base_calculo.present?
					end
					alias_attribute :modBC, :modalidade_base_calculo

					# PERCENTUAL REDUÇÃO DE BASE DE CÁLCULO DO ICMS
					# Utilizado nos CSTs: [20 51 70 90 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [20 70]_
					# <b>Example:  </b> _45.00_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pRedBC
					# 
					attr_accessor :reducao_base_calculo
					alias_attribute :pRedBC, :reducao_base_calculo

					# VALOR DA BASE DE CÁLCULO DO ICMS
					# Valor base utilizado para calcular o valor d ICMS
					# Utilizado nos CSTs: [00 10 20 51 70 90 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [00 10 20 70 90]_
					# <b>Example:  </b> _350.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBC, :total_base_calculo

					# ALÍQUOTA DO ICMS 
					# Percentual do imposto do ICMS
					# Utilizado nos CSTs: [00 10 20 51 70 90 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [00 10 20 70 90]_
					# <b>Example:  </b> _17.00_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pICMS
					# 
					attr_accessor :aliquota
					alias_attribute :pICMS, :aliquota

					# VALOR DO ICMS
					# Valor total do ICMS
					# Utilizado nos CSTs: [00 10 20 51 70 900]
					# O calculo se dá através da base de cálculo x alíquota
					# EX: 
					#  total_base_calculo = 200.00
					#  aliquota = 17.0%
					#  total = 200*17% = 34.00
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [00 10 20 70]_
					# <b>Example:  </b> _120.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMS
					# 
					attr_accessor :total
					def total
						@total ||= calculate_total
					end
					alias_attribute :vICMS, :total

					# Modalidade de determinação da BC do ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					#  0=Preço tabelado ou máximo sugerido;
					#  1=Lista Negativa (valor);
					#  2=Lista Positiva (valor);
					#  3=Lista Neutra (valor);
					#  4=Margem Valor Agregado (%);
					#  5=Pauta (valor)
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _CST: [10 30 70 201 202 203]_
					# <b>Example:  </b> _2_
					# <b>Length:   </b> _1_
					# <b>tag:      </b> modBCST
					# 
					attr_accessor :modalidade_base_calculo_st
					def modalidade_base_calculo_st
						@modalidade_base_calculo_st.to_i if @modalidade_base_calculo_st.present?
					end
					alias_attribute :modBCST, :modalidade_base_calculo_st

					# PERCENTUAL DA MARGEM DE VALOR ADICIONADO DO ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					#  MVA ST original – é a margem de valor agregado prevista 
					#  na legislação do Estado do destinatário para suas operações 
					#  internas com produto sujeito ao regime de substituição tributária;
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _120.00_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pMVAST
					# 
					attr_accessor :mva_st
					alias_attribute :pMVAST, :mva_st

					# PERCENTUAL REDUÇÃO DE BASE DE CÁLCULO DO ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _45.00_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pRedBCST
					# 
					attr_accessor :reducao_base_calculo_st	
					alias_attribute :pRedBCST, :reducao_base_calculo_st

					# VALOR DA BASE DE CÁLCULO DO ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [10 30 70 201 202 203]_
					# <b>Example:  </b> _1450.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vBCST
					# 
					attr_accessor :total_base_calculo_st
					alias_attribute :vBCST, :total_base_calculo_st

					# ALÍQUOTA DO ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					# Percentual do imposto do ICMS
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [10 30 70 201 202 203]_
					# <b>Example:  </b> _17.00_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pICMSST
					# 
					attr_accessor :aliquota_st
					alias_attribute :pICMSST, :aliquota_st

					# VALOR DO ICMS ST
					# Utilizado nos CSTs: [10 30 70 201 202 203 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [10 30 70 201 202 203]_
					# <b>Example:  </b> _120.00_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSST
					# 
					attr_accessor :total_st
					alias_attribute :vICMSST, :total_st

					# VALOR DO ICMS DESONERADO
					# Utilizado nos CSTs: [20 30 40 41 50 70]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSDeson
					# 
					attr_accessor :total_desoneracao
					alias_attribute :vICMSDeson, :total_desoneracao

					# MOTIVO DA DESONERAÇÃO DO ICMS
					#   Campo será preenchido quando o campo anterior estiver
					#   preenchido. Informar o motivo da desoneração:
					#
					# Utilizado nos CSTs: [20 30 70]
					#   3=Uso na agropecuária;
					#   9=Outros;
					#   12=Órgão de fomento e desenvolvimento agropecuário.
					#
					# Utilizado nos CSTs: [40 41 50]
					#    1=Táxi;
					#    2=Deficiente Físico <- Revogada a partir da versão 3.01
					#    3=Produtor Agropecuário;
					#    4=Frotista/Locadora;
					#    5=Diplomático/Consular;
					#    6=Utilitários e Motocicletas da Amazônia Ocidental e Áreas de
					#      Livre Comércio (Resolução 714/88 e 790/94 – CONTRAN e suas alterações);
					#    7=SUFRAMA;
					#    8=Venda a Órgão Público;
					#    9=Outros. (NT 2011/004);
					#    10=Deficiente Condutor (Convênio ICMS 38/12);
					#    11=Deficiente Não Condutor (Convênio ICMS 38/12).
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_ (yes if total_desoneracao)
					# <b>Example:  </b> _9_
					# <b>Length:   </b> _1 OR 2_
					# <b>tag:      </b> motDesICMS
					# 
					attr_accessor :motivo_desoneracao
					def motivo_desoneracao
						@motivo_desoneracao.to_i if @motivo_desoneracao.present?
					end
					alias_attribute :motDesICMS, :motivo_desoneracao

					# VALOR DO ICMS DA OPERAÇÃO
					# Informar o valor do ICMS como se não tivesse diferimento
					#
					# Utilizado nos CSTs: [51]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSOp
					# 
					attr_accessor :total_icms_operacao
					alias_attribute :vICMSOp, :total_icms_operacao

					# PERCENTUAL DO DIFERIMENTO
					# No caso de diferimento total, informar o percentual de difereimento = 100
					# Utilizado nos CSTs: [51]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pDif
					# 
					attr_accessor :percentual_diferimento
					alias_attribute :pDif, :percentual_diferimento

					# VALOR DO ICMS DIFERIDO
					# 
					# Utilizado nos CSTs: [51]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSDif
					# 
					attr_accessor :total_icms_diferido
					alias_attribute :vICMSDif, :total_icms_diferido

					# VALOR DA BC DO ICMS ST RETIDO
					# Valor da BC do ICMS ST cobrado anteriormente por ST (v2.0).
					# O valor pode ser omitido quando a legislação não exigir a sua
					# informação. (NT 2011/004)
					# 
					# Utilizado nos CSTs: [60 500]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vBCSTRet
					# 
					attr_accessor :total_base_calculo_st_retido
					alias_attribute :vBCSTRet, :total_base_calculo_st_retido

					# VALOR DO ICMS ST RETIDO
					# Valor do ICMS ST cobrado anteriormente por ST (v2.0). O valor
					# pode ser omitido quando a legislação não exigir a sua
					# informação. (NT 2011/004)
					# 
					# Utilizado nos CSTs: [60 500]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if total_base_calculo_st_retido > 0)
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vICMSSTRet
					# 
					attr_accessor :total_st_retido
					alias_attribute :vICMSSTRet, :total_st_retido

					# ALÍQUOTA APLICÁVEL DE CÁLCULO DO CRÉDITO (SIMPLES NACIONAL).
					#
					# Utilizado nos CSTs: [101 201 900]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [101 201]_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2-4_
					# <b>tag:      </b> pCredSN
					# 
					attr_accessor :aliquota_credito_sn
					alias_attribute :pCredSN, :aliquota_credito_sn

					# VALOR CRÉDITO DO ICMS QUE PODE SER APROVEITADO 
					# nos termos do art. 23 da LC 123 (Simples Nacional)
					#
					# Utilizado nos CSTs: [101 201]
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _CST: [101 201 900]_
					# <b>Example:  </b> _75.5_
					# <b>Length:   </b> _13v2_
					# <b>tag:      </b> vCredICMSSN
					# 
					attr_accessor :total_credito_sn
					alias_attribute :vCredICMSSN, :total_credito_sn


					###################################################################
					###########################  VALIDAÇÕES ###########################
					validates :origem, inclusion: {in: 0..8}
					validates :codigo_cst, inclusion: {in: %w[00 10 20 30 40 41 50 51 60 70 90 101 102 103 201 202 203 300 400 500 900]}
					validates :codigo_cst, presence: true
					validates :reducao_base_calculo, :reducao_base_calculo_st, numericality: {
						greater_than_or_equal_to: 0.0,  less_than_or_equal_to: 100.0
					}, allow_blank: true

					with_options if: lambda{|r| r.codigo_cst == '00' } do |record|
						record.validates :aliquota,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota,                presence: true
						record.validates :total_base_calculo,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo,      presence: true
						record.validates :modalidade_base_calculo, inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo, presence: true
					end
					with_options if: lambda{|r| r.codigo_cst == '10' } do |record|
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
						record.validates :aliquota,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota,                   presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota_st,                presence: true
						record.validates :total_base_calculo,         numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo,         presence: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :modalidade_base_calculo,    inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo,    presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :modalidade_base_calculo_st, presence: true
					end
					with_options if: lambda{|r| r.codigo_cst == '20' } do |record|
						record.validates :aliquota,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota,                presence: true
						record.validates :total_desoneracao,       numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :motivo_desoneracao,      inclusion: {in: [3,9,12]}, allow_blank: true
						validates        :motivo_desoneracao,      presence: true, if: lambda{|r| r.codigo_cst == '20' && r.total_desoneracao.present? }
						record.validates :total_base_calculo,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo,      presence: true
						record.validates :reducao_base_calculo,    presence: true
						record.validates :modalidade_base_calculo, inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo, presence: true
					end
					with_options if: lambda{|r| r.codigo_cst == '30' } do |record|
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota_st,                presence: true
						record.validates :total_desoneracao,          numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :motivo_desoneracao,         inclusion: {in: [3,9,12]}, allow_blank: true
						validates        :motivo_desoneracao,         presence: true, if: lambda{|r| r.codigo_cst == '30' && r.total_desoneracao.present? }
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :modalidade_base_calculo_st, presence: true
					end
					with_options if: lambda{|r| r.codigo_cst.in?(%w[40 41 50]) } do |record|
						record.validates :total_desoneracao,  numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :motivo_desoneracao, inclusion: {in: 1..11}, allow_blank: true
						validates        :motivo_desoneracao, presence: true, if: lambda{|r| r.codigo_cst.in?(%w[40 41 50]) && r.total_desoneracao.present? }
					end
					with_options if: lambda{|r| r.codigo_cst == '51' } do |record|
						record.validates :modalidade_base_calculo, inclusion: {in: 0..3}, allow_blank: true
						record.validates :total_icms_operacao,    numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_icms_diferido,    numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :percentual_diferimento, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}, allow_blank: true
					end

					with_options if: lambda{|r| r.codigo_cst == '70' } do |record|
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
						record.validates :aliquota,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota,                   presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota_st,                presence: true
						record.validates :total_desoneracao,          numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :motivo_desoneracao,         inclusion: {in: [3,9,12]}, allow_blank: true
						validates        :motivo_desoneracao,         presence: true, if: lambda{|r| r.codigo_cst == '70' && r.total_desoneracao.present? }
						record.validates :total_base_calculo,         numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo,         presence: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :modalidade_base_calculo,    inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo,    presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :modalidade_base_calculo_st, presence: true
					end

					with_options if: lambda{|r| r.codigo_cst == '90' } do |record|
						record.validates :aliquota,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota,                   presence: true
						record.validates :total_desoneracao,          numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :motivo_desoneracao,         inclusion: {in: [3,9,12]}, allow_blank: true
						validates        :motivo_desoneracao,         presence: true, if: lambda{|r| r.codigo_cst == '90' && r.total_desoneracao.present? }
						record.validates :total_base_calculo,         numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo,         presence: true
						record.validates :modalidade_base_calculo,    inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo,    presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
					with_options if: lambda{|r| r.codigo_cst == '90' && r.aliquota_st.present? } do |record|
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :modalidade_base_calculo_st, presence: true
					end

					with_options if: lambda{|r| r.codigo_cst == '101' } do |record|
						record.validates :total_credito_sn,    presence: true
						record.validates :total_credito_sn,    numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :aliquota_credito_sn, presence: true
						record.validates :aliquota_credito_sn, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}, allow_blank: true
					end
					with_options if: lambda{|r| r.codigo_cst == '201' } do |record|
						record.validates :modalidade_base_calculo_st, presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota_st,                presence: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
						record.validates :total_credito_sn,           presence: true
						record.validates :total_credito_sn,           numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :aliquota_credito_sn,        presence: true
						record.validates :aliquota_credito_sn,        numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0}, allow_blank: true
					end
					with_options if: lambda{|r| r.codigo_cst.in?(%w[202 203]) } do |record|
						record.validates :modalidade_base_calculo_st, presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_base_calculo_st,      presence: true
						record.validates :aliquota_st,                numericality: {greater_than_or_equal_to: 0.0}
						record.validates :aliquota_st,                presence: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}
						record.validates :total_st,                   presence: true
					end

					with_options if: lambda{|r| r.codigo_cst.in?(['60','500']) && r.total_base_calculo_st_retido.to_f > 0.0 } do |record|
						record.validates :total_st_retido, presence: true
						record.validates :total_st_retido, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
					
					with_options if: lambda{|r| r.codigo_cst == '900'} do |record|
						record.validates :aliquota,            numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :aliquota_st,         numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :aliquota_credito_sn, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end					
					with_options if: lambda{|r| r.codigo_cst == '900' && r.aliquota.to_f > 0.0 } do |record|
						record.validates :total_base_calculo,         numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_base_calculo,         presence: true
						record.validates :total,                      numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :modalidade_base_calculo,    inclusion: {in: 0..3}
						record.validates :modalidade_base_calculo,    presence: true
					end
					with_options if: lambda{|r| r.codigo_cst == '900' && r.aliquota_st.to_f > 0.0 } do |record|
						record.validates :mva_st,                     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_base_calculo_st,      numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_base_calculo_st,      presence: true
						record.validates :total_st,                   numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_st,                   presence: true
						record.validates :modalidade_base_calculo_st, inclusion: {in: 0..5}
						record.validates :modalidade_base_calculo_st, presence: true
					end
					with_options if: lambda{|r| r.codigo_cst == '900' && r.aliquota_credito_sn.to_f > 0.0 } do |record|
						record.validates :total_credito_sn, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_credito_sn, presence: true
					end

				private

					def calculate_total
						(total_base_calculo.to_f * (aliquota.to_f/100.0)).round(2)
					end



				end
			end
		end
	end
end