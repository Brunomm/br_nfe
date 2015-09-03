module BrNfe
	class Destinatario  < BrNfe::ActiveModelBase
		include BrNfe::Helper::HaveAddress
		
		attr_accessor :cpf_cnpj
		attr_accessor :inscricao_municipal
		attr_accessor :inscricao_estadual
		attr_accessor :inscricao_suframa
		attr_accessor :razao_social
		attr_accessor :nome_fantasia
		attr_accessor :telefone
		attr_accessor :email
		
	end
end