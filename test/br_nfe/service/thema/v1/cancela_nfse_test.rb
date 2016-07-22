require 'test_helper'

describe BrNfe::Service::Thema::V1::CancelaNfse do
	subject             { FactoryGirl.build(:service_thema_v1_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	describe "#response_path_module" do
		it "deve ter o module ServicoCancelarNfseResposta" do
			subject.response_path_module.must_equal BrNfe::Service::Response::Paths::V1::ServicoCancelarNfseResposta
		end
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal []
	end

	it "#body_xml_path" do
		subject.body_xml_path.must_equal [:cancelar_nfse_response, :return]
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'cancelarNfse'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/thema/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				# Por algum motivo o XSD não valida a assinatura XML
				subject.certificate_pkcs12_password = nil
				subject.certificate_pkcs12_path = nil

				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

end