require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Volume do
	subject { FactoryGirl.build(:product_transporte_volume) }

	describe "#validations" do
		it "Pode haver no máximi 5000 lacres" do
			class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
				def string_of_length(length)
					['x'] * length
				end
			end
			
			must validate_length_of(:lacres).is_at_most(5_000) 
			
			# Volto a alteração que fiz no método para outros testes
			# Funcionarem adequadamente
			class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
				def string_of_length(length)
					'x' * length
				end
			end
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