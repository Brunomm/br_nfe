module BrNfe
	module Product
		class NotaFiscal  < BrNfe::ActiveModelBase
			# include BrNfe::Association::HaveCondicaoPagamento

			# Identificação do emitente da NF-e
			# 
			# <b>Type:     </b> _BrNfe.emitente_product_class
			# <b>Required: </b> _Yes_
			# <b>tag:      </b> emit
			#
			has_one :emitente, 'BrNfe.emitente_product_class', null: false
			alias_attribute :emit, :emitente

			# Identificação do Destinatário da NF-e
			#  Grupo obrigatório para a NF-e (modelo 55)
			# 
			# <b>Type:     </b> _BrNfe.destinatario_product_class_
			# <b>Required: </b> _Yes_ (No if modelo_nf == 65)
			# <b>tag:      </b> dest
			#
			has_one :destinatario, 'BrNfe.destinatario_product_class', null: false
			alias_attribute :dest, :destinatario
			
			# Código do Tipo de Emissão da NF-e
			#  ✓ 1=Emissão normal (não em contingência);
			#  ✓ 6=Contingência SVC-AN (SEFAZ Virtual de Contingência do AN);
			#  ✓ 7=Contingência SVC-RS (SEFAZ Virtual de Contingência do RS);
			#  ✓ 9=Contingência off-line da NFC-e (as demais opções de contingência são válidas 
			#      também para a NFC-e).
			#  Para a NFC-e somente estão disponíveis e são válidas as opções de contingência 5 e 9.
			# 
			# <b>Type:     </b> _Number_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _1_
			# <b>Length:   </b> _1_
			# <b>tag:      </b> tpEmis
			#
			attr_accessor :codigo_tipo_emissao
			alias_attribute :tpEmis, :codigo_tipo_emissao


			attr_accessor :chave_de_acesso

			def chave_de_acesso_dv
				chave_de_acesso[-1]
			end
			def chave_de_acesso_sem_dv
				chave_de_acesso[0..-2]
			end
			def chave_de_acesso
				@chave_de_acesso ||= gerar_chave_de_acesso!
			end


			# Código numérico que compõe a Chave de Acesso. Número aleatório gerado pelo 
			# emitente para cada NF-e para evitar acessos indevidos da NF-e.
			# Resumo: É um código controlado pelo sistema. Pode por exemplo ser
			#        utilizado o ID da tabela da nota fiscal.
			# 
			# <b>Type:     </b> _Number_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _nil_
			# <b>Length:  </b> _max: 8_
			# <b>tag:      </b> cNF
			#
			attr_accessor :codigo_nf
			alias_attribute :cNF, :codigo_nf

			
			# Série do Documento Fiscal, preencher com zeros na hipótese
			# de a NF-e não possuir série. (v2.0) 
			# Série 890-899: uso exclusivo para emissão de NF-e avulsa, pelo
			#    contribuinte com seu certificado digital, através do site do Fisco
			#    (procEmi=2). (v2.0)
			# Serie 900-999: uso exclusivo de NF-e emitidas no SCAN. (v2.0)
			#
			# <b>Type:     </b> _Number_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _nil_
			# <b>Length:   </b> _max: 3_
			# <b>tag:      </b> serie
			#
			attr_accessor :serie

			# Número do Documento Fiscal.
			# Número da nota fiscal De fato
			#
			# <b>Type:     </b> _Number_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _nil_
			# <b>Length:   </b> _max: 9_
			# <b>tag:      </b> nNF
			#
			attr_accessor :numero_nf
			alias_attribute :nNF, :numero_nf

			# Descrição da Natureza da Operação
			# Informar a natureza da operação de que decorrer a saída ou a
			# entrada, tais como: venda, compra, transferência, devolução,
			# importação, consignação, remessa (para fins de demonstração,
			# de industrialização ou outra), conforme previsto na alínea 'i',
			# inciso I, art. 19 do CONVÊNIO S/No, de 15 de dezembro de
			# 1970.
			#
			# <b>Type:     </b> _String_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _'Venda'_
			# <b>tag:      </b> natOp
			#
			attr_accessor :natureza_operacao
			alias_attribute :natOp, :natureza_operacao

			# Indicador da forma de pagamento
			# 0=Pagamento à vista; (Default)
			# 1=Pagamento a prazo;
			# 2=Outros.
			#
			# <b>Type:     </b> _Number_ OR _String_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _0_
			# <b>Length:   </b> _1_
			# <b>tag:      </b> indPag
			#
			attr_accessor :forma_pagamento
			alias_attribute :indPag, :forma_pagamento

			# Código do Modelo do Documento Fiscal
			# 55=NF-e emitida em substituição ao modelo 1 ou 1A; (Default)
			# 65=NFC-e, utilizada nas operações de venda no varejo (a critério da UF aceitar este modelo de documento).
			#
			# <b>Type:     </b> _Number_ OR _String_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _55_
			# <b>Length:   </b> _2_
			# <b>tag:      </b> mod
			#
			attr_accessor :modelo_nf
			alias_attribute :mod, :modelo_nf

			# Data e hora de emissão do Documento Fiscal
			#
			# <b>Type:     </b> _Time_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _Time.current_
			# <b>tag:      </b> dhEmi
			#
			attr_accessor :data_hora_emissao
			def data_hora_emissao
				convert_to_time(@data_hora_emissao)
			end
			alias_attribute :dhEmi, :data_hora_emissao

			# Data e hora de Saída ou da Entrada da Mercadoria/Produto
			# Campo não considerado para a NFC-e.
			#
			# <b>Type:     </b> _Time_
			# <b>Required: </b> _Yes_ (apenas para modelo 55)
			# <b>Default:  </b> _Time.current_
			# <b>tag:      </b> dhSaiEnt
			#
			attr_accessor :data_hora_expedicao
			def data_hora_expedicao
				convert_to_time(@data_hora_expedicao)
			end
			alias_attribute :dhSaiEnt, :data_hora_expedicao

			# Tipo de Operação
			# 0=Entrada;
			# 1=Saída (Default)
			#
			# <b>Type:     </b> _Number_ OR _String_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _1_
			# <b>Length:   </b> _1_
			# <b>tag:      </b> tpNF
			#
			attr_accessor :tipo_operacao
			alias_attribute :tpNF, :tipo_operacao

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
			# <b>Default:  </b> _1_
			# <b>tag:      </b> tpEmis
			#
			attr_accessor :tipo_impressao
			alias_attribute :tpEmis, :tipo_impressao

			# Finalidade de emissão da NF-e
			# 1=NF-e normal; (Default)
			# 2=NF-e complementar;
			# 3=NF-e de ajuste;
			# 4=Devolução de mercadoria.
			#
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _1_
			# <b>tag:      </b> finNFe
			#
			attr_accessor :finalidade_emissao
			alias_attribute :finNFe, :finalidade_emissao


			# Indica operação com Consumidor final
			# false=Normal;
			# true=Consumidor final;
			#
			# Preencher esse campo com true ou false
			#
			# <b>Type:     </b> _Boolean_
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _false_
			# <b>tag:      </b> indFinal
			#
			attr_accessor :consumidor_final
			def consumidor_final
				convert_to_boolean(@consumidor_final)
			end
			alias_attribute :indFinal, :consumidor_final

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
			# <b>Default:  </b> _9_
			# <b>tag:      </b> indPres
			#
			attr_accessor :presenca_comprador
			alias_attribute :indPres, :presenca_comprador

			# Processo de emissão da NF-e
			# 0=Emissão de NF-e com aplicativo do contribuinte; (Default)
			# 1=Emissão de NF-e avulsa pelo Fisco;
			# 2=Emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;
			# 3=Emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
			#
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _0_
			# <b>tag:      </b> procEmi
			#
			attr_accessor :processo_emissao
			alias_attribute :procEmi, :processo_emissao

			# Versão do Processo de emissão da NF-e
			# Informar a versão do aplicativo emissor de NF-e.
			#
			# <b>Required: </b> _Yes_
			# <b>Default:  </b> _0_
			# <b>tag:      </b> verProc
			#
			attr_accessor :versao_aplicativo
			alias_attribute :verProc, :versao_aplicativo

			# Endereço da retirada da mercadoria
			#
			# <b>Type:     </b> _BrNfe.endereco_class_
			# <b>Required: </b> _No_
			# <b>Default:  </b> _nil_
			# <b>tag:      </b> retirada
			#
			has_one :endereco_retirada, 'BrNfe.endereco_class'
			alias_attribute :retirada, :endereco_retirada
			
			# CPF ou CNPJ do local de retirada da mercadoria.
			# Só é obrigatório se o endereco_retirada for preenchido
			#
			# <b>Type:     </b> _String_
			# <b>Required: </b> _No_ (_Yes_ if endereco_retirada is present)
			# <b>Default:  </b> _nil_
			# <b>tag:      </b> retirada/CPF ou retirada/CNPJ
			#
			attr_accessor :endereco_retirada_cpf_cnpj
			def endereco_retirada_cpf_cnpj
				return unless @endereco_retirada_cpf_cnpj.present?
				BrNfe::Helper::CpfCnpj.new(@endereco_retirada_cpf_cnpj).sem_formatacao
			end


			# Endereço da entrega da mercadoria
			# Informar apenas quando for diferente do endereço do destinatário
			#
			# <b>Type:     </b> _BrNfe.endereco_class_
			# <b>Required: </b> _No_
			# <b>Default:  </b> _nil_
			# <b>tag:      </b> entrega
			#
			has_one :endereco_entrega, 'BrNfe.endereco_class'
			alias_attribute :entrega, :endereco_entrega
			
			# CPF ou CNPJ do local de entrega da mercadoria.
			# Só é obrigatório se o endereco_entrega for preenchido
			#
			# <b>Type:     </b> _String_
			# <b>Required: </b> _No_ (_Yes_ if endereco_entrega is present)
			# <b>Default:  </b> _nil_
			# <b>tag:      </b> entrega/CPF ou entrega/CNPJ
			#
			attr_accessor :endereco_entrega_cpf_cnpj
			def endereco_entrega_cpf_cnpj
				return unless @endereco_entrega_cpf_cnpj.present?
				BrNfe::Helper::CpfCnpj.new(@endereco_entrega_cpf_cnpj).sem_formatacao
			end

			# CPF ou CNPJ das pessoas que estão autorizadas a fazer o download do XML da NF-e.
			# Deve ser um Array com os CPF's e CNPJ's válidos.
			#
			# <b>Type:     </b> _Array_
			# <b>Required: </b> _No_
			# <b>Default:  </b> _[]_
			# <b>tag:      </b> autXML
			#
			attr_accessor :autorizados_download_xml
			def autorizados_download_xml
				@autorizados_download_xml = [@autorizados_download_xml].flatten unless @autorizados_download_xml.is_a?(Array)
				@autorizados_download_xml.compact!
				@autorizados_download_xml
			end
			alias_attribute :autXML, :autorizados_download_xml

			# Transporte da mercadoria
			# Informações referentes ao transporte da mercadoria.
			#
			# <b>Type:     </b> _BrNfe.transporte_product_class_
			# <b>Required: </b> _No_
			# <b>Default:  </b> _nil_
			# <b>tag:      </b> transp
			#
			has_one :transporte, 'BrNfe.transporte_product_class'
			alias_attribute :transp, :transporte

			# Dados da cobrança da NF-e
			# Fatura e Duplicatas da Nota Fiscal
			# Utilizado para especificar os dados da fatura e das duplicatas.
			# No caso desta GEM, a fatura contém o Array de duplicatas.
			# Ex:
			#    self.fatura.duplicatas
			#    => [#<::Cobranca::Duplicata:0x00000006302b80 ...>, #<::Cobranca::Duplicata:0x00000046465bw4 ...>] 
			#
			# <b>Type:     </b> _BrNfe.fatura_product_class_
			# <b>Required: </b> _No_
			# <b>Default:  </b> _nil_
			# <b>Exemplo:  </b> _BrNfe::Product::Nfe::Cobranca::Fatura.new(numero_fatura: 'FAT646498'...)_
			# <b>tag:      </b> cobr
			#
			has_one :fatura, 'BrNfe.fatura_product_class'
			alias_attribute :cobranca, :fatura
			alias_attribute :cobr, :fatura
			
			# Array com as informações dos pagamentos
			# IMPORTANTE: Utilizado apenas para NFC-e
			#
			# Pode ser adicionado os dados dos pagamentos em forma de `Hash` 
			# ou o próprio objeto da classe BrNfe.pagamento_product_class.
			#
			# Exemplo com Hash:
			#    self.pagamentos = [{forma_pagamento: '1', total: 100.00, ...},{forma_pagamento: '2', total: 200.00, ...}]
			#    self.pagamentos << {forma_pagamento: '3', total: 300.00, ...}
			#    self.pagamentos << {forma_pagamento: '4', total: 400.00, ...}
			#
			# Exemplo com Objetos:
			#    self.pagamentos = [BrNfe::Product::Nfe::Cobranca::Pagamento.new({forma_pagamento: '5', total: 500.00, ...}),{forma_pagamento: '11', total: 600.00, ...}]
			#    self.pagamentos << BrNfe::Product::Nfe::Cobranca::Pagamento.new({forma_pagamento: '10', total: 700.00, ...})
			#    self.pagamentos << {forma_pagamento: '12', total: 800.00, ...}
			#
			# Sempre vai retornar um Array de objetos da class configurada em `BrNfe.pagamento_product_class`
			#
			# <b>Tipo:    </b> _BrNfe.pagamento_product_class (BrNfe::Product::Nfe::Cobranca::Pagamento)_
			# <b>Min:     </b> _0_
			# <b>Max:     </b> _100_
			# <b>Default: </b> _[]_
			# <b>tag:     </b> pag
			#
			has_many :pagamentos, 'BrNfe.pagamento_product_class'
			alias_attribute :pag, :pagamentos

			# DETALHAMENTO DE PRODUTOS E SERVIÇOS
			#
			# <b>Type:    </b> _BrNfe.item_product_class (BrNfe::Product::Nfe::Item)_
			# <b>Default: </b> _[]_
			# <b>Length:  </b> _min: 1, max: 990_
			# <b>tag:     </b> det
			#
			has_many :itens, 'BrNfe.item_product_class'
			alias_attribute :det, :itens

			##########################################################################
			#########################  TOTAIS PARA PRODUTOS  #########################
				# BASE DE CÁLCULO DO ICMS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vBC
				#
				attr_accessor :total_icms_base_calculo
				alias_attribute :ICMSTot_vBC, :total_icms_base_calculo
				validates :total_icms_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vICMS
				#
				attr_accessor :total_icms
				alias_attribute :ICMSTot_vICMS, :total_icms
				validates :total_icms, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS DESONERADO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vICMSDeson
				#
				attr_accessor :total_icms_desonerado
				alias_attribute :ICMSTot_vICMSDeson, :total_icms_desonerado
				validates :total_icms_desonerado, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS RELATIVO FUNDO DE COMBATE À POBREZA(FCP)
				# DA UF DE DESTINO
				#   Valor total do ICMS relativo ao Fundo de Combate à Pobreza
				#   (FCP) para a UF de destino.
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _108.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vFCPUFDest
				#
				attr_accessor :total_icms_fcp_uf_destino
				alias_attribute :ICMSTot_vFCPUFDest, :total_icms_fcp_uf_destino
				validates :total_icms_fcp_uf_destino, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS INTERESTADUAL PARA A UF DE DESTINO
				#   Valor total do ICMS Interestadual para a UF de destino, já
				#   considerando o valor do ICMS relativo ao Fundo de Combate à
				#   Pobreza naquela UF
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _108.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vICMSUFDest
				#
				attr_accessor :total_icms_uf_destino
				alias_attribute :ICMSTot_vICMSUFDest, :total_icms_uf_destino
				validates :total_icms_uf_destino, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS INTERESTADUAL PARA A UF DO REMETENTE
				#   Valor total do ICMS Interestadual para a UF do remetente.
				#   Nota: A partir de 2019, este valor será zero.
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _108.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vICMSUFRemet
				#
				attr_accessor :total_icms_uf_origem
				alias_attribute :ICMSTot_vICMSUFRemet, :total_icms_uf_origem
				validates :total_icms_uf_origem, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# BASE DE CÁLCULO DO ICMS ST
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vBCST
				#
				attr_accessor :total_icms_base_calculo_st
				alias_attribute :ICMSTot_vBCST, :total_icms_base_calculo_st
				validates :total_icms_base_calculo_st, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ICMS ST
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vST
				#
				attr_accessor :total_icms_st
				alias_attribute :ICMSTot_vST, :total_icms_st
				validates :total_icms_st, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DOS PRODUTOS E SERVIÇOS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vProd
				#
				attr_accessor :total_produtos
				alias_attribute :ICMSTot_vProd, :total_produtos
				validates :total_produtos, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO FRETE
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vFrete
				#
				attr_accessor :total_frete
				alias_attribute :ICMSTot_vFrete, :total_frete
				validates :total_frete, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO SEGURO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vSeg
				#
				attr_accessor :total_seguro
				alias_attribute :ICMSTot_vSeg, :total_seguro
				validates :total_seguro, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO DESCONTO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vDesc
				#
				attr_accessor :total_desconto
				alias_attribute :ICMSTot_vDesc, :total_desconto
				validates :total_desconto, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO II
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vII
				#
				attr_accessor :total_imposto_importacao
				alias_attribute :ICMSTot_vII, :total_imposto_importacao
				validates :total_imposto_importacao, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO IPI
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vIPI
				#
				attr_accessor :total_ipi
				alias_attribute :ICMSTot_vIPI, :total_ipi
				validates :total_ipi, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO PIS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vPIS
				#
				attr_accessor :total_pis
				alias_attribute :ICMSTot_vPIS, :total_pis
				validates :total_pis, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO COFINS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vCOFINS
				#
				attr_accessor :total_cofins
				alias_attribute :ICMSTot_vCOFINS, :total_cofins
				validates :total_cofins, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# OUTRAS DESPESAS ACESSÓRIAS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vOutro
				#
				attr_accessor :total_outras_despesas
				alias_attribute :ICMSTot_vOutro, :total_outras_despesas
				validates :total_outras_despesas, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DA NF-E
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vNF
				#
				attr_accessor :total_nf
				alias_attribute :ICMSTot_vNF, :total_nf
				validates :total_nf, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR APROXIMADO TOTAL DE TRIBUTOS FEDERAIS, ESTADUAIS E MUNICIPAIS.
				# (NT 2013/003)
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ICMSTot/vTotTrib
				#
				attr_accessor :total_tributos
				alias_attribute :ICMSTot_vTotTrib, :total_tributos
				validates :total_tributos, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
			##########################################################################
			#########################  TOTAIS PARA SERVIÇOS  #########################
				# VALOR TOTAL DOS SERVIÇOS SOB NÃO-INCIDÊNCIA OU NÃO TRIBUTADOS PELO ICMS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vServ
				#
				attr_accessor :total_servicos
				alias_attribute :ISSQNtot_vServ, :total_servicos
				validates :total_servicos, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL BASE DE CÁLCULO DO ISS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vBC
				#
				attr_accessor :total_servicos_base_calculo
				alias_attribute :ISSQNtot_vBC, :total_servicos_base_calculo
				validates :total_servicos_base_calculo, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO ISS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vISS
				#
				attr_accessor :total_servicos_iss
				alias_attribute :ISSQNtot_vISS, :total_servicos_iss
				validates :total_servicos_iss, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DO PIS SOBRE SERVIÇOS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vPIS
				#
				attr_accessor :total_servicos_pis
				alias_attribute :ISSQNtot_vPIS, :total_servicos_pis
				validates :total_servicos_pis, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DA COFINS SOBRE SERVIÇOS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vCOFINS
				#
				attr_accessor :total_servicos_cofins
				alias_attribute :ISSQNtot_vCOFINS, :total_servicos_cofins
				validates :total_servicos_cofins, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# DATA DA PRESTAÇÃO DO SERVIÇO
				# 
				#
				# <b>Type:     </b> _Date_
				# <b>Required: </b> _Yes_ apenas se tiver algum serviço nos itens
				# <b>Default:  </b> _Date.current_
				# <b>Example:  </b> _Date.current_
				# <b>Length:   </b> _8_ YYYYMMDD
				# <b>tag:      </b> total/ISSQNtot/dCompet
				#
				attr_accessor :servicos_data_prestacao
				def servicos_data_prestacao
					convert_to_date(@servicos_data_prestacao)
				end
				alias_attribute :ISSQNtot_dCompet, :servicos_data_prestacao
				validates :servicos_data_prestacao, presence: true, if: :has_any_service?

				# VALOR TOTAL DEDUÇÃO PARA REDUÇÃO DA BASE DE CÁLCULO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vDeducao
				#
				attr_accessor :total_servicos_deducao
				alias_attribute :ISSQNtot_vDeducao, :total_servicos_deducao
				validates :total_servicos_deducao, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL OUTRAS RETENÇÕES DO ISSQN
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vOutro
				#
				attr_accessor :total_servicos_outras_retencoes
				alias_attribute :ISSQNtot_vOutro, :total_servicos_outras_retencoes
				validates :total_servicos_outras_retencoes, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DESCONTO INCONDICIONADO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vDescIncond
				#
				attr_accessor :total_servicos_desconto_incondicionado
				alias_attribute :ISSQNtot_vDescIncond, :total_servicos_desconto_incondicionado
				validates :total_servicos_desconto_incondicionado, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL DESCONTO CONDICIONADO
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vDescCond
				#
				attr_accessor :total_servicos_desconto_condicionado
				alias_attribute :ISSQNtot_vDescCond, :total_servicos_desconto_condicionado
				validates :total_servicos_desconto_condicionado, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR TOTAL RETENÇÃO ISS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/ISSQNtot/vISSRet
				#
				attr_accessor :total_servicos_iss_retido
				alias_attribute :ISSQNtot_vISSRet, :total_servicos_iss_retido
				validates :total_servicos_iss_retido, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# CÓDIGO DO REGIME ESPECIAL DE TRIBUTAÇÃO
				#  1 = Microempresa Municipal; 
				#  2 = Estimativa;
				#  3 = Sociedade de Profissionais; 
				#  4 = Cooperativa;
				#  5 = Microempresário Individual (MEI);
				#  6 = Microempresário e Empresa de Pequeno Porte (ME/EPP)
				#
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _2_
				# <b>Default:  </b> _1_
				# <b>Length:   </b> _1_
				# <b>tag:      </b> total/ISSQNtot/cRegTrib
				#
				attr_accessor :regime_tributario_servico
				def regime_tributario_servico
					@regime_tributario_servico.to_i if @regime_tributario_servico.present?
				end
				alias_attribute :ISSQNtot_cRegTrib, :regime_tributario_servico
				validates :regime_tributario_servico, inclusion: {in: [1,2,3,4,5,6]}
			##########################################################################
			#########################  TOTAIS DAS RETENÇÕES  #########################
				# VALOR RETIDO DE PIS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vRetPIS
				#
				attr_accessor :total_retencao_pis
				alias_attribute :retTrib_vRetPIS, :total_retencao_pis
				validates :total_retencao_pis, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR RETIDO DE COFINS
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vRetCOFINS
				#
				attr_accessor :total_retencao_cofins
				alias_attribute :retTrib_vRetCOFINS, :total_retencao_cofins
				validates :total_retencao_cofins, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR RETIDO DE CSLL
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vRetCSLL
				#
				attr_accessor :total_retencao_csll
				alias_attribute :retTrib_vRetCSLL, :total_retencao_csll
				validates :total_retencao_csll, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# BASE DE CÁLCULO DO IRRF
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vBCIRRF
				#
				attr_accessor :total_retencao_base_calculo_irrf
				alias_attribute :retTrib_vBCIRRF, :total_retencao_base_calculo_irrf
				validates :total_retencao_base_calculo_irrf, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR RETIDO DO IRRF
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vIRRF
				#
				attr_accessor :total_retencao_irrf
				alias_attribute :retTrib_vIRRF, :total_retencao_irrf
				validates :total_retencao_irrf, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# BASE DE CÁLCULO DA RETENÇÃO DA PREVIDÊNCIA SOCIAL
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vBCRetPrev
				#
				attr_accessor :total_retencao_base_calculo_previdencia
				alias_attribute :retTrib_vBCRetPrev, :total_retencao_base_calculo_previdencia
				validates :total_retencao_base_calculo_previdencia, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true

				# VALOR DA RETENÇÃO DA PREVIDÊNCIA SOCIAL
				#
				# <b>Type:     </b> _Float_
				# <b>Required: </b> _No_
				# <b>Example:  </b> _178.46_
				# <b>Length:   </b> _13v2_
				# <b>tag:      </b> total/retTrib/vRetPrev
				#
				attr_accessor :total_retencao_previdencia
				alias_attribute :retTrib_vRetPrev, :total_retencao_previdencia
				validates :total_retencao_previdencia, numericality: {greater_than_or_equal_to: 0.0}, allow_blank: true
			##########################################################################
			########################  INFORMAÇÕES ADICIONAIS  ########################
				# INFORMAÇÕES ADICIONAIS DE INTERESSE DO FISCO
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _max: 2000_
				# <b>tag:      </b> infAdic/infAdFisco
				#
				attr_accessor :informacoes_fisco
				alias_attribute :infAdFisco, :informacoes_fisco

				# INFORMAÇÕES COMPLEMENTARES DE INTERESSE DO CONTRIBUINTE
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _max: 5000_
				# <b>tag:      </b> infAdic/infCpl
				#
				attr_accessor :informacoes_contribuinte
				alias_attribute :infCpl, :informacoes_contribuinte

				# GRUPO PROCESSO REFERENCIADO
				# (NT 2012/003)
				#
				# <b>Type:    </b> _BrNfe.processo_referencia_product_class (BrNfe::Product::Nfe::ProcessoReferencia)_
				# <b>Default: </b> _[]_
				# <b>Length:  </b> _max: 100_
				# <b>tag:     </b> procRef
				#
				has_many :processos_referenciados, 'BrNfe.processo_referencia_product_class'
				alias_attribute :procRef, :processos_referenciados
			##########################################################################
			######################  INFORMAÇÕES DE EXPORTAÇÃO  #######################
				# SIGLA DA UF DE EMBARQUE OU DE TRANSPOSIÇÃO DE FRONTEIRA
				# Não aceita o valor "EX"
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _2_
				# <b>tag:      </b> exporta/UFSaidaPais
				#
				attr_accessor :exportacao_uf_saida
				alias_attribute :UFSaidaPais, :exportacao_uf_saida
				validates :exportacao_uf_saida, inclusion: {in: BrNfe::Constants::SIGLAS_UF-['EX'] }, allow_blank: true

				# DESCRIÇÃO DO LOCAL DE EMBARQUE OU DE TRANSPOSIÇÃO DE FRONTEIRA
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> exporta/xLocExporta
				#
				attr_accessor :exportacao_local_embarque
				alias_attribute :xLocExporta, :exportacao_local_embarque

				# DESCRIÇÃO DO LOCAL DE DESPACHO
				# Informação do Recinto Alfandegado
				#
				# <b>Type:     </b> _String_
				# <b>Required: </b> _No_
				# <b>Default:  </b> _nil_
				# <b>Length:   </b> _max: 60_
				# <b>tag:      </b> exporta/xLocDespacho
				#
				attr_accessor :exportacao_local_despacho
				alias_attribute :xLocDespacho, :exportacao_local_despacho

			############################################################################
			#########################  DADOS SETADOS NO RETORNO #######################
				# Utilizado para setar o XML da nfe na resposta
				attr_accessor :xml

				# PROTOCOLO / NÚMERO DO RECIBO
				#  Número do Recibo gerado pelo Portal da
				#  Secretaria de Fazenda Estadual
				#
				attr_accessor :protocol
				alias_attribute :nProt, :protocol

				# VALOR DIGEST DO RETORNO
				#  Digest Value da NF-e processada
				#  Utilizado para conferir a integridade da NFe
				#  original.
				#
				attr_accessor :digest_value
				alias_attribute :digVal, :digest_value

				# DATA E HORA DO PROCESSAMENTO DA REQUISIÇÃO
				# 
				attr_accessor :processed_at
				def processed_at
					convert_to_time(@processed_at)
				end
				alias_attribute :dhRecbto, :processed_at

				# STATUS DA OPERAÇÃO
				# Esse é o status final da operação com anota fiscal.
				# A partir do status é possível identificar se obteve sucesso
				# no processamento da nota (para qualquer operação)
				#
				attr_accessor :status_code
				attr_accessor :status_motive
				def status
					if "#{status_code}   ".strip.in?( BrNfe::Constants::NFE_STATUS_SUCCESS )
						:success
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_PROCESSING )
						:processing
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_OFFLINE )
						:offline
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_STATUS_DENIED )
						:denied
					elsif status_code.present?
						:error
					end
				end

				# SITUAÇÃO DA NOTA FISCAL
				# Informa o status atual da nota fiscal.
				# Retorna se a nota fiscal está autorizada, cancelada, denegada, rejeitada, ajustada.
				# Exemplo:
				# - :authorized - Quando a nota fiscal está autorizada para uso
				# - :adjusted - Quando a nota fiscal está autorizada para o uso e foi realizado algum
				#               evento posterior que a mesma foi ajustada
				# - :draft    - Quando a nota fiscal ainda não tem validade fiscal.
				# - :canceled - Quando a nota fiscal foi cancelada.
				# - :denied   - Quando a nota fiscal foi denegada e o XML deve ser guardado.
				# - :rejected - Quando a nota fiscal foi rejeitada e pode ser enviada novamente com as correções.
				# 
				attr_accessor :situation
				def situation
					@situation ||= get_situation_by_status_code
				end
				def get_situation_by_status_code
					if "#{status_code}".strip.in?(    BrNfe::Constants::NFE_SITUATION_AUTORIZED )
						:authorized
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_SITUATION_ADJUSTED )
						:adjusted
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_SITUATION_CANCELED )
						:canceled
					elsif "#{status_code}".strip.in?( BrNfe::Constants::NFE_SITUATION_DENIED )
						:denied
					elsif status_code.blank? || "#{status_code}".strip.in?( BrNfe::Constants::NFE_SITUATION_DRAFT )
						:draft
					else
						:rejected
					end
				end

			def default_values
				{
					versao_aplicativo:   0, 
					natureza_operacao:   'Venda',
					forma_pagamento:     0, # 0=À vista
					modelo_nf:           55, #NF-e
					data_hora_emissao:   Time.current.in_time_zone,
					data_hora_expedicao: Time.current.in_time_zone,
					tipo_operacao:       1, # 1=Saída
					tipo_impressao:      1, # 1=DANFE normal, Retrato;
					finalidade_emissao:  1, # 1=NF-e normal;
					presenca_comprador:  9, # 9=Operação não presencial, outros.
					processo_emissao:    0, # 0=Emissão de NF-e com aplicativo do contribuinte;
					codigo_tipo_emissao: 1, # 1=Normal
					servicos_data_prestacao:   Date.current,
					regime_tributario_servico: 1, # 1=Microempresa Municipal;
				}
			end

			validates :codigo_tipo_emissao, presence: true
			validates :codigo_tipo_emissao, inclusion: [1, 6, 7, 9, '1', '6', '7', '9']
			
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

			validates :autorizados_download_xml, length: { maximum: 10 }

			validate_has_many :itens, message: :invalid_item
			validates         :itens, length:  {minimum: 1, maximum: 990}
			
			validate_has_many :processos_referenciados, message: :invalid_processo

			with_options if: :nfce? do |record|
				record.validate_has_many :pagamentos
				record.validates :pagamentos, length: {maximum: 100}
			end

			validate_has_one  :transporte
			validate_has_one  :fatura
			validate_has_one  :destinatario
			validate_has_one  :emitente
			
			validate_has_one  :endereco_retirada
			with_options if: :endereco_retirada do |record|
				record.validates :endereco_retirada_cpf_cnpj, presence: true
				record.validates :endereco_retirada_cpf_cnpj, length: {maximum: 14}
			end

			validate_has_one  :endereco_entrega
			with_options if: :endereco_entrega do |record|
				record.validates :endereco_entrega_cpf_cnpj, presence: true
				record.validates :endereco_entrega_cpf_cnpj, length: {maximum: 14}
			end

			def nfe?
				modelo_nf.to_i == 55
			end

			def nfce?
				modelo_nf.to_i == 65
			end

			def has_any_service?
				itens.select(&:is_service?).any?
			end

			def has_any_product?
				itens.select(&:is_product?).any?
			end

			# MÉTODO PARA SABER SE EXISTE ALGUM VALOR NO TOTALIZADOR DE RETENÇÃO DE IMPOSTOS.
			# Utilizado para saber se deve ou não colocar a tag de totalizador de retenções 
			# no XML.
			#
			# <b>Tipo: </b> _Boolean_
			#
			def has_taxes_retention?
				total_retencao_pis.to_f  > 0.0 || total_retencao_cofins.to_f > 0.0 ||
				total_retencao_csll.to_f > 0.0 || total_retencao_irrf.to_f > 0.0   ||
				total_retencao_previdencia.to_f > 0.0
			end

		private

			###############################################################################################
			#       | Código | AAMM da | CNPJ do  | Modelo | Série | Número  | Cód. tipo | Código   | DV  |
			#       | da UF  | emissão | Emitente |        |       | da NF-e | emissão   | Numérico |     |
			#       ---------------------------------------------------------------------------------------
			# Tam = |  02    |   04    |    14    |   02   |   03  |   09    |    01     |    08    | 01  |
			#       °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
			def gerar_chave_de_acesso!
				chave_sem_dv =  "#{emitente.endereco.codigo_ibge_uf}"
				chave_sem_dv << "#{data_hora_emissao.try(:strftime, '%y%m')}"
				chave_sem_dv << "#{emitente.cnpj}".rjust(14,'0')
				chave_sem_dv << "#{modelo_nf}"
				chave_sem_dv << "#{serie}".rjust(3, '0')
				chave_sem_dv << "#{numero_nf}".rjust(9, '0')
				chave_sem_dv << "#{codigo_tipo_emissao}"
				chave_sem_dv << "#{codigo_nf}".rjust(8, '0')
				dv = BrNfe::Calculos::Modulo11FatorDe2a9RestoZero.new(chave_sem_dv)
				"#{chave_sem_dv}#{dv}"
			end
		end
	end
end