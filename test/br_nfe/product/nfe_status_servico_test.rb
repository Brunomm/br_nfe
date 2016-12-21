require 'test_helper'

describe BrNfe::Product::NfeStatusServico do
	subject { FactoryGirl.build(:product_nfe_status_servico) }
	let(:gateway) { FactoryGirl.build(:product_gateway_web_service_svrs) }

	before do
		subject.stubs(:gateway).returns(gateway)
	end
	
	it 'o método #url_xmlns deve pegar o valor do método url_xmlns_status_servico do gateway ' do
		gateway.expects(:url_xmlns_status_servico).returns('http://teste.url_xmlns_status_servico.com')
		subject.url_xmlns.must_equal 'http://teste.url_xmlns_status_servico.com'
	end

	it 'o método #wsdl deve pegar o valor do método wsdl_status_servico do gateway ' do
		gateway.expects(:wsdl_status_servico).returns('http://teste.wsdl_status_servico.com')
		subject.wsdl.must_equal 'http://teste.wsdl_status_servico.com'
	end

	it 'o método #method_wsdl deve pegar o valor do método operation_status_servico do gateway ' do
		gateway.expects(:operation_status_servico).returns(:operation_status_servico)
		subject.method_wsdl.must_equal :operation_status_servico
	end

	it 'o método #gateway_xml_version deve pegar o valor do método version_xml_status_servico do gateway ' do
		gateway.expects(:version_xml_status_servico).returns(:v3_20)
		subject.gateway_xml_version.must_equal :v3_20
	end

	describe '#xml_builder' do
		it "deve renderizar para o xml nfe_status_servico" do
			subject.expects(:render_xml).with('nfe_status_servico').returns('<ok>1</ok>')
			subject.xml_builder.must_equal '<ok>1</ok>'
		end
	end

	describe "Validação do XML através do XSD" do		
		it "Deve ser válido em ambiente de produção" do
			subject.env = :production
			nfe_must_be_valid_by_schema 'consStatServ_v3.10.xsd'
		end
		it "Deve ser válido em ambiente de homologação" do
			subject.env = :test
			nfe_must_be_valid_by_schema 'consStatServ_v3.10.xsd'
		end
	end

end