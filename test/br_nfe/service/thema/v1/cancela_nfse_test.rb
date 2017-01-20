require 'test_helper'

describe BrNfe::Service::Thema::V1::CancelaNfse do
	subject             { FactoryGirl.build(:service_thema_v1_cancela_nfse, emitente: emitente) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }

	describe "superclass" do
		it { subject.class.superclass.must_equal BrNfe::Service::Thema::V1::Base }
	end

	it "deve conter as regras de BrNfe::Service::Concerns::Rules::CancelamentoNfs inclusas" do
		subject.class.included_modules.must_include BrNfe::Service::Concerns::Rules::CancelamentoNfs
	end

	describe "#method_wsdl" do
		it { subject.method_wsdl.must_equal :cancelar_nfse }
	end

	describe "#wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl'
			subject.env = :test
			subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl'
		end
		describe 'Para a cidade 4205902 - Gaspar-SC' do
			before { subject.ibge_code_of_issuer_city = '4205902' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl'
			end
		end
		
		describe 'Para a cidade 4316808 - Santa Cruz do Sul-RS' do
			before { subject.ibge_code_of_issuer_city = '4316808' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.santacruz.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://grphml.santacruz.rs.gov.br/thema-nfse-hml/services/NFSEcancelamento?wsdl'
			end
		end
		
		describe 'Para a cidade 4303103 - Cachoeirinha-RS' do
			before { subject.ibge_code_of_issuer_city = '4303103' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.cachoeirinha.rs.gov.br/nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.cachoeirinha.rs.gov.br/nfse/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4307708 - Esteio-RS' do
			before { subject.ibge_code_of_issuer_city = '4307708' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://grp.esteio.rs.gov.br/nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://grp.esteio.rs.gov.br/nfsehml/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4311403 - Lajeado-RS' do
			before { subject.ibge_code_of_issuer_city = '4311403' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.lajeado.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehml.lajeado.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4312401 - Montenegro-RS' do
			before { subject.ibge_code_of_issuer_city = '4312401' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://nfe.montenegro.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://nfsehml.montenegro.rs.gov.br/nfsehml/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4312658 - Não-Me-Toque-RS' do
			before { subject.ibge_code_of_issuer_city = '4312658' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.naometoquers.com.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			# it "ambiente de testes" do
			# 	subject.env = :test
			# 	subject.wsdl.must_equal ''
			# end
		end

		describe 'Para a cidade 4314100 - Passo Fundo-RS' do
			before { subject.ibge_code_of_issuer_city = '4314100' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.pmpf.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4317608 - Santo Antônio da Patrulha-RS' do
			before { subject.ibge_code_of_issuer_city = '4317608' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.pmsap.com.br/nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.pmsap.com.br/nfsehml/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4318705 - São Leopoldo-RS' do
			before { subject.ibge_code_of_issuer_city = '4318705' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfe.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfehomologacao.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4321204 - Taquara-RS' do
			before { subject.ibge_code_of_issuer_city = '4321204' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.taquara.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.taquara.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
		end

		describe 'Para a cidade 4322608 - Venâncio Aires-RS' do
			before { subject.ibge_code_of_issuer_city = '4322608' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfe.venancioaires.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfehml.venancioaires.rs.gov.br/thema-nfse/services/NFSEcancelamento?wsdl'
			end
		end 	
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

	describe "#request and set response" do
		before do 
			savon.mock!
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_cancelamento.xml') )
		end
		after  { savon.unmock! }

		it "Quando cancelou a NF com sucesso" do
			fixture = read_fixture('service/response/thema/v1/cancela_nfse/success.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.must_be_kind_of BrNfe::Service::Response::Cancelamento
			response.data_hora_cancelamento.must_equal Time.parse('2016-08-15T13:50:31.016Z')
			response.codigo_cancelamento.must_equal 'E506'
			response.numero_nfs.must_equal '201600000000005'

			response.status.must_equal :success
			response.successful_request?.must_equal true
		end

		it "Quando a requisição voltar com erro deve setar os erros corretamente" do
			fixture = read_fixture('service/response/thema/v1/cancela_nfse/fault.xml')
			
			savon.expects(:cancelar_nfse).returns(fixture)
			subject.request
			response = subject.response

			response.data_hora_cancelamento.must_be_nil
			
			response.status.must_equal :falied

			response.error_messages.size.must_equal 1
			response.error_messages[0][:code].must_equal     'E505'
			response.error_messages[0][:message].must_equal  'E505-Código da Cancelamento Não existe na tabela de erros e alertas'
			response.error_messages[0][:solution].must_be_nil
			response.successful_request?.must_equal true
		end
	end

	describe "#xml_builder deve assinar o cancelamento corretamente" do
		it "deve retornar o XMl assinado e comparar com um template testado" do
			xml_sem_assinatura = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/cancelar_nfse_envio.xml")
			xml_assinado = File.read("#{BrNfe.root}/test/fixtures/service/thema/v1/cancelar_nfse_envio_signed.xml")		
			
			subject.id_cancelamento = '5544'
			
			subject.stubs(:render_xml).with('servico_cancelar_nfse_envio').returns(xml_sem_assinatura)

			subject.xml_builder.must_equal xml_assinado
		end
	end

end