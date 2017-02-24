require 'test_helper'

describe BrNfe::Service::Issnet::V1::Base do
	subject             { FactoryGirl.build(:service_issnet_v1_base, emitente: emitente) }
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
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da issnet" do
			subject.env = :test
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/homologacao/servicos.asmx?wsdl'
		end

		# Anápolis - GO
		it "se codigo da cidade emitente for 5201108 então deve pagar a URL de Anápolis - GO" do
			subject.ibge_code_of_issuer_city = '5201108'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/anapolis/servicos.asmx?wsdl'
		end

		# Aparecida de Goiânia - GO
		it "se codigo da cidade emitente for 5201405 então deve pagar a URL de Aparecida de Goiânia - GO" do
			subject.ibge_code_of_issuer_city = '5201405'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/aparecidadegoiania/servicos.asmx?wsdl'
		end

		# Mantena - MG
		it "se codigo da cidade emitente for 3139607 então deve pagar a URL de Mantena - MG" do
			subject.ibge_code_of_issuer_city = '3139607'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/mantena/servicos.asmx?wsdl'
		end

		# Três Corações - MG
		it "se codigo da cidade emitente for 3169307 então deve pagar a URL de Três Corações - MG" do
			subject.ibge_code_of_issuer_city = '3169307'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/trescoracoes/servicos.asmx?wsdl'
		end

		# Anaurilândia - MS
		it "se codigo da cidade emitente for 5000807 então deve pagar a URL de Anaurilândia - MS" do
			subject.ibge_code_of_issuer_city = '5000807'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/anaurilandia/servicos.asmx?wsdl'
		end

		# Angélica - MS
		it "se codigo da cidade emitente for 5000856 então deve pagar a URL de Angélica - MS" do
			subject.ibge_code_of_issuer_city = '5000856'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/angelica/servicos.asmx?wsdl'
		end

		# Bodoquena - MS 
		# it "se codigo da cidade emitente for 5002159 então deve pagar a URL de Bodoquena - MS " do
		# 	subject.ibge_code_of_issuer_city = '5002159'
		# 	subject.wsdl.must_equal ''
		# end

		# Bonito - MS
		it "se codigo da cidade emitente for 5002209 então deve pagar a URL de Bonito - MS" do
			subject.ibge_code_of_issuer_city = '5002209'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/bonito/servicos.asmx?wsdl'
		end

		# Deodápolis - MS
		it "se codigo da cidade emitente for 5003454 então deve pagar a URL de Deodápolis - MS" do
			subject.ibge_code_of_issuer_city = '5003454'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/deodapolis/servicos.asmx?wsdl'
		end

		# Dourados - MS
		it "se codigo da cidade emitente for 5003702 então deve pagar a URL de Dourados - MS" do
			subject.ibge_code_of_issuer_city = '5003702'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/dourados/servicos.asmx?wsdl'
		end

		# Eldorado - MS
		it "se codigo da cidade emitente for 5003751 então deve pagar a URL de Eldorado - MS" do
			subject.ibge_code_of_issuer_city = '5003751'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/eldorado/servicos.asmx?wsdl'
		end

		# Itaporã - MS
		it "se codigo da cidade emitente for 5004502 então deve pagar a URL de Itaporã - MS" do
			subject.ibge_code_of_issuer_city = '5004502'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/itapora/servicos.asmx?wsdl'
		end

		# Paranaíba - MS
		it "se codigo da cidade emitente for 5006309 então deve pagar a URL de Paranaíba - MS" do
			subject.ibge_code_of_issuer_city = '5006309'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/paranaiba/servicos.asmx?wsdl'
		end

		# Porto Murtinho - MS
		it "se codigo da cidade emitente for 5006903 então deve pagar a URL de Porto Murtinho - MS" do
			subject.ibge_code_of_issuer_city = '5006903'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/portomurtinho/servicos.asmx?wsdl'
		end

		# Rio Brilhante - MS
		it "se codigo da cidade emitente for 5007208 então deve pagar a URL de Rio Brilhante - MS" do
			subject.ibge_code_of_issuer_city = '5007208'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/riobrilhante/servicos.asmx?wsdl'
		end

		# Sidrolândia - MS
		it "se codigo da cidade emitente for 5007901 então deve pagar a URL de Sidrolândia - MS" do
			subject.ibge_code_of_issuer_city = '5007901'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/sidrolandia/servicos.asmx?wsdl'
		end

		# Cuiabá - MT
		it "se codigo da cidade emitente for 5103403 então deve pagar a URL de Cuiabá - MT" do
			subject.ibge_code_of_issuer_city = '5103403'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/cuiaba/servicos.asmx?wsdl'
		end

		# Abaetetuba - PA
		it "se codigo da cidade emitente for 1500107 então deve pagar a URL de Abaetetuba - PA" do
			subject.ibge_code_of_issuer_city = '1500107'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/abaetetuba/servicos.asmx?wsdl'
		end

		# Cascavel - PR
		it "se codigo da cidade emitente for 4104808 então deve pagar a URL de Cascavel - PR" do
			subject.ibge_code_of_issuer_city = '4104808'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/cascavel/servicos.asmx?wsdl'
		end

		# Cruz Alta - RS
		it "se codigo da cidade emitente for 4306106 então deve pagar a URL de Cruz Alta - RS" do
			subject.ibge_code_of_issuer_city = '4306106'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/cruzalta/servicos.asmx?wsdl'
		end

		# Novo Hamburgo - RS
		it "se codigo da cidade emitente for 4313409 então deve pagar a URL de Novo Hamburgo - RS" do
			subject.ibge_code_of_issuer_city = '4313409'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/novohamburgo/servicos.asmx?wsdl'
		end

		# Santa Maria - RS
		it "se codigo da cidade emitente for 4316907 então deve pagar a URL de Santa Maria - RS" do
			subject.ibge_code_of_issuer_city = '4316907'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/santamaria/servicos.asmx?wsdl'
		end

		# Aparecida - SP
		it "se codigo da cidade emitente for 3502507 então deve pagar a URL de Aparecida - SP" do
			subject.ibge_code_of_issuer_city = '3502507'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/aparecida/servicos.asmx?wsdl'
		end

		# Jacareí - SP 
		it "se codigo da cidade emitente for 3524402 então deve pagar a URL de Jacareí - SP " do
			subject.ibge_code_of_issuer_city = '3524402'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/jacarei/servicos.asmx?wsdl'
		end

		# Jaguariuna - SP
		it "se codigo da cidade emitente for 3524709 então deve pagar a URL de Jaguariuna - SP" do
			subject.ibge_code_of_issuer_city = '3524709'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/jaguariuna/servicos.asmx?wsdl'
		end

		# Mogi das Cruzes - SP
		it "se codigo da cidade emitente for 3530607 então deve pagar a URL de Mogi das Cruzes - SP" do
			subject.ibge_code_of_issuer_city = '3530607'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/mogidascruzes/servicos.asmx?wsdl'
		end

		# Praia Grande - SP
		it "se codigo da cidade emitente for 3541000 então deve pagar a URL de Praia Grande - SP" do
			subject.ibge_code_of_issuer_city = '3541000'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/praiagrande/servicos.asmx?wsdl'
		end

		# São Vicente - SP
		it "se codigo da cidade emitente for 3551009 então deve pagar a URL de São Vicente - SP" do
			subject.ibge_code_of_issuer_city = '3551009'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/saovicente/servicos.asmx?wsdl'
		end

		# Serrana - SP
		it "se codigo da cidade emitente for 3551504 então deve pagar a URL de Serrana - SP" do
			subject.ibge_code_of_issuer_city = '3551504'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/serrana/servicos.asmx?wsdl'
		end

		# Presidente Venceslau - SP
		it "se codigo da cidade emitente for 3541505 então deve pagar a URL de Presidente Venceslau - SP" do
			subject.ibge_code_of_issuer_city = '3541505'
			subject.wsdl.must_equal 'http://www.issnetonline.com.br/webserviceabrasf/presidentevenceslau/servicos.asmx?wsdl'
		end


	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({'xmlns:ns3' => "http://www.issnetonline.com.br/webserviceabrasf/vsd/tipos_complexos.xsd"})
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
			dados =  "<nfd:rootTag xmlns:nfd=\"http://www.issnetonline.com.br/webservice/nfd\">"
			dados <<   '<nfd:xml>'
			dados <<     "<![CDATA[<xml>Builder</xml>]]>"
			dados <<   '</nfd:xml>'
			dados << "</nfd:rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da issnet" do
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