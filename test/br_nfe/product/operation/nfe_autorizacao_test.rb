require 'test_helper'

describe BrNfe::Product::Operation::NfeAutorizacao do
	subject { FactoryGirl.build(:product_operation_nfe_autorizacao) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 

	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :idLote,  :numero_lote }
		it { must_have_alias_attribute :indSinc, :sincrono, true }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_lote) }
		it { must validate_length_of(:numero_lote).is_at_most(15) }
		it { must validate_numericality_of(:numero_lote).only_integer }
		it { must allow_value('123456789012345').for(:numero_lote) }
	end

	describe '#notas_fiscais' do
		it { must_validate_length_has_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, {minimum: 1, maximum: 50})  }
		it { must_validates_has_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, :invalid_invoice) }
		it { must_have_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, {codigo_nf: '1233', serie: '1'})  }
	end

	it "o attr sincrono deve sempre retornar um boolean" do
		must_returns_a_boolean_for :sincrono
	end
	
	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_autorizacao do gateway ' do
		gateway.expects(:url_xmlns_autorizacao).returns('http://teste.url_xmlns_autorizacao.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_autorizacao.com'
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_autorizacao do gateway ' do
		gateway.expects(:wsdl_autorizacao).returns('http://teste.wsdl_autorizacao.com')
		subject.wsdl.must_equal 'http://teste.wsdl_autorizacao.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_autorizacao do gateway ' do
		gateway.expects(:operation_autorizacao).returns(:operation_autorizacao)
		subject.method_wsdl.must_equal :operation_autorizacao
	end

	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_autorizacao do gateway ' do
		gateway.expects(:version_xml_autorizacao).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	describe '#xml_builder' do
		it "Deve renderizar o XML e setar o valor na variavel @xml_builder" do
			subject.expects(:render_xml).returns('<xml>OK</xml>')
			
			subject.xml_builder.must_equal '<xml>OK</xml>'
			subject.instance_variable_get(:@xml_builder).must_equal '<xml>OK</xml>'
		end
		it "Se já houver valor setado na variavel @xml_builder não deve renderizar o xml novamente" do
			subject.instance_variable_set(:@xml_builder, '<xml>OK</xml>')
			subject.expects(:render_xml).never
			subject.xml_builder.must_equal '<xml>OK</xml>'
		end
	end

	context "Ao gerar o XML do lote deve setar o XML de cada nota no atributo xml da nf" do
		let(:subject) { FactoryGirl.build(:product_operation_nfe_autorizacao, :for_signature_test) }
		let(:nf1) { subject.notas_fiscais[0] }
		let(:nf2) { subject.notas_fiscais[1] }
		it "Para a versão 3.10 da NF" do
			subject.stubs(:gateway_xml_version).returns(:v3_10)
			nf1.xml.must_be_nil
			nf2.xml.must_be_nil

			subject.xml_builder

			nf1.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000021201601015"'
			nf2.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000501201601012"'

			nf1.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
			nf2.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
		end
		it "Para a versão 2.00 da NF" do
			subject.stubs(:gateway_xml_version).returns(:v2_00)
			nf1.xml.must_be_nil
			nf2.xml.must_be_nil

			subject.xml_builder

			nf1.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000021201601015"'
			nf2.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000501201601012"'

			nf1.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
			nf2.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
		end
	end

	describe "Validação do XML através do XSD" do
		subject { FactoryGirl.build(:product_operation_nfe_autorizacao, :complete) }
		
		context "Para a versão 3.10" do
			before do
				gateway.stubs(:version_xml_autorizacao).returns(:v3_10)
			end
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
			end
			it "Deve ser válido com mais de uma nota" do
				nf2 = subject.notas_fiscais[0].dup
				nf2.numero_nf = nf2.numero_nf.to_i+1
				subject.notas_fiscais << nf2
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
			end
		end
	end

	describe "Validação da assinatura da NF-e" do
		it "deve assinar a NF-e corretamente de acordo com uma NF-e já testada e homologada" do
			# Esse teste serve para validar que a estrutura para assinar a NF-e não foi modificada
			# e corrompida.
			aut = FactoryGirl.build(:product_operation_nfe_autorizacao, :for_signature_test)
			aut.content_xml.must_equal read_fixture('product/operation/nfe_autorizacao/nfe_signed.xml')
		end
	end
end