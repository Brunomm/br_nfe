require 'test_helper'

describe BrNfe::Service::MG::BeloHorizonte::V1::CancelaNfse do
	subject        { FactoryGirl.build(:br_nfe_service_mg_bh_v1_cancela_nfse, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente)   }
	
	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::MG::BeloHorizonte::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'CancelarNfse'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/mg/belo_horizonte/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "O XML deve ser válido com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
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
			skip "\n\n ----->>>  Testar depois com dados reais <<<-----\n\n"
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/mg/belo_horizonte/v1.xml') )
		end
		after  { savon.unmock! }

		it "Quando cancelou a NF com sucesso" do
			fixture = read_fixture('service/response/thema/v1/cancela_nfse/success.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::Cancelamento
			response.data_hora_cancelamento.must_equal Time.parse('2016-08-15T13:50:31.016Z')
			response.codigo_cancelamento.must_equal 'E506'
			response.numero_nfs.must_equal '201600000000005'

			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/cancela_nfse/fault.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.data_hora_cancelamento.must_be_nil
			
			response.status.must_equal :falied

			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal     'E505'
			response.error_messages[0][:message].must_equal  'E505-Código da Cancelamento Não existe na tabela de erros e alertas'
			response.error_messages[0][:solution].must_be_nil
			response.successful_request?.must_equal true
		end
	end

	describe "#xml_builder deve assinar o cancelamento corretamente" do
		it "deve retornar o XMl assinado e comparar com um template testado" do
			skip "\n\n ----->>>  Testar depois com dados reais <<<-----\n\n"
			xml_sem_assinatura = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/cancelar_nfse_envio.xml")
			xml_assinado = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/cancelar_nfse_envio_signed.xml")		
			
			subject.id_cancelamento = '5544'
			
			subject.stubs(:render_xml).with('servico_cancelar_nfse_envio').returns(xml_sem_assinatura)

			subject.xml_builder.must_equal xml_assinado
		end
	end

end