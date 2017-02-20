require 'test_helper'

describe BrNfe::Service::Dbseller::V1::Base do
	subject             { FactoryGirl.build(:service_dbseller_v1_base, emitente: emitente) }
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
				subject.wsdl.must_equal 'http://nfse.alegrete.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Alegrete - RS
		describe 'Para a cidade 4300406 - Alegrete - RS ' do
			before { subject.ibge_code_of_issuer_city = '4300406' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.alegrete.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.alegrete.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Alvorada - RS
		describe 'Para a cidade 4300604 - Alvorada - RS' do
			before { subject.ibge_code_of_issuer_city = '4300604' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.alvorada.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.alvorada.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Carazinho - RS
		describe 'Para a cidade 4304705 - Carazinho - RS' do
			before { subject.ibge_code_of_issuer_city = '4304705' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.carazinho.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.carazinho.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Charqueadas - RS
		describe 'Para a cidade 4305355 - Charqueadas - RS' do
			before { subject.ibge_code_of_issuer_city = '4305355' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.charqueadas.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.charqueadas.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Itaqui - RS
		describe 'Para a cidade 4310603 - Itaqui - RS' do
			before { subject.ibge_code_of_issuer_city = '4310603' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.itaqui.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.itaqui.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

		# Osorio - RS
		describe 'Para a cidade 4313508 - Osorio - RS' do
			before { subject.ibge_code_of_issuer_city = '4313508' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.osorio.rs.gov.br:81/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.osorio.rs.gov.br:26000/webservice/index/homologacao?wsdl'
			end
		end

		# Taquari - RS
		describe 'Para a cidade 4321303 - Taquari - RS' do
			before { subject.ibge_code_of_issuer_city = '4321303' }
			it "ambiente de produção" do
				subject.env = :production
				subject.wsdl.must_equal 'http://nfse.taquari.rs.gov.br/webservice/index/producao?wsdl'
			end
			it "ambiente de testes" do
				subject.env = :test
				subject.wsdl.must_equal 'http://nfse.taquari.rs.gov.br/webservice/index/homologacao?wsdl'
			end
		end

	end

	describe "#canonicalization_method_algorithm" do
		it { subject.canonicalization_method_algorithm.must_equal 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
	end

	describe "#message_namespaces" do
		it "deve ter um valor" do
			subject.message_namespaces.must_equal({'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",})
		end
	end

	describe "#soap_namespaces" do
		it "deve conter os namespaces padrões mais o namespace da mensagem" do
			subject.soap_namespaces.must_equal({
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance',
				# 'xmlns:nfse'    => 'http://www.abrasf.org.br/ABRASF/arquivos/'
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
		before do
			subject.env = :production
			subject.ibge_code_of_issuer_city = '4304705' # Carazinho - RS
		end
		let(:expected_xml) do
			dados =  "<rootTag xmlns=\"http://nfse.carazinho.rs.gov.br/webservice/index/producao\">"
			dados <<		'<xml xmlns="">'
			dados << 		"<![CDATA[<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml>Builder</xml>]]>"
			dados <<		'</xml>'
			dados << "</rootTag>"
			dados
		end

		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da dbseller" do
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