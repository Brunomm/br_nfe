require 'test_helper'
require 'br_nfe/helper/have_address_test.rb'

describe BrNfe::Destinatario do
	subject { FactoryGirl.build(:destinatario, endereco: endereco) }
	let(:endereco) { FactoryGirl.build(:endereco) } 
	
	describe "#endereco" do
		include BrNfeTest::HelperTest::HaveAddressTest
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