FactoryGirl.define do
	factory :product_transporte_veiculo, class:  BrNfe::Product::Nfe::Transporte::Veiculo do
		placa 'RUB-1100'
		uf    'SC'
		rntc  'BRNFE1000'
	end
end