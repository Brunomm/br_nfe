require 'test_helper'

describe BrNfe::Product::Nfe::ProcessoReferencia do
	subject { FactoryGirl.build(:product_nfe_processo_referencia) }

	describe "Alias attributes" do
		it { must_have_alias_attribute :nProc,   :numero_processo }
		it { must_have_alias_attribute :indProc, :indicador, 1 }
	end

	describe 'Validações' do
		it { must validate_presence_of(:numero_processo) }
		it { must validate_inclusion_of(:indicador).in_array([0,1,2,3,9]) }
	end

	describe '#indicador' do
		it "deve sempre retornar um inteiro" do
			subject.indicador = '0'
			subject.indicador.must_equal 0
			subject.indicador = '1'
			subject.indicador.must_equal 1
			subject.indicador = '2'
			subject.indicador.must_equal 2
			subject.indicador = '3'
			subject.indicador.must_equal 3
			subject.indicador = '09'
			subject.indicador.must_equal 9
		end
	end
end