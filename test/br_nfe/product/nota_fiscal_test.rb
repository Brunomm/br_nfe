require 'test_helper'

describe BrNfe::Product::NotaFiscal do
	subject { FactoryGirl.build(:product_nota_fiscal) }
	let(:endereco) { FactoryGirl.build(:endereco) } 

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
	end

	describe "Validations" do
		class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
			# Sobrescrevo o metodo para que quando vai executar os testes
			# de tamanho, sempre vai setar um valor numérico
			def string_of_length(length)
				'1' * length
			end
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
end