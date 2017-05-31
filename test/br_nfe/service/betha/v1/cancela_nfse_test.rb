require 'test_helper'

describe BrNfe::Service::Betha::V1::CancelaNfse do
	subject             { FactoryGirl.build(:servico_betha_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	it "o certificado deve ser obrigatório" do
		subject.certificado_obrigatorio?.must_equal true
	end
	
	describe "#url_wsdl" do
		context "for env production" do
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/cancelarNfse?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/cancelarNfse?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse_envio }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_cancelar_nfse_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/betha/v1/cancelar_nfse.xml') )
		end
		after  { savon.unmock! }

		it "Quando cancelou a NF com sucesso" do
			fixture = read_fixture('service/response/betha/v1/cancela_nfse/success.xml')
			savon.expects(:cancelar_nfse_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::Cancelamento
			response.data_hora_cancelamento.must_equal Time.parse('2016-09-21T17:33:45.718-03:00')
			response.codigo_cancelamento.must_equal '2'
			response.numero_nfs.must_equal '3188'

			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/betha/v1/cancela_nfse/fault.xml')
			
			savon.expects(:cancelar_nfse_envio).returns(fixture)
			subject.request
			response = subject.response

			response.data_hora_cancelamento.must_be_nil
			
			response.status.must_equal :falied

			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal     'E42'
			response.error_messages[0][:message].must_equal  'Código do município da prestação do serviço inválido.'
			response.error_messages[0][:solution].must_equal 'Informe o código do município onde foi prestado o serviço, conforme Tabela de Municípios do IBGE.'

			response.successful_request?.must_equal true
		end
	end

end