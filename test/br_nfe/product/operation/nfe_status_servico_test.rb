require 'test_helper'

describe BrNfe::Product::Operation::NfeStatusServico do
	subject { FactoryGirl.build(:product_operation_nfe_status_servico) }
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
		describe 'for XML version 2.00' do
			before { subject.stubs(:gateway_xml_version).returns(:v2_00) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consStatServ_v2.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consStatServ_v2.00.xsd'
			end
		end
		describe 'for XML version 3.10' do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
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

	describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
		let(:xml_success) { read_fixture('product/response/v3.10/nfe_status_servico/success.xml') } 
		let(:xml_fail)    { read_fixture('product/response/v3.10/nfe_status_servico/fail.xml') } 
		before do 
			savon.mock!
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('product/wsdl/NfeStatusServico2.xml') )
		end
		after  { savon.unmock! }

		it "Quando serviço estiver ONLINE" do
			savon.expects(subject.method_wsdl).returns(xml_success)
			subject.request
			response = subject.response

			response.environment.must_equal :production
			response.app_version.must_equal 'SVRS201610061549'
			response.processed_at.must_equal Time.parse('2017-01-05T17:26:03-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '107'
			response.processing_status_motive.must_equal 'Servico em Operacao'
			response.processing_status.must_equal :success

			response.uf.must_equal '42'
			response.average_time.must_equal 1
			response.observation.must_equal ''
			response.return_prevision.must_be_nil
			response.status.must_equal :online
		end

		it "Quando serviço estiver OFFLINE" do
			savon.expects(subject.method_wsdl).returns(xml_fail)
			subject.request
			response = subject.response

			response.environment.must_equal :test
			response.app_version.must_equal 'SVRS201610061549'
			response.processed_at.must_equal Time.parse('2017-01-05T17:26:03-02:00')
			response.protocol.must_be_nil
			response.request_status.must_equal :success
			response.processing_status_code.must_equal '108'
			response.processing_status_motive.must_equal 'Serviço Paralisado Temporariamente'
			response.processing_status.must_equal :offline

			response.uf.must_equal '42'
			response.average_time.must_equal 0
			response.observation.must_equal 'NOSSO WEBSERVEICE É UMA BOSTA'
			response.return_prevision.must_equal Time.parse('2017-01-05T17:30:03-02:00')
			response.status.must_equal :offline
		end
	end

end