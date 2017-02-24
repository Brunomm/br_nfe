require 'test_helper'

describe BrNfe::Product::Response::Build::Base do
	subject { FactoryGirl.build(:product_response_build_base) }
	
	describe '#response' do
		context "é responsável por instanciar e setar os valores da resposta para cada operação" do
			it "deve setar os valores :soap_xml com o xml presente no attr savon_response " do
				subject.savon_response = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8"?><tag>1<tag>')
				subject.savon_response.stubs(:xml).returns('<?xml version="1.0" encoding="UTF-8"?><tag>1<tag>')

				subject.response.soap_xml.must_equal '<?xml version="1.0" encoding="UTF-8"?><tag>1<tag>'
			end
			it "Deve setar o status da requisição com :success" do
				subject.response.request_status.must_equal :success
			end
			it "deve setar os atributos especificos para cada operação" do
				subject.expects(:specific_attributes).returns({app_version: '1', protocol: '2'})

				resp = subject.response
				resp.app_version.must_equal '1'
				resp.protocol.must_equal '2'
				subject.instance_variable_get(:@response).must_equal resp
			end
			it "se já tiver valor na variavel @response não deve tentar instanciar novamnete" do
				subject.instance_variable_set(:@response, 'resp')

				subject.expects(:response_class).never

				subject.response.must_equal 'resp'
			end
		end
	end
end