FactoryGirl.define do
	factory :product_response_build_base, class:  BrNfe::Product::Response::Build::Base do
		savon_response { Nokogiri::XML( File.read("#{BrNfe.root}/test/fixtures/product/response/v3.10/nfe_autorizacao/async_success.xml") ) }
		operation      { FactoryGirl.build(:product_operation_nfe_autorizacao) }
	end
end