require 'test_helper'
require 'br_nfe/helper/have_emitente_test'

describe BrNfe::Base do
	subject { FactoryGirl.build(:br_nfe_base, emitente: emitente) }
	let(:emitente) { FactoryGirl.build(:emitente) } 

	describe "validations" do
		context "obrigatoriedade do certificado" do
			it "deve ser obrigatorio se certificado_obrigatorio? for true" do
				subject.stubs(:certificado_obrigatorio?).returns(true)
				subject.certificate_pkcs12 = nil
				subject.certificate_pkcs12_value = nil
				subject.certificate_pkcs12_password = nil

				must validate_presence_of(:certificate)
				must validate_presence_of(:certificate_key)
			end
			it "não deve ser obrigatorio se certificado_obrigatorio? for false" do
				subject.stubs(:certificado_obrigatorio?).returns(false)
				subject.certificate_pkcs12 = nil
				wont validate_presence_of(:certificate)
				wont validate_presence_of(:certificate_key)
			end
		end
		context "validação do emitente" do
			it "se emitente for válido" do
				emitente.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				emitente.expects(:invalid?).returns(false)
				subject.valid?.must_equal true
				subject.errors.full_messages.must_equal( [] )				
			end

			it "se emitente for inválido" do
				emitente.stubs(:errors).returns(stub(full_messages: ["Erro rps"]))
				emitente.expects(:invalid?).returns(true)
				subject.valid?.must_equal false
				subject.errors.full_messages.must_equal( ["Emitente: Erro rps"] )
			end
		end
	end

	describe "#emitente" do
		include BrNfeTest::HelperTest::HaveEmitenteTest
	end
	
	describe "#env" do
		it "deve ter o valor :production por default" do
			BrNfe::Base.new.env.must_equal :production
		end

		it "deve permitir a modificação do valor" do
			BrNfe::Base.new(env: :test).env.must_equal :test
		end
	end

	describe "#wsdl_encoding" do
		it { subject.wsdl_encoding.must_equal 'UTF-8' }
	end

	it "certificado_obrigatorio?" do
		subject.certificado_obrigatorio?.must_equal false
	end

	describe "#certificate_pkcs12_value" do
		it "se tiver algum valor setado deve retornar esse valor" do
			subject.certificate_pkcs12_value = "algum valor"
			subject.certificate_pkcs12_value.must_equal "algum valor"
		end
		it "se não tiver um valor deve carregar o arquivo setado no atributo certificado_path" do
			subject.certificate_pkcs12_path = "algum/lugar.pfx"
			File.expects(:read).with("algum/lugar.pfx").returns("valor do arquivo")
			subject.certificate_pkcs12_value.must_equal "valor do arquivo"
		end
	end

	describe "#response" do
		it "deve retornar o valor da variavel @response" do
			subject.instance_variable_set(:@response, 'valor')
			subject.response.must_equal 'valor'
		end
		it "valor default" do
			subject.response.must_be_nil
		end
	end

	describe "#original_response" do
		it "deve retornar o valor da variavel @original_response" do
			subject.instance_variable_set(:@original_response, 'valor')
			subject.original_response.must_equal 'valor'
		end
		it "valor default" do
			subject.original_response.must_be_nil
		end
	end

	describe "#wsdl" do
		it "deve dar um erro por default" do
			assert_raises RuntimeError do
				subject.wsdl
			end
		end
	end

	describe "#env_namespace" do
		it "deve ser soapenv" do
			subject.env_namespace.must_equal :soapenv
		end
	end

	describe "#method_wsdl" do
		it "deve dar um erro por default" do
			assert_raises RuntimeError do
				subject.method_wsdl
			end
		end
	end

	describe "#xml_builder" do
		it "deve dar um erro por default" do
			assert_raises RuntimeError do
				subject.xml_builder
			end
		end
	end

	describe "#namespace_identifier" do
		it "deve dar um erro por default" do
			assert_raises RuntimeError do
				subject.namespace_identifier
			end
		end
	end

	describe "#namespaces" do
		it "valor padrão" do
			subject.namespaces.must_equal({})
		end
	end

	describe "#value_date" do
		context "deve retornar no formato YYYY-MM-DD" do
			it "Se passar uma string" do
				subject.send(:value_date, '12/07/2018').must_equal '2018-07-12'
			end
			it "Se passar um objeto data" do
				subject.send(:value_date, Date.parse('25/09/2000')).must_equal '2000-09-25'
			end
		end

		it "se passar um valor inválido retorna uma string vazia" do
			subject.send(:value_date, '25/09\00').must_equal ''
		end
	end

	describe "#value_date_time" do
		context "deve retornar no formato YYYY-MM-DDTHH:MM:SS" do
			it "Se passar uma string" do
				subject.send(:value_date_time, '12/07/2018').must_equal '2018-07-12T00:00:00'
			end
			it "Se passar um objeto data" do
				subject.send(:value_date_time, DateTime.parse('25/09/2000 03:56:28')).must_equal '2000-09-25T03:56:28'
			end
		end

		it "se passar um valor inválido retorna uma string vazia" do
			subject.send(:value_date_time, '25/09\00').must_equal ''
		end
	end

	describe "#canonicalize" do
		it "deve cannonicalizar uma string xml" do
			xml = '<?xml version="1.0" encoding="UTF-8"?>'+"<TagRaiz>\n\t<TagFilho>Texo Tag    \n\t\n\t     Filho</TagFilho>    \n</TagRaiz>    "
			subject.send(:canonicalize, xml).must_equal "<TagRaiz><TagFilho>Texo Tag    \n\t\n\t     Filho</TagFilho></TagRaiz>"
		end
		it "deve cannonicalizar um Document xml Nokogiri" do
			xml = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |x|
				x.TagRaiz{
					x.TagFilho "Texo Tag    \n\t\n\t     Filho"
				}
			end.doc
			subject.send(:canonicalize, xml).must_equal "<TagRaiz><TagFilho>Texo Tag    \n\t\n\t     Filho</TagFilho></TagRaiz>"
		end
	end

	describe "#remove_quebras" do
		it "deve remover as quebras de linhas e tabs de identação de uma string" do
			str = "    Uma \n\tString \n\tCom quebras    "
			subject.send(:remove_quebras, str).must_equal "Uma String Com quebras"
		end
	end

	describe "Assinatura" do
		let(:xml) { " <Um> <Xml> Com valor</Xml> \n\t</Um> " } 

		describe "#xml_digest_value" do
			it "deve receber um xml, canonicalizar - codificar para base64 e remover as quebras" do
				subject.expects(:remove_quebras).with("adQF8B5pegJ6uSDKv3qKnXCI5yQ=\n").returns("adQF8B5pegJ6uSDKv3qKnXCI5yQ=")
				subject.send(:xml_digest_value, xml).must_equal 'adQF8B5pegJ6uSDKv3qKnXCI5yQ='
			end
		end

		describe "#xml_signature_value" do
			it "deve assinar um xml com o certificado" do
				sh1 = OpenSSL::Digest::SHA1.new
				OpenSSL::Digest::SHA1.stubs(:new).returns(sh1)
				subject.certificate_pkcs12.key.expects(:sign).with(sh1, "<Um><Xml> Com valor</Xml></Um>").returns('mv\xBFH\xE3\xF5Z\x0F\xE1*0D')
				
				subject.send(:xml_signature_value, xml).must_equal 'bXZceEJGSFx4RTNceEY1Wlx4MEZceEUxKjBE'
			end
		end

		describe "#signed_info" do
			it "deve gerar a estrutura da tag SignedInfo" do
				subject.expects(:xml_digest_value).with(xml).returns("adQFGKGDJ6uSDKv3qKnXCI5yQ")
				signed_info = Nokogiri::XML( subject.send(:signed_info, xml).doc.root.to_s )
				
				signed_info.namespaces.must_equal({"xmlns"=>"http://www.w3.org/2000/09/xmldsig#"})
				signed_info.remove_namespaces!
				signed_info.xpath('SignedInfo/CanonicalizationMethod').first.attr("Algorithm").must_equal 'http://www.w3.org/2001/10/xml-exc-c14n#'
				signed_info.xpath('SignedInfo/SignatureMethod').first.attr("Algorithm").must_equal 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
				signed_info.xpath('SignedInfo/Reference').first.attr("URI").must_equal ''
				signed_info.xpath('SignedInfo/Reference/Transforms/Transform').first.attr("Algorithm").must_equal 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
				signed_info.xpath('SignedInfo/Reference/Transforms/Transform').last.attr("Algorithm").must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
				signed_info.xpath('SignedInfo/Reference/DigestMethod').first.attr("Algorithm").must_equal 'http://www.w3.org/2000/09/xmldsig#sha1'
				signed_info.xpath('SignedInfo/Reference/DigestValue').first.text.must_equal 'adQFGKGDJ6uSDKv3qKnXCI5yQ'
			end

			it "deve pegar a URI que for passada por parâmetro" do
				signed_info = Nokogiri::XML( subject.send(:signed_info, xml, 'new_uri').doc.root.to_s )
				
				signed_info.remove_namespaces!
				signed_info.xpath('SignedInfo/Reference').first.attr("URI").must_equal 'new_uri'
				
			end
		end


		describe "#assinatura_xml" do
			let(:xml_signed_info) do
				Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
					xml.Signature(xmlns: 'http://www.w3.org/2000/09/xmldsig#') {
						xml.Value 'STUBADO'
					}
				end
			end

			it "deve gerar o xml" do
				subject.stubs(:signed_info).with(xml, 'URI123').returns(xml_signed_info)
				subject.expects(:xml_signature_value).with('<Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><Value>STUBADO</Value></Signature>').returns("KEYFORINFOSIGNED")
				
				assinatura = Nokogiri::XML( subject.send(:assinatura_xml, xml, 'URI123') )

				assinatura.namespaces.must_equal({"xmlns"=>"http://www.w3.org/2000/09/xmldsig#"})
				assinatura.remove_namespaces!
				assinatura.xpath('Signature/Signature/Value').first.text.must_equal 'STUBADO'
				assinatura.xpath('Signature/SignatureValue').first.text.must_equal 'KEYFORINFOSIGNED'
				assinatura.xpath('Signature/KeyInfo/X509Data/X509Certificate').first.text.must_equal 'MIIEqzCCA5OgAwIBAgIDMTg4MA0GCSqGSIb3DQEBBQUAMIGSMQswCQYDVQQGEwJCUjELMAkGA1UECBMCUlMxFTATBgNVBAcTDFBvcnRvIEFsZWdyZTEdMBsGA1UEChMUVGVzdGUgUHJvamV0byBORmUgUlMxHTAbBgNVBAsTFFRlc3RlIFByb2pldG8gTkZlIFJTMSEwHwYDVQQDExhORmUgLSBBQyBJbnRlcm1lZGlhcmlhIDEwHhcNMDkwNTIyMTcwNzAzWhcNMTAxMDAyMTcwNzAzWjCBnjELMAkGA1UECBMCUlMxHTAbBgNVBAsTFFRlc3RlIFByb2pldG8gTkZlIFJTMR0wGwYDVQQKExRUZXN0ZSBQcm9qZXRvIE5GZSBSUzEVMBMGA1UEBxMMUE9SVE8gQUxFR1JFMQswCQYDVQQGEwJCUjEtMCsGA1UEAxMkTkZlIC0gQXNzb2NpYWNhbyBORi1lOjk5OTk5MDkwOTEwMjcwMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCx1O/e1Q+xh+wCoxa4pr/5aEFt2dEX9iBJyYu/2a78emtorZKbWeyK435SRTbHxHSjqe1sWtIhXBaFa2dHiukT1WJyoAcXwB1GtxjT2VVESQGtRiujMa+opus6dufJJl7RslAjqN/ZPxcBXaezt0nHvnUB/uB1K8WT9G7ES0V17wIDAQABo4IBfjCCAXowIgYDVR0jAQEABBgwFoAUPT5TqhNWAm+ZpcVsvB7malDBjEQwDwYDVR0TAQH/BAUwAwEBADAPBgNVHQ8BAf8EBQMDAOAAMAwGA1UdIAEBAAQCMAAwgawGA1UdEQEBAASBoTCBnqA4BgVgTAEDBKAvBC0yMjA4MTk3Nzk5OTk5OTk5OTk5MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDCgEgYFYEwBAwKgCQQHREZULU5GZaAZBgVgTAEDA6AQBA45OTk5OTA5MDkxMDI3MKAXBgVgTAEDB6AOBAwwMDAwMDAwMDAwMDCBGmRmdC1uZmVAcHJvY2VyZ3MucnMuZ292LmJyMCAGA1UdJQEB/wQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDBTBgNVHR8BAQAESTBHMEWgQ6BBhj9odHRwOi8vbmZlY2VydGlmaWNhZG8uc2VmYXoucnMuZ292LmJyL0xDUi9BQ0ludGVybWVkaWFyaWEzOC5jcmwwDQYJKoZIhvcNAQEFBQADggEBAJFytXuiS02eJO0iMQr/Hi+Ox7/vYiPewiDL7s5EwO8A9jKx9G2Baz0KEjcdaeZk9a2NzDEgX9zboPxhw0RkWahVCP2xvRFWswDIa2WRUT/LHTEuTeKCJ0iF/um/kYM8PmWxPsDWzvsCCRp146lc0lz9LGm5ruPVYPZ/7DAoimUk3bdCMW/rzkVYg7iitxHrhklxH7YWQHUwbcqPt7Jv0RJxclc1MhQlV2eM2MO1iIlk8Eti86dRrJVoicR1bwc6/YDqDp4PFONTi1ddewRu6elGS74AzCcNYRSVTINYiZLpBZO0uivrnTEnsFguVnNtWb9MAHGt3tkR0gAVs6S0fm8='
			end
		end

		describe "#certificate_pkcs12" do
			it "deve ler o certificate_pkcs12 PKCS12 do atributo certificate_pkcs12_value e com a senha do certificate_pkcs12_password" do
				subject.assign_attributes(certificate_pkcs12: nil, certificate_pkcs12_value: "CERTIFICADO", certificate_pkcs12_password: 'pWd123')
				OpenSSL::PKCS12.expects(:new).with("CERTIFICADO", 'pWd123').returns('certificate_pkcs12')
				subject.certificate_pkcs12.must_equal 'certificate_pkcs12'
			end
			it "se já tem um certificate_pkcs12 na variavel @certificate_pkcs12 não deve ler novamente do PKCS12" do
				base_nfe = FactoryGirl.build(:br_nfe_base, emitente: emitente, certificate_pkcs12_password: nil, certificate_pkcs12_path: nil)
				base_nfe.instance_variable_set(:@certificate_pkcs12, subject.certificate_pkcs12)

				subject.certificate_pkcs12.wont_be_nil
				
				OpenSSL::PKCS12.expects(:new).never
				base_nfe.certificate_pkcs12.must_equal subject.certificate_pkcs12
			end
			it "posso setar o certificate_pkcs12" do
				subject.certificate_pkcs12 = 'certificate_pkcs12 123'
				subject.certificate_pkcs12.must_equal 'certificate_pkcs12 123'
			end
		end


		describe "#client_wsdl" do
			before do 
				# Stub metodos para configuração do client WSDL
				subject.stubs(:namespaces).returns('namespaces')
				subject.stubs(:env_namespace).returns('env_namespace')
				subject.stubs(:wsdl).returns('wsdl')
				subject.stubs(:wsdl_encoding).returns('client_encoding')
				subject.stubs(:namespace_identifier).returns('namespace_identifier')
				# Ajusto a configuração da gem para testar
				BrNfe.client_wsdl_log                   = 'client_wsdl_log'
				BrNfe.client_wsdl_pretty_print_xml      = 'client_wsdl_pretty_print_xml'
				BrNfe.client_wsdl_ssl_verify_mode       = 'client_wsdl_ssl_verify_mode'
				BrNfe.client_wsdl_ssl_cert_file         = 'client_wsdl_ssl_cert_file'
				BrNfe.client_wsdl_ssl_cert_key_file     = 'client_wsdl_ssl_cert_key_file'
				BrNfe.client_wsdl_ssl_cert_key_password = 'client_wsdl_ssl_cert_key_password'
			end
			it "deve instanciar um Savon.client com a configuração adequada" do
				subject.instance_variable_get(:@client_wsdl).must_be_nil
				Savon.expects(:client).with({
					namespaces:            'namespaces',
					env_namespace:         'env_namespace',
					wsdl:                  'wsdl',
					namespace_identifier:  'namespace_identifier',
					log:                   'client_wsdl_log',
					encoding:              'client_encoding',
					pretty_print_xml:      'client_wsdl_pretty_print_xml',
					ssl_verify_mode:       'client_wsdl_ssl_verify_mode',
					ssl_cert_file:         'client_wsdl_ssl_cert_file',
					ssl_cert_key_file:     'client_wsdl_ssl_cert_key_file',
					ssl_cert_key_password: 'client_wsdl_ssl_cert_key_password'
				}).returns('client wsdl')

				subject.client_wsdl.must_equal 'client wsdl'
				subject.instance_variable_get(:@client_wsdl).must_equal 'client wsdl'
			end
			it "se ja tiver valor na variavel @client_wsdl deve manter esse valor" do
				Savon.expects(:client).never
				subject.instance_variable_set(:@client_wsdl, :valor_client_wsdl)
				subject.client_wsdl.must_equal :valor_client_wsdl
				subject.instance_variable_get(:@client_wsdl).must_equal :valor_client_wsdl
			end
		end
	end

end