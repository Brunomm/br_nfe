FactoryGirl.define do
	factory :endereco, class:  BrNfe::Endereco do
		logradouro       "Rua João Cândido Lopes"
		numero           "402"
		complemento      ""
		bairro           "Centro"
		nome_municipio   "Chapecó"
		codigo_municipio "4204202"
		uf               "SC"
		cep              "89801-000"
	end
end