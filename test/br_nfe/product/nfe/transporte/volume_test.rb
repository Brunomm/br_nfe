require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Volume do
	subject { FactoryGirl.build(:product_transporte_volume) }
	
	describe "Alias attributes" do
		it { must_have_alias_attribute :qVol,  :quantidade }
		it { must_have_alias_attribute :esp,   :especie }
		it { must_have_alias_attribute :nVol,  :numercao }
		it { must_have_alias_attribute :pesoL, :peso_liquido }
		it { must_have_alias_attribute :pesoB, :peso_bruto }
	end

	describe "#validations" do
		it "Pode haver no máximi 5000 lacres" do
			MiniTest::Spec.string_for_validation_length = ['x']			
			must validate_length_of(:lacres).is_at_most(5_000)
			MiniTest::Spec.string_for_validation_length = 'x'
		end
		it { must validate_length_of(:especie).is_at_most(60) }
		it { must validate_length_of(:marca).is_at_most(60) }
		it { must validate_length_of(:numercao).is_at_most(60) }
	end

	describe '#lacres' do
		it "ao instanciar o obejto já deve retornar um array" do
			subject.class.new.lacres.must_be_kind_of Array
			subject.lacres = nil
			subject.class.new.lacres.must_be_kind_of Array
		end
		it "se setar um valor diretamente deve converter em array" do
			subject.lacres = '123'
			subject.lacres.must_equal ['123']
		end
		it "Posso utilizar o operador << para adiiconar valores" do
			subject.lacres << 'v1'
			subject.lacres.must_equal(['v1'])
			subject.lacres << 2
			subject.lacres.must_equal(['v1',2])
		end
	end
end