require 'test_helper'

describe BrNfe::Service::Simpliss::V1::CancelaNfse do
	subject             { FactoryGirl.build(:service_simpliss_v1_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Simpliss::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	describe "#response_path_module" do
		it "deve ter o module ServicoCancelarNfseResposta" do
			subject.response_path_module.must_equal BrNfe::Service::Simpliss::V1::ResponsePaths::ServicoCancelarNfseResposta
		end
	end

	it "#response_root_path" do
		subject.response_root_path.must_equal [:cancelar_nfse_response]
	end

	it "#body_xml_path" do
		subject.body_xml_path.must_equal []
	end

	it "#soap_body_root_tag" do
		subject.soap_body_root_tag.must_equal 'CancelarNfse'
	end

	describe "Validação do XML através do XSD" do
		let(:schemas_dir) { BrNfe.root+'/test/br_nfe/service/simpliss/v1/xsd' }
				
		describe "Validações a partir do arquivo XSD" do
			it "Deve ser válido com 1 RPS com todas as informações preenchidas" do
				# Só assim para passar na validação XSD.
				# o XSD não consegue validar os namespaces pois estão declarados na
				# tag envelope.
				subject.stubs(:message_namespaces).returns({'xmlns' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"})
				subject.stubs(:namespace_identifier).returns(nil)
				subject.stubs(:namespace_for_tags).returns(nil)
				subject.stubs(:namespace_for_signature).returns(nil)
					
				Dir.chdir(schemas_dir) do
					schema = Nokogiri::XML::Schema(IO.read('nfse_3.xsd'))
					document = Nokogiri::XML(subject.xml_builder)
					errors = schema.validate(document)
					errors.must_be_empty
				end
			end
		end
	end

	describe "#request and set response" do
		before { savon.mock!   }
		after  { savon.unmock! }

		it "Quando cancelou a NF com sucesso" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/simpliss/v1/cancela_nfse/success.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.cancelation_date_time.must_equal Time.parse('2016-07-29T09:38:24.4803985-03:00')
			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = File.read(BrNfe.root+'/test/fixtures/service/response/simpliss/v1/cancela_nfse/fault.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.protocolo.must_be_nil
			response.data_recebimento.must_be_nil
			response.numero_lote.must_be_nil
			response.cancelation_date_time.must_be_nil
			
			response.status.must_equal :falied

			response.error_messages.size.must_equal 2
			response.error_messages[0][:code].must_equal     'E6'
			response.error_messages[0][:message].must_equal  'Essa Nfs-e não pode ser cancelada através desse serviço, pois há crédito informado.'
			response.error_messages[0][:solution].must_equal 'O cancelamento de uma Nfs-e com crédito deve ser feito através de processo administrativo aberto em uma repartição fazendária.'

			response.error_messages[1][:code].must_equal     'E79'
			response.error_messages[1][:message].must_equal  'Essa Nfs-e já está cancelada.'
			response.error_messages[1][:solution].must_equal 'Confira e informe novamente os dados da Nfs-e que deseja cancelar.'

			response.successful_request?.must_equal true
		end
	end

end