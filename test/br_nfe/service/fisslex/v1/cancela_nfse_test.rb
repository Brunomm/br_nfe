require 'test_helper'

describe BrNfe::Service::Fisslex::V1::CancelaNfse do
	subject             { FactoryGirl.build(:service_fisslex_v1_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Fisslex::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			subject.env = :test
			subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
		end
		
		describe 'Para a cidade 5101704 - Barra do Bugres - MT' do
			before { subject.ibge_code_of_issuer_city = '5101704' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end
		
		describe 'Para a cidade 5105101 - Juara - MT' do
			before { subject.ibge_code_of_issuer_city = '5105101' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juara.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 5105150 - Juina - MT' do
			before { subject.ibge_code_of_issuer_city = '5105150' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://juina.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end
		
		describe 'Para a cidade 5106232 - Nova Olimpia - MT' do
			before { subject.ibge_code_of_issuer_city = '5106232' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 5107248 - Santa Carmem - MT' do
			before { subject.ibge_code_of_issuer_city = '5107248' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 5107800 - Santo António do Leverger - MT' do
			before { subject.ibge_code_of_issuer_city = '5107800' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 5107875 - Sapezal - MT' do
			before { subject.ibge_code_of_issuer_city = '5107875' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 5107909 - Sinop - MT' do
			before { subject.ibge_code_of_issuer_city = '5107909' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end

		describe 'Para a cidade 1100106 - Guajará-Mirim - RO' do
			before { subject.ibge_code_of_issuer_city = '1100106' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl'
			end
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :execute }
		# it { subject.method_wsdl.must_equal :cancelamento_nfse }
	end

	it "#body_xml_path" do
		subject.body_xml_path.must_equal []
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'WS_CancelarNfse.Execute'
		# subject.soap_body_root_tag.must_equal 'CancelamentoNFSE'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/fixtures/service/schemas/fisslex/V1' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
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

	# 	it "Quando cancelou a NF com sucesso" do
	# 		fixture = read_fixture('service/response/fisslex/v1/cancela_nfse/success.xml')
			
	# 		savon.expects(:cancelar_nfse).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.must_be_kind_of BrNfe::Service::Response::Cancelamento
	# 		response.data_hora_cancelamento.must_equal Time.parse('2016-07-29T09:38:24.4803985-03:00')
	# 		response.codigo_cancelamento.must_equal '2'
	# 		response.numero_nfs.must_equal '3'

	# 		response.status.must_equal :success
	# 		response.successful_request?.must_equal true
	# 	end

	# 	it "Quando a requisição voltar com erro deve setar os erros corretamente" do
	# 		fixture = read_fixture('service/response/fisslex/v1/cancela_nfse/fault.xml')
			
	# 		savon.expects(:cancelar_nfse).returns(fixture)
	# 		subject.request
	# 		response = subject.response

	# 		response.data_hora_cancelamento.must_be_nil
			
	# 		response.status.must_equal :falied

	# 		response.error_messages.size.must_equal 2
	# 		response.error_messages[0][:code].must_equal     'E6'
	# 		response.error_messages[0][:message].must_equal  'Essa Nfs-e não pode ser cancelada através desse serviço, pois há crédito informado.'
	# 		response.error_messages[0][:solution].must_equal 'O cancelamento de uma Nfs-e com crédito deve ser feito através de processo administrativo aberto em uma repartição fazendária.'

	# 		response.error_messages[1][:code].must_equal     'E79'
	# 		response.error_messages[1][:message].must_equal  'Essa Nfs-e já está cancelada.'
	# 		response.error_messages[1][:solution].must_equal 'Confira e informe novamente os dados da Nfs-e que deseja cancelar.'

	# 		response.successful_request?.must_equal true
	# 	end
	# end

end