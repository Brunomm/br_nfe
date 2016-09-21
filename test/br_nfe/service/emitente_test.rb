require 'test_helper'

describe BrNfe::Service::Emitente do
	subject { FactoryGirl.build(:service_emitente, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 

	it "deve herdar da classe ::Person" do
		subject.must_be_kind_of BrNfe::Service::Emitente
		subject.must_be_kind_of BrNfe::Person
	end

	describe "validations" do
		it { must validate_presence_of(:inscricao_municipal) }
		it { must validate_presence_of(:natureza_operacao) }
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