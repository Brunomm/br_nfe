require 'test_helper'

describe BrNfe::Service::Simpliss::V1::Base do
	subject             { FactoryGirl.build(:service_simpliss_v1_base, emitente: emitente) }
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
		it "se o env for de test deve enviar a requisição para o ambinete de homologação da SIMPLISS" do
			subject.ibge_code_of_issuer_city = '4202008'
			subject.env = :test
			subject.wsdl.must_equal 'http://wshomologacao.simplissweb.com.br/nfseservice.svc?wsdl'
		end

		# Balneário Camboriú-SC
		it "se codigo da cidade emitente for 4202008 então deve pagar a URL de Balneário Camboriú-SC" do
			subject.ibge_code_of_issuer_city = '4202008'
			subject.wsdl.must_equal 'http://wsbalneariocamboriu.simplissweb.com.br/nfseservice.svc?wsdl'
		end

		# Andirá-PR
		it "se codigo da cidade emitente for 4101101 então deve pagar a URL de Andirá-PR" do
			subject.ibge_code_of_issuer_city = '4101101'
			subject.wsdl.must_equal 'http://wsandira.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Astorga-PR
		it "se codigo da cidade emitente for 4102109 então deve pagar a URL de Astorga-PR" do
			subject.ibge_code_of_issuer_city = '4102109'
			subject.wsdl.must_equal 'http://wsastorga.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Bandeirantes-PR
		it "se codigo da cidade emitente for 4102406 então deve pagar a URL de Bandeirantes-PR" do
			subject.ibge_code_of_issuer_city = '4102406'
			subject.wsdl.must_equal 'http://wsbandeirantes.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Colorado-PR
		it "se codigo da cidade emitente for 4105904 então deve pagar a URL de Colorado-PR" do
			subject.ibge_code_of_issuer_city = '4105904'
			subject.wsdl.must_equal 'http://wscolorado.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Nova Londrina-PR
		it "se codigo da cidade emitente for 4117107 então deve pagar a URL de Nova Londrina-PR" do
			subject.ibge_code_of_issuer_city = '4117107'
			subject.wsdl.must_equal 'http://wsnovalondrina.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Porecatu-PR
		it "se codigo da cidade emitente for 4120002 então deve pagar a URL de Porecatu-PR" do
			subject.ibge_code_of_issuer_city = '4120002'
			subject.wsdl.must_equal 'http://wsporecatu.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Sertanópolis-PR
		it "se codigo da cidade emitente for 4126504 então deve pagar a URL de Sertanópolis-PR" do
			subject.ibge_code_of_issuer_city = '4126504'
			subject.wsdl.must_equal 'http://wssertanopolis.simplissweb.com.br/nfseservice.svc?wsdl'
		end

		# Bambuí-MG
		it "se codigo da cidade emitente for 3105103 então deve pagar a URL de Bambuí-MG" do
			subject.ibge_code_of_issuer_city = '3105103'
			subject.wsdl.must_equal 'http://wsbambui.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Iguatama-MG
		it "se codigo da cidade emitente for 3130309 então deve pagar a URL de Iguatama-MG" do
			subject.ibge_code_of_issuer_city = '3130309'
			subject.wsdl.must_equal 'http://wsiguatama.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# João Monlevade-MG	
		it "se codigo da cidade emitente for 3136207 então deve pagar a URL de João Monlevade-MG" do
			subject.ibge_code_of_issuer_city = '3136207'
			subject.wsdl.must_equal 'http://wsjoaomonlevade.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Patrocinio-MG	
		it "se codigo da cidade emitente for 3148103 então deve pagar a URL de Patrocinio-MG" do
			subject.ibge_code_of_issuer_city = '3148103'
			subject.wsdl.must_equal 'http://wspatrocinio.simplissweb.com.br/nfseservice.svc?wsdl'
		end


		# Volta Redonda-RJ	
		it "se codigo da cidade emitente for 3306305 então deve pagar a URL de Volta Redonda-RJ" do
			subject.ibge_code_of_issuer_city = '3306305'
			subject.wsdl.must_equal 'http://wsvoltaredonda.simplissweb.com.br/nfseservice.svc?wsdl'
		end

			
		# Alfredo Marcondes-SP
		it "se codigo da cidade emitente for 3500808 então deve pagar a URL de Alfredo Marcondes-SP" do
			subject.ibge_code_of_issuer_city = '3500808'
			subject.wsdl.must_equal 'http://wsalfredomarcondes.simplissweb.com.br/nfseservice.svc?wsdl'
		end			
		# Araras-SP
		it "se codigo da cidade emitente for 3503307 então deve pagar a URL de Araras-SP" do
			subject.ibge_code_of_issuer_city = '3503307'
			subject.wsdl.must_equal 'http://189.56.68.34:8080/ws_araras/nfseservice.svc?wsdl'
		end
		# Carapicuíba-SP
		it "se codigo da cidade emitente for 3510609 então deve pagar a URL de Carapicuíba-SP" do
			subject.ibge_code_of_issuer_city = '3510609'
			subject.wsdl.must_equal 'http://wscarapicuiba.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Casa Branca-SP
		it "se codigo da cidade emitente for 3510807 então deve pagar a URL de Casa Branca-SP" do
			subject.ibge_code_of_issuer_city = '3510807'
			subject.wsdl.must_equal 'http://wscasabranca.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Dois Córregos-SP
		it "se codigo da cidade emitente for 3514106 então deve pagar a URL de Dois Corregos-SP" do
			subject.ibge_code_of_issuer_city = '3514106'
			subject.wsdl.must_equal 'http://wsdoiscorregos.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Embu das Artes-SP
		it "se codigo da cidade emitente for 3515004 então deve pagar a URL de Embu das Artes-SP" do
			subject.ibge_code_of_issuer_city = '3515004'
			subject.wsdl.must_equal 'http://wsembudasartes.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Espirito Santo do Pinhal-SP
		it "se codigo da cidade emitente for 3515186 então deve pagar a URL de Embu das Artes-SP" do
			subject.ibge_code_of_issuer_city = '3515186'
			subject.wsdl.must_equal 'http://wsespiritosantodopinhal.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Herculandia-SP
		it "se codigo da cidade emitente for 3519006 então deve pagar a URL de Herculandia-SP" do
			subject.ibge_code_of_issuer_city = '3519006'
			subject.wsdl.must_equal 'http://wsherculandia.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Indiana-SP
		it "se codigo da cidade emitente for 3520608 então deve pagar a URL de Indiana-SP" do
			subject.ibge_code_of_issuer_city = '3520608'
			subject.wsdl.must_equal 'http://wsindiana.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Iracemápolis-SP
		it "se codigo da cidade emitente for 3521408 então deve pagar a URL de Iracemápolis-SP" do
			subject.ibge_code_of_issuer_city = '3521408'
			subject.wsdl.must_equal 'http://wsiracemapolis.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Mirante Do Paranapanema-SP
		it "se codigo da cidade emitente for 3530201 então deve pagar a URL de Mirante Do Paranapanema-SP" do
			subject.ibge_code_of_issuer_city = '3530201'
			subject.wsdl.must_equal 'http://wsmirantedoparanapanema.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Osvaldo Cruz-SP
		it "se codigo da cidade emitente for 3534609 então deve pagar a URL de Osvaldo Cruz-SP" do
			subject.ibge_code_of_issuer_city = '3534609'
			subject.wsdl.must_equal 'http://wsosvaldocruz.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Piracicaba-SP
		it "se codigo da cidade emitente for 3538709 então deve pagar a URL de Piracicaba-SP" do
			subject.ibge_code_of_issuer_city = '3538709'
			subject.wsdl.must_equal 'http://sistemas.pmp.sp.gov.br/semfi/simpliss/ws_nfse/nfseservice.svc?wsdl'
		end
		# Presidente Prudente-SP
		it "se codigo da cidade emitente for 3541406 então deve pagar a URL de Presidente Prudente-SP" do
			subject.ibge_code_of_issuer_city = '3541406'
			subject.wsdl.must_equal 'http://issprudente.sp.gov.br/ws_nfse/nfseservice.svc?wsdl'
		end
		# Santa Cruz das Palmeiras-SP
		it "se codigo da cidade emitente for 3546306 então deve pagar a URL de Santa Cruz das Palmeiras-SP" do
			subject.ibge_code_of_issuer_city = '3546306'
			subject.wsdl.must_equal 'http://wssantacruzdaspalmeiras.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# São João da Boa Vista-SP
		it "se codigo da cidade emitente for 3549102 então deve pagar a URL de São João da Boa Vista-SP" do
			subject.ibge_code_of_issuer_city = '3549102'
			subject.wsdl.must_equal 'http://wssaojoao.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# São José do Rio Pardo-SP
		it "se codigo da cidade emitente for 3549706 então deve pagar a URL de São José do Rio Pardo-SP" do
			subject.ibge_code_of_issuer_city = '3549706'
			subject.wsdl.must_equal 'http://wssaojosedoriopardo.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Tupã-SP
		it "se codigo da cidade emitente for 3555000 então deve pagar a URL de Tupã-SP" do
			subject.ibge_code_of_issuer_city = '3555000'
			subject.wsdl.must_equal 'http://wstupa.simplissweb.com.br/nfseservice.svc?wsdl'
		end
		# Vargem Grande do Sul-SP
		it "se codigo da cidade emitente for 3556404 então deve pagar a URL de Vargem Grande do Sul-SP" do
			subject.ibge_code_of_issuer_city = '3556404'
			subject.wsdl.must_equal 'http://wsvargemgrandedosul.simplissweb.com.br/nfseservice.svc?wsdl'
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