require 'test_helper'

describe BrNfe::Product::Operation::NfeConsultaProtocolo do
	subject { FactoryGirl.build(:product_operation_nfe_consulta_protocolo) }

	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	
	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :chNFe, :chave_nfe }
	end

	describe 'Validations' do
		it { must validate_presence_of(:chave_nfe) }
		it { must validate_length_of(:chave_nfe).is_equal_to(44) }
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_consulta_protocolo do gateway ' do
		gateway.expects(:wsdl_consulta_protocolo).returns('http://teste.wsdl_consulta_protocolo.com')
		subject.wsdl.must_equal 'http://teste.wsdl_consulta_protocolo.com'
	end
	
	it 'o método #method_wsdl deve pegar o valor do método operation_consulta_protocolo do gateway ' do
		gateway.expects(:operation_consulta_protocolo).returns(:operation_consulta_protocolo)
		subject.method_wsdl.must_equal :operation_consulta_protocolo
	end
	
	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_consulta_protocolo do gateway ' do
		gateway.expects(:version_xml_consulta_protocolo).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_consulta_protocolo do gateway ' do
		gateway.expects(:url_xmlns_consulta_protocolo).returns('http://teste.url_xmlns_consulta_protocolo.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_consulta_protocolo.com'
	end

	it 'o método #ssl_version deve pegar o valor do método ssl_version_consulta_protocolo do gateway ' do
		gateway.expects(:ssl_version_consulta_protocolo).returns(:SSLv1)
		subject.ssl_version.must_equal :SSLv1
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

	describe "Validação do XML através do XSD" do
		context "for XML Version 2.01" do
			before { subject.stubs(:gateway_xml_version).returns(:v2_01) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consSitNFe_v2.01.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consSitNFe_v2.01.xsd'
			end
		end
		context "for XML Version 3.10" do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
			
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consSitNFe_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consSitNFe_v3.10.xsd'
			end
		end
	end

end