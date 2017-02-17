require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Ipi do
	subject { FactoryGirl.build(:product_item_tax_ipi) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :CST,      :codigo_cst, '01' }
		it { must_have_alias_attribute :clEnq,    :classe_enquadramento}
		it { must_have_alias_attribute :CNPJProd, :cnpj_produtor, '001'}
		it { must_have_alias_attribute :cSelo,    :codigo_selo}
		it { must_have_alias_attribute :qSelo,    :quantidade_selo, '1'}
		it { must_have_alias_attribute :vBC,      :base_calculo}
		it { must_have_alias_attribute :pIPI,     :aliquota}
		it { must_have_alias_attribute :qUnid,    :quantidade_unidade}
		it { must_have_alias_attribute :vUnid,    :total_unidade}
		it { must_have_alias_attribute :vIPI,     :total}
	end

	describe 'Default values' do
		it { subject.class.new.codigo_enquadramento.must_equal '999' }
	end

	describe 'Validations' do
		context '#codigo_cst' do
			it { must validate_presence_of(:codigo_cst) }
			it { must validate_inclusion_of(:codigo_cst).in_array(%w[00 01 02 03 04 05 49 50 51 52 53 54 55 99]) }
		end
		context '#classe_enquadramento' do
			it { must allow_value('').for(:classe_enquadramento) }
			it { must validate_length_of(:classe_enquadramento).is_at_most(5) }
		end
		context '#cnpj_produtor' do
			before { MiniTest::Spec.string_for_validation_length = '1' }
			after  { MiniTest::Spec.string_for_validation_length = 'x' }
			it { must allow_value('').for(:cnpj_produtor) }
			it { must validate_length_of(:cnpj_produtor).is_equal_to(14) }
		end
		context '#codigo_selo' do
			it { must allow_value('').for(:codigo_selo) }
			it { must validate_length_of(:codigo_selo).is_at_most(60) }
		end
		context '#quantidade_selo' do
			before { MiniTest::Spec.string_for_validation_length = '1' }
			after  { MiniTest::Spec.string_for_validation_length = 'x' }
			it { must allow_value('').for(:quantidade_selo) }
			it { must validate_length_of(:quantidade_selo).is_at_most(12) }
		end
		context '#codigo_enquadramento' do
			it { must validate_presence_of(:codigo_enquadramento) }
			it { must validate_length_of(:codigo_enquadramento).is_at_most(3) }
		end
		describe "CST 00" do
			before { subject.codigo_cst = '00' }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 01" do
			before { subject.codigo_cst = '01' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 02" do
			before { subject.codigo_cst = '02' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 03" do
			before { subject.codigo_cst = '03' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 04" do
			before { subject.codigo_cst = '04' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 05" do
			before { subject.codigo_cst = '05' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 49" do
			before { subject.codigo_cst = '49' }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 50" do
			before { subject.codigo_cst = '50' }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 51" do
			before { subject.codigo_cst = '51' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 52" do
			before { subject.codigo_cst = '52' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 53" do
			before { subject.codigo_cst = '53' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 54" do
			before { subject.codigo_cst = '54' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 55" do
			before { subject.codigo_cst = '55' }
			it { wont validate_presence_of(:total) }
			it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		describe "CST 99" do
			before { subject.codigo_cst = '99' }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		end
	end

	describe '#codigo_cst' do
		it "deve sempre retornar uam string" do
			subject.codigo_cst = 100
			subject.codigo_cst.must_equal '100'
		end
		it "deve ajustar o valor para 2 posições adicionando zeros" do
			subject.codigo_cst = 0
			subject.codigo_cst.must_equal '00'
		end
		it "se não tiver valor setado deve retornar nil" do
			subject.codigo_cst = ''
			subject.codigo_cst.must_be_nil
		end
	end

	describe '#cnpj_produtor' do
		it "deve retornar apenas os numeros setados" do
			subject.cnpj_produtor = '00.000.000/0001-00'
			subject.cnpj_produtor.must_equal '00000000000100'
		end
		it "se setar um valor inteiro deve retornar em forma de string" do
			subject.cnpj_produtor = 1234567890
			subject.cnpj_produtor.must_equal '1234567890'
		end
	end

	describe '#quantidade_selo' do
		it "deve retornar apenas os numeros setados" do
			subject.quantidade_selo = 'A001B'
			subject.quantidade_selo.must_equal '001'
		end
		it "se setar um valor inteiro deve retornar em forma de string" do
			subject.quantidade_selo = 123
			subject.quantidade_selo.must_equal '123'
		end
	end
end