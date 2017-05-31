require 'test_helper'

describe BrNfe::Service::Thema::V1::RecepcaoLoteRpsLimitado do
	subject        { FactoryGirl.build(:service_thema_v1_recepcao_lote_rps_limitado, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, natureza_operacao: '50')   }
	
	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::RecepcaoLoteRps }
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :recepcionar_lote_rps_limitado }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'recepcionarLoteRpsLimitado'
	end

	describe "#url_wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			subject.env = :test
			subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
		end
		describe 'Para a cidade 4205902 - Gaspar-SC' do
			before { subject.ibge_code_of_issuer_city = '4205902' }
			it "ambiente de produção" do
				subject.env = :production
				subject.url_wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.url_wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			end			
		end	 	
	end
	
	describe "Validação do XML através do XSD" do
		let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
		let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
		
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/thema/v1/xsd' }
		
		def validate_schema
			subject.stubs(:certificate).returns(nil)			
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
			subject.lote_rps = [rps_completo, rps_basico]
			validate_schema
		end
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_remessa.xml') )
		end
		after  { savon.unmock! }

		it "Quando gravou o RPS com sucesso deve setar seus valores corretamente na resposta" do
			fixture = read_fixture('service/response/thema/v1/recepcao_lote_rps_limitado/success.xml')
			
			savon.expects(:recepcionar_lote_rps_limitado).returns(fixture)
			subject.request
			response = subject.response

			response.status.must_equal :success
			response.protocolo.must_equal '2916417'
			response.data_recebimento.must_equal Time.parse('2016-08-15T17:21:35.725Z')
			response.numero_lote.must_equal '14'
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/recepcao_lote_rps_limitado/error.xml')
			
			savon.expects(:recepcionar_lote_rps_limitado).returns(fixture)
			subject.request
			response = subject.response

			response.protocolo.must_equal '2916418'
			response.data_recebimento.must_equal Time.parse('2016-08-15T17:22:32.796Z')
			response.numero_lote.must_equal '14'
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E500'
			response.error_messages[0][:message].must_equal 'E500-Número de Lote já informado em outras remessas'
			response.error_messages[0][:solution].must_be_nil
			response.successful_request?.must_equal true
		end
	end
end