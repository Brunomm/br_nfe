require 'test_helper'

describe BrNfe::Product::Operation::NfeAutorizacao do
	subject { FactoryGirl.build(:product_operation_nfe_autorizacao) }
	let(:nota_fiscal) { FactoryGirl.build(:product_nota_fiscal) } 

	describe '#aliases' do
		it { must_have_alias_attribute :idLote,  :numero_lote }
		it { must_have_alias_attribute :indSinc, :sincrono, true }
	end

	describe 'Validations' do
		it { must validate_presence_of(:numero_lote) }
		it { must validate_length_of(:numero_lote).is_at_most(15) }
		it { must validate_numericality_of(:numero_lote).only_integer }
		it { must allow_value('123456789012345').for(:numero_lote) }
	end

	describe '#notas_fiscais' do
		it { must_validate_length_has_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, {minimum: 1, maximum: 50})  }
		it { must_validates_has_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, :invalid_invoice) }
		it { must_have_many(:notas_fiscais, BrNfe.nota_fiscal_product_class, {codigo_nf: '1233', serie: '1'})  }
	end

	it "o attr sincrono deve sempre retornar um boolean" do
		must_returns_a_boolean_for :sincrono
	end

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

	context "Ao gerar o XML do lote deve setar o XML de cada nota no atributo xml da nf" do
		let(:subject) { FactoryGirl.build(:product_operation_nfe_autorizacao, :for_signature_test) }
		let(:nf1) { subject.notas_fiscais[0] }
		let(:nf2) { subject.notas_fiscais[1] }
		it "Para a versão 3.10 da NF" do
			subject.stubs(:gateway_xml_version).returns(:v3_10)
			nf1.xml.must_be_nil
			nf2.xml.must_be_nil

			subject.xml_builder

			nf1.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000021201601015"'
			nf2.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000501201601012"'

			nf1.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
			nf2.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
		end
		it "Para a versão 2.00 da NF" do
			subject.stubs(:gateway_xml_version).returns(:v2_00)
			nf1.xml.must_be_nil
			nf2.xml.must_be_nil

			subject.xml_builder

			nf1.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000021201601015"'
			nf2.xml[0..108].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe42161266622465000192550010000000501201601012"'

			nf1.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
			nf2.xml[-57..-1].must_equal '</X509Certificate></X509Data></KeyInfo></Signature></NFe>'
		end
	end


	describe "Validação da assinatura da NF-e" do
		it "deve assinar a NF-e corretamente de acordo com uma NF-e já testada e homologada" do
			# Esse teste serve para validar que a estrutura para assinar a NF-e não foi modificada
			# e corrompida.
			aut = FactoryGirl.build(:product_operation_nfe_autorizacao, :for_signature_test)
			aut.content_xml.must_equal read_fixture('product/operation/nfe_autorizacao/nfe_signed.xml')
		end
	end
	context "Validações para NF-e versão 3.10" do
		before do
			subject.assign_attributes(nfe_version: :v3_10, ibge_code_of_issuer_uf: '42', env: :test)
		end
		describe "Validação do XML através do XSD" do
			subject { FactoryGirl.build(:product_operation_nfe_autorizacao, :complete) }
			context "Para a versão 3.10" do
				it "Deve ser válido em ambiente de produção" do
					subject.env = :production
					subject.valid?.must_equal true, "#{subject.errors.full_messages}"
					nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
				end
				it "Deve ser válido em ambiente de homologação" do
					subject.env = :test
					subject.valid?.must_equal true, "#{subject.errors.full_messages}"
					nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
				end
				it "Deve ser válido com mais de uma nota" do
					nf2 = subject.notas_fiscais[0].dup
					nf2.numero_nf = nf2.numero_nf.to_i+1
					subject.notas_fiscais << nf2
					subject.valid?.must_equal true, "#{subject.errors.full_messages}"
					nfe_must_be_valid_by_schema 'enviNFe_v3.10.xsd'
				end
			end
		end
		describe 'REQUEST MUST BE SET RESPONSE CORRECTLY' do
			let(:original_xml)           { read_fixture('product/response/v3.10/nfe_autorizacao/original_xml.xml') } 
			let(:response_async_fail)    { read_fixture('product/response/v3.10/nfe_autorizacao/async_fail.xml') }
			let(:response_async_success) { read_fixture('product/response/v3.10/nfe_autorizacao/async_success.xml') }
			let(:response_sync_fail)     { read_fixture('product/response/v3.10/nfe_autorizacao/sync_fail.xml') }
			let(:response_sync_success)  { read_fixture('product/response/v3.10/nfe_autorizacao/sync_success.xml') }
			let(:xml_nfe_without_proc)   { read_fixture('product/response/v3.10/nfe_autorizacao/nfe/without_proc.xml') }
			let(:xml_nfe_with_proc)      { read_fixture('product/response/v3.10/nfe_autorizacao/nfe/with_proc.xml') }
			before do
				# Seto a chave da NF com o mesmo valor das chaves que estão nas fixtures
				nota_fiscal.chave_de_acesso = '42161208897094000155550010000000041201601018'
				subject.notas_fiscais = [nota_fiscal]

				savon.mock!
				stub_request(:get, 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl').to_return(status: 200, body: read_fixture('product/wsdl/NfeAutorizacao.xml') )
			end
			after  { savon.unmock! }

			context 'Requisições assíncronas' do
				it 'Qaundo houver SUCESSO no processamento - deve setar os valores na resposta e na NF' do
					# Valido que não deve ter protocolo setado antes da requisição
					nota_fiscal.protocol.must_be_nil

					subject.assign_attributes(sincrono: false)
					savon.expects(subject.method_wsdl).returns(response_async_success)
					subject.request
					response = subject.response

					response.must_be_kind_of BrNfe::Product::Response::NfeAutorizacao
				
					response.request_status.must_equal :success
					response.processing_status.must_equal :success
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-20T10:50:44-02:00')
					response.protocol.must_equal '423002169442281'
					response.processing_status_code.must_equal '103'
					response.processing_status_motive.must_equal 'Lote recebido com sucesso'
					response.notas_fiscais.must_equal([nota_fiscal])

					nota_fiscal.status.must_equal :success
					nota_fiscal.protocol.must_equal '423002169442281'
					nota_fiscal.processed_at.must_equal response.processed_at
					nota_fiscal.status_code.must_equal '103'
					nota_fiscal.status_motive.must_equal 'Lote recebido com sucesso'
				end
				it 'Qaundo houver SUCESSO no processamento - e tiver mais de 1 nf deve setar os valores em todas as notas' do
					# Valido que não deve ter protocolo setado antes da requisição
					nota_fiscal.protocol.must_be_nil
					nf2 = nota_fiscal.dup
					nf2.assign_attributes(chave_de_acesso: nil, numero_nf: 765)
					subject.notas_fiscais = [nota_fiscal, nf2]

					subject.assign_attributes(sincrono: false)
					savon.expects(subject.method_wsdl).returns(response_async_success)
					subject.request
					response = subject.response

					response.must_be_kind_of BrNfe::Product::Response::NfeAutorizacao
				
					response.request_status.must_equal :success
					response.processing_status.must_equal :success
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-20T10:50:44-02:00')
					response.protocol.must_equal '423002169442281'
					response.processing_status_code.must_equal '103'
					response.processing_status_motive.must_equal 'Lote recebido com sucesso'
					response.notas_fiscais.must_equal([nota_fiscal, nf2])

					nota_fiscal.protocol.must_equal '423002169442281'
					nota_fiscal.status.must_equal :success
					nota_fiscal.processed_at.must_equal response.processed_at
					nota_fiscal.status_code.must_equal '103'
					nota_fiscal.status_motive.must_equal 'Lote recebido com sucesso'

					nf2.protocol.must_equal '423002169442281'
					nf2.status.must_equal :success
					nf2.processed_at.must_equal response.processed_at
					nf2.status_code.must_equal '103'
					nf2.status_motive.must_equal 'Lote recebido com sucesso'
				end
				it 'XDD Qaundo NÃO houver SUCESSO no processamento - deve setar os valores em todas as notas' do
					# Valido que não deve ter protocolo setado antes da requisição
					nota_fiscal.protocol.must_be_nil
					nf2 = nota_fiscal.dup
					nf2.assign_attributes(chave_de_acesso: nil, numero_nf: 765)
					subject.notas_fiscais = [nota_fiscal, nf2]

					subject.assign_attributes(sincrono: false)
					savon.expects(subject.method_wsdl).returns(response_async_fail)
					subject.request
					response = subject.response

					response.must_be_kind_of BrNfe::Product::Response::NfeAutorizacao
				
					response.request_status.must_equal :success
					response.processing_status.must_equal :error
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-27T16:36:27-02:00')
					response.protocol.must_be_nil
					response.processing_status_code.must_equal '225'
					response.processing_status_motive.must_equal 'Rejeicao: Falha no Schema XML do lote de NFe'
					response.notas_fiscais.must_equal([nota_fiscal, nf2])

					nota_fiscal.protocol.must_be_nil
					nota_fiscal.status.must_be_nil
					nota_fiscal.processed_at.must_be_nil
					nota_fiscal.status_code.must_be_nil
					nota_fiscal.status_motive.must_be_nil

					nf2.protocol.must_be_nil
					nf2.status.must_be_nil
					nf2.processed_at.must_be_nil
					nf2.status_code.must_be_nil
					nf2.status_motive.must_be_nil
				end
			end
			context 'Requisições síncronas' do
				it 'Qaundo houver SUCESSO e a NF-e tem xml setado - deve setar os valores na resposta e na NF deve ajustar o xml para colocar a tag nfeProc' do
					# Valido que não deve ter protocolo setado antes da requisição
					nota_fiscal.protocol.must_be_nil

					subject.assign_attributes(sincrono: true)
					savon.expects(subject.method_wsdl).returns(response_sync_success)
					subject.request

					# Antes de chamar a resposta a NF-e deve ter o XML da NF
					nota_fiscal.xml[0..63].must_equal '<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe  Id="NFe'
					nota_fiscal.xml[-6..-1].must_equal '</NFe>'

					# Agora vou setar um XML fixo na NF para que seja 
					# modificado conforme o esperado. Não vou usar o xml original
					# pois o mesmo pode ser modificado conforme novas regras vão surgindo.
					# e não é o objetivo desse teste validar as regras de campos do xml, e sim
					# se está ajustando o valor corretamente.
					nota_fiscal.xml = xml_nfe_without_proc
					
					# Ao chamar o response irá setar a tag <nfeProc> no XML da NF-e
					# e também irá adicionar o protocolo de autorização
					response = subject.response

					response.request_status.must_equal :success
					response.processing_status.must_equal :success
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-27T16:39:28-02:00')
					response.protocol.must_equal '342160000822005'
					response.processing_status_code.must_equal '104'
					response.processing_status_motive.must_equal 'Lote processado'
					response.notas_fiscais.must_equal([nota_fiscal])

					nota_fiscal.status.must_equal :success
					nota_fiscal.protocol.must_equal '342160000822005'
					nota_fiscal.processed_at.must_equal Time.parse('2016-12-27T16:39:27-02:00')
					nota_fiscal.status_code.must_equal '100'
					nota_fiscal.status_motive.must_equal 'Autorizado o uso da NF-e'

					# Deve adicionar a tag <nfeProc> com o protocolo de autorização dentro
					nota_fiscal.xml.must_equal xml_nfe_with_proc
				end

				it 'Qaundo houver SUCESSO e a NF-e NÃO TEM xml setado, deve considerar o xml do atributo original_xml para buscar a nota e setar o protocolo no XML' do
					nota_fiscal.protocol = nil
					nota_fiscal.xml = nil

					subject.assign_attributes(sincrono: true)

					# É setado um XML fixo no builder para que esteja de acordo com as regras do teste
					subject.instance_variable_set(:@xml_builder, original_xml)
					savon.expects(subject.method_wsdl).returns(response_sync_success)
					subject.request

					# Antes de chamar a resposta a NF-e não deve ter XML setado
					nota_fiscal.xml.must_be_nil

					# Ao chamar o response irá setar a tag <nfeProc> no XML da NF-e
					# e também irá adicionar o protocolo de autorização.
					# Irá considerar o XML que for setado em original_xml
					response = subject.response

					response.request_status.must_equal :success
					response.processing_status.must_equal :success
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-27T16:39:28-02:00')
					response.protocol.must_equal '342160000822005'
					response.processing_status_code.must_equal '104'
					response.processing_status_motive.must_equal 'Lote processado'
					response.notas_fiscais.must_equal([nota_fiscal])

					nota_fiscal.status.must_equal :success
					nota_fiscal.protocol.must_equal '342160000822005'
					nota_fiscal.processed_at.must_equal Time.parse('2016-12-27T16:39:27-02:00')
					nota_fiscal.status_code.must_equal '100'
					nota_fiscal.status_motive.must_equal 'Autorizado o uso da NF-e'

					# Deve adicionar a tag <nfeProc> com o protocolo de autorização dentro
					nota_fiscal.xml.must_equal xml_nfe_with_proc
				end

				it 'Qaundo houver ERRO deve setaro os valores da resposta e não pode alterar o XML da nota' do
					nota_fiscal.protocol = nil
					nota_fiscal.xml = xml_nfe_without_proc

					subject.assign_attributes(sincrono: true)

					# É setado um XML fixo no builder para que esteja de acordo com as regras do teste
					subject.instance_variable_set(:@xml_builder, original_xml)
					savon.expects(subject.method_wsdl).returns(response_sync_fail)
					subject.request

					# Antes de chamar a resposta a NF-e não deve ter XML setado
					nota_fiscal.xml.wont_be_nil

					# Ao chamar o response irá setar a tag <nfeProc> no XML da NF-e
					# e também irá adicionar o protocolo de autorização.
					# Irá considerar o XML que for setado em original_xml
					response = subject.response

					response.request_status.must_equal :success
					response.processing_status.must_equal :success
					response.environment.must_equal :test
					response.app_version.must_equal 'SVRS201603081012'
					response.processed_at.must_equal Time.parse('2016-12-27T16:42:12-02:00')
					response.protocol.must_equal ''
					response.processing_status_code.must_equal '104'
					response.processing_status_motive.must_equal 'Lote processado'
					response.notas_fiscais.must_equal([nota_fiscal])

					nota_fiscal.status.must_equal :error
					nota_fiscal.protocol.must_equal ''
					nota_fiscal.processed_at.must_equal Time.parse('2016-12-27T16:37:12-02:00')
					nota_fiscal.status_code.must_equal '204'
					nota_fiscal.status_motive.must_equal 'Rejeicao: Duplicidade de NF-e [chNFe:42161208897094000155550010000000041201601018]'

					# Não deve mudar o xml original da nota
					nota_fiscal.xml.must_equal xml_nfe_without_proc
				end
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal true
					client_wsdl.globals[:headers].must_equal( {:'Content-Type' => 'application/soap+xml; charset=utf-8'} )
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :TLSv1
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
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
					client_wsdl.globals[:wsdl].must_equal 'https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx?wsdl'
					client_wsdl.globals[:ssl_verify_mode].must_equal :none
					client_wsdl.globals[:ssl_version].must_equal :SSLv3
					client_wsdl.globals[:follow_redirects].must_equal false
					client_wsdl.globals[:headers].must_be_nil
				end
				it "configurações para e emissão normal no ambiente de teste" do
					subject.env = :test
					client_wsdl.globals[:wsdl].must_equal 'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx?wsdl'
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
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end
	def must_use_SVAN
		subject.env = :production
		client_wsdl.globals[:wsdl].must_equal 'https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.env = :test
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCAN_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://hom.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :TLSv1
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

	def must_use_SVCRS_for_SVC_mode
		subject.assign_attributes(env: :production, tipo_emissao: :svc)
		client_wsdl.globals[:wsdl].must_equal 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil

		subject.instance_variable_set(:@client_wsdl, nil)
		subject.assign_attributes(env: :test, tipo_emissao: :svc)
		client_wsdl = subject.client_wsdl
		client_wsdl.globals[:wsdl].must_equal 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx?wsdl'
		client_wsdl.globals[:ssl_verify_mode].must_equal :none
		client_wsdl.globals[:ssl_version].must_equal :SSLv3
		client_wsdl.globals[:follow_redirects].must_equal false
		client_wsdl.globals[:headers].must_be_nil
	end

end
