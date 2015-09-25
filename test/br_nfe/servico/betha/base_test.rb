require 'test_helper'

describe BrNfe::Servico::Betha::Base do
	subject { FactoryGirl.build(:br_nfe_servico_betha_base) }
	let(:rps) { FactoryGirl.build(:br_nfe_rps) }
	let(:destinatario) { FactoryGirl.build(:destinatario) }
	let(:endereco) { FactoryGirl.build(:endereco) }

	describe "#xml_identificacao_rps" do
		it "deve vir com a estrutura adecuada" do
			xml = subject.send(:xml_identificacao_rps, rps).doc

			xml.xpath('IdentificacaoRps/Numero').first.text.must_equal "#{rps.numero}"
			xml.xpath('IdentificacaoRps/Serie').first.text.must_equal  "#{rps.serie}"
			xml.xpath('IdentificacaoRps/Tipo').first.text.must_equal   "#{rps.tipo}"
		end
	end

	describe "#xml_rps_substituido" do
		before do
			rps.numero_substituicao = 333
			rps.serie_substituicao = 5
			rps.tipo_substituicao = 9
		end
		it "deve vir com a estrutura adecuada" do
			xml = subject.send(:xml_rps_substituido, rps).doc

			xml.xpath('RpsSubstituido/Numero').first.text.must_equal "333"
			xml.xpath('RpsSubstituido/Serie').first.text.must_equal  "5"
			xml.xpath('RpsSubstituido/Tipo').first.text.must_equal   "9"
		end

		it "se rps contem_substituicao deve retornar um html vazio" do
			rps.expects(:contem_substituicao?).returns(false)
			xml = subject.send(:xml_rps_substituido, rps).doc.root.to_s.must_equal ''
		end
	end

	describe "#xml_endereco" do
		before do
			endereco.assign_attributes({
				logradouro:       'á'.rjust(130, 'á'),
				numero:           '2'.rjust(100, '2'),
				complemento:      'õ'.rjust(100, 'õ'),
				bairro:           'ê'.rjust(100, 'ê'),
				codigo_municipio: '123456789'.rjust(100, 'A'),
				uf:               'ABCDE',
				cep:              '123-4567-89-60',
				codigo_pais:      '123456AAAA'
			})
		end
		it "valores padroes" do
			xml = subject.send(:xml_endereco, endereco).doc
			xml.xpath('Endereco/Endereco').first.text.must_equal        "A".rjust(125, 'A')
			xml.xpath('Endereco/Numero').first.text.must_equal          "2".rjust(10, '2')
			xml.xpath('Endereco/Complemento').first.text.must_equal     "O".rjust(60, 'O')
			xml.xpath('Endereco/Bairro').first.text.must_equal          "E".rjust(60, 'E')
			xml.xpath('Endereco/CodigoMunicipio').first.text.must_equal "1234567"
			xml.xpath('Endereco/Uf').first.text.must_equal              "AB"
			xml.xpath('Endereco/Cep').first.text.must_equal             '12345678'
			xml.xpath('Endereco/CodigoPais').first.must_be_nil
		end

		it "se for versao 1 e mandar o codigo_pais como true deve ignorar" do
			subject.stubs(:version).returns(:v1)
			xml = subject.send(:xml_endereco, endereco, true).doc
			xml.xpath('Endereco/CodigoPais').first.must_be_nil
		end

		it "se for versao 2 e mandar o codigo_pais como true deve trazer junto o codigo do pais" do
			subject.stubs(:version).returns(:v2)
			xml = subject.send(:xml_endereco, endereco, true).doc
			xml.xpath('Endereco/CodigoPais').first.text.must_equal '1234'
		end

		it "se for versao 2 e mandar o codigo_pais como false não deve trazer o codigo do pais" do
			subject.stubs(:version).returns(:v2)
			xml = subject.send(:xml_endereco, endereco, false).doc
			xml.xpath('Endereco/CodigoPais').first.must_be_nil
		end
	end

	describe "#xml_dados_tomador" do
		it "Valores padrões indiferentemente da versao" do
			xml = subject.send(:xml_dados_tomador, destinatario).doc

			xml.xpath('Tomador/RazaoSocial').first.text.must_equal destinatario.razao_social
			xml.xpath('Tomador/IdentificacaoTomador/CpfCnpj/Cpf').first.text.must_equal BrNfe::Helper::CpfCnpj.new(destinatario.cpf_cnpj).sem_formatacao
			xml.xpath('Tomador/IdentificacaoTomador/InscricaoMunicipal').first.text.must_equal destinatario.inscricao_municipal
			xml.xpath('Tomador/IdentificacaoTomador/InscricaoEstadual').first.must_be_nil

			xml.xpath('Tomador/Endereco/Endereco').first.text.must_equal        destinatario.endereco.logradouro
			xml.xpath('Tomador/Endereco/Numero').first.text.must_equal          destinatario.endereco.numero
			xml.xpath('Tomador/Endereco/Complemento').first.text.must_equal     destinatario.endereco.complemento
			xml.xpath('Tomador/Endereco/Bairro').first.text.must_equal          destinatario.endereco.bairro
			xml.xpath('Tomador/Endereco/CodigoMunicipio').first.text.must_equal destinatario.endereco.codigo_municipio
			xml.xpath('Tomador/Endereco/Uf').first.text.must_equal              destinatario.endereco.uf
			xml.xpath('Tomador/Endereco/Cep').first.text.must_equal             destinatario.endereco.cep.gsub(/[^0-9]/,'')
			xml.xpath('Tomador/Endereco/CodigoPais').first.must_be_nil
			

			xml.xpath('Tomador/Contato/Telefone').first.text.must_equal destinatario.telefone
			xml.xpath('Tomador/Contato/Email').first.text.must_equal destinatario.email
		end

		context "tags da versão 1" do
			before do
				subject.stubs(:version).returns(:v1)
			end
			it "inscricao_estadual" do
				xml = subject.send(:xml_dados_tomador, destinatario).doc
				xml.xpath('Tomador/IdentificacaoTomador/InscricaoEstadual').first.text.must_equal destinatario.inscricao_estadual
			end
		end
	end

	describe "#xml_dados_construcao_civil" do
		it "quando rps não tem codigo_obra" do
			rps.assign_attributes(codigo_obra: '', codigo_art: '366')
			xml = subject.send(:xml_dados_construcao_civil, rps).doc.root.to_s.must_equal ''
		end
		it "quando rps não tem codigo_art" do
			rps.assign_attributes(codigo_obra: '13', codigo_art: '')
			xml = subject.send(:xml_dados_construcao_civil, rps).doc.root.to_s.must_equal ''
		end

		it "quando rps tem codigo_art e codigo_obra" do
			rps.assign_attributes(codigo_obra: '13', codigo_art: '555')
			xml = subject.send(:xml_dados_construcao_civil, rps).doc
			xml.xpath('ConstrucaoCivil/CodigoObra').first.text.must_equal '13'
			xml.xpath('ConstrucaoCivil/Art').first.text.must_equal '555'
		end
	end
	
end