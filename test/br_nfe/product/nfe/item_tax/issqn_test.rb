require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Issqn do
	subject { FactoryGirl.build(:product_item_tax_issqn) }

	describe "Default values" do
		it { must_have_default_value_for :indicador_iss,    1 }
		it { must_have_default_value_for :incentivo_fiscal, false }
	end
	describe 'Alias attributes' do
		it { must_have_alias_attribute :vBC,          :total_base_calculo }
		it { must_have_alias_attribute :vAliq,        :aliquota }
		it { must_have_alias_attribute :vISSQN,       :total }
		it { must_have_alias_attribute :cMunFG,       :municipio_ocorrencia, '1' }
		it { must_have_alias_attribute :cListServ,    :codigo_servico, '1' }
		it { must_have_alias_attribute :vDeducao,     :total_deducao_bc }
		it { must_have_alias_attribute :vOutro,       :total_outras_retencoes }
		it { must_have_alias_attribute :vDescIncond,  :total_desconto_incondicionado }
		it { must_have_alias_attribute :vDescCond,    :total_desconto_condicionado }
		it { must_have_alias_attribute :vISSRet,      :total_iss_retido }
		it { must_have_alias_attribute :indISS,       :indicador_iss, 1 }
		it { must_have_alias_attribute :cServico,     :codigo_servico_municipio }
		it { must_have_alias_attribute :cMun,         :municipio_incidencia }
		it { must_have_alias_attribute :cPais,        :codigo_pais }
		it { must_have_alias_attribute :nProcesso,    :numero_processo }
		it { must_have_alias_attribute :indIncentivo, :incentivo_fiscal, true }
	end

	describe 'Validations' do
		before { MiniTest::Spec.string_for_validation_length = '1' }
		after  { MiniTest::Spec.string_for_validation_length = 'x' }
		
		it { must validate_presence_of(:indicador_iss) }
		it { must validate_presence_of(:codigo_servico) }
		it { must validate_presence_of(:total_base_calculo) }
		it { must validate_presence_of(:aliquota) }
		it { must validate_presence_of(:total) }
		it { must validate_presence_of(:municipio_ocorrencia) }

		it { must validate_inclusion_of(:indicador_iss).in_array([1,2,3,4,5,6,7]) }
		
		it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		
		it { must validate_length_of(:codigo_pais).is_at_most(4) }
		it { must validate_length_of(:municipio_ocorrencia).is_at_most(7) }
		it { must validate_length_of(:municipio_incidencia).is_at_most(7) }
		it { must validate_length_of(:codigo_servico_municipio).is_at_most(20) }
		it { must validate_length_of(:numero_processo).is_at_most(30) }
	end

	describe 'Valores formatados' do
		it { must_returns_a_boolean_for :incentivo_fiscal }
		it { must_accept_only_numbers   :municipio_ocorrencia }
		it { must_returns_a_integer_for :indicador_iss }
		describe '#codigo_servico' do
			it "se setar um valor já formatado deve retornar esse mesmo valor" do
				subject.codigo_servico = '7.90'
				subject.codigo_servico.must_equal '7.90'
			end
			it "se setar um valor inteiro deve formatar para NN.NN" do
				subject.codigo_servico = 1785
				subject.codigo_servico.must_equal '17.85'
			end
			it "se setar um valor inteiro com apenas 1 caracter deve retornar esse unico caractere" do
				subject.codigo_servico = 1
				subject.codigo_servico.must_equal '1'
			end
			it "se setar um valor com mais de 4 posições deve formatar mesmo assim" do
				subject.codigo_servico = 123456
				subject.codigo_servico.must_equal '12.34.56'
			end
			it "se setar nil deve retornar o um valor em branco e não da erro" do
				subject.codigo_servico = nil
				subject.codigo_servico.must_be_nil
			end
			it "deve ignorar os Zeros da frente do número" do
				subject.codigo_servico = '0458'
				subject.codigo_servico.must_equal '4.58'
			end			
		end
	end
end