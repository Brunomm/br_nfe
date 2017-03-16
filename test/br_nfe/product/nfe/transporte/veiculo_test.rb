require 'test_helper'

describe BrNfe::Product::Nfe::Transporte::Veiculo do
	subject { FactoryGirl.build(:product_transporte_veiculo) }

	describe "#validations" do
		it { must validate_presence_of(:placa) }
		it { must validate_presence_of(:uf) }
		it { must validate_inclusion_of(:uf).in_array(BrNfe::Constants::SIGLAS_UF) }
		it { must validate_length_of(:rntc).is_at_most(20) }
		it { must validate_length_of(:placa).is_equal_to(7) }
	end
end