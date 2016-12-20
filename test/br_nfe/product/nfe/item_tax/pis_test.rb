require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Pis do
	subject { FactoryGirl.build(:product_item_tax_pis) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :CST,       :codigo_cst, '01' }
		it { must_have_alias_attribute :vBC,       :total_base_calculo }
		it { must_have_alias_attribute :pPIS,      :aliquota }
		it { must_have_alias_attribute :vPIS,      :total }
		it { must_have_alias_attribute :qBCProd,   :quantidade_vendida }
		it { must_have_alias_attribute :vAliqProd, :total_aliquota }
	end

	it { must_have_default_value_for(:codigo_cst, '07') }

	describe 'Validations' do
		context '#codigo_cst' do
			it { must validate_presence_of(:codigo_cst) }
			it { must validate_inclusion_of(:codigo_cst).in_array(%w[01 02 03 04 05 06 07 08 09 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 67 70 71 72 73 74 75 98 99]) }
		end
		context "CST 01" do
			before { subject.codigo_cst = '01' }
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:aliquota) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
			
			it { wont validate_presence_of(:quantidade_vendida) }
			it { wont validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:total_aliquota) }
			it { wont validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		context "CST 02" do
			before { subject.codigo_cst = '02' }
			it { must validate_presence_of(:total_base_calculo) }
			it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:aliquota) }
			it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
			
			it { wont validate_presence_of(:quantidade_vendida) }
			it { wont validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:total_aliquota) }
			it { wont validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
		end
		context "CST 03" do
			before { subject.codigo_cst = '03' }
			it { must validate_presence_of(:quantidade_vendida) }
			it { must validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:total_aliquota) }
			it { must validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
			it { must validate_presence_of(:total) }
			it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
			
			it { wont validate_presence_of(:total_base_calculo) }
			it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
			it { wont validate_presence_of(:aliquota) }
			it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
		end

		context "CSTs 04, 05, 06, 07, 08  e 09" do
			%w[04 05 06 07 08 09].each do |cst|
				before { subject.codigo_cst = cst }
				it { wont validate_presence_of(:quantidade_vendida) }
				it { wont validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:total_aliquota) }
				it { wont validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:total) }
				it { wont validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:total_base_calculo) }
				it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:aliquota) }
				it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
			end
		end

		context "CST 49..99" do
			%w[49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 67 70 71 72 73 74 75 98 99].each do |cst|
				before { subject.codigo_cst = cst }
				it { must validate_presence_of(:total) }
				it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }

				it { wont validate_presence_of(:quantidade_vendida) }
				it { wont validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:total_aliquota) }
				it { wont validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:total_base_calculo) }
				it { wont validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
				it { wont validate_presence_of(:aliquota) }
				it { wont validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
			end
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
end