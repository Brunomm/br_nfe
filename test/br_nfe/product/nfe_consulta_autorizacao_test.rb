require 'test_helper'

describe BrNfe::Product::NfeConsultaAutorizacao do
	subject { FactoryGirl.build(:product_nfe_consulta_autorizacao) }

	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 

	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :nRec,  :numero_recibo }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_recibo) }
		it { must validate_length_of(:numero_recibo).is_at_most(15) }
		it { must validate_numericality_of(:numero_recibo).only_integer }
		it { must allow_value('123456789012345').for(:numero_recibo) }
	end

	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_retorno_autorizacao do gateway ' do
		gateway.expects(:url_xmlns_retorno_autorizacao).returns('http://teste.url_xmlns_retorno_autorizacao.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_retorno_autorizacao.com'
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_retorno_autorizacao do gateway ' do
		gateway.expects(:wsdl_retorno_autorizacao).returns('http://teste.wsdl_retorno_autorizacao.com')
		subject.wsdl.must_equal 'http://teste.wsdl_retorno_autorizacao.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_retorno_autorizacao do gateway ' do
		gateway.expects(:operation_retorno_autorizacao).returns(:operation_retorno_autorizacao)
		subject.method_wsdl.must_equal :operation_retorno_autorizacao
	end

	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_retorno_autorizacao do gateway ' do
		gateway.expects(:version_xml_retorno_autorizacao).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	describe "Validação do XML através do XSD" do		
		let(:schemas_dir) { BrNfe.root+'/lib/br_nfe/product/xml/v3_10/XSD' }		
		def validate_schema
			subject.stubs(:certificate).returns(nil)			
			Dir.chdir(schemas_dir) do
				schema = Nokogiri::XML::Schema(IO.read('consReciNFe_v3.10.xsd'))
				document = Nokogiri::XML(subject.xml_builder)
				errors = schema.validate(document)
				errors.must_be_empty
			end
		end
		it "Deve ser válido em ambiente de produção" do
			subject.env = :production
			validate_schema
		end
		it "Deve ser válido em ambiente de homologação" do
			subject.env = :test
			validate_schema
		end
	end

end