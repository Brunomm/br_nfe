require 'test_helper'

describe BrNfe::Service::Simpliss::V1::Base do
	subject             { FactoryGirl.build(:service_simpliss_v1_base, emitente: emitente) }
	let(:rps)           { FactoryGirl.build(:br_nfe_rps, :completo) }
	let(:emitente)      { FactoryGirl.build(:service_emitente) }
	let(:intermediario) { FactoryGirl.build(:intermediario) }

	describe "inheritance class" do
		it { subject.class.superclass.must_equal BrNfe::Service::Base }
	end

	describe "#url_wsdl" do
		before do
			subject.env = :production
		end		
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da SIMPLISS" do
			subject.ibge_code_of_issuer_city = '4202008'
			subject.env = :test
			subject.url_wsdl.must_equal 'http://wshomologacao.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		it "se codigo da cidade emitente for 4202008 então deve pagar a URL de Balneário Camboriú" do
			subject.ibge_code_of_issuer_city = '4202008'
			subject.url_wsdl.must_equal 'http://wsbalneariocamboriu.simplissweb.com.br/nfseservice.svc?wsdl'
		end
	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				'xmlns:ns1' => "http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd",
				'xmlns:ns2' => "http://www.w3.org/2000/09/xmldsig#",
				'xmlns:ns3' => "http://www.sistema.com.br/Sistema.Ws.Nfse",
				'xmlns:ns4' => "http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"
			})
		end
	end

	describe "#namespaces" do
		it '-> namespace_identifier'    do subject.namespace_identifier.must_equal 'ns3:'    end
		it '-> namespace_for_tags'      do subject.namespace_for_tags.must_equal 'ns1:'      end
		it '-> namespace_for_signature' do subject.namespace_for_signature.must_equal 'ns2:' end
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
			dados = "<ns3:rootTag>"
			dados += '<xml>Builder</xml>'
			dados += "</ns3:rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da Simpliss" do
			subject.expects(:soap_body_root_tag).returns('rootTag').twice	
			subject.expects(:xml_builder).returns('<xml>Builder</xml>')
			subject.content_xml.must_equal expected_xml
		end
	end

	describe "#ts_item_lista_servico" do
		it "se passar um valor já formatado deve retornar esse mesmo valor" do
			subject.ts_item_lista_servico('7.90').must_equal '7.90'
		end
		it "se passar um valor inteiro deve formatar para NN.NN" do
			subject.ts_item_lista_servico(1785).must_equal '17.85'
		end
		it "se passar um valor inteiro com apenas 1 caracter deve retornar esse unico caractere" do
			subject.ts_item_lista_servico(1).must_equal '1'
		end
		it "se passar um valor com mais de 4 posições deve reotrnar apenas 4 numeros e 1 ponto" do
			subject.ts_item_lista_servico(123456).must_equal '12.34'
		end
		it "se passar nil deve retornar o um valor em branco e não da erro" do
			subject.ts_item_lista_servico(nil).must_be_nil
		end
		it "deve ignorar os Zeros da frente do número" do
			subject.ts_item_lista_servico('0458').must_equal '4.58'
		end
	end

end