FactoryGirl.define do
	factory :product_declaracao_importacao, class: BrNfe::Product::Nfe::DeclaracaoImportacao do
		numero_documento  'DOC159456'
		data_registro     {Date.current}
		local_desembaraco 'PORTO'
		uf_desembaraco    'SP'
		data_desembaraco  {Date.current.ago(5.days)}
		valor_afrmm       245.00 
	end
end