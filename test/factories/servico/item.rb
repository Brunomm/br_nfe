FactoryGirl.define do
	factory :service_item, class:  BrNfe::Servico::Item do
		cnae_code     '123456'
		description  'Item description'
		cst          '1'
		iss_tax_rate 0.025
		unit_value   100.00
		quantity     2.0
		total_value  200.00
	end
end