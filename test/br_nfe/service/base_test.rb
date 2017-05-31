require 'test_helper'
describe BrNfe::Service::Base do
	subject { FactoryGirl.build(:br_nfe_servico_base) }

	before do
		subject.stubs(:response_class).returns(BrNfe::Service::Response::Default)
	end

	describe "Included modules" do
		it "deve ter o module BrNfe::Service::Concerns::ValuesTs::ServiceV1 incluso" do
			subject.class.included_modules.must_include(BrNfe::Service::Concerns::ValuesTs::ServiceV1)
		end
	end
	
	describe '#xml_current_dir_path' do
		it "o valor padrão deve ser o diretorio xml de serviços na versão do layout setado" do
			subject.expects(:xml_version).returns(:version_layout)
			subject.xml_current_dir_path.must_equal(["#{BrNfe.root}/lib/br_nfe/service/xml/version_layout"])
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

	describe "#emitente" do
		class OtherClassEmitente < BrNfe::ActiveModelBase
		end
		it "deve ter incluso o module HaveEmitente" do
			subject.class.included_modules.must_include BrNfe::Association::HaveEmitente
		end
		it "o método #emitente_class deve ter por padrão a class BrNfe::Service::Emitente" do
			subject.emitente.must_be_kind_of BrNfe::Service::Emitente
			subject.send(:emitente_class).must_equal BrNfe::Service::Emitente
		end
		it "a class do emitente pode ser modificada através da configuração emitente_service_class" do
			BrNfe.emitente_service_class = OtherClassEmitente
			subject.emitente.must_be_kind_of OtherClassEmitente
			subject.send(:emitente_class).must_equal OtherClassEmitente

			# É necessário voltar a configuração original para não falhar outros testes
			BrNfe.emitente_service_class = BrNfe::Service::Emitente
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
			subject.stubs(:url_wsdl).returns('http://duobr.com?wsdl')
			subject.stubs(:method_wsdl).returns(:operation)
			subject.expects(:soap_xml).returns(soap_xml)
		end

		it "deve fazer a requisição para o WS passando a resposta para o metodo set_response" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).returns(:savon_response)
			subject.expects(:set_response).returns(:result)
			subject.request.must_equal :result
			subject.instance_variable_get(:@original_response).must_equal :savon_response
		end

		it "Se ocorrer erro Savon::SOAPFault deve ser tratado e setar o status da resposta com :soap_error" do
			subject.client_wsdl.expects(:call).with(:operation, xml: soap_xml).raises(soap_fault)
			subject.expects(:set_response).never
			
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
		it "deve ser desenvolvido nas sublasses" do
			assert_raises RuntimeError do
				subject.send(:set_response)
			end
		end
	end
end