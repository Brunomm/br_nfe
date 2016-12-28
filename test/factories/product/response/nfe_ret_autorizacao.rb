FactoryGirl.define do
	factory :product_response_nfe_ret_autorizacao, class:  BrNfe::Product::Response::NfeRetAutorizacao do
		soap_xml                 { File.read("#{BrNfe.root}/test/fixtures/product/response/v3.10/nfe_autorizacao/async_success.xml") }
		environment              2
		app_version              'SVRS201611281548'
		processed_at             '2016-12-23 15:02:01 -0200'
		protocol                 '342160000820226'
		request_status           :success
		processing_status_code   '104'
		processing_status_motive 'Lote processado'
		notas_fiscais            { [] }
	end
end