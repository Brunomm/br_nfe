require 'test_helper'

describe BrNfe::Service::Betha::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente)   }
	let(:rps_1)    { FactoryGirl.build(:br_nfe_rps, valor_pis: '', valor_cofins: nil, valor_inss: nil, valor_ir: nil, valor_csll: nil) } 
	let(:rps_2)    { FactoryGirl.build(:br_nfe_rps, :completo) } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	describe "validations" do
		it { must validate_presence_of(:numero_lote_rps) }
		context "validações do certificado" do
			before do
				subject.certificate_pkcs12 = nil
				subject.certificate_pkcs12_value = nil
				subject.certificate_pkcs12_password = nil
			end
			it { must validate_presence_of(:certificate) }
			it { must validate_presence_of(:certificate_key) }
		end
		
		it "deve chamar o metodo validar_lote_rps" do
			subject.expects(:validar_lote_rps)
			subject.valid?
		end
	end

	describe "#url_wsdl" do
		context "for env production" do
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/recepcionarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.url_wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/recepcionarLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :enviar_lote_rps_envio }
	end

	describe "Validação do XML através do XSD" do
		let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
		let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
		
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
		
		def validate_schema
			Dir.chdir(schemas_dir) do
				schema = Nokogiri::XML::Schema(IO.read('servico_enviar_lote_rps_envio_v01.xsd'))
				document = Nokogiri::XML(subject.content_xml)
				errors = schema.validate(document)
				errors.must_be_empty "#{subject.content_xml}"
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
			subject.lote_rps = [rps_completo, rps_basico]
			validate_schema
		end
	end

	it "Deve adicionar a tag InscricaoMunicipal no XML" do
		subject.lote_rps = [rps_1]
		# Esse test foi feito devido a sobrescrita do XML _tc_identificacao_prestador
		subject.emitente.inscricao_municipal = '12345'
		subject.emitente.cpf_cnpj = '12345678901234'
		content_xml = Nori.new.parse(subject.content_xml).deep_transform_keys!{|k| k.to_s.underscore.to_sym}
		prestador =  content_xml[:'ns1:enviar_lote_rps_envio'][:lote_rps][:lista_rps][:rps][:inf_rps][:prestador]
		
		prestador[:cnpj].must_equal '12345678901234'
		prestador[:inscricao_municipal].must_equal '12345'
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/betha/v1/recepcionar_lote_rps.xml') )
		end
		after  { savon.unmock! }

		it "Quando gravou o RPS com sucesso deve setar seus valores corretamente na resposta" do
			fixture = read_fixture('service/response/betha/v1/recepcao_lote_rps/success.xml')
			
			savon.expects(:enviar_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.protocolo.must_equal '925721130413341'
			response.data_recebimento.must_equal Time.parse('2016-09-22T18:11:20.310-03:00')
			response.numero_lote.must_equal '1'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/betha/v1/recepcao_lote_rps/error.xml')
			
			savon.expects(:enviar_lote_rps_envio).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.protocolo.must_be_nil
			response.data_recebimento.must_be_nil
			response.numero_lote.must_be_nil
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E44'
			response.error_messages[0][:message].must_equal 'CNPJ do prestador inválido'
			response.error_messages[0][:solution].must_equal 'Informe o número do CNPJ correto do prestador.'
			response.successful_request?.must_equal true
		end
	end

end