require 'test_helper'

describe BrNfe::Service::Ciga::V1::Base do
	subject             { FactoryGirl.build(:service_ciga_v1_base, emitente: emitente) }
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
		it "se o env for de production deve enviar a requisição para o ambinete de produção da ciga" do
			subject.env = :production
			subject.wsdl.must_equal 'https://nfse.ciga.sc.gov.br/webservice/v1'
		end
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da ciga" do
			subject.env = :test
			subject.wsdl.must_equal 'https://nfse-testes.ciga.sc.gov.br/webservice/v1'
		end

	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({'xmlns' => "http://www.abrasf.org.br/nfse.xsd",})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				'xmlns:nfse'    => 'http://nfse.abrasf.org.br'
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
			dados =  "<nfse:rootTag>"
			dados <<		'<nfseCabecMsg>'
			dados <<			'<![CDATA[<versaoDados>1.00</versaoDados>]]>'
			dados <<		'</nfseCabecMsg>'
			dados <<		'<nfseDadosMsg>'
			dados << 		"<![CDATA[<xml>Builder</xml>]]>"
			dados <<		'</nfseDadosMsg>'
			dados << "</nfse:rootTag>"
			dados
		end

		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da ciga" do
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