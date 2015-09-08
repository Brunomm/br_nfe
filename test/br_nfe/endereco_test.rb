require 'test_helper'

describe BrNfe::Endereco do
	subject { FactoryGirl.build(:endereco) }
	
	describe "#default_values" do
		it "for codigo_pais must equal to 1058 " do
			BrNfe::Endereco.new().codigo_pais.must_equal '1058'
		end
		it "for nome_pais must equal to BRASIL " do
			BrNfe::Endereco.new().nome_pais.must_equal 'BRASIL'
		end
	end

	describe "#logradouro" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.logradouro = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.logradouro.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#complemento" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.complemento = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.complemento.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#bairro" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.bairro = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.bairro.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#nome_municipio" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.nome_municipio = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.nome_municipio.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

	describe "#nome_pais" do
		it "deve retornar a string em maiusculoo e sem acentos" do
			subject.nome_pais = 'ó têxtú dève vìr SÉM ÀçÊnTÕ'
			subject.nome_pais.must_equal "O TEXTU DEVE VIR SEM ACENTO"
		end
	end

end