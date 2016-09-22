require 'test_helper'

describe BrNfe::Service::Betha::V1::ConsultaSituacaoLoteRps do
	subject             { FactoryGirl.build(:servico_betha_consulta_situacao_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::ConsultaLoteRps }
	end

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/consultarSituacaoLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/consultarSituacaoLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_situacao_lote_rps_envio }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_consultar_situacao_lote_rps_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before { savon.mock!   }
		after  { savon.unmock! }

		it "Quando processou o RPS com sucesso deve setar a situation com :success" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/success.xml')
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :success
			response.numero_lote.must_equal '10'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando processou o RPS com erros deve setar a situation com :error" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/error.xml')
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :error
			response.numero_lote.must_equal '13'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando não processou o RPS deve setar a situation com :unprocessed" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/unprocessed.xml')
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unprocessed
			response.numero_lote.must_equal '11'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando não encontrar o RPS deve setar a situation com :unreceived" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/unreceived.xml')
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unreceived
			response.numero_lote.must_equal '12'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/fault.xml')
			
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.numero_lote.must_be_nil
			response.situation.must_equal :error
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E86'
			response.error_messages[0][:message].must_equal 'Número do protocolo de recebimento do lote inexistente na base de dados.'
			response.error_messages[0][:solution].must_equal 'Confira se o lote foi enviado e informe o número correto do protocolo de recebimento.'
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro E4 deve definir a situação como unreceived" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/unreceived_by_code_error.xml')
			
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unreceived
			response.numero_lote.must_be_nil
			response.status.must_equal :falied
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro E92 deve definir a situação como unprocessed" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/betha/v1/consulta_situacao_lote_rps/unprocessed_by_code_error.xml')
			
			savon.expects(:consultar_situacao_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unprocessed
			response.numero_lote.must_be_nil
			response.status.must_equal :falied
			response.successful_request?.must_equal true
		end
	end
end