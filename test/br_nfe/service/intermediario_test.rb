require 'test_helper'

describe BrNfe::Service::Intermediario do
	subject { FactoryGirl.build(:intermediario) }
	describe "validations" do
		it { must validate_presence_of(:cpf_cnpj) }
		it { must validate_presence_of(:razao_social) }
	end

	describe "#razao_social" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.razao_social = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.razao_social.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end
end