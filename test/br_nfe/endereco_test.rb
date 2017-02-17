require 'test_helper'

describe BrNfe::Endereco do
	subject { FactoryGirl.build(:endereco) }

	describe "validations" do
		it { must validate_presence_of(:logradouro) }
		it { must validate_presence_of(:numero) }
		it { must validate_presence_of(:bairro) }
		it { must validate_presence_of(:codigo_municipio) }
		it { must validate_presence_of(:uf) }
		it { must validate_presence_of(:cep) }
		it { must validate_inclusion_of(:codigo_ibge_uf).
			       in_array(BrNfe::Constants::CODIGO_IBGE_UF).
			       allow_blank
		}
	end
	
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

	describe "#codigo_ibge_uf" do
		it "se não setar nenhum valor deve pegar os primeiros 2 dígitos do código do município" do
			subject.assign_attributes(codigo_ibge_uf: nil, codigo_municipio: 123456)
			subject.codigo_ibge_uf.must_equal '12'
			subject.assign_attributes(codigo_ibge_uf: nil, codigo_municipio: '65347')
			subject.codigo_ibge_uf.must_equal '65'
		end
		it "se não tiver valor setado no código IBGE da cidade não da erro" do
			subject.assign_attributes(codigo_ibge_uf: nil, codigo_municipio: nil)
			subject.codigo_ibge_uf.must_equal ''
		end
		it "se setar o código ibge da uf diretamente deve desconsiderar o código do municipio" do
			subject.assign_attributes(codigo_ibge_uf: '44', codigo_municipio: 123456)
			subject.codigo_ibge_uf.must_equal '44'
		end
	end

	describe "#exterior?" do
		it "se codigo_pais for diferente de 1058 enão deve ser true" do
			subject.codigo_pais = 4456
			subject.exterior?.must_equal true
			subject.codigo_pais = '1234'
			subject.exterior?.must_equal true
		end
		it "se codigo_pais for igual a 1058 enão deve ser false" do
			subject.codigo_pais = 1058
			subject.exterior?.must_equal false
			subject.codigo_pais = '1058'
			subject.exterior?.must_equal false
		end
	end

end