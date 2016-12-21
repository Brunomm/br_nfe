require 'test_helper'

describe BrNfe::Product::NfeRecepcaoEvento do
	subject { FactoryGirl.build(:product_nfe_recepcao_evento) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }
	
	before do
		subject.stubs(:gateway).returns(gateway)
	end

	describe '#aliases' do
		it { must_have_alias_attribute :idLote,  :numero_lote }
	end

	describe 'have one cancelamento' do
		it { must_have_one :cancelamento, BrNfe.cancelamento_product_class, {protocolo_nfe: '12345', justificativa: 'Justi'} }
		it { must_validate_have_one :cancelamento, BrNfe.cancelamento_product_class, :invalid_cancelamento }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_lote) }
		it { must validate_length_of(:numero_lote).is_at_most(15) }
		it { must validate_numericality_of(:numero_lote).only_integer }
		it { must allow_value('123456789012345').for(:numero_lote) }
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_recepcao_evento do gateway ' do
		gateway.expects(:wsdl_recepcao_evento).returns('http://teste.wsdl_recepcao_evento.com')
		subject.wsdl.must_equal 'http://teste.wsdl_recepcao_evento.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_recepcao_evento do gateway ' do
		gateway.expects(:operation_recepcao_evento).returns(:operation_recepcao_evento)
		subject.method_wsdl.must_equal :operation_recepcao_evento
	end
	
	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_recepcao_evento do gateway ' do
		gateway.expects(:version_xml_recepcao_evento).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end
	
	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_recepcao_evento do gateway ' do
		gateway.expects(:url_xmlns_recepcao_evento).returns('http://teste.url_xmlns_recepcao_evento.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_recepcao_evento.com'
	end
	
	it 'o método #ssl_version deve pegar o valor do método ssl_version_recepcao_evento do gateway ' do
		gateway.expects(:ssl_version_recepcao_evento).returns(:TLSv1)
		subject.ssl_version.must_equal :TLSv1
	end
	
	describe "Validação do XML para o Cancelamento através do XSD" do
		context "Para emissores que utilizam a versão 1.00" do
			before do
				gateway.stubs(:version_xml_recepcao_evento).returns(:v1_00)
			end
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
		end
		context "Para emissores que utilizam a versão 3.10" do
			before do
				gateway.stubs(:version_xml_recepcao_evento).returns(:v3_10)
			end
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				subject.valid?.must_equal true, "#{subject.errors.full_messages}"
				nfe_must_be_valid_by_schema 'envEventoCancNFe_v1.00.xsd'
			end
		end
	end

end