FactoryGirl.define do
	factory :product_nota_fiscal, class:  BrNfe::Product::NotaFiscal do
		codigo_nf            100
		serie                1
		numero_nf            25
		natureza_operacao    'Venda'
		forma_pagamento      0  # À Vista
		modelo_nf            55 # NF-e
		data_hora_emissao    { Time.current }
		data_hora_expedicao  { Time.current }
		tipo_operacao        1 # Saída
		tipo_impressao       1 # DANFE normal, Retrato
		finalidade_emissao   1 # Normal
		consumidor_final     true
		presenca_comprador   9 # Operação não presencial, outros
		processo_emissao     0 # Emissão de NF-e com aplicativo do contribuinte
		versao_aplicativo    0
		
		# trait :completa do
		# end
	end
end