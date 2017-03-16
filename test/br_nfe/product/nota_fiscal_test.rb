require 'test_helper'

describe BrNfe::Product::NotaFiscal do
	subject { FactoryGirl.build(:product_nota_fiscal, emitente: emitente) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	let(:emitente) { FactoryGirl.build(:product_emitente, endereco: endereco) } 

	let(:pagamento) { FactoryGirl.build(:product_cobranca_pagamento) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :tpEmis,   :codigo_tipo_emissao }
		it { must_have_alias_attribute :cNF,      :codigo_nf }
		it { must_have_alias_attribute :nNF,      :numero_nf }
		it { must_have_alias_attribute :natOp,    :natureza_operacao }
		it { must_have_alias_attribute :indPag,   :forma_pagamento }
		it { must_have_alias_attribute :mod,      :modelo_nf }
		it { must_have_alias_attribute :dhEmi,    :data_hora_emissao,   Time.current.in_time_zone }
		it { must_have_alias_attribute :dhSaiEnt, :data_hora_expedicao, Time.current.in_time_zone }
		it { must_have_alias_attribute :tpNF,     :tipo_operacao }
		it { must_have_alias_attribute :tpEmis,   :tipo_impressao }
		it { must_have_alias_attribute :finNFe,   :finalidade_emissao }
		it { must_have_alias_attribute :indFinal, :consumidor_final, true }
		it { must_have_alias_attribute :indPres,  :presenca_comprador }
		it { must_have_alias_attribute :procEmi,  :processo_emissao }
		it { must_have_alias_attribute :verProc,  :versao_aplicativo, '0' }
		it { must_have_alias_attribute :retirada, :endereco_retirada, BrNfe.endereco_class.new }
		it { must_have_alias_attribute :entrega,  :endereco_entrega,  BrNfe.endereco_class.new }
		it { must_have_alias_attribute :autXML,   :autorizados_download_xml, ['12345678901'] }
		it { must_have_alias_attribute :transp,   :transporte,BrNfe.transporte_product_class.new }
		it { must_have_alias_attribute :cobranca, :fatura, BrNfe.fatura_product_class.new }
		it { must_have_alias_attribute :cobr,     :fatura, BrNfe.fatura_product_class.new }
		it { must_have_alias_attribute :pag,      :pagamentos, [BrNfe.pagamento_product_class.new] }
		
		it { must_have_alias_attribute :ICMSTot_vBC,          :total_icms_base_calculo }
		it { must_have_alias_attribute :ICMSTot_vICMS,        :total_icms }
		it { must_have_alias_attribute :ICMSTot_vICMSDeson,   :total_icms_desonerado }
		it { must_have_alias_attribute :ICMSTot_vFCPUFDest,   :total_icms_fcp_uf_destino }
		it { must_have_alias_attribute :ICMSTot_vICMSUFDest,  :total_icms_uf_destino }
		it { must_have_alias_attribute :ICMSTot_vICMSUFRemet, :total_icms_uf_origem }
		it { must_have_alias_attribute :ICMSTot_vBCST,        :total_icms_base_calculo_st }
		it { must_have_alias_attribute :ICMSTot_vST,          :total_icms_st }
		it { must_have_alias_attribute :ICMSTot_vProd,        :total_produtos }
		it { must_have_alias_attribute :ICMSTot_vFrete,       :total_frete }
		it { must_have_alias_attribute :ICMSTot_vSeg,         :total_seguro }
		it { must_have_alias_attribute :ICMSTot_vDesc,        :total_desconto }
		it { must_have_alias_attribute :ICMSTot_vII,          :total_imposto_importacao }
		it { must_have_alias_attribute :ICMSTot_vIPI,         :total_ipi }
		it { must_have_alias_attribute :ICMSTot_vPIS,         :total_pis }
		it { must_have_alias_attribute :ICMSTot_vCOFINS,      :total_cofins }
		it { must_have_alias_attribute :ICMSTot_vOutro,       :total_outras_despesas }
		it { must_have_alias_attribute :ICMSTot_vNF,          :total_nf }
		it { must_have_alias_attribute :ICMSTot_vTotTrib,     :total_tributos }
		it { must_have_alias_attribute :ISSQNtot_vServ,       :total_servicos }
		it { must_have_alias_attribute :ISSQNtot_vBC,         :total_servicos_base_calculo }
		it { must_have_alias_attribute :ISSQNtot_vISS,        :total_servicos_iss }
		it { must_have_alias_attribute :ISSQNtot_vPIS,        :total_servicos_pis }
		it { must_have_alias_attribute :ISSQNtot_vCOFINS,     :total_servicos_cofins }
		it { must_have_alias_attribute :ISSQNtot_dCompet,     :servicos_data_prestacao, Date.yesterday }
		it { must_have_alias_attribute :ISSQNtot_vDeducao,    :total_servicos_deducao }
		it { must_have_alias_attribute :ISSQNtot_vOutro,      :total_servicos_outras_retencoes }
		it { must_have_alias_attribute :ISSQNtot_vDescIncond, :total_servicos_desconto_incondicionado }
		it { must_have_alias_attribute :ISSQNtot_vDescCond,   :total_servicos_desconto_condicionado }
		it { must_have_alias_attribute :ISSQNtot_vISSRet,     :total_servicos_iss_retido }
		it { must_have_alias_attribute :ISSQNtot_cRegTrib,    :regime_tributario_servico, 3 }
		it { must_have_alias_attribute :retTrib_vRetPIS,      :total_retencao_pis }
		it { must_have_alias_attribute :retTrib_vRetCOFINS,   :total_retencao_cofins }
		it { must_have_alias_attribute :retTrib_vRetCSLL,     :total_retencao_csll }
		it { must_have_alias_attribute :retTrib_vBCIRRF,      :total_retencao_base_calculo_irrf }
		it { must_have_alias_attribute :retTrib_vIRRF,        :total_retencao_irrf }
		it { must_have_alias_attribute :retTrib_vBCRetPrev,   :total_retencao_base_calculo_previdencia }
		it { must_have_alias_attribute :retTrib_vRetPrev,     :total_retencao_previdencia }
		it { must_have_alias_attribute :infAdFisco,           :informacoes_fisco }
		it { must_have_alias_attribute :infCpl,               :informacoes_contribuinte }
		it { must_have_alias_attribute :procRef,              :processos_referenciados, [BrNfe.processo_referencia_product_class.new] }
	end
	describe "#default_values" do
		it '#versao_aplicativo deve ter o padrão 0' do
			subject.class.new.versao_aplicativo.must_equal 0
		end
		it '#natureza_operacao deve ter o padrão Venda' do
			subject.class.new.natureza_operacao.must_equal 'Venda'
		end
		it '#forma_pagamento deve ter o padrão 0' do
			subject.class.new.forma_pagamento.must_equal 0
		end
		it '#modelo_nf deve ter o padrão 55' do
			subject.class.new.modelo_nf.must_equal 55
		end
		it '#data_hora_emissao deve ter o padrão Time.current' do
			subject.class.new.data_hora_emissao.to_s.must_equal Time.current.in_time_zone.to_s
		end
		it '#data_hora_expedicao deve ter o padrão Time.current' do
			subject.class.new.data_hora_expedicao.to_s.must_equal Time.current.in_time_zone.to_s
		end
		it '#tipo_operacao deve ter o padrão 1' do
			subject.class.new.tipo_operacao.must_be_within_delta 1
		end
		it '#tipo_impressao deve ter o padrão 1' do
			subject.class.new.tipo_impressao.must_be_within_delta 1
		end
		it '#finalidade_emissao deve ter o padrão 1' do
			subject.class.new.finalidade_emissao.must_be_within_delta 1
		end
		it '#presenca_comprador deve ter o padrão 9' do
			subject.class.new.presenca_comprador.must_be_within_delta 9
		end
		it '#processo_emissao deve ter o padrão 0' do
			subject.class.new.processo_emissao.must_be_within_delta 0
		end
		it '#codigo_tipo_emissao deve ter o padrão 1' do
			subject.class.new.codigo_tipo_emissao.must_be_within_delta 1
		end
	end

	describe "Validations" do
		before do 
			MiniTest::Spec.string_for_validation_length = '1'
		end
		after do 
			MiniTest::Spec.string_for_validation_length = 'x'
		end

		context '#codigo_nf' do
			it { must validate_presence_of(:codigo_nf) }
			it { must validate_numericality_of(:codigo_nf).only_integer }
			it { must validate_length_of(:codigo_nf).is_at_most(8) }
		end
		context '#serie' do
			it { must validate_presence_of(:serie) }
			it { must validate_numericality_of(:serie).only_integer }
			it { must validate_length_of(:serie).is_at_most(3) }
			it { must validate_exclusion_of(:serie).in_array([890, 899, 990, 999, '890', '899', '990', '999']) }
		end
		context '#numero_nf' do
			it { must validate_presence_of(:numero_nf) }
			it { must validate_numericality_of(:numero_nf).only_integer }
			it { must validate_length_of(:numero_nf).is_at_most(9) }
		end
		context '#natureza_operacao' do
			it { must validate_presence_of(:natureza_operacao) }
		end
		context '#forma_pagamento' do
			it { must validate_presence_of(:forma_pagamento) }
			it { must validate_inclusion_of(:forma_pagamento).in_array([0, 1, 2, '0', '1', '2']) }
		end
		context '#modelo_nf' do
			it { must validate_presence_of(:modelo_nf) }
			it { must validate_inclusion_of(:modelo_nf).in_array([55, 65, '55', '65']) }
		end
		context '#data_hora_emissao' do
			it { must validate_presence_of(:data_hora_emissao) }
		end
		context '#data_hora_expedicao' do
			it "deve ser obrigatório se for uma NF-e" do
				subject.modelo_nf = 55
				must validate_presence_of(:data_hora_expedicao)				
			end
			it "não deve ser obrigatório se for uma NFC-e" do
				subject.modelo_nf = 65
				wont validate_presence_of(:data_hora_expedicao)				
			end
		end
		context '#tipo_operacao' do
			it { must validate_presence_of(:tipo_operacao) }
			it { must validate_inclusion_of(:tipo_operacao).in_array([0, 1, '0', '1']) }
		end
		context '#tipo_impressao' do
			it { must validate_presence_of(:tipo_impressao) }
			it { must validate_inclusion_of(:tipo_impressao).in_array([0, 1, 2, 3, 4, 5, '0', '1', '2', '3', '4', '5']) }
		end
		context '#presenca_comprador' do
			it { must validate_presence_of(:presenca_comprador) }
			it { must validate_inclusion_of(:presenca_comprador).in_array([0, 1, 2, 3, 4, 9, '0', '1', '2', '3', '4', '9']) }
		end
		context '#processo_emissao' do
			it { must validate_presence_of(:processo_emissao) }
			it { must validate_inclusion_of(:processo_emissao).in_array([0, 1, 2, 3, '0', '1', '2', '3']) }
		end
		context '#codigo_tipo_emissao' do
			it { must validate_presence_of(:codigo_tipo_emissao) }
			it { must validate_inclusion_of(:codigo_tipo_emissao).in_array([1, 6, 7, 9, '1', '6', '7', '9']) }
		end
		describe '#endereco_entrega_cpf_cnpj validations' do
			context "quando o endereco_entrega for preenchido" do
				before { subject.endereco_entrega = BrNfe.endereco_class.new }
				it { must validate_presence_of(:endereco_entrega_cpf_cnpj) }
				it { must validate_length_of(:endereco_entrega_cpf_cnpj).is_at_most(14) }
			end
			context "quando o endereco_entrega não for preenchido" do
				before { subject.endereco_entrega = nil }
				it { wont validate_presence_of(:endereco_entrega_cpf_cnpj) }				
				it { wont validate_length_of(:endereco_entrega_cpf_cnpj).is_at_most(14) }
			end
		end
		describe '#endereco_retirada_cpf_cnpj validations' do
			context "quando o endereco_retirada for preenchido" do
				before { subject.endereco_retirada = BrNfe.endereco_class.new }
				it { must validate_presence_of(:endereco_retirada_cpf_cnpj) }
				it { must validate_length_of(:endereco_retirada_cpf_cnpj).is_at_most(14) }
			end
			context "quando o endereco_retirada não for preenchido" do
				before { subject.endereco_retirada = nil }
				it { wont validate_presence_of(:endereco_retirada_cpf_cnpj) }				
				it { wont validate_length_of(:endereco_retirada_cpf_cnpj).is_at_most(14) }
			end
		end
		describe '#autorizados_download_xml' do
			it 'deve no maximo 10' do
				MiniTest::Spec.string_for_validation_length = ['1']
				must validate_length_of(:autorizados_download_xml).is_at_most(10)
				MiniTest::Spec.string_for_validation_length = 'x'
			end
		end

		it { must validate_numericality_of(:total_icms_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_desonerado).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_fcp_uf_destino).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_uf_destino).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_uf_origem).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_base_calculo_st).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_icms_st).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_produtos).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_frete).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_seguro).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_desconto).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_imposto_importacao).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_ipi).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_pis).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_cofins).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_outras_despesas).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_nf).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_tributos).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_iss).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_pis).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_cofins).is_greater_than_or_equal_to(0.0).allow_nil }
		describe '#servicos_data_prestacao' do
			it "deve ser obrigatório se houver algum serviço" do
				subject.stubs(:has_any_service?).returns(true)
				must validate_presence_of(:servicos_data_prestacao)
			end
			it "não deve ser obrigatório se não houver serviços" do
				subject.stubs(:has_any_service?).returns(false)
				wont validate_presence_of(:servicos_data_prestacao)
			end
		end
		it { must validate_numericality_of(:total_servicos_deducao).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_outras_retencoes).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_desconto_incondicionado).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_desconto_condicionado).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_servicos_iss_retido).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_inclusion_of(:regime_tributario_servico).in_array([1,2,3,4,5,6]) }

		it { must validate_numericality_of(:total_retencao_pis).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_cofins).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_csll).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_base_calculo_irrf).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_irrf).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_base_calculo_previdencia).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_retencao_previdencia).is_greater_than_or_equal_to(0.0).allow_nil }

		it { must validate_inclusion_of(:exportacao_uf_saida).in_array(BrNfe::Constants::SIGLAS_UF-['EX']) }
	end

	describe '#nfe?' do
		it "deve ser true se modelo_nf for 55" do
			subject.modelo_nf = 55
			subject.nfe?.must_equal true
			subject.modelo_nf = '55'
			subject.nfe?.must_equal true
		end
		it 'deve ser false se modelo_nf for diferente de 55' do
			subject.modelo_nf = 65
			subject.nfe?.must_equal false
			subject.modelo_nf = '65'
			subject.nfe?.must_equal false
		end
	end

	describe '#nfce?' do
		it "deve ser true se modelo_nf for 65" do
			subject.modelo_nf = 65
			subject.nfce?.must_equal true
			subject.modelo_nf = '65'
			subject.nfce?.must_equal true
		end
		it 'deve ser false se modelo_nf for diferente de 65' do
			subject.modelo_nf = 55
			subject.nfce?.must_equal false
			subject.modelo_nf = '55'
			subject.nfce?.must_equal false
		end
	end

	describe 'chave_de_acesso' do
		it "se já tem chave de acesso setada na variavel @chave_de_acesso não deve calcular a chave novamente" do
			subject.chave_de_acesso = '123'
			subject.chave_de_acesso.must_equal '123'
			subject.instance_variable_get(:@chave_de_acesso).must_equal '123'
		end
		it "deve calcular a chave de acesso com o DV se não tiver chave setada" do
			emitente.endereco.codigo_ibge_uf = '42'
			subject.data_hora_emissao = Time.parse('2016-06-09')
			emitente.cnpj = '01.498.013/0001-98'
			subject.modelo_nf = 65
			subject.serie = 1
			subject.numero_nf = 664
			subject.codigo_tipo_emissao = 7
			subject.codigo_nf = 100

			key = subject.chave_de_acesso
			key.size.must_equal 44

			key[0..1].must_equal '42' # UF
			key[2..5].must_equal  '1606' # Ano e mês da emissão
			key[6..19].must_equal '01498013000198' # CNPJ
			key[20..21].must_equal '65' # Modelo NF
			key[22..24].must_equal '001' # Série
			key[25..33].must_equal '000000664' # numero nf
			key[34].must_equal '7' # Tipo emissão
			key[35..42].must_equal '00000100' # codigo nf
			key[43].must_equal '7' # DV

			subject.instance_variable_get(:@chave_de_acesso).must_equal key
		end
		it "deve calcular a chave de acesso conforme exemplo da documentação" do
			emitente.endereco.codigo_ibge_uf = '52'
			subject.data_hora_emissao = Time.parse('2006-04-12')
			emitente.cnpj = '33009911002506'
			subject.modelo_nf = 55
			subject.serie = 12
			subject.numero_nf = '0780'
			subject.codigo_tipo_emissao = 0
			subject.codigo_nf = 26730161

			key = subject.chave_de_acesso
			key.size.must_equal 44

			key[0..1].must_equal   '52' # UF
			key[2..5].must_equal   '0604' # Ano e mês da emissão
			key[6..19].must_equal  '33009911002506' # CNPJ
			key[20..21].must_equal '55' # Modelo NF
			key[22..24].must_equal '012' # Série
			key[25..33].must_equal '000000780' # numero nf
			key[34].must_equal     '0' # Tipo emissão
			key[35..42].must_equal '26730161' # codigo nf
			key[43].must_equal     '5' # DV
		end

		it "deve calcular a chave de acesso conforme exemplo de uma NF-e válida" do
			emitente.endereco.codigo_ibge_uf = '35'
			subject.data_hora_emissao = Time.parse('2015-03-04')
			emitente.cnpj = '00776574000741'
			subject.modelo_nf = 55
			subject.serie = 3
			subject.numero_nf = 5616108
			subject.codigo_tipo_emissao = 4
			subject.codigo_nf = 65900349

			key = subject.chave_de_acesso
			key.size.must_equal 44

			key[0..1].must_equal   '35' # UF
			key[2..5].must_equal   '1503' # Ano e mês da emissão
			key[6..19].must_equal  '00776574000741' # CNPJ
			key[20..21].must_equal '55' # Modelo NF
			key[22..24].must_equal '003' # Série
			key[25..33].must_equal '005616108' # numero nf
			key[34].must_equal     '4' # Tipo emissão
			key[35..42].must_equal '65900349' # codigo nf
			key[43].must_equal     '0' # DV
		end
	end

	describe '#chave_de_acesso_dv' do
		it "deve pegar sempre o último dígido da chave_de_acesso" do
			subject.chave_de_acesso = '35150300776574000741550030056161084659003490'
			subject.chave_de_acesso_dv.must_equal '0'

			subject.chave_de_acesso = '52060433009911002506550120000007800267301615'
			subject.chave_de_acesso_dv.must_equal '5'

			subject.chave_de_acesso = '5206043300991100250655012000000780026730161X'
			subject.chave_de_acesso_dv.must_equal 'X'
		end
	end
	describe '#chave_de_acesso_sem_dv' do
		it "deve pegar sempre o último dígido da chave_de_acesso" do
			subject.chave_de_acesso = '35150300776574000741550030056161084659003490'
			subject.chave_de_acesso_sem_dv.must_equal '3515030077657400074155003005616108465900349'

			subject.chave_de_acesso = '24729423849324793274947940000007800267301615'
			subject.chave_de_acesso_sem_dv.must_equal '2472942384932479327494794000000780026730161'

			subject.chave_de_acesso = '5206043300991100250655012000000780026730161X'
			subject.chave_de_acesso_sem_dv.must_equal '5206043300991100250655012000000780026730161'
		end
	end

	describe '#endereco_retirada' do
		it { must_have_one(:endereco_retirada, 
				BrNfe.endereco_class,  
				{logradouro: 'LOG', numero: 'NR', bairro: "BRR"}
		)}
		it { must_validate_have_one(:endereco_retirada, BrNfe.endereco_class, :invalid_endereco_retirada) }
	end

	describe '#endereco_entrega' do
		it '316' do 
			must_have_one(:endereco_entrega, 
				BrNfe.endereco_class,  
				{logradouro: 'LOG', numero: 'NR', bairro: "BRR"}
			)
		end
		it { must_validate_have_one(:endereco_entrega, BrNfe.endereco_class, :invalid_endereco_entrega) }
	end

	describe '#autorizados_download_xml' do
		it "deve  inicializar com um array vazio" do
			subject.class.new.autorizados_download_xml.must_be_kind_of Array
			subject.class.new.autorizados_download_xml.must_be_empty
		end
		it "mesmo que setar um valor qualquer deve sempre retornar um array" do
			subject.autorizados_download_xml = 123
			subject.autorizados_download_xml.must_equal([123])
			subject.autorizados_download_xml = 'xxx'
			subject.autorizados_download_xml.must_equal(['xxx'])
			subject.autorizados_download_xml = ['xxx',123]
			subject.autorizados_download_xml.must_equal(['xxx',123])
		end
		it "deve desconsiderar os valores nil" do
			subject.autorizados_download_xml = [nil,123,nil,'xxx',nil]
			subject.autorizados_download_xml.must_equal([123,'xxx'])
			subject.autorizados_download_xml = nil
			subject.autorizados_download_xml.must_equal([])
			subject.autorizados_download_xml = [nil]
			subject.autorizados_download_xml.must_equal([])
		end
	end

	describe '#emitente' do
		it 'have one' do 
			must_have_one(:emitente,
				BrNfe.emitente_product_class,
				{nome_fantasia: 'FANTASIA', razao_social: 'RAZAO'},
				null: false
			)
		end
		it { must_validate_have_one(:emitente, BrNfe.emitente_product_class, :invalid_emitente) }
	end

	describe '#destinatario' do
		it 'have one' do 
			must_have_one(:destinatario,
				BrNfe.destinatario_product_class,
				{nome_fantasia: 'FANTASIA', razao_social: 'RAZAO'},
				null: false
			)
		end
		it { must_validate_have_one(:destinatario, BrNfe.destinatario_product_class, :invalid_destinatario) }
	end

	describe '#transporte' do
		it { must_have_one(:transporte, 
				BrNfe.transporte_product_class,  
				{retencao_cfop: 'LOG', retencao_valor_sevico: 50.55}
		)}
		it { must_validate_have_one(:transporte, BrNfe.transporte_product_class, :invalid_transporte) }
	end

	describe '#fatura' do
		it { must_have_one(:fatura, 
				BrNfe.fatura_product_class,  
				{numero_fatura: 'LOG', valor_original: 50.55}
		)}
		it { must_validate_have_one(:fatura, BrNfe.fatura_product_class, :invalid_fatura) }
	end

	describe '#pagamentos' do
		it { must_have_many(:pagamentos, BrNfe.pagamento_product_class, {forma_pagamento: '1', total: 350.00})  }
		it { must_validate_length_has_many(:pagamentos, 
				BrNfe.pagamento_product_class, 
				condition: :nfce?
		)}
		
		it { must_validates_has_many(:pagamentos, 
			BrNfe.pagamento_product_class, 
			:invalid_pagamento,
			condition: :nfce?
		)}
	end

	describe '#itens' do
		it { must_have_many(:itens, BrNfe.item_product_class, {codigo_produto: 'P123', codigo_ean: '123456'})  }
		it { must_validate_length_has_many(:itens, 
				BrNfe.item_product_class, 
				minimum: 1
		)}
		it { must_validates_has_many(:itens, BrNfe.item_product_class, :invalid_item) }
	end

	describe '#has_any_service?' do
		it "se tiver algum serviço entre os itens deve retornar true" do
			subject.itens = [{tipo_produto: :product},{tipo_produto: :service},{tipo_produto: :product}]
			subject.has_any_service?.must_equal true
		end
		it "se não tiver serviço entre os itens deve retornar false" do
			subject.itens = [{tipo_produto: :product},{tipo_produto: :product}]
			subject.has_any_service?.must_equal false
		end
	end
	describe '#has_any_product?' do
		it "se tiver algum serviço entre os itens deve retornar true" do
			subject.itens = [{tipo_produto: :service},{tipo_produto: :product},{tipo_produto: :product}]
			subject.has_any_product?.must_equal true
		end
		it "se não tiver serviço entre os itens deve retornar false" do
			subject.itens = [{tipo_produto: :service},{tipo_produto: :service}]
			subject.has_any_product?.must_equal false
		end
	end

	describe '#has_taxes_retention?' do
		before do
			subject.assign_attributes(
				total_retencao_pis:  nil, total_retencao_cofins: nil,
				total_retencao_csll: nil, total_retencao_irrf: nil,
				total_retencao_previdencia: nil
			)
		end
		it "deve retornar false se todos os valores de retenção estiverem nil" do
			subject.has_taxes_retention?.must_equal false
		end
		it "deve retornar false se todos os valores de retenção estiverem zerados" do
			subject.assign_attributes(
				total_retencao_pis:  0.0, total_retencao_cofins: 0.0,
				total_retencao_csll: 0.0, total_retencao_irrf:   0.0,
				total_retencao_previdencia: 0.0
			)
			subject.has_taxes_retention?.must_equal false
		end

		it "deve retornar true se total_retencao_pis for maior que zero" do
			subject.total_retencao_pis = 1.0
			subject.has_taxes_retention?.must_equal true
		end
		it "deve retornar true se total_retencao_cofins for maior que zero" do
			subject.total_retencao_cofins = 1.0
			subject.has_taxes_retention?.must_equal true
		end
		it "deve retornar true se total_retencao_csll for maior que zero" do
			subject.total_retencao_csll = 1.0
			subject.has_taxes_retention?.must_equal true
		end
		it "deve retornar true se total_retencao_irrf for maior que zero" do
			subject.total_retencao_irrf = 1.0
			subject.has_taxes_retention?.must_equal true
		end
		it "deve retornar true se total_retencao_previdencia for maior que zero" do
			subject.total_retencao_previdencia = 1.0
			subject.has_taxes_retention?.must_equal true
		end
	end

	describe '#processos_referenciados' do
		it { must_have_many(:processos_referenciados, BrNfe.processo_referencia_product_class, {numero_processo: 'P123', indicador: 1})  }
		it { must_validates_has_many(:processos_referenciados, BrNfe.processo_referencia_product_class, :invalid_processo) }
	end

	describe '#status' do
		it 'Deve retornar :success se o status_code estiver entre os valores da constante NFE_STATUS_SUCCESS' do
			BrNfe::Constants::NFE_STATUS_SUCCESS.each do |code|
				subject.status_code = code
				subject.status.must_equal :success
			end
		end
		it 'Deve retornar :processing se o status_code estiver entre os valores da constante NFE_STATUS_PROCESSING' do
			BrNfe::Constants::NFE_STATUS_PROCESSING.each do |code|
				subject.status_code = code
				subject.status.must_equal :processing
			end
		end
		it 'Deve retornar :offline se o status_code estiver entre os valores da constante NFE_STATUS_OFFLINE' do
			BrNfe::Constants::NFE_STATUS_OFFLINE.each do |code|
				subject.status_code = code
				subject.status.must_equal :offline
			end
		end
		it 'Deve retornar :denied se o status_code estiver entre os valores da constante NFE_STATUS_DENIED' do
			BrNfe::Constants::NFE_STATUS_DENIED.each do |code|
				subject.status_code = code
				subject.status.must_equal :denied
			end
		end
		it "deve retornar o status :error para qualquer outro código que não esteja entre os códigos testados anteriormente" do
			subject.status_code = '000'
			subject.status.must_equal :error
			subject.status_code = '1000'
			subject.status.must_equal :error
		end
		it "se status_code não tiver valor deve retornar nil" do
			subject.status_code = ''
			subject.status.must_be_nil
			subject.status_code = nil
			subject.status.must_be_nil
		end
	end

	describe '#situation' do
		it "Se setar a situação manualmente, deve manter o valor" do
			subject.situation = :manual
			subject.situation.must_equal :manual
		end
		it "se não tiver uma situação setada manualmente deve buscar através do código do status" do
			subject.expects(:get_situation_by_status_code).returns(:by_status)
			subject.situation = nil
			subject.situation.must_equal :by_status
		end
	end
	describe '#get_situation_by_status_code' do
		it "se o código do status estiver na constante NFE_SITUATION_AUTORIZED, deve retornar :authorized" do
			BrNfe::Constants::NFE_SITUATION_AUTORIZED.each do |code|
				subject.status_code = code
				subject.get_situation_by_status_code.must_equal :authorized
			end
		end
		it "se o código do status estiver na constante NFE_SITUATION_ADJUSTED, deve retornar :adjusted" do
			BrNfe::Constants::NFE_SITUATION_ADJUSTED.each do |code|
				subject.status_code = code
				subject.get_situation_by_status_code.must_equal :adjusted
			end
		end
		it "se o código do status estiver na constante NFE_SITUATION_CANCELED, deve retornar :canceled" do
			BrNfe::Constants::NFE_SITUATION_CANCELED.each do |code|
				subject.status_code = code
				subject.get_situation_by_status_code.must_equal :canceled
			end
		end
		it "se o código do status estiver na constante NFE_SITUATION_DENIED, deve retornar :denied" do
			BrNfe::Constants::NFE_SITUATION_DENIED.each do |code|
				subject.status_code = code
				subject.get_situation_by_status_code.must_equal :denied
			end
		end
		it "se o código do status estiver na constante NFE_SITUATION_DRAFT, deve retornar :draft" do
			BrNfe::Constants::NFE_SITUATION_DRAFT.each do |code|
				subject.status_code = code
				subject.get_situation_by_status_code.must_equal :draft
			end
		end
		it "Se o código do status estiver em branco deve retornar :draft" do
			subject.status_code = ''
			subject.get_situation_by_status_code.must_equal :draft
		end
		it "Se retornar qualquer outro código não mencionando deve retornar :rejected" do
			subject.status_code = '354'
			subject.get_situation_by_status_code.must_equal :rejected
		end
	end
end