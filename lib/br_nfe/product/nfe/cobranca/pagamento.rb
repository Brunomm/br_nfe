module BrNfe
	module Product
		module Nfe
			module Cobranca
				class Pagamento < BrNfe::ActiveModelBase
					# Forma de pagamento
					# 01=Dinheiro
					# 02=Cheque
					# 03=Cartão de Crédito
					# 04=Cartão de Débito
					# 05=Crédito Loja
					# 10=Vale Alimentação
					# 11=Vale Refeição
					# 12=Vale Presente
					# 13=Vale Combustível
					# 99=Outros
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_
					# <b>Exemplo:  </b> _1_ ou _'01'_
					# <b>Length:   </b> _2_
					# <b>tag:      </b> tPag
					#
					attr_accessor :forma_pagamento
					alias_attribute :tPag, :forma_pagamento

					# Valor do pagamento
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Exemplo:  </b> _1500.50_
					# <b>tag:      </b> vPag
					#
					attr_accessor :total
					alias_attribute :vPag, :total

					# TIPO DE INTEGRAÇÃO COM O CARTÃO
					#   Tipo de Integração do processo de pagamento com o sistema de automação da empresa/ 
					#   1 = Pagamento integrado com o sistema de automação da empresa Ex. equipamento TEF , Comercio Eletronico 
					#   2 = Pagamento não integrado com o sistema de automação da empresa Ex: equipamento POS
					# 
					# <b>Type:     </b> _Float_
					# <b>Required: </b> _Yes_
					# <b>Exemplo:  </b> _1500.50_
					# <b>tag:      </b> tpIntegra
					#
					attr_accessor :tipo_integracao
					alias_attribute :tpIntegra, :tipo_integracao

					# CNPJ da Credenciadora de cartão de crédito e/ou débito
					# Informar o CNPJ da Credenciadora de cartão de crédito / débito
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_ (if forma_pagamento IN [3, 4] )
					# <b>Exemplo:  </b> _12.123.456/0001-88_ ou _12345678901234_
					# <b>tag:      </b> CNPJ
					#
					attr_accessor :cartao_cnpj
					def cartao_cnpj
						return unless @cartao_cnpj.present?
						BrNfe::Helper::CpfCnpj.new(@cartao_cnpj).sem_formatacao
					end
					alias_attribute :CNPJ, :cartao_cnpj

					# Bandeira da operadora de cartão de crédito e/ou débito
					# 01=Visa
					# 02=Mastercard
					# 03=American Express
					# 04=Sorocred
					# 99=Outros
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _Yes_ (if forma_pagamento IN [3, 4] )
					# <b>Exemplo:  </b> _1_ ou _'02'_
					# <b>tag:      </b> tBand
					#
					attr_accessor :cartao_bandeira
					alias_attribute :tBand, :cartao_bandeira

					# Número de autorização da operação cartão de crédito e/ou débito.
					# Identifica o número da autorização da transação da operação com 
					# cartão de crédito e/ou débito
					#
					# <b>Type:     </b> _String_
					# <b>Required: </b> _Yes_ (if forma_pagamento IN [3, 4] )
					# <b>Exemplo:  </b> _'9799844646'_
					# <b>tag:      </b> cAut
					#
					attr_accessor :cartao_autorizacao
					alias_attribute :cAut, :cartao_autorizacao

					validates :forma_pagamento, :total, presence: true
					validates :forma_pagamento, inclusion: {in: BrNfe::Constants::FORMAS_PAGAMENTO}
					validates :total, numericality: {greater_than_or_equal_to: 0.0}
					
					with_options if: :cartao? do |record|
						record.validates :cartao_cnpj, :cartao_bandeira, :cartao_autorizacao, presence: true
						record.validates :cartao_cnpj, length: {maximum: 14}
						record.validates :cartao_autorizacao, length: {maximum: 20}
						record.validates :cartao_bandeira,    inclusion: {in: [1, 2, 3, 4, 99, '1', '2', '3', '4', '01', '02', '03', '04', '99']}
					end


					def cartao?
						forma_pagamento.to_i.in?([3, 4])
					end
				
				end
			end
		end
	end
end