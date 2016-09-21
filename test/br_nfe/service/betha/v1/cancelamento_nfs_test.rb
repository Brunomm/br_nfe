require 'test_helper'

describe BrNfe::Service::Betha::V1::CancelamentoNfs do
	subject             { FactoryGirl.build(:servico_betha_cancelamento_nfs, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Betha::V1::Gateway }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	it "o certificado deve ser obrigatório" do
		subject.certificado_obrigatorio?.must_equal true
	end
	
	describe "#wsdl" do
		context "for env production" do
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-ws/cancelarNfseV02?wsdl' }
		end
		context "for env test" do
			before do 
				subject.env = :test
			end
			it { subject.wsdl.must_equal 'http://e-gov.betha.com.br/e-nota-contribuinte-test-ws/cancelarNfseV02?wsdl' }
		end
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse_envio }
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal [:cancelar_nfse_envio_response]
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/betha/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('servico_cancelar_nfse_envio_v01.xsd'))
					document = Nokogiri::XML(subject.content_xml)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

end