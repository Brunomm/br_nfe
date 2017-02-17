module BrNfe
	module Product
		module Nfe
			module ItemTax
				class Cofins < BrNfe::ActiveModelBase
					# CÓDIGO DA SITUAÇÃO TRIBUTÁRIA do COFINS
					#  01 = Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo));
					#  02 = Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada));
					#  03 = Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto);
					#  04 = Operação Tributável (tributação monofásica, alíquota zero);
					#  05 = Operação Tributável (Substituição Tributária);
					#  06 = Operação Tributável (alíquota zero);
					#  07 = Operação Isenta da Contribuição;
					#  08 = Operação Sem Incidência da Contribuição;
					#  09 = Operação com Suspensão da Contribuição;
					#  49 = Outras Operações de Saída;
					#  50 = Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno;
					#  51 = Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno;
					#  52 = Operação com Direito a Crédito – Vinculada Exclusivamente a Receita de Exportação;
					#  53 = Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno;
					#  54 = Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;
					#  55 = Operação com Direito a Crédito - Vinculada a Receitas Não- Tributadas no Mercado Interno e de Exportação;
					#  56 = Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;
					#  60 = Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno;
					#  61 = Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno;
					#  62 = Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação;
					#  63 = Crédito Presumido - Operação de Aquisição Vinculada Receitas Tributadas e Não-Tributadas no Mercado Interno;
					#  64 = Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação;
					#  65 = Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação;
					#  66 = Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação;
					#  67 = Crédito Presumido - Outras Operações;
					#  70 = Operação de Aquisição sem Direito a Crédito;
					#  71 = Operação de Aquisição com Isenção;
					#  72 = Operação de Aquisição com Suspensão;
					#  73 = Operação de Aquisição a Alíquota Zero;
					#  74 = Operação de Aquisição; sem Incidência da Contribuição;
					#  75 = Operação de Aquisição por Substituição Tributária;
					#  98 = Outras Operações de Entrada;
					#  99 = Outras Operações;
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

					# VALOR DA BASE DE CÁLCULO DO COFINS
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst in [01 02])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> vBC
					# 
					attr_accessor :total_base_calculo
					alias_attribute :vBC, :total_base_calculo

					# ALÍQUOTA DO COFINS (EM PERCENTUAL)
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst in [01 02])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> pCOFINS
					# 
					attr_accessor :aliquota
					alias_attribute :pCOFINS, :aliquota

					# VALOR DO COFINS
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_ (No if cst in [04 05 06 07 08 09])
					# <b>Example:  </b> _350.47_
					# <b>tag:      </b> vCOFINS
					# 
					attr_accessor :total
					alias_attribute :vCOFINS, :total

					# QUANTIDADE VENDIDA
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst is 03)
					# <b>Example:  </b> _10.0_
					# <b>Length:   </b> _12v0-4_
					# <b>tag:      </b> qBCProd
					# 
					attr_accessor :quantidade_vendida
					alias_attribute :qBCProd, :quantidade_vendida

					# ALÍQUOTA DO COFINS (EM REAIS)
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _No_ (Yes if cst is 03)
					# <b>Example:  </b> _10.0_
					# <b>Length:   </b> _11v0-4_
					# <b>tag:      </b> vAliqProd
					# 
					attr_accessor :total_aliquota
					alias_attribute :vAliqProd, :total_aliquota

					def default_values
						{
							codigo_cst: '07'
						}
					end
					
					validates :codigo_cst, presence: true
					validates :codigo_cst, inclusion: {in: %w[01 02 03 04 05 06 07 08 09 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 67 70 71 72 73 74 75 98 99]}

					with_options if: lambda{ |r| r.codigo_cst.in?(%w[01 02]) } do |record|
						record.validates :total_base_calculo, presence: true
						record.validates :total_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :aliquota,           presence: true
						record.validates :aliquota,           numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total,              presence: true
						record.validates :total,              numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
					with_options if: lambda{ |r| r.codigo_cst == '03' } do |record|
						record.validates :quantidade_vendida, presence: true
						record.validates :quantidade_vendida, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total_aliquota,     presence: true
						record.validates :total_aliquota,     numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
						record.validates :total,              presence: true
						record.validates :total,              numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
					with_options if: lambda{ |r| r.codigo_cst.in?(%w[49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 67 70 71 72 73 74 75 98 99]) } do |record|
						record.validates :total,              presence: true
						record.validates :total,              numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
					end
				end
			end
		end
	end
end