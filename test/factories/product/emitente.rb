FactoryGirl.define do
	factory :product_emitente, class:  BrNfe::Product::Emitente do
		endereco                   { FactoryGirl.build(:endereco) }
		cnpj                       "40345138000147"
		inscricao_municipal        "123465"
		razao_social               "EMPRESA DE TECNOLOGIA DA INFORMAÇÃO"
		nome_fantasia              "TI"
		telefone                   "333366558"
		email                      "mail@mail.com"
		regime_especial_tributacao "3"
		codigo_regime_tributario   "3"
		incentivo_fiscal           "2"
		natureza_operacao          "1"
	end
end