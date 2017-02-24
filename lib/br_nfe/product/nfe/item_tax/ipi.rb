module BrNfe
	module Product
		module Nfe
			module ItemTax
				class Ipi < BrNfe::ActiveModelBase
					# CÓDIGO DA SITUAÇÃO TRIBUTÁRIA do IPI
					#   00 = Entrada com recuperação de crédito
					#   01 = Entrada tributada com alíquota zero
					#   02 = Entrada isenta
					#   03 = Entrada não-tributada
					#   04 = Entrada imune
					#   05 = Entrada com suspensão
					#   49 = Outras entradas
					#   50 = Saída tributada
					#   51 = Saída tributada com alíquota zero
					#   52 = Saída isenta
					#   53 = Saída não-tributada
					#   54 = Saída imune
					#   55 = Saída com suspensão
					#   99 = Outras saídas
					#
					# <b>Type:     </b> _Number_ <- string
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _00_
					# <b>Length:   </b> _2_
					# <b>tag:      </b> CST
					# 
					attr_accessor :codigo_cst
					def codigo_cst
						"#{@codigo_cst}".rjust(2, '0') if @codigo_cst.present?
					end
					alias_attribute :CST, :codigo_cst

					# CLASSE DE ENQUADRAMENTO DO IPI PARA CIGARROS E BEBIDAS
					#  Preenchimento conforme Atos Normativos editados pela
					#  Receita Federal (Observação 2)
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _C1324_
					# <b>Length:   </b> _max: 5_
					# <b>tag:      </b> clEnq
					# 
					attr_accessor :classe_enquadramento
					alias_attribute :clEnq, :classe_enquadramento

					# CNPJ DO PRODUTOR DA MERCADORIA, QUANDO DIFERENTE DO EMITENTE. 
					# SOMENTE PARA OS CASOS DE EXPORTAÇÃO DIRETA OU INDIRETA.
					#  Informar os zeros não significativos
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _00.000.000/0001-00 OU 01234567890123_
					# <b>Length:   </b> _14_
					# <b>tag:      </b> CNPJProd
					# 
					attr_accessor :cnpj_produtor
					def cnpj_produtor
						"#{@cnpj_produtor}".gsub(/[^\d]/,'')
					end
					alias_attribute :CNPJProd, :cnpj_produtor

					# CÓDIGO DO SELO DE CONTROLE IPI
					#  Preenchimento conforme Atos Normativos editados pela
					#  Receita Federal (Observação 3)
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _SELO12345654_
					# <b>Length:   </b> _max: 60_
					# <b>tag:      </b> cSelo
					# 
					attr_accessor :codigo_selo
					alias_attribute :cSelo, :codigo_selo

					# QUANTIDADE DE SELO DE CONTROLE
					#
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _50_
					# <b>Length:   </b> _max: 12_
					# <b>tag:      </b> qSelo
					# 
					attr_accessor :quantidade_selo
					def quantidade_selo
						"#{@quantidade_selo}".gsub(/[^\d]/,'')
					end
					alias_attribute :qSelo, :quantidade_selo
					
					# CÓDIGO DE ENQUADRAMENTO LEGAL DO IPI
					# Tabela a ser criada pela RFB, informar 999 enquanto a tabela
					# não for criada
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_
					# <b>Example:  </b> _999_
					# <b>Default:  </b> _999_
					# <b>Length:   </b> _max: 3_
					# <b>tag:      </b> cEnq
					# 
					attr_accessor :codigo_enquadramento
					alias_attribute :cEnq, :codigo_enquadramento

					# Valor da BC do IPI
					# Informar se o cálculo do IPI for por alíquota.
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _152.38_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :base_calculo
					alias_attribute :vBC, :base_calculo

					# Alíquota do IPI
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12.00_
					# <b>tag:      </b> pIPI
					# 
					attr_accessor :aliquota
					alias_attribute :pIPI, :aliquota

					# QUANTIDADE TOTAL NA UNIDADE PADRÃO PARA TRIBUTAÇÃO 
					# (SOMENTE PARA OS PRODUTOS TRIBUTADOS POR UNIDADE)
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12.00_
					# <b>tag:      </b> qUnid
					# 
					attr_accessor :quantidade_unidade
					alias_attribute :qUnid, :quantidade_unidade

					# VALOR POR UNIDADE TRIBUTÁVEL
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12.00_
					# <b>tag:      </b> vUnid
					# 
					attr_accessor :total_unidade
					alias_attribute :vUnid, :total_unidade

					# VALOR DO IPI
					#
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if CST [00 49 50 99])
					# <b>Example:  </b> _12.00_
					# <b>tag:      </b> vIPI
					# 
					attr_accessor :total
					alias_attribute :vIPI, :total

					def default_values
						{
							codigo_enquadramento: '999', 
						}
					end

					validates :codigo_cst, presence: true
					validates :codigo_cst, inclusion: {in: %w[00 01 02 03 04 05 49 50 51 52 53 54 55 99]}
					validates :classe_enquadramento, length: {maximum: 5}
					validates :cnpj_produtor,        length: {is: 14}, allow_blank: true
					validates :codigo_selo,          length: {maximum: 60}
					validates :quantidade_selo,      length: {maximum: 12}
					validates :codigo_enquadramento, presence: true
					validates :codigo_enquadramento, length: {maximum: 3}

					with_options if: lambda{|r| r.codigo_cst.in?(%w[00 49 50 99])} do |record|
						record.validates :total, presence: true
						record.validates :total, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
				end
			end
		end
	end
end