FactoryGirl.define do
	factory :product_response_build_base, class:  BrNfe::Product::Response::Build::Base do
		savon_response { Nokogiri::XML( File.read("#{BrNfe.root}/test/fixtures/product/response/v3.10/nfe_autorizacao/success.xml") ) }
		original_xml   ''
	end
end