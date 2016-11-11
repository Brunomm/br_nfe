FactoryGirl.define do
	factory :product_item, class:  BrNfe::Product::Nfe::Item do
		codigo_produto           'PROD0001'
		cfop                     '5.102'
		codigo_ean               123456789012
		descricao_produto        'COPO DE PLÁSTICO 700 ML PARATA'
		codigo_ncm               '12345678'
		codigos_nve              {['AB12324','AB5678']}
		codigo_extipi            '123'
		unidade_comercial        'UN'
		quantidade_comercial     2
		valor_unitario_comercial 100.50
		valor_total_produto      201.0
	end
end