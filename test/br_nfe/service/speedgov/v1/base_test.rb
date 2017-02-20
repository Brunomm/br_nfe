require 'test_helper'

describe BrNfe::Service::Speedgov::V1::Base do
	subject             { FactoryGirl.build(:service_speedgov_v1_base, emitente: emitente) }
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
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da speedgov" do
			subject.env = :test
			subject.wsdl.must_equal 'http://speedgov.com.br/wsmod/Nfes?wsdl'
		end

		# Caculé - BA
		it "se codigo da cidade emitente for 2905008 então deve pagar a URL de Caculé - BA" do
			subject.ibge_code_of_issuer_city = '2905008'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wscac/Nfes?wsdl'
		end

		# Aquiraz - CE 
		it "se codigo da cidade emitente for 2301000 então deve pagar a URL de Aquiraz - CE " do
			subject.ibge_code_of_issuer_city = '2301000'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsaqz/Nfes?wsdl'
		end

		# Aracati - CE 
		it "se codigo da cidade emitente for 2301109 então deve pagar a URL de Aracati - CE " do
			subject.ibge_code_of_issuer_city = '2301109'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsarc/Nfes?wsdl'
		end

		# Barbalha - CE 
		it "se codigo da cidade emitente for 2301901 então deve pagar a URL de Barbalha - CE " do
			subject.ibge_code_of_issuer_city = '2301901'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsbar/Nfes?wsdl'
		end

		# Beberibe - CE 
		it "se codigo da cidade emitente for 2302206 então deve pagar a URL de Beberibe - CE " do
			subject.ibge_code_of_issuer_city = '2302206'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsbeb/Nfes?wsdl'
		end

		# Crateús - CE
		it "se codigo da cidade emitente for 2304103 então deve pagar a URL de Crateús - CE" do
			subject.ibge_code_of_issuer_city = '2304103'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wscra/Nfes?wsdl'
		end

		# Crato - CE
		it "se codigo da cidade emitente for 2304202 então deve pagar a URL de Crato - CE" do
			subject.ibge_code_of_issuer_city = '2304202'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wscrt/Nfes?wsdl'
		end

		# Guaraciaba do Norte - CE
		it "se codigo da cidade emitente for 2305001 então deve pagar a URL de Guaraciaba do Norte - CE" do
			subject.ibge_code_of_issuer_city = '2305001'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsgua/Nfes?wsdl'
		end

		# Horizonte - CE
		it "se codigo da cidade emitente for 2305233 então deve pagar a URL de Horizonte - CE" do
			subject.ibge_code_of_issuer_city = '2305233'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wshor/Nfes?wsdl'
		end

		# Itaitinga - CE
		it "se codigo da cidade emitente for 2306256 então deve pagar a URL de Itaitinga - CE" do
			subject.ibge_code_of_issuer_city = '2306256'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsita/Nfes?wsdl'
		end

		# Jijoca - CE
		it "se codigo da cidade emitente for 2307254 então deve pagar a URL de Jijoca - CE" do
			subject.ibge_code_of_issuer_city = '2307254'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsjij/Nfes?wsdl'
		end

		# Juazeiro do Norte - CE
		it "se codigo da cidade emitente for 2307304 então deve pagar a URL de Juazeiro do Norte - CE" do
			subject.ibge_code_of_issuer_city = '2307304'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsjun/Nfes?wsdl'
		end

		# Maracanaú - CE
		it "se codigo da cidade emitente for 2307650 então deve pagar a URL de Maracanaú - CE" do
			subject.ibge_code_of_issuer_city = '2307650'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsmar/Nfes?wsdl'
		end

		# Pindoretama - CE
		it "se codigo da cidade emitente for 2310852 então deve pagar a URL de Pindoretama - CE" do
			subject.ibge_code_of_issuer_city = '2310852'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wspin/Nfes?wsdl'
		end

		# Quixadá  - CE
		it "se codigo da cidade emitente for 2311306 então deve pagar a URL de Quixadá  - CE" do
			subject.ibge_code_of_issuer_city = '2311306'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsqda/Nfes?wsdl'
		end

		# Quixeramobim - CE
		it "se codigo da cidade emitente for 2311405 então deve pagar a URL de Quixeramobim - CE" do
			subject.ibge_code_of_issuer_city = '2311405'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsqxb/Nfes?wsdl'
		end

		# Tauá - CE
		it "se codigo da cidade emitente for 2313302 então deve pagar a URL de Tauá - CE" do
			subject.ibge_code_of_issuer_city = '2313302'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wstau/Nfes?wsdl'
		end

		# Tianguá - CE
		it "se codigo da cidade emitente for 2313401 então deve pagar a URL de Tianguá - CE" do
			subject.ibge_code_of_issuer_city = '2313401'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wstia/Nfes?wsdl'
		end

		# Barra do Corda - MA
		it "se codigo da cidade emitente for 2101608 então deve pagar a URL de Barra do Corda - MA" do
			subject.ibge_code_of_issuer_city = '2101608'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wsbco/Nfes?wsdl'
		end

		# Petrolina - PE
		it "se codigo da cidade emitente for 2611101 então deve pagar a URL de Petrolina - PE" do
			subject.ibge_code_of_issuer_city = '2611101'
			subject.wsdl.must_equal 'http://www.speedgov.com.br/wspet/Nfes?wsdl'
		end


	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({"xmlns:p1"=>"http://ws.speedgov.com.br/tipos_v1.xsd"})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				'xmlns:nfse'     => 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'
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
			dados <<		'<header>'
			dados <<			'<![CDATA[<p:cabecalho versao="1" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:p="http://ws.speedgov.com.br/cabecalho_v1.xsd" xmlns:p1="http://ws.speedgov.com.br/tipos_v1.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://ws.speedgov.com.br/cabecalho_v1.xsd cabecalho_v1.xsd">'
			dados <<				'<versaoDados>1</versaoDados>'
			dados <<			'</p:cabecalho>]]>'
			dados <<		'</header>'
			dados <<		'<parameters>'
			dados << 		"<![CDATA[<xml>Builder</xml>]]>"
			dados <<		'</parameters>'
			dados << "</nfse:rootTag>"
			dados
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da speedgov" do
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