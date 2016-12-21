require 'test_helper'

describe BrNfe::Product::NfeConsultaProtocolo do
	subject { FactoryGirl.build(:product_nfe_consulta_protocolo) }

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

	describe "Validação do XML através do XSD" do		
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