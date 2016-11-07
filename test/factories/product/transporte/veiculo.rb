FactoryGirl.define do
	factory :product_transporte_veiculo, class:  BrNfe::Product::Transporte::Veiculo do
		placa 'RUB-1100'
		uf    'SC'
		rntc  'BRNFE1000'
	end
end