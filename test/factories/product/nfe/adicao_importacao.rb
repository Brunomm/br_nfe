FactoryGirl.define do
	factory :product_adicao_importacao, class: BrNfe::Product::Nfe::AdicaoImportacao do
		numero_adicao 12
		sequencial 1
		codigo_fabricante 'XINGLING'
	end
end