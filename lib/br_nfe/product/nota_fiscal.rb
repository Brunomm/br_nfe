module BrNfe
	module Product
		class NotaFiscal  < BrNfe::ActiveModelBase
			include BrNfe::Association::HaveDestinatario
			# include BrNfe::Association::HaveCondicaoPagamento

			# Código numérico que compõe a Chave de Acesso. Número aleatório gerado pelo 
			# emitente para cada NF-e para evitar acessos indevidos da NF-e.
			# Resumo: É um código controlado pelo sistema. Pode por exemplo ser
			#        utilizado o ID da tabela da nota fiscal.
			# 
			# <b>Tipo: </b> _Number_
			# <b>Max: </b> _8_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _nil_
			#
			attr_accessor :codigo_nf
			
			# Série do Documento Fiscal, preencher com zeros na hipótese
			# de a NF-e não possuir série. (v2.0) 
			# Série 890-899: uso exclusivo para emissão de NF-e avulsa, pelo
			#    contribuinte com seu certificado digital, através do site do Fisco
			#    (procEmi=2). (v2.0)
			# Serie 900-999: uso exclusivo de NF-e emitidas no SCAN. (v2.0)
			#
			# <b>Tipo: </b> _Number_
			# <b>Max: </b> _3_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _nil_
			#
			attr_accessor :serie

			# Número do Documento Fiscal.
			# Número da nota fiscal -< De fato
			#
			# <b>Tipo: </b> _Number_
			# <b>Max: </b> _9_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _nil_
			#
			attr_accessor :numero_nf

			# Descrição da Natureza da Operação
			# Informar a natureza da operação de que decorrer a saída ou a
			# entrada, tais como: venda, compra, transferência, devolução,
			# importação, consignação, remessa (para fins de demonstração,
			# de industrialização ou outra), conforme previsto na alínea 'i',
			# inciso I, art. 19 do CONVÊNIO S/No, de 15 de dezembro de
			# 1970.
			#
			# <b>Tipo: </b> _String_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _'Venda'_
			#
			attr_accessor :natureza_operacao

			# Indicador da forma de pagamento
			# 0=Pagamento à vista; (Default)
			# 1=Pagamento a prazo;
			# 2=Outros.
			#
			# <b>Tipo: </b> _Number_ OR _String_
			# <b>Max: </b> _1_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _0_
			#
			attr_accessor :forma_pagamento

			# Código do Modelo do Documento Fiscal
			# 55=NF-e emitida em substituição ao modelo 1 ou 1A; (Default)
			# 65=NFC-e, utilizada nas operações de venda no varejo (a critério da UF aceitar este modelo de documento).
			#
			# <b>Tipo: </b> _Number_ OR _String_
			# <b>Max: </b> _2_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _55_
			#
			attr_accessor :modelo_nf

			# Data e hora de emissão do Documento Fiscal
			#
			# <b>Tipo: </b> _Time_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _Time.current_
			#
			attr_accessor :data_hora_emissao
			def data_hora_emissao
				convert_to_time(@data_hora_emissao)
			end

			# Data e hora de Saída ou da Entrada da Mercadoria/Produto
			# Campo não considerado para a NFC-e.
			#
			# <b>Tipo: </b> _Time_
			# <b>Required: </b> _Yes_ (apenas para modelo 55)
			# <b>Default: </b> _Time.current_
			#
			attr_accessor :data_hora_expedicao
			def data_hora_expedicao
				convert_to_time(@data_hora_expedicao)
			end

			# Tipo de Operação
			# 0=Entrada;
			# 1=Saída (Default)
			#
			# <b>Tipo: </b> _Number_ OR _String_
			# <b>Max: </b> _1_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _1_
			#
			attr_accessor :tipo_operacao

			# Formato de Impressão do DANFE
			# 0=Sem geração de DANFE;
			# 1=DANFE normal, Retrato; (Default)
			# 2=DANFE normal, Paisagem;
			# 3=DANFE Simplificado;
			# 4=DANFE NFC-e;
			# 5=DANFE NFC-e em mensagem eletrônica (o envio de mensagem eletrônica pode
			#   ser feita de forma simultânea com a impressão do DANFE; usar o tpImp=5 
			#   quando esta for a única forma de disponibilização do DANFE).
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _1_
			#
			attr_accessor :tipo_impressao

			# Finalidade de emissão da NF-e
			# 1=NF-e normal; (Default)
			# 2=NF-e complementar;
			# 3=NF-e de ajuste;
			# 4=Devolução de mercadoria.
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _1_
			#
			attr_accessor :finalidade_emissao


			# Indica operação com Consumidor final
			# false=Normal;
			# true=Consumidor final;
			#
			# Preencher esse campo com true ou false
			#
			# <b>Tipo: </b> _Boolean_
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _false_
			#
			attr_accessor :consumidor_final
			def consumidor_final
				convert_to_boolean(@consumidor_final)
			end


			# Indicador de presença do comprador no estabelecimento comercial no 
			# momento da operação:
			#   0=Não se aplica (por exemplo, Nota Fiscal complementar ou de ajuste);
			#   1=Operação presencial;
			#   2=Operação não presencial, pela Internet;
			#   3=Operação não presencial, Teleatendimento;
			#   4=NFC-e em operação com entrega a domicílio;
			#   9=Operação não presencial, outros. (Default)
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _9_
			#
			attr_accessor :presenca_comprador

			# Processo de emissão da NF-e
			# 0=Emissão de NF-e com aplicativo do contribuinte; (Default)
			# 1=Emissão de NF-e avulsa pelo Fisco;
			# 2=Emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;
			# 3=Emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _0_
			#
			attr_accessor :processo_emissao

			# Versão do Processo de emissão da NF-e
			# Informar a versão do aplicativo emissor de NF-e.
			#
			# <b>Required: </b> _Yes_
			# <b>Default: </b> _0_
			#
			attr_accessor :versao_aplicativo
			

			def default_values
				{
					versao_aplicativo:   0, 
					natureza_operacao:   'Venda',
					forma_pagamento:     0, # 0=À vista
					modelo_nf:           55, #NF-e
					data_hora_emissao:   Time.current,
					data_hora_expedicao: Time.current,
					tipo_operacao:       1, # 1=Saída
					tipo_impressao:      1, # 1=DANFE normal, Retrato;
					finalidade_emissao:  1, # 1=NF-e normal;
					presenca_comprador:  9, # 9=Operação não presencial, outros.
					processo_emissao:    0, # 0=Emissão de NF-e com aplicativo do contribuinte;
				}
			end

			validates :codigo_nf, presence: true
			validates :codigo_nf, numericality: { only_integer: true }
			validates :codigo_nf, length: { maximum: 8 }
			
			validates :serie, presence: true
			validates :serie, numericality: { only_integer: true }
			validates :serie, length: { maximum: 3 }
			validates :serie, exclusion: [890, 899, 990, 999, '890', '899', '990', '999']
			
			validates :numero_nf, presence: true
			validates :numero_nf, numericality: { only_integer: true }
			validates :numero_nf, length: { maximum: 9 }
			
			validates :natureza_operacao, presence: true
			
			validates :forma_pagamento, presence: true
			validates :forma_pagamento, inclusion: [0, 1, 2, '0', '1', '2']
			
			validates :modelo_nf, presence: true
			validates :modelo_nf, inclusion: [55, 65, '55', '65']

			validates :data_hora_emissao, presence: true
			validates :data_hora_expedicao, presence: true, if: :nfe?
			
			validates :tipo_operacao, presence: true
			validates :tipo_operacao, inclusion: [0, 1, '0', '1']

			validates :tipo_impressao, presence: true
			validates :tipo_impressao, inclusion: [0, 1, 2, 3, 4, 5, '0', '1', '2', '3', '4', '5']
			
			validates :presenca_comprador, presence: true
			validates :presenca_comprador, inclusion: [0, 1, 2, 3, 4, 9, '0', '1', '2', '3', '4', '9']
			
			validates :processo_emissao, presence: true
			validates :processo_emissao, inclusion: [0, 1, 2, 3, '0', '1', '2', '3']


			def nfe?
				modelo_nf.to_i == 55
			end
			def nfce?
				modelo_nf.to_i == 65
			end

		private

			def destinatario_class
				BrNfe.destinatario_product_class
			end

		end
	end
end