require 'test_helper'

describe BrNfe::Product::Destinatario do
	subject { FactoryGirl.build(:product_destinatario, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 

	describe "validations" do
		it { must validate_presence_of(:cpf_cnpj) }
		it { must validate_presence_of(:razao_social) }
		it { must validate_inclusion_of(:indicador_ie).in_array([1,2,9]) }
		
		describe "valida o endereco" do
			it "deve ser inválido se endereco for invalido" do
				subject.endereco.stubs(:valid?).returns(false)
				subject.endereco.stubs(:errors).returns(stub(full_messages: ["Erro 1"] ))
				subject.valid?.must_equal false
				subject.errors.full_messages.include?("Endereço: Erro 1").must_equal true
			end
			it "deve ser válido se endereco for valido" do
				subject.endereco.stubs(:valid?).returns(true)
				subject.valid?.must_equal true
			end
		end

	end
end