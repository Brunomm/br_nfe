require 'test_helper'

describe BrNfe::Service::Fisslex::V1::ConsultaSituacaoLoteRps do
	subject             { FactoryGirl.build(:service_fisslex_v1_consulta_situacao_lote_rps, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	it { must validate_presence_of(:protocolo) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Fisslex::V1::Base }
	end

	describe "#wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			subject.env = :test
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
		end
		
		describe 'Para a cidade 5101704 - Barra do Bugres - MT' do
			before { subject.ibge_code_of_issuer_city = '5101704' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end
		
		describe 'Para a cidade 5105101 - Juara - MT' do
			before { subject.ibge_code_of_issuer_city = '5105101' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juara.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 5105150 - Juina - MT' do
			before { subject.ibge_code_of_issuer_city = '5105150' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juina.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end
		
		describe 'Para a cidade 5106232 - Nova Olimpia - MT' do
			before { subject.ibge_code_of_issuer_city = '5106232' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107248 - Santa Carmem - MT' do
			before { subject.ibge_code_of_issuer_city = '5107248' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107800 - Santo António do Leverger - MT' do
			before { subject.ibge_code_of_issuer_city = '5107800' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107875 - Sapezal - MT' do
			before { subject.ibge_code_of_issuer_city = '5107875' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107909 - Sinop - MT' do
			before { subject.ibge_code_of_issuer_city = '5107909' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end

		describe 'Para a cidade 1100106 - Guajará-Mirim - RO' do
			before { subject.ibge_code_of_issuer_city = '1100106' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl'
			end
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :execute }
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/fisslex/V1' }
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válidado pelo schema" do
				# Só assim para passar na validação XSD.
				# o XSD não consegue validar os namespaces pois estão declarados na
				# tag envelope.
				subject.stubs(:message_namespaces).returns({'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"})
				subject.stubs(:namespace_identifier).returns(nil)
				subject.stubs(:namespace_for_tags).returns(nil)
				subject.stubs(:namespace_for_signature).returns(nil)

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
	# 		stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/fisslex/v1/NfseServices.svc.xml') )
	# 	end
	# 	after  { savon.unmock! }

	# 	it "Quando processou o RPS com sucesso deve setar a situation com :success" do
	# 		fixture = read_fixture('service/response/fisslex/v1/consulta_situacao_lote_rps/success.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :success
	# 		response.numero_lote.must_equal '2'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando processou o RPS com erros deve setar a situation com :error" do
	# 		fixture = read_fixture('service/response/fisslex/v1/consulta_situacao_lote_rps/error.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :error
	# 		response.numero_lote.must_equal '1'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando não processou o RPS deve setar a situation com :unprocessed" do
	# 		fixture = read_fixture('service/response/fisslex/v1/consulta_situacao_lote_rps/unprocessed.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :unprocessed
	# 		response.numero_lote.must_equal '3'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando não encontrar o RPS deve setar a situation com :unreceived" do
	# 		fixture = read_fixture('service/response/fisslex/v1/consulta_situacao_lote_rps/unreceived.xml')
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.situation.must_equal :unreceived
	# 		response.numero_lote.must_equal '4'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando a requisição voltar com erro deve setar os erros corretamente" do
	# 		fixture = read_fixture('service/response/fisslex/v1/consulta_situacao_lote_rps/fault.xml')
			
	# 		savon.expects(:consultar_situacao_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::ConsultaSituacaoLoteRps
	# 		response.numero_lote.must_be_nil
	# 		response.situation.must_equal :error
	# 		response.status.must_equal :falied
	# 		response.error_messages.size.must_equal 1
	# 		response.error_messages[0][:code].must_equal 'E50'
	# 		response.error_messages[0][:message].must_equal 'Inscricao Municipal do pretador inválida'
	# 		response.error_messages[0][:solution].must_equal 'Informe a inscricao municipal correta do prestador. '
	# 		response.successful_request?.must_equal true
	# 	end
	# end
end