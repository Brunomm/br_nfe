FactoryGirl.define do
	factory :service_item, class:  BrNfe::Service::Item do
		cnae_id      '886'
		cnae_code    '1234567'
		description  'Item description'
		cst          '1'
		iss_tax_rate 0.025
		unit_value   100.00
		quantity     2.0
		total_value  200.00
	end
end