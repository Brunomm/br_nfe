require 'test_helper'

describe BrNfe::Service::Thema::V1::ConsultaSituacaoLoteRps do
	subject             { FactoryGirl.build(:service_thema_v1_consulta_situacao_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	it { must validate_presence_of(:protocolo) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::ConsultaLoteRps }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :consultar_situacao_lote_rps }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'consultarSituacaoLoteRps'
	end

	describe "#url_wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			subject.env = :test
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
		end
		describe 'Para a cidade 4205902 - Gaspar-SC' do
			before { subject.ibge_code_of_issuer_city = '4205902' }
			it "ambiente de produção" do
				subject.env = :production
				subject.url_wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl'
			end			
		end	 	
	end
	
	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/thema/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
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
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_consulta.xml') )
		end
		after  { savon.unmock! }

		it "Quando processou o RPS com sucesso deve setar a situation com :success" do
			fixture = read_fixture('service/response/thema/v1/consulta_situacao_lote_rps/success.xml')
			savon.expects(:consultar_situacao_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :success, "#{response.inspect}"
			response.numero_lote.must_equal '11'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando processou o RPS com erros deve setar a situation com :error" do
			fixture = read_fixture('service/response/thema/v1/consulta_situacao_lote_rps/error.xml')
			savon.expects(:consultar_situacao_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :error
			response.numero_lote.must_equal '11'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando não processou o RPS deve setar a situation com :unprocessed" do
			fixture = read_fixture('service/response/thema/v1/consulta_situacao_lote_rps/unprocessed.xml')
			savon.expects(:consultar_situacao_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unprocessed
			response.numero_lote.must_equal '11'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando não encontrar o RPS deve setar a situation com :unreceived" do
			fixture = read_fixture('service/response/thema/v1/consulta_situacao_lote_rps/unreceived.xml')
			savon.expects(:consultar_situacao_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :unreceived
			response.numero_lote.must_equal '0'
			response.status.must_equal :falied
			response.successful_request?.must_equal true

			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E86'
			response.error_messages[0][:message].must_equal 'Número do protocolo de recebimento do lote inexistente na base de dados'
			response.error_messages[0][:solution].must_equal 'Confira se o lote foi enviado e informe o número correto do protocolo de recebimento.'
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/consulta_situacao_lote_rps/fault.xml')
			
			savon.expects(:consultar_situacao_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
			response.situation.must_equal :error
			response.numero_lote.must_be_nil
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E515'
			response.error_messages[0][:message].must_equal 'Erro ao validar assinatura. - Certificado usado para assinar a remessa não é do prestador e nem de empresa autorizada.'
			response.error_messages[0][:solution].must_be_nil
			response.successful_request?.must_equal true
		end
	end
end