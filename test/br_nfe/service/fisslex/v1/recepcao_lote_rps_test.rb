require 'test_helper'

describe BrNfe::Service::Fisslex::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:service_fisslex_v1_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente)   }
	
	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Fisslex::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
	end

	describe "#wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			subject.env = :test
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
		end
		
		describe 'Para a cidade 5101704 - Barra do Bugres - MT' do
			before { subject.ibge_code_of_issuer_city = '5101704' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end
		
		describe 'Para a cidade 5105101 - Juara - MT' do
			before { subject.ibge_code_of_issuer_city = '5105101' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juara.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 5105150 - Juina - MT' do
			before { subject.ibge_code_of_issuer_city = '5105150' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juina.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end
		
		describe 'Para a cidade 5106232 - Nova Olimpia - MT' do
			before { subject.ibge_code_of_issuer_city = '5106232' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107248 - Santa Carmem - MT' do
			before { subject.ibge_code_of_issuer_city = '5107248' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107800 - Santo António do Leverger - MT' do
			before { subject.ibge_code_of_issuer_city = '5107800' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107875 - Sapezal - MT' do
			before { subject.ibge_code_of_issuer_city = '5107875' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 5107909 - Sinop - MT' do
			before { subject.ibge_code_of_issuer_city = '5107909' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end

		describe 'Para a cidade 1100106 - Guajará-Mirim - RO' do
			before { subject.ibge_code_of_issuer_city = '1100106' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl'
			end
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :execute }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'WS_RecepcionarLoteRps.Execute'
	end

	describe "#content_xml" do
		let(:expected_xml) do
			dados =  "<fiss:rootTag>"
			dados +=  "<fiss:Enviarloterpsenvio>"
			dados +=  	"<xml>Builder</xml>"
			dados +=  "</fiss:Enviarloterpsenvio>"
			dados += "</fiss:rootTag>"
			dados
		end
	end
	
	describe "Validação do XML através do XSD" do
		let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
		let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
		
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/fisslex/V1' }
		
		def validate_schema
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
		it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
			subject.lote_rps = [rps_completo]
			validate_schema
		end
		it "Deve ser válido com 1 RPS com apenas as informações obrigatórias preenchidas" do
			subject.lote_rps = [rps_basico]
			validate_schema
		end
		it "Deve ser válido com vários RPS's - 1 rps completo e 1 parcial" do
			subject.assign_attributes(certificate_pkcs12_password: nil, certificate_pkcs12_path: nil, username: '23020443000140', password: '33161107')
			subject.lote_rps = [rps_completo, rps_basico]
			validate_schema
		end
	end

	# describe "#request and set response" do
	# 	before do 
	# 		savon.mock!
	# 		stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/fisslex/v1/NfseServices.svc.xml') )
	# 	end
	# 	after  { savon.unmock! }

	# 	it "Quando gravou o RPS com sucesso deve setar seus valores corretamente na resposta" do
	# 		fixture = read_fixture('service/response/fisslex/v1/recepcao_lote_rps/success.xml')
			
	# 		savon.expects(:recepcionar_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
	# 		response.protocolo.must_equal '128277'
	# 		response.data_recebimento.must_equal Time.parse('2016-07-28T16:17:18.4043985-03:00')
	# 		response.numero_lote.must_equal '10'
	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando a requisição voltar com erro deve setar os erros corretamente" do
	# 		fixture = read_fixture('service/response/fisslex/v1/recepcao_lote_rps/error.xml')
			
	# 		savon.expects(:recepcionar_lote_rps).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
	# 		response.protocolo.must_be_nil
	# 		response.data_recebimento.must_be_nil
	# 		response.numero_lote.must_be_nil
	# 		response.status.must_equal :falied
	# 		response.error_messages.size.must_equal 1
	# 		response.error_messages[0][:code].must_equal 'E903'
	# 		response.error_messages[0][:message].must_equal 'Já existe lote protocolado com esse número para o mesmo cnpj e inscrição municipal.'
	# 		response.error_messages[0][:solution].must_equal 'Altere o número do lote.'
	# 		response.successful_request?.must_equal true
	# 	end
	# end
end

