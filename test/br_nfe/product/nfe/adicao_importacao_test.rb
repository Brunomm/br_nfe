require 'test_helper'

describe BrNfe::Product::Nfe::AdicaoImportacao do
	subject { FactoryGirl.build(:product_adicao_importacao) }

	it { must validate_presence_of(:numero_adicao) }
	it { must validate_presence_of(:sequencial) }
	it { must validate_presence_of(:codigo_fabricante) }
	it { must validate_length_of(:numero_drawback).is_at_least(9).is_at_most(11) }
	it { must validate_length_of(:codigo_fabricante).is_at_most(60) }
end