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

	# describe '#xml_builder' do
	# 	it "deve renderizar para o xml nfe_autorizacao" do
	# 		subject.expects(:render_xml).with('nfe_autorizacao').returns('<ok>1</ok>')
	# 		subject.xml_builder.must_equal '<ok>1</ok>'
	# 	end
	# end

	# describe "Validação do XML através do XSD" do		
	# 	let(:schemas_dir) { BrNfe.root+'/lib/br_nfe/product/xml/v3_10/XSD' }		
	# 	def validate_schema
	# 		subject.stubs(:certificate).returns(nil)			
	# 		Dir.chdir(schemas_dir) do
	# 			schema = Nokogiri::XML::Schema(IO.read('consStatServ_v3.10.xsd'))
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