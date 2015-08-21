require 'test_helper'

describe BrNfe::Endereco do
	subject { FactoryGirl.build(:endereco) }
	
	describe "validations" do
		it { must validate_presence_of(:logradouro) }
		it { must validate_presence_of(:numero) }
		it { must validate_presence_of(:bairro) }
		it { must validate_presence_of(:nome_municipio) }
		it { must validate_presence_of(:codigo_municipio) }
		it { must validate_presence_of(:uf) }
		it { must validate_presence_of(:cep) }
	end

	describe "#default_values" do
		it "for codigo_pais must equal to 1058 " do
			BrNfe::Endereco.new().codigo_pais.must_equal '1058'
		end
		it "for nome_pais must equal to BRASIL " do
			BrNfe::Endereco.new().nome_pais.must_equal 'BRASIL'
		end
	end

end