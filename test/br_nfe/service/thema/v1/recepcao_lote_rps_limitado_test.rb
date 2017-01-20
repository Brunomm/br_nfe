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

	describe "#wsdl" do
		it "default" do
			subject.ibge_code_of_issuer_city = '111'
			subject.env = :production
			subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			subject.env = :test
			subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
		end
		describe 'Para a cidade 4205902 - Gaspar-SC' do
			before { subject.ibge_code_of_issuer_city = '4205902' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl'
			end
		end
		
		describe 'Para a cidade 4316808 - Santa Cruz do Sul-RS' do
			before { subject.ibge_code_of_issuer_city = '4316808' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.santacruz.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://grphml.santacruz.rs.gov.br/thema-nfse-hml/services/NFSEremessa?wsdl'
			end
		end
		
		describe 'Para a cidade 4303103 - Cachoeirinha-RS' do
			before { subject.ibge_code_of_issuer_city = '4303103' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.cachoeirinha.rs.gov.br/nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.cachoeirinha.rs.gov.br/nfse/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4307708 - Esteio-RS' do
			before { subject.ibge_code_of_issuer_city = '4307708' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://grp.esteio.rs.gov.br/nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://grp.esteio.rs.gov.br/nfsehml/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4311403 - Lajeado-RS' do
			before { subject.ibge_code_of_issuer_city = '4311403' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.lajeado.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehml.lajeado.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4312401 - Montenegro-RS' do
			before { subject.ibge_code_of_issuer_city = '4312401' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'https://nfe.montenegro.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'https://nfsehml.montenegro.rs.gov.br/nfsehml/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4312658 - Não-Me-Toque-RS' do
			before { subject.ibge_code_of_issuer_city = '4312658' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.naometoquers.com.br/thema-nfse/services/NFSEremessa?wsdl'
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
				subject.wsdl.must_equal 'http://nfse.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.pmpf.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4317608 - Santo Antônio da Patrulha-RS' do
			before { subject.ibge_code_of_issuer_city = '4317608' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.pmsap.com.br/nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.pmsap.com.br/nfsehml/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4318705 - São Leopoldo-RS' do
			before { subject.ibge_code_of_issuer_city = '4318705' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfe.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfehomologacao.saoleopoldo.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4321204 - Taquara-RS' do
			before { subject.ibge_code_of_issuer_city = '4321204' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.taquara.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsehomologacao.taquara.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
		end

		describe 'Para a cidade 4322608 - Venâncio Aires-RS' do
			before { subject.ibge_code_of_issuer_city = '4322608' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfe.venancioaires.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfehml.venancioaires.rs.gov.br/thema-nfse/services/NFSEremessa?wsdl'
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
			stub_request(:get, subject.wsdl).to_return(status: 200, body: read_fixture('service/wsdl/thema/v1/nfse_remessa.xml') )
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