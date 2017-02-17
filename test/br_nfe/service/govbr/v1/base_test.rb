require 'test_helper'

describe BrNfe::Service::Govbr::V1::Base do
	subject             { FactoryGirl.build(:service_govbr_v1_base, emitente: emitente) }
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
		# it "se o env for de production deve enviar a requisição para o ambinete de homologação do GOVBR" do
		# 	subject.wsdl.must_equal 'http://nfse.guapore.rs.gov.br/NFSEWS/Services.svc?wsdl'
		# end
		# it "se o env for de test deve enviar a requisição para o ambinete de homologação do GOVBR" do
		# 	subject.env = :test
		# 	subject.wsdl.must_equal 'http://nfse.guapore.rs.gov.br/NFSEWSTESTE/Services.svc?wsdl'
		# end

		describe 'deve assumir alguma cidade por default se não for informado nenhum codigo da cidade' do
			before { subject.ibge_code_of_issuer_city = '' }
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.patobranco.pr.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end

		describe 'Para a cidade 3202405 - Guarapari-ES' do
			before { subject.ibge_code_of_issuer_city = '3202405' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.guarapari.es.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.guarapari.es.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end


		describe 'Para a cidade 3107109 - Boa Esperança-MG' do
			before { subject.ibge_code_of_issuer_city = '3107109' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://receita.boaesperanca.mg.gov.br:8082/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://receita.boaesperanca.mg.gov.br:8082/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3118601 - Contagem-MG' do
			before { subject.ibge_code_of_issuer_city = '3118601' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.contagem.mg.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://teste.contagem.mg.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end


		describe 'Para a cidade 5005707 - Naviraí-MS' do
			before { subject.ibge_code_of_issuer_city = '5005707' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://187.6.10.202:9191/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://187.6.10.202:9191/NFSEWSTESTE/Services.svc?wsdl'
			end
		end


		describe 'Para a cidade 410050 - Altonia-PR' do
			before { subject.ibge_code_of_issuer_city = '410050' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://201.87.233.17:5620/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 410140 - Apucarana-PR' do
			before { subject.ibge_code_of_issuer_city = '410140' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://cetil.apucarana.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 410200 - Assis Chateaubriand-PR' do
			before { subject.ibge_code_of_issuer_city = '410200' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://177.38.165.34:8184/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://177.38.165.34:8184/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4110953 - Itaipulândia-PR' do
			before { subject.ibge_code_of_issuer_city = '4110953' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://177.10.24.51:9091/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4111803 - Jacarezinho-PR' do
			before { subject.ibge_code_of_issuer_city = '4111803' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://186.251.15.6:8486/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://186.251.15.6:8486/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4112108 - Jandaia Do Sul-PR' do
			before { subject.ibge_code_of_issuer_city = '4112108' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://187.109.161.3:8082/nfseWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4115408 - Marmeleiro-PR' do
			before { subject.ibge_code_of_issuer_city = '4115408' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.marmeleiro.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.marmeleiro.pr.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4115705 - Matinhos-PR' do
			before { subject.ibge_code_of_issuer_city = '4115705' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.matinhos.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4115804 - Medianeira-PR' do
			before { subject.ibge_code_of_issuer_city = '4115804' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.medianeira.pr.gov.br:8080/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4118501 - Pato Branco-PR' do
			before { subject.ibge_code_of_issuer_city = '4118501' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.patobranco.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.patobranco.pr.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4122404 - Rolândia-PR' do
			before { subject.ibge_code_of_issuer_city = '4122404' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.rolandia.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4124053 - Santa Terezinha de Itaipu-PR' do
			before { subject.ibge_code_of_issuer_city = '4124053' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.stitaipu.pr.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4124103 - Santo Antônio da Platina-PR' do
			before { subject.ibge_code_of_issuer_city = '4124103' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://186.251.15.12:90/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 4127957 - Tupãssi-PR' do
			before { subject.ibge_code_of_issuer_city = '4127957' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://200.195.176.227/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end


		describe 'Para a cidade 3304706 - Santo Antônio de Pádua-RJ' do
			before { subject.ibge_code_of_issuer_city = '3304706' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://sistemas.padua.rj.gov.br/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://sistemas.padua.rj.gov.br/nfsewsteste/services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3306206 - Vassouras-RJ' do
			before { subject.ibge_code_of_issuer_city = '3306206' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://186.226.210.213/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://186.226.210.213/nfsewsteste/services.svc?wsdl'
			end
		end


		describe 'Para a cidade 4303509 - Camaquã-RS' do
			before { subject.ibge_code_of_issuer_city = '4303509' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://portal.camaqua.rs.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://portal.camaqua.rs.gov.br:8181/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4308102 - Feliz-RS' do
			before { subject.ibge_code_of_issuer_city = '4308102' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://187.84.56.68:8081/nfsews/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://187.84.56.69:8082/nfsewsteste/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4309407 - Guaporé-RS' do
			before { subject.ibge_code_of_issuer_city = '4309407' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.guapore.rs.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.guapore.rs.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4310207 - Ijuí-RS' do
			before { subject.ibge_code_of_issuer_city = '4310207' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://server21.ijui.rs.gov.br/nfsews/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://ambienteteste.ijui.rs.gov.br/nfsewsteste/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4313375 - Nova Santa Rita-RS' do
			before { subject.ibge_code_of_issuer_city = '4313375' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.novasantarita.rs.gov.br/NFSEWS//Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.novasantarita.rs.gov.br:8181/NFSEWSTESTE//Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4314423 - Picada Café-RS' do
			before { subject.ibge_code_of_issuer_city = '4314423' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://portal.picadacafe.rs.gov.br:8585/nfsews/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://portal.picadacafe.rs.gov.br:8383/nfsewsteste/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4318309 - São Gabriel-RS' do
			before { subject.ibge_code_of_issuer_city = '4318309' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://191.36.145.163/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://191.36.145.163/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4320800 - Soledade-RS' do
			before { subject.ibge_code_of_issuer_city = '4320800' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfsesoledade.ddns.net/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfsesoledade.ddns.net/nfsewsteste/services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4321709 - Três Coroas-RS' do
			before { subject.ibge_code_of_issuer_city = '4321709' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.pmtcoroas.com.br/nfsews/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfseteste.pmtcoroas.com.br/nfsewsteste/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4322004 - Triunfo-RS' do
			before { subject.ibge_code_of_issuer_city = '4322004' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://deiss.triunfo.rs.gov.br:90/nfsews/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://189.30.16.212:90/nfsewsteste/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 4322400 - Uruguaiana-RS' do
			before { subject.ibge_code_of_issuer_city = '4322400' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://177.36.44.89:7778/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end


		describe 'Para a cidade 3505609 - Barrinha-SP' do
			before { subject.ibge_code_of_issuer_city = '3505609' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://186.232.87.226:90/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end
		describe 'Para a cidade 3511102 - Catanduva-SP' do
			before { subject.ibge_code_of_issuer_city = '3511102' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.catanduva.sp.gov.br/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.catanduva.sp.gov.br/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3511706 - Charqueada-SP' do
			before { subject.ibge_code_of_issuer_city = '3511706' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://189.109.40.26:49392/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://189.109.40.26:49392/nfsewsteste/services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3512001 - Colina-SP' do
			before { subject.ibge_code_of_issuer_city = '3512001' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://200.144.17.186/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://200.144.17.186/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3530300 - Mirassol-SP' do
			before { subject.ibge_code_of_issuer_city = '3530300' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.mirassol.sp.gov.br:5557/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.mirassol.sp.gov.br:5557/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3542404 - Regente Feijó-SP' do
			before { subject.ibge_code_of_issuer_city = '3542404' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.regentefeijo.sp.gov.br:81/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.regentefeijo.sp.gov.br:81/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3544251 - Rosana-SP' do
			before { subject.ibge_code_of_issuer_city = '3544251' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://200.159.122.139/NFSEWS/Services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://200.159.122.139/NFSEWSTESTE/Services.svc?wsdl'
			end
		end
		describe 'Para a cidade 3545407 - Salto Grande-SP' do
			before { subject.ibge_code_of_issuer_city = '3545407' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://200.192.244.89/nfsews/services.svc?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://200.192.244.89/nfsewsteste/services.svc?wsdl'
			end
		end

	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({'xmlns:ns4'     =>  "http://tempuri.org/tipos_complexos.xsd"})
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
			dados =  "<rootTag xmlns=\"http://tempuri.org/\">"
			dados <<   '<xmlEnvio>'
			dados <<     "<![CDATA[<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml>Builder</xml>]]>"
			dados <<   '</xmlEnvio>'
			dados << "</rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da ginfes" do
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