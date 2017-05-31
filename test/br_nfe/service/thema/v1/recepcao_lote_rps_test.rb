require 'test_helper'

describe BrNfe::Service::Thema::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:service_thema_v1_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente, natureza_operacao: '50')   }
	
	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::ConsultaNfsPorRps inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :recepcionar_lote_rps }
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'recepcionarLoteRps'
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

	it "Deve assinar todos os RPS's corretamente" do
		lote_sem_assinatura = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/enviar_lote_rps.xml")
		lote_assinado = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/enviar_lote_rps_signed.xml")		
		
		subject.lote_rps = [BrNfe::Service::Rps.new(numero: 9), BrNfe::Service::Rps.new(numero: 10)]
		subject.numero_lote_rps = 9

		subject.stubs(:render_xml).with('servico_enviar_lote_rps_envio').returns(lote_sem_assinatura)

		subject.xml_builder.must_equal lote_assinado
	end

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.url_wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_remessa.xml') )
		end
		after  { savon.unmock! }

		it "Quando gravou o RPS com sucesso deve setar seus valores corretamente na resposta" do
			fixture = read_fixture('service/response/thema/v1/recepcao_lote_rps/success.xml')
			
			savon.expects(:recepcionar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.status.must_equal :success
			response.protocolo.must_equal '2916414'
			response.data_recebimento.must_equal Time.parse('2016-08-15T14:55:01.271Z')
			response.numero_lote.must_equal '17'
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/recepcao_lote_rps/error.xml')
			
			savon.expects(:recepcionar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.protocolo.must_be_nil
			response.data_recebimento.must_be_nil
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