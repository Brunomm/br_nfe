require 'test_helper'

describe BrNfe::Product::NfeDownloadNf do
	subject { FactoryGirl.build(:product_nfe_download_nf) }
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



	# describe "Validação do XML através do XSD" do
	# 	let(:schemas_dir) { BrNfe.root+'/lib/br_nfe/product/xml/v3_10/XSD' }
	# 	def validate_schema
	# 		Dir.chdir(schemas_dir) do
	# 			schema = Nokogiri::XML::Schema(IO.read('inutNFe_v3.10.xsd'))
	# 			document = Nokogiri::XML(subject.xml_builder)
	# 			errors = schema.validate(document)
	# 			errors.must_be_empty
	# 		end
	# 	end
	# 	it "Deve ser válido em ambiente de produção" do
	# 		subject.env = :production
	# 		validate_schema
	# 	end
	# 	it "Deve ser válido em ambiente de homologação" do
	# 		subject.env = :test
	# 		validate_schema
	# 	end
	# end

end