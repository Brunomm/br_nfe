FactoryGirl.define do
	factory :product_transporte_transportador, class:  BrNfe::Product::Nfe::Transporte::Transportador do
		endereco     { FactoryGirl.build(:endereco) }
		cnpj         "40345138000147"
		razao_social "EMPRESA DE TECNOLOGIA DA INFORMAÇÃO"
	end
end