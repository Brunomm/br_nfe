require 'test_helper'

describe BrNfe::Service::Betha::V1::RecepcaoLoteRps do
	subject        { FactoryGirl.build(:br_nfe_servico_betha_recepcao_lote_rps, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente)   }
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

	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/recepcionarLoteRps?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/recepcionarLoteRps?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :enviar_lote_rps_envio }
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal [:enviar_lote_rps_envio_response]
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


end