require 'test_helper'

describe BrNfe::Product::Nfe::ItemTax::CofinsSt do
	subject { FactoryGirl.build(:product_item_tax_cofins_st) }

	describe 'Alias attributes' do
		it { must_have_alias_attribute :vBC,       :total_base_calculo }
		it { must_have_alias_attribute :pCOFINS,   :aliquota }
		it { must_have_alias_attribute :vCOFINS,   :total }
		it { must_have_alias_attribute :qBCProd,   :quantidade_vendida }
		it { must_have_alias_attribute :vAliqProd, :total_aliquota }
	end

	describe 'Validations' do
		it { must validate_presence_of(:total) }
		it { must validate_numericality_of(:total).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:quantidade_vendida).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:total_base_calculo).is_greater_than_or_equal_to(0.0).allow_nil }
		it { must validate_numericality_of(:aliquota).is_greater_than_or_equal_to(0.0).allow_nil }
	end
end