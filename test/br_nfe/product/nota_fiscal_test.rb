require 'test_helper'

describe BrNfe::Product::NotaFiscal do
	subject { FactoryGirl.build(:product_nota_fiscal, emitente: emitente) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	let(:emitente) { FactoryGirl.build(:product_emitente, endereco: endereco) } 

	let(:pagamento) { FactoryGirl.build(:product_cobranca_pagamento) } 

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
			subject.class.new.data_hora_emissao.must_be_within_delta Time.current
		end
		it '#data_hora_expedicao deve ter o padrão Time.current' do
			subject.class.new.data_hora_expedicao.must_be_within_delta Time.current
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

		describe '#pagamentos' do
			it { must_validate_length_has_many(:pagamentos, 
					BrNfe.pagamento_product_class, 
					maximum: 100,
					condition: :nfce?
			)}
			
			it { must_validates_has_many(:pagamentos, 
				BrNfe.pagamento_product_class, 
				:invalid_pagamento,
				condition: :nfce?
			)}

			it { must_have_many(:pagamentos, BrNfe.pagamento_product_class, {forma_pagamento: '1', total: 350.00})  }
			context 'Não deve aplicar a validação dos pagamentos se for uma NF-e' do
				before { subject.modelo_nf = '55' }
				it 'Não deve validar o máximo de 100 pagamentos' do 
					wont validate_length_of(:pagamentos).is_at_most(100)
				end

				it "Não deve verificar se os pagametos estão válidos" do
					pagamento.stubs(:valid?).returns(true)
					pagamento2 = pagamento.dup
					pagamento2.errors.add(:base, 'Erro do pagamento 2')
					pagamento2.stubs(:valid?).returns(false)
					pagamento3 = pagamento.dup
					pagamento3.errors.add(:base, 'Erro do pagamento 3')
					pagamento3.stubs(:valid?).returns(false)
					subject.pagamentos = [pagamento, pagamento2, pagamento3]

					wont_be_message_error :base, :invalid_pagamento, {index: 2, error_message: 'Erro do pagamento 2'}
					wont_be_message_error :base, :invalid_pagamento, {index: 3, error_message: 'Erro do pagamento 3'}, false
				end
			end
		end
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

	describe "#emitente" do
		class OtherClassEmitente < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveEmitente" do
			subject.class.included_modules.must_include BrNfe::Association::HaveEmitente
		end
		it "o método #emitente_class deve ter por padrão a class BrNfe::Product::Emitente" do
			subject.emitente.must_be_kind_of BrNfe::Product::Emitente
			subject.send(:emitente_class).must_equal BrNfe::Product::Emitente
		end
		it "a class do emitente pode ser modificada através da configuração emitente_product_class" do
			BrNfe.emitente_product_class = OtherClassEmitente
			subject.emitente.must_be_kind_of OtherClassEmitente
			subject.send(:emitente_class).must_equal OtherClassEmitente

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.emitente_product_class = BrNfe::Product::Emitente
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
		it "deve ignorar valores que não são da class de endereço" do
			subject.endereco_retirada = 123
			subject.endereco_retirada.must_be_nil
			subject.endereco_retirada = 'aaaa'
			subject.endereco_retirada.must_be_nil
			subject.endereco_retirada = BrNfe.endereco_class.new
			subject.endereco_retirada.must_be_kind_of BrNfe.endereco_class
		end
		it "deve instanciar um endereço com os atributos se setar um Hash " do
			subject.endereco_retirada = nil
			subject.endereco_retirada = {logradouro: 'LOG', numero: 'NR', bairro: "BRR"}
			subject.endereco_retirada.must_be_kind_of BrNfe.endereco_class

			subject.endereco_retirada.logradouro.must_equal 'LOG'
			subject.endereco_retirada.numero.must_equal 'NR'
			subject.endereco_retirada.bairro.must_equal 'BRR'
		end
		it "deve instanciar um endereço setar os atributos em forma de Block " do
			subject.endereco_retirada = nil
			subject.endereco_retirada do |e| 
				e.logradouro = 'LOGBLK'
				e.numero     = 'NR'
				e.bairro     = 'BRR'
			end
			
			subject.endereco_retirada.must_be_kind_of BrNfe.endereco_class
			subject.endereco_retirada.logradouro.must_equal 'LOGBLK'
			subject.endereco_retirada.numero.must_equal 'NR'
			subject.endereco_retirada.bairro.must_equal 'BRR'
		end
		it "deve ser possível limpar o atributo" do
			subject.endereco_retirada = {logradouro: 'LOG'}
			subject.endereco_retirada.must_be_kind_of BrNfe.endereco_class

			subject.endereco_retirada = nil
			subject.endereco_retirada.must_be_nil
		end
			
		it "deve validar o endereço de retirada se tiver for preenchido" do
			endereco = BrNfe.endereco_class.new
			endereco.errors.add :base, 'Erro 1'
			endereco.errors.add :base, 'Erro 2'
			endereco.expects(:invalid?).returns(true)
			subject.endereco_retirada = endereco
			
			must_be_message_error :base, 'Endereço de retirada: Erro 1'
			must_be_message_error :base, 'Endereço de retirada: Erro 2', {}, false # Para não executar mais o valid?
		end
	end

	describe '#endereco_entrega' do
		it "deve ignorar valores que não são da class de endereço" do
			subject.endereco_entrega = 123
			subject.endereco_entrega.must_be_nil
			subject.endereco_entrega = 'aaaa'
			subject.endereco_entrega.must_be_nil
			subject.endereco_entrega = BrNfe.endereco_class.new
			subject.endereco_entrega.must_be_kind_of BrNfe.endereco_class
		end
		it "deve instanciar um endereço com os atributos se setar um Hash " do
			subject.endereco_entrega = nil
			subject.endereco_entrega = {logradouro: 'LOG', numero: 'NR', bairro: "BRR"}
			subject.endereco_entrega.must_be_kind_of BrNfe.endereco_class

			subject.endereco_entrega.logradouro.must_equal 'LOG'
			subject.endereco_entrega.numero.must_equal 'NR'
			subject.endereco_entrega.bairro.must_equal 'BRR'
		end
		it "deve instanciar um endereço setar os atributos em forma de Block " do
			subject.endereco_entrega = nil
			subject.endereco_entrega do |e| 
				e.logradouro = 'LOGBLK'
				e.numero     = 'NR'
				e.bairro     = 'BRR'
			end
			
			subject.endereco_entrega.must_be_kind_of BrNfe.endereco_class
			subject.endereco_entrega.logradouro.must_equal 'LOGBLK'
			subject.endereco_entrega.numero.must_equal 'NR'
			subject.endereco_entrega.bairro.must_equal 'BRR'
		end
		it "deve ser possível limpar o atributo" do
			subject.endereco_entrega = {logradouro: 'LOG'}
			subject.endereco_entrega.must_be_kind_of BrNfe.endereco_class

			subject.endereco_entrega = nil
			subject.endereco_entrega.must_be_nil
		end
			
		it "deve validar o endereço de entrega se tiver for preenchido" do
			endereco = BrNfe.endereco_class.new
			endereco.errors.add :base, 'Erro 1'
			endereco.errors.add :base, 'Erro 2'
			endereco.expects(:invalid?).returns(true)
			subject.endereco_entrega = endereco
			
			must_be_message_error :base, 'Endereço de entrega: Erro 1'
			must_be_message_error :base, 'Endereço de entrega: Erro 2', {}, false # Para não executar mais o valid?
		end
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

	describe '#transporte' do
		let(:msg_erro_1) { 'Erro 1' } 
		let(:msg_erro_2) { 'Erro 2' } 
		it "deve ignorar valores que não são da class de transporte" do
			subject.transporte = nil
			subject.transporte = 123
			subject.transporte.must_be_nil
			subject.transporte = 'aaaa'
			subject.transporte.must_be_nil
			subject.transporte = BrNfe.transporte_product_class.new
			subject.transporte.must_be_kind_of BrNfe.transporte_product_class
		end
		it "deve instanciar um transporte com os atributos se setar um Hash " do
			subject.transporte = nil
			subject.transporte = {retencao_cfop: 'LOG', retencao_valor_sevico: 50.55}
			subject.transporte.must_be_kind_of BrNfe.transporte_product_class

			subject.transporte.retencao_cfop.must_equal 'LOG'
			subject.transporte.retencao_valor_sevico.must_equal  50.55
		end
		it "deve instanciar um transporte setar os atributos em forma de Block " do
			subject.transporte = nil
			subject.transporte do |e| 
				e.retencao_cfop = 'PLACA'
				e.retencao_valor_sevico  = 47.74
			end

			subject.transporte.must_be_kind_of BrNfe.transporte_product_class
			subject.transporte.retencao_cfop.must_equal 'PLACA'
			subject.transporte.retencao_valor_sevico.must_equal  47.74
		end
		it "deve ser possível limpar o atributo" do
			subject.transporte = {retencao_valor_sevico: 132}
			subject.transporte.must_be_kind_of BrNfe.transporte_product_class

			subject.transporte = nil
			subject.transporte.must_be_nil
		end
			
		it "deve validar o transporte se for preenchido" do
			transporte = BrNfe.transporte_product_class.new
			transporte.errors.add :base, msg_erro_1
			transporte.errors.add :base, msg_erro_2
			transporte.expects(:invalid?).returns(true)
			subject.transporte = transporte
			
			must_be_message_error(:base, :invalid_transporte, {error_message: msg_erro_1})
			must_be_message_error(:base, :invalid_transporte, {error_message: msg_erro_2}, false) # Para não executar mais o valid?
		end
	end

	describe '#fatura' do
		let(:msg_erro_1) { 'Erro 1' } 
		let(:msg_erro_2) { 'Erro 2' } 
		it "deve ignorar valores que não são da class de fatura" do
			subject.fatura = nil
			subject.fatura = 123
			subject.fatura.must_be_nil
			subject.fatura = 'aaaa'
			subject.fatura.must_be_nil
			subject.fatura = BrNfe.fatura_product_class.new
			subject.fatura.must_be_kind_of BrNfe.fatura_product_class
		end
		it "deve instanciar uma fatura com os atributos se setar um Hash " do
			subject.fatura = nil
			subject.fatura = {numero_fatura: 'LOG', valor_original: 50.55}
			subject.fatura.must_be_kind_of BrNfe.fatura_product_class

			subject.fatura.numero_fatura.must_equal 'LOG'
			subject.fatura.valor_original.must_equal  50.55
		end
		it "deve instanciar uma fatura setar os atributos em forma de Block " do
			subject.fatura = nil
			subject.fatura do |e| 
				e.numero_fatura = 'FAT453536'
				e.valor_original  = 47.74
			end

			subject.fatura.must_be_kind_of BrNfe.fatura_product_class
			subject.fatura.numero_fatura.must_equal 'FAT453536'
			subject.fatura.valor_original.must_equal  47.74
		end
		it "deve ser possível limpar o atributo" do
			subject.fatura = {valor_original: 132}
			subject.fatura.must_be_kind_of BrNfe.fatura_product_class

			subject.fatura = nil
			subject.fatura.must_be_nil
		end
			
		it "deve validar o fatura se for preenchida" do
			fatura = BrNfe.fatura_product_class.new
			fatura.errors.add :base, msg_erro_1
			fatura.errors.add :base, msg_erro_2
			fatura.expects(:invalid?).returns(true)
			subject.fatura = fatura
			
			must_be_message_error(:base, :invalid_fatura, {error_message: msg_erro_1})
			must_be_message_error(:base, :invalid_fatura, {error_message: msg_erro_2}, false) # Para não executar mais o valid?
		end
	end

	describe '#pagamentos' do
		it "deve inicializar o objeto com um Array" do
			subject.class.new.pagamentos.must_be_kind_of Array
		end
		it "deve aceitar apenas objetos da class Hash ou Veiculo" do
			nf_hash = {forma_pagamento: '1', total: 1146}
			subject.pagamentos = [pagamento, 1, 'string', nil, {}, [], :symbol, nf_hash, true]
			subject.pagamentos.size.must_equal 2
			subject.pagamentos[0].must_equal pagamento

			subject.pagamentos[1].forma_pagamento.must_equal '1'
			subject.pagamentos[1].total.must_equal 1146
		end
		it "posso adicionar notas fiscais  com <<" do
			new_object = subject.class.new
			new_object.pagamentos << pagamento
			new_object.pagamentos << 1
			new_object.pagamentos << nil
			new_object.pagamentos << {forma_pagamento: '2', total: 223}
			new_object.pagamentos << {forma_pagamento: '3', total: 800}

			new_object.pagamentos.size.must_equal 3
			new_object.pagamentos[0].must_equal pagamento

			new_object.pagamentos[1].forma_pagamento.must_equal '2'
			new_object.pagamentos[1].total.must_equal 223
			new_object.pagamentos[2].forma_pagamento.must_equal '3'
			new_object.pagamentos[2].total.must_equal 800
		end
	end
end