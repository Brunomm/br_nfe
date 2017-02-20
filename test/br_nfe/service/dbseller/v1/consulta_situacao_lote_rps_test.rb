require 'test_helper'

describe BrNfe::Service::Dbseller::V1::ConsultaSituacaoLoteRps do
	subject             { FactoryGirl.build(:service_dbseller_v1_consulta_situacao_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	it { must validate_presence_of(:protocolo) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Dbseller::V1::Base }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_situacao_lote_rps }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/dbseller/V1'}

		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válidado pelo schema" do

				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	# describe "#request and set response" do
	# 	before do 
	# 		savon.mock!
	# 		stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/dbseller/v1/nfseservice.xml') )
	# 	end
	# 	after  { savon.unmock! }

	# 	it "Quando processou o RPS com sucesso deve setar a situation com :success" do
	# 		fixture = read_fixture('service/response/dbseller/v1/consulta_situacao_lote_rps/success.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :success
	# 		response.numero_lote.must_equal '10'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando processou o RPS com erros deve setar a situation com :error" do
	# 		fixture = read_fixture('service/response/dbseller/v1/consulta_situacao_lote_rps/error.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :error
	# 		response.numero_lote.must_equal '13'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando não processou o RPS deve setar a situation com :unprocessed" do
	# 		fixture = read_fixture('service/response/dbseller/v1/consulta_situacao_lote_rps/unprocessed.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :unprocessed
	# 		response.numero_lote.must_equal '11'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando não encontrar o RPS deve setar a situation com :unreceived" do
	# 		fixture = read_fixture('service/response/dbseller/v1/consulta_situacao_lote_rps/unreceived.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :unreceived
	# 		response.numero_lote.must_equal '12'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando a requisição voltar com erro deve setar os erros corretamente" do
	# 		fixture = read_fixture('service/response/dbseller/v1/consulta_situacao_lote_rps/fault.xml')
			
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.numero_lote.must_be_nil
	# 		response.situation.must_equal :error
	# 		response.status.must_equal :falied
	# 		response.error_messages.size.must_equal 1
	# 		response.error_messages[0][:code].must_equal 'E900'
	# 		response.error_messages[0][:message].must_equal 'Chamada ao método retornou erro.'
	# 		response.error_messages[0][:solution].must_equal 'Entre em contato com o fornecedor do serviço para mais informações'
	# 		response.successful_request?.must_equal true
	# 	end
	# end
end