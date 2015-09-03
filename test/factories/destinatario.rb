FactoryGirl.define do
	factory :destinatario, class:  BrNfe::Destinatario do
		cpf_cnpj            "767.345.234-03"
		inscricao_municipal '6656-9'
		inscricao_estadual  '8888-9'
		razao_social        "João das Coves"
		telefone            "6204000"
		email               "mail@mail.com"
		endereco            { FactoryGirl.build(:endereco) }
	end
end