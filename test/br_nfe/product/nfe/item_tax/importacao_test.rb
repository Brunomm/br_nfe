require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::Importacao do
	subject { FactoryGirl.build(:product_item_tax_importacao) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :vBC,      :total_base_calculo }
		it { must_have_alias_attribute :vDespAdu, :total_despesas_aduaneiras }
		it { must_have_alias_attribute :vII,      :total_imposto }
		it { must_have_alias_attribute :vIOF,     :total_iof }
	end

	describe 'Validations' do
		it { must validate_presence_of(:total_base_calculo) }
		it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_presence_of(:total_despesas_aduaneiras) }
		it { must validate_numericality_of(:total_despesas_aduaneiras).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_presence_of(:total_imposto) }
		it { must validate_numericality_of(:total_imposto).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_presence_of(:total_iof) }
		it { must validate_numericality_of(:total_iof).is_greater_than_or_equal_to(0.0).allow_nil }
	end
end