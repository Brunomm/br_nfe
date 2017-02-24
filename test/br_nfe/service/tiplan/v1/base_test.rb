require 'test_helper'

describe BrNfe::Service::Tiplan::V1::Base do
	subject             { FactoryGirl.build(:service_tiplan_v1_base, emitente: emitente) }
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
			it "ambiente de produção" do
				subject.wsdl.must_equal 'https://spe.duquedecaxias.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
			end
			it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
				subject.env = :test
				assert_raises RuntimeError do
					subject.wsdl
				end
			end
		end

		# Angra dos Reis - RJ
		it "se codigo da cidade emitente for 3300100 então deve pagar a URL de Angra dos Reis - RJ" do
			subject.ibge_code_of_issuer_city = '3300100'
			subject.wsdl.must_equal 'https://www.spe.angra.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end		
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3300100'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end											

		# Duque de Caxias - RJ
		it "se codigo da cidade emitente for 3301702 então deve pagar a URL de Duque de Caxias - RJ" do
			subject.ibge_code_of_issuer_city = '3301702'
			subject.wsdl.must_equal 'https://spe.duquedecaxias.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3301702'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Itaguaí - RJ
		it "se codigo da cidade emitente for 3302007 então deve pagar a URL de Itaguaí - RJ" do
			subject.ibge_code_of_issuer_city = '3302007'
			subject.wsdl.must_equal 'https://spe.itaguai.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3302007'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Macaé - RJ
		it "se codigo da cidade emitente for 3302403 então deve pagar a URL de Macaé - RJ" do
			subject.ibge_code_of_issuer_city = '3302403'
			subject.wsdl.must_equal 'https://spe.macae.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3302403'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Mangaratiba - RJ
		it "se codigo da cidade emitente for 3302601 então deve pagar a URL de Mangaratiba - RJ" do
			subject.ibge_code_of_issuer_city = '3302601'
			subject.wsdl.must_equal 'https://spe.mangaratiba.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3302601'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Piraí - RJ
		it "se codigo da cidade emitente for 3304003 então deve pagar a URL de Piraí - RJ" do
			subject.ibge_code_of_issuer_city = '3304003'
			subject.wsdl.must_equal 'https://nfse.pirai.rj.gov.br/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3304003'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Resende - RJ
		it "se codigo da cidade emitente for 3304201 então deve pagar a URL de Resende - RJ" do
			subject.ibge_code_of_issuer_city = '3304201'
			subject.wsdl.must_equal 'https://spe.resende.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3304201'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Rio das Ostras - RJ
		it "se codigo da cidade emitente for 3304524 então deve pagar a URL de Rio das Ostras - RJ" do
			subject.ibge_code_of_issuer_city = '3304524'
			subject.wsdl.must_equal 'https://spe.riodasostras.rj.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3304524'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
			end
		end	

		# Americana - SP
		it "se codigo da cidade emitente for 3501608 então deve pagar a URL de Americana - SP" do
			subject.ibge_code_of_issuer_city = '3501608'
			subject.wsdl.must_equal 'https://nfse.americana.sp.gov.br/nfse/WSNacional/nfse.asmx?wsdl'
		end
		it "se o env for de test deve gera um alerta pois o provedor Tiplan não possui ambiente de teste" do
			subject.ibge_code_of_issuer_city = '3501608'
			subject.env = :test
			assert_raises RuntimeError do
				subject.wsdl
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
			dados =  "<rootTag xmlns=\"http://www.nfe.com.br/\">"
			dados +=   '<inputXML>'
			dados +=     "<![CDATA[<xml>Builder</xml>]]>"
			dados +=   '</inputXML>'
			dados += "</rootTag>"
			dados
		end
		it "deve encapsular o XML de xml_builder em um CDATA mantendo o XML body no padrão da tiplan" do
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