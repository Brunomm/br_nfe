require 'test_helper'

describe BrNfe::Service::Destinatario do
	subject { FactoryGirl.build(:service_destinatario, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 

	describe "validations" do
		it { must validate_presence_of(:cpf_cnpj) }
		it { must validate_presence_of(:razao_social) }
		
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

	
	describe "#endereco" do
		# include BrNfeTest::HelperTest::HaveAddressTest
	end

	describe "#razao_social" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.razao_social = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.razao_social.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#nome_fantasia" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.nome_fantasia = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.nome_fantasia.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

end