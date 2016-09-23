FactoryGirl.define do
	factory :service_destinatario, class:  BrNfe::Service::Destinatario do
		cpf_cnpj            "767.345.234-03"
		inscricao_municipal '66569'
		inscricao_estadual  '88889'
		razao_social        "João das Coves"
		telefone            "33665544"
		email               "mail@mail.com"
		endereco            { FactoryGirl.build(:endereco) }
	end
end