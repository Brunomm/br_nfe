require 'test_helper'

describe BrNfe::Service::PR::Curitiba::V1::Base do
	subject             { FactoryGirl.build(:service_pr_curitiba_v1_base, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Base }
	end

	describe "#wsdl" do
		before do
			subject.env = :production
		end

		describe 'deve assumir alguma cidade por default se não for informado nenhum codigo da cidade' do
			before { subject.ibge_code_of_issuer_city = '' }
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://pilotoisscuritiba.curitiba.pr.gov.br/nfse_ws/nfsews.asmx?wsdl'
			end
		end

		# Curitiba - PR
		it "se codigo da cidade emitente for 4106902 então deve pagar a URL de Curitiba - PR" do
			subject.ibge_code_of_issuer_city = '4106902'
			subject.wsdl.must_equal 'https://isscuritiba.curitiba.pr.gov.br/Iss.NfseWebService/nfsews.asmx?wsdl'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação de curitiba" do
			subject.ibge_code_of_issuer_city = '4106902'
			subject.env = :test
			subject.wsdl.must_equal 'http://pilotoisscuritiba.curitiba.pr.gov.br/nfse_ws/nfsews.asmx?wsdl'
		end
	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({'xmlns' => "http://isscuritiba.curitiba.pr.gov.br/iss/nfse.xsd",})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
			})
		end
	end

	describe "#soap_body_root_tag" do
		it "por padrão deve dar um Raise pois é necessário que seja sobrescrito nas sublcasses" do
			assert_raises RuntimeError do
				subject.soap_body_root_tag
			end
		end
	end

	describe "#content_xml" do
		let(:expected_xml) do
			dados =  "<rootTag xmlns=\"http://www.e-governeapps2.com.br/\">"
			dados += 	"<xml>Builder</xml>"
			dados += "</rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão de curitiba" do
			subject.expects(:soap_body_root_tag).returns('rootTag').twice	
			subject.expects(:xml_builder).returns('<xml>Builder</xml>')
			subject.content_xml.must_equal expected_xml
		end
		it "Caso o xml_builder já vier com a tag <?xml não deve inserir a tag novamnete" do
			subject.expects(:soap_body_root_tag).returns('rootTag').twice	
			subject.expects(:xml_builder).returns('<xml>Builder</xml>')
			subject.content_xml.must_equal expected_xml
		end
	end

end