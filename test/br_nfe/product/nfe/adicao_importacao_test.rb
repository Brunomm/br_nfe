require 'test_helper'

describe BrNfe::Product::Nfe::AdicaoImportacao do
	subject { FactoryGirl.build(:product_adicao_importacao) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :nAdicao,     :numero_adicao }
		it { must_have_alias_attribute :nSeqAdic,    :sequencial }
		it { must_have_alias_attribute :cFabricante, :codigo_fabricante }
		it { must_have_alias_attribute :vDescDI,     :valor_desconto }
		it { must_have_alias_attribute :nDraw,       :numero_drawback }
	end

	it { must validate_presence_of(:numero_adicao) }
	it { must validate_presence_of(:sequencial) }
	it { must validate_presence_of(:codigo_fabricante) }
	it { must validate_length_of(:numero_drawback).is_at_least(9).is_at_most(11) }
	it { must validate_length_of(:codigo_fabricante).is_at_most(60) }
end