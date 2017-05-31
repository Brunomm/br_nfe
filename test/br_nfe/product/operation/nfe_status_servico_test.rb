require 'test_helper'

describe BrNfe::Product::Operation::NfeStatusServico do
	subject { FactoryGirl.build(:product_operation_nfe_status_servico) }

	describe '#xml_builder' do
		it "Deve renderizar o XML e setar o valor na variavel @xml_builder" do
			subject.expects(:render_xml).returns('<xml>OK</xml>')
			
			subject.xml_builder.must_equal '<xml>OK</xml>'
			subject.instance_variable_get(:@xml_builder).must_equal '<xml>OK</xml>'
		end
		it "Se já houver valor setado na variavel @xml_builder não deve renderizar o xml novamente" do
			subject.instance_variable_set(:@xml_builder, '<xml>OK</xml>')
			subject.expects(:render_xml).never
			subject.xml_builder.must_equal '<xml>OK</xml>'
		end
	end

	describe "Validação do XML através do XSD" do		
		describe 'for XML version 2.00' do
			before { subject.stubs(:gateway_xml_version).returns(:v2_00) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consStatServ_v2.00.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consStatServ_v2.00.xsd'
			end
		end
	end

	context "Validações para NF-e versão 3.10" do
		before do
			subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
		end
		describe "Validação do XML através do XSD" do
			before { subject.stubs(:gateway_xml_version).returns(:v3_10) }
			it "Deve ser válido em ambiente de produção" do
				subject.env = :production
				nfe_must_be_valid_by_schema 'consStatServ_v3.10.xsd'
			end
			it "Deve ser válido em ambiente de homologação" do
				subject.env = :test
				nfe_must_be_valid_by_schema 'consStatServ_v3.10.xsd'
			end
		end
		describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
			let(:xml_success) { read_fixture('product/response/v3.10/nfe_status_servico/success.xml') } 
			let(:xml_fail)    { read_fixture('product/response/v3.10/nfe_status_servico/fail.xml') } 
			before do 
				savon.mock!
				stub_request(:get, subject.client_wsdl.globals[:wsdl]).to_return(status: 200, body: read_fixture('product/wsdl/NfeStatusServico2.xml') )
			end
			after  { savon.unmock! }

			it "Quando serviço estiver ONLINE" do
				savon.expects(subject.method_wsdl).returns(xml_success)
				subject.request
				response = subject.response

				response.environment.must_equal :production
				response.app_version.must_equal 'SVRS201610061549'
				response.processed_at.must_equal Time.parse('2017-01-05T17:26:03-02:00')
				response.protocol.must_be_nil
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '107'
				response.processing_status_motive.must_equal 'Servico em Operacao'
				response.processing_status.must_equal :success

				response.uf.must_equal '42'
				response.average_time.must_equal 1
				response.observation.must_equal ''
				response.return_prevision.must_be_nil
				response.status.must_equal :online
			end

			it "Quando serviço estiver OFFLINE" do
				savon.expects(subject.method_wsdl).returns(xml_fail)
				subject.request
				response = subject.response

				response.environment.must_equal :test
				response.app_version.must_equal 'SVRS201610061549'
				response.processed_at.must_equal Time.parse('2017-01-05T17:26:03-02:00')
				response.protocol.must_be_nil
				response.request_status.must_equal :success
				response.processing_status_code.must_equal '108'
				response.processing_status_motive.must_equal 'Serviço Paralisado Temporariamente'
				response.processing_status.must_equal :offline

				response.uf.must_equal '42'
				response.average_time.must_equal 0
				response.observation.must_equal 'NOSSO WEBSERVEICE É UMA BOSTA'
				response.return_prevision.must_equal Time.parse('2017-01-05T17:30:03-02:00')
				response.status.must_equal :offline
			end
		end
		describe 'Configurações por UF dos parametros para instanciar o client Soap' do
			let(:client_wsdl) { subject.client_wsdl } 
			describe 'UF 12 - Acre' do
				before { subject.ibge_code_of_issuer_uf = '12' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 27 - Alagoas' do
				before { subject.ibge_code_of_issuer_uf = '27' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 16 - Amapá' do
				before { subject.ibge_code_of_issuer_uf = '16' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 13 - Amazonas' do
				before { subject.ibge_code_of_issuer_uf = '13' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 29 - Bahia' do
				before { subject.ibge_code_of_issuer_uf = '29' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 23 - Ceará' do
				before { subject.ibge_code_of_issuer_uf = '23' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 53 - Distrito Federal' do
				before { subject.ibge_code_of_issuer_uf = '53' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 32 - Espírito Santo' do
				before { subject.ibge_code_of_issuer_uf = '32' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 52 - Goiás' do
				before { subject.ibge_code_of_issuer_uf = '52' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 21 - Maranhão' do
				before { subject.ibge_code_of_issuer_uf = '21' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVAN
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 51 - Mato Grosso' do
				before { subject.ibge_code_of_issuer_uf = '51' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 50 - Mato Grosso do Sul' do
				before { subject.ibge_code_of_issuer_uf = '50' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 31 - Minas Gerais' do
				before { subject.ibge_code_of_issuer_uf = '31' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 15 - Pará' do
				before { subject.ibge_code_of_issuer_uf = '15' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVAN
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 25 - Paraíba' do
				before { subject.ibge_code_of_issuer_uf = '25' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 41 - Paraná' do
				before { subject.ibge_code_of_issuer_uf = '41' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 26 - Pernambuco' do
				before { subject.ibge_code_of_issuer_uf = '26' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 22 - Piauí' do
				before { subject.ibge_code_of_issuer_uf = '22' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCRS_for_SVC_mode
				end
			end
			describe 'UF 33 - Rio de Janeiro' do
				before { subject.ibge_code_of_issuer_uf = '33' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 24 - Rio Grande do Norte' do
				before { subject.ibge_code_of_issuer_uf = '24' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 43 - Rio Grande do Sul' do
				before { subject.ibge_code_of_issuer_uf = '43' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 11 - Rondônia' do
				before { subject.ibge_code_of_issuer_uf = '11' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 14 - Roraima' do
				before { subject.ibge_code_of_issuer_uf = '14' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 42 - Santa Catarina' do
				before { subject.ibge_code_of_issuer_uf = '42' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 35 - São Paulo' do
				before { subject.ibge_code_of_issuer_uf = '35' }
				it "configurações para e emissão normal no ambiente de produção" do
					subject.env = :production
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 28 - Sergipe' do
				before { subject.ibge_code_of_issuer_uf = '28' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
			describe 'UF 17 - Tocantins' do
				before { subject.ibge_code_of_issuer_uf = '17' }
				it "Deve utilizar o servidor SVRS para emissão normal" do
					must_use_SVRS
				end
				it "Deve usar o servidor SVCAN para emissão em Contingência" do
					must_use_SVCAN_for_SVC_mode
				end
			end
		end
	end


private
	def must_use_SVRS
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
	def must_use_SVAN
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCAN_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCRS_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
end