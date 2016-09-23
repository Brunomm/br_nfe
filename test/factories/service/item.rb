FactoryGirl.define do
	factory :service_item, class:  BrNfe::Service::Item do
		cnae_id      '886'
		cnae_code    '1234567'
		description  'Item description'
		cst          '1'
		iss_aliquota 0.025
		valor_unitario   100.00
		quantidade     2.0
		valor_total  200.00
	end
end