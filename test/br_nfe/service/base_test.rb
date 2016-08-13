require 'test_helper'

describe BrNfe::Service::Base do
	subject { FactoryGirl.build(:br_nfe_servico_base) }

	describe "Included modules" do
		it "deve ter o module BrNfe::Helper::ValuesTs::ServiceV1 incluso" do
			subject.class.included_modules.must_include(BrNfe::Helper::ValuesTs::ServiceV1)
		end
	end
	
	describe '#xml_current_dir_path' do
		it "o valor padrão deve ser o diretorio xml de serviços na versão do layout setado" do
			subject.expects(:xml_version).returns(:version_layout)
			subject.xml_current_dir_path.must_equal(["#{BrNfe.root}/lib/br_nfe/service/xml/version_layout"])
		end
	end

	describe '#response_path_module' do
		it "deve ser sobrescrito nas subclasses" do
			assert_raises RuntimeError do
				subject.response_path_module
			end
		end
	end

	describe "#response_root_path" do
		it "deve ter um array vazio por padrão" do
			subject.response_root_path.must_equal([])
		end
	end

	describe '#nfse_xml_path' do
		it "deve retornar o caminho generico para encontrar o xml da NFS-e" do
			subject.nfse_xml_path.must_equal '//*/*/*/*'
			# Esse caminho significa: //Envelope/Body/TagRoot/NFSe
		end
	end

	describe "#body_xml_path" do
		it "deve ter um array vazio por padrão" do
			subject.body_xml_path.must_equal([])
		end
	end

	describe "#soap_xml" do
		it "deve trazer a tag_xml e a renderização para o soap_env concatenados" do
			subject.expects(:tag_xml).returns('<?xml?>')
			subject.expects(:render_xml).with('soap_env').returns('<Soap>value</Soap>')
			subject.soap_xml.must_equal '<?xml?><Soap>value</Soap>'
		end
		it "deve renderizar o xml com o valor original" do
			subject.stubs(:xml_builder).returns('<xml>builder</xml>')
			subject.soap_xml.must_equal '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:ins0="http://www.w3.org/2000/09/xmldsig#" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><xml>builder</xml></soapenv:Body></soapenv:Envelope>'
		end
	end

	describe "#request" do
		let(:nori) { Nori.new(:strip_namespaces => true, :convert_tags_to => lambda { |tag| tag.snakecase.to_sym }) }
		let(:soap_fault) do 
			obj = Savon::SOAPFault.new new_response, nori
			obj.stubs(:message_by_version).returns("Message Error")
			obj
		end
		let(:new_response) do
			HTTPI::Response.new 500, {}, '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns2:authenticateResponse xmlns:ns2="http://v1_0.ws.user.example.com"></ns2:authenticateResponse></soap:Body></soap:Envelope>'
		end
		let(:soap_xml) { '<Envelope><Body>XML</Body></Envelope>' } 

		before do
			subject.stubs(:wsdl).returns('http://duobr.com?wsdl')
			subject.stubs(:method_wsdl).returns(:operation)
			subject.expects(:soap_xml).returns(soap_xml)
		end

		it "deve fazer a requisição para o WS passando a resposta para o metodo set_response" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).returns(:savon_response)
			subject.expects(:set_response).with(:savon_response).returns(:result)
			subject.request.must_equal :result
		end

		it "Se ocorrer erro Savon::SOAPFault deve ser tratado e setar o status da resposta com :soap_error" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).returns(:savon_response)
			subject.expects(:set_response).with(:savon_response).raises(soap_fault)
			
			subject.request
			subject.response.error_messages.must_equal(['Message Error'])
			subject.response.status.must_equal :soap_error
		end

		it "Se ocorrer erro Savon::HTTPError deve ser tratado e setar o status da resposta com :http_error" do
			http_error = Savon::HTTPError.new(new_response)
			http_error.stubs(:to_s).returns('Message')
			
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(http_error)
			
			subject.request
			subject.response.error_messages.must_equal(['Message'])
			subject.response.status.must_equal :http_error
		end

		it "Se ocorrer qualquer outro erro deve setar o status com :unknown_error" do
			error = RuntimeError.new('ERROU')
			
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(error)
			
			subject.request
			subject.response.error_messages.must_equal(['ERROU'])
			subject.response.status.must_equal :unknown_error
		end
	end

	describe "#set_response" do
		let(:build_response) { BrNfe::Response::Service::BuildResponse.new() } 
		it "Deve setar a variavel @original_response com a resposta original do savon" do
			BrNfe::Response::Service::BuildResponse.any_instance.stubs(:response).returns(:response)
			subject.stubs(:response_root_path).returns(:response_root_path)
			subject.stubs(:nfse_xml_path).returns(:nfse_xml_path)
			subject.stubs(:response_path_module)
			subject.stubs(:body_xml_path).returns(:body_xml_path)

			subject.set_response(:original).must_equal :response
			subject.instance_variable_get(:@original_response).must_equal(:original)
		end
		it "deve instanciar o build_response e retornar a resposta" do
			build_response
			subject.expects(:response_root_path).returns(:response_root_path)
			subject.expects(:nfse_xml_path).returns(:nfse_xml_path)
			subject.expects(:response_path_module)
			subject.expects(:body_xml_path).returns(:body_xml_path)
			subject.expects(:response_encoding).returns('ENCODE')
			BrNfe::Response::Service::BuildResponse.expects(:new).with({
				savon_response: :savon_response, 
				keys_root_path: :response_root_path,
				nfe_xml_path:   :nfse_xml_path, 
				module_methods: nil,
				body_xml_path:  :body_xml_path,
				xml_encode:     'ENCODE',
			}).returns(build_response)
			build_response.expects(:response).returns('resposta')

			subject.set_response(:savon_response).must_equal 'resposta'
			subject.instance_variable_get(:@response).must_equal('resposta')
		end
	end

	describe "#ibge_code_of_issuer_city" do
		it "se não setar um valor deve pegar o valor do codigo IBGE do endereço do emitente" do
			subject.emitente.endereco.codigo_municipio = '12345678'
			subject.ibge_code_of_issuer_city = nil
			subject.ibge_code_of_issuer_city.must_equal '12345678'
		end
		it "se setar o valor em ibge_code_of_issuer_city não deve pegar do endereço do emitente" do
			subject.emitente.endereco.codigo_municipio = '12345678'
			subject.ibge_code_of_issuer_city = 78978945
			subject.ibge_code_of_issuer_city.must_equal '78978945'
		end
	end
end