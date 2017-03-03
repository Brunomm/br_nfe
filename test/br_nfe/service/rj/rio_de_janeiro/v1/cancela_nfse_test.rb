require 'test_helper'

describe BrNfe::Service::RJ::RioDeJaneiro::V1::CancelaNfse do
	subject             { FactoryGirl.build(:service_rj_rj_v1_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::RJ::RioDeJaneiro::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	it "#body_xml_path" do
		subject.body_xml_path.must_equal []
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'CancelarNfseRequest'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/rj/rio_de_janeiro/V1' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('tipos_nfse_v01.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/rj/rio_de_janeiro/v1/nfse.asmx.xml') )
		end
		after  { savon.unmock! }

		it "Quando cancelou a NF com sucesso" do
			fixture = read_fixture('service/response/rj/rio_de_janeiro/v1/cancela_nfse/success.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::Cancelamento
			response.data_hora_cancelamento.must_equal Time.parse('2016-07-29T09:38:24.4803985-03:00')
			response.codigo_cancelamento.must_equal '2'
			response.numero_nfs.must_equal '3'

			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/rj/rio_de_janeiro/v1/cancela_nfse/fault.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.data_hora_cancelamento.must_be_nil
			
			response.status.must_equal :falied

			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal     'E973'
			response.error_messages[0][:message].must_equal  'Assinatura : Cancelamento_NF5544'
			response.error_messages[0][:solution].must_equal 'Verifique a assinatura do elemento'

			response.successful_request?.must_equal true
		end
	end

end