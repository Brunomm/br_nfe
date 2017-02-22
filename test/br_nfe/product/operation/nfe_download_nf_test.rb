require 'test_helper'

describe BrNfe::Product::Operation::NfeDownloadNf do
	subject { FactoryGirl.build(:product_operation_nfe_download_nf) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	
	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :chNFe, :chave_nfe }
	end

	describe 'Validations' do
		describe '#chave_nfe' do
			before { subject.stubs(:generate_key) }
			it { must validate_presence_of(:chave_nfe) }
			it { must validate_length_of(:chave_nfe).is_equal_to(44) }
		end
	end

	describe '#gateway' do
		before do
			subject.unstub(:gateway)
			subject.ibge_code_of_issuer_uf = 42
		end
		it "Por padrão deve pegar o gateway conforme o estado" do
			subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVRS
			subject.class.new(ibge_code_of_issuer_uf: 23).gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceCE
		end
		it "Deve ser possível forçar a utilizar o gateway do SVAN" do
			subject.force_gateway = :SVAN
			subject.gateway.must_be_kind_of BrNfe::Product::Gateway::WebServiceSVAN
		end
		it "Deve ser possível forçar a utilizar o gateway do AN - Vai pegar o base" do
			subject.force_gateway = 'AN'
			subject.gateway.class.must_equal BrNfe::Product::Gateway::Base
		end
	end

	describe 'gateway methods' do
		it 'o método #wsdl deve pegar o valor do método wsdl_download_nf do gateway ' do
			gateway.expects(:wsdl_download_nf).returns('http://teste.wsdl_download_nf.com')
			subject.wsdl.must_equal 'http://teste.wsdl_download_nf.com'
		end

		it 'o método #method_wsdl deve pegar o valor do método operation_download_nf do gateway ' do
			gateway.expects(:operation_download_nf).returns(:operation_download_nf)
			subject.method_wsdl.must_equal :operation_download_nf
		end

		it 'o método #gateway_xml_version deve pegar o valor do método version_xml_download_nf do gateway ' do
			gateway.expects(:version_xml_download_nf).returns(:v3_20)
			subject.gateway_xml_version.must_equal :v3_20
		end

		it 'o método #url_xmlns deve pegar o valor do método url_xmlns_download_nf do gateway ' do
			gateway.expects(:url_xmlns_download_nf).returns('http://teste.url_xmlns_download_nf.com')
			subject.url_xmlns.must_equal 'http://teste.url_xmlns_download_nf.com'
		end

		it 'o método #ssl_version deve pegar o valor do método ssl_version_download_nf do gateway ' do
			gateway.expects(:ssl_version_download_nf).returns(:SSLv1)
			subject.ssl_version.must_equal :SSLv1
		end
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
		it "Deve ser válido em ambiente de produção" do
			subject.env = :production
			nfe_must_be_valid_by_schema 'downloadNFe_v1.00.xsd'
		end
		it "Deve ser válido em ambiente de homologação" do
			subject.env = :test
			nfe_must_be_valid_by_schema 'downloadNFe_v1.00.xsd'
		end
	end
end