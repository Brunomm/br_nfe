require 'test_helper'

describe BrNfe::Servico::Betha::Base do
	subject { FactoryGirl.build(:br_nfe_servico_betha_base) }
	let(:rps) { FactoryGirl.build(:br_nfe_rps) }
	let(:destinatario) { FactoryGirl.build(:destinatario) }

	describe "#tag_identificacao_rps" do
		it "deve vir com a estrutura adecuada" do
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_identificacao_rps, xml, rps)
			end.doc

			xml.xpath('IdentificacaoRps/Numero').first.text.must_equal "#{rps.numero}"
			xml.xpath('IdentificacaoRps/Serie').first.text.must_equal  "#{rps.serie}"
			xml.xpath('IdentificacaoRps/Tipo').first.text.must_equal   "#{rps.tipo}"
		end
	end

	describe "#tag_rps_substituido" do
		before do
			rps.numero_substituicao = 333
			rps.serie_substituicao = 5
			rps.tipo_substituicao = 9
		end
		it "deve vir com a estrutura adecuada" do
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_rps_substituido, xml, rps)
			end.doc

			xml.xpath('RpsSubstituido/Numero').first.text.must_equal "333"
			xml.xpath('RpsSubstituido/Serie').first.text.must_equal  "5"
			xml.xpath('RpsSubstituido/Tipo').first.text.must_equal   "9"
		end
	end

	describe "#tag_dados_tomador" do
		it "Valores padrões indiferentemente da versao" do
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_dados_tomador, xml, destinatario)
			end.doc

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
			xml.xpath('Tomador/Endereco/Cep').first.text.must_equal             destinatario.endereco.cep
			xml.xpath('Tomador/Endereco/CodigoPais').first.must_be_nil
			

			xml.xpath('Tomador/Contato/Telefone').first.text.must_equal destinatario.telefone
			xml.xpath('Tomador/Contato/Email').first.text.must_equal destinatario.email
		end

		context "tags da versão 1" do
			before do
				subject.stubs(:version).returns(:v1)
			end
			it "inscricao_estadual" do
				xml = Nokogiri::XML::Builder.new do |xml|
					subject.send(:tag_dados_tomador, xml, destinatario)
				end.doc
				xml.xpath('Tomador/IdentificacaoTomador/InscricaoEstadual').first.text.must_equal destinatario.inscricao_estadual
			end
		end

	end

	describe "#tag_dados_construcao_civil" do
		it "quando rps não tem codigo_obra" do
			rps.assign_attributes(codigo_obra: '', codigo_art: '366')
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_dados_construcao_civil, xml, rps)
			end.doc
			xml.xpath('ConstrucaoCivil/CodigoObra').first.must_be_nil
			xml.xpath('ConstrucaoCivil/Art').first.must_be_nil
			xml.to_s.must_equal "<?xml version=\"1.0\"?>\n"
		end
		it "quando rps não tem codigo_art" do
			rps.assign_attributes(codigo_obra: '13', codigo_art: '')
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_dados_construcao_civil, xml, rps)
			end.doc
			xml.xpath('ConstrucaoCivil/CodigoObra').first.must_be_nil
			xml.xpath('ConstrucaoCivil/Art').first.must_be_nil
			xml.to_s.must_equal "<?xml version=\"1.0\"?>\n"
		end

		it "quando rps tem codigo_art e codigo_obra" do
			rps.assign_attributes(codigo_obra: '13', codigo_art: '555')
			xml = Nokogiri::XML::Builder.new do |xml|
				subject.send(:tag_dados_construcao_civil, xml, rps)
			end.doc
			xml.xpath('ConstrucaoCivil/CodigoObra').first.text.must_equal '13'
			xml.xpath('ConstrucaoCivil/Art').first.text.must_equal '555'
		end
	end
	
end