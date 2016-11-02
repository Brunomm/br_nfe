require 'test_helper'

describe BrNfe::Service::MG::BeloHorizonte::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:br_nfe_service_mg_bh_v1_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:service_emitente)   }
	let(:rps_1)    { FactoryGirl.build(:br_nfe_rps, valor_pis: '', valor_cofins: nil, valor_inss: nil, valor_ir: nil, valor_csll: nil) } 
	let(:rps_2)    { FactoryGirl.build(:br_nfe_rps, :completo) } 

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::MG::BeloHorizonte::V1::Base }
	end

	it "deve ter incluso as regras de RecepcaoLoteRps" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::RecepcaoLoteRps
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

	describe '#lote_rps_fixed_attributes' do
		it "deve por padrão adicionar a versão do XML na tag do lote" do
			subject.lote_rps_fixed_attributes[:versao].must_equal '1.00'
			subject.lote_rps = [rps_1]
			subject.numero_lote_rps = 50
			subject.xml_builder[60..100].must_include '<LoteRps Id="L50" versao="1.00">'
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :recepcionar_lote_rps }
	end

	describe "#soap_body_root_tag" do
		it { subject.soap_body_root_tag.must_equal 'RecepcionarLoteRpsRequest' }
	end

	describe "Validação do XML através do XSD" do
		let(:rps_basico) { FactoryGirl.build(:br_nfe_rps)              } 
		let(:rps_completo) { FactoryGirl.build(:br_nfe_rps, :completo) } 
		
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/mg/belo_horizonte/v1/xsd' }
		
		def validate_schema
			Dir.chdir(schemas_dir) do
				schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
				document = Nokogiri::XML(subject.xml_builder)
				errors = schema.validate(document)
				errors.must_be_empty "#{subject.xml_builder}"
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
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/mg/belo_horizonte/v1.xml') )
		end
		after  { savon.unmock! }

		it "Quando gravou o RPS com sucesso deve setar seus valores corretamente na resposta" do
			fixture = read_fixture('service/response/mg/belo_horizonte/v1/recepcao_lote_rps/success.xml')
			skip "\n\n ----->>>  Testar depois com dados reais <<<-----\n\n"
			savon.expects(:recepcionar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.data_recebimento.must_equal DateTime.parse('2009-09-25T12:57:07')
			response.protocolo.must_equal 'Ak0591217L2009q000000006'
			response.numero_lote.must_equal '1'
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/mg/belo_horizonte/v1/recepcao_lote_rps/error.xml')
			
			skip "\n\n ----->>>  Testar depois com dados reais <<<-----\n\n"
			savon.expects(:recepcionar_lote_rps).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::RecepcaoLoteRps
			response.protocolo.must_be_nil
			response.data_recebimento.must_be_nil
			response.numero_lote.must_be_nil
			response.status.must_equal :falied
			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal 'E69'
			response.error_messages[0][:message].must_equal 'O documento XML do cabeçalho de dados esta fora do padrao especificado.'
			response.error_messages[0][:solution].must_be_nil
			response.successful_request?.must_equal true
		end
	end

end