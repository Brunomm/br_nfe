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

		validates :cpf_cnpj, :razao_social, presence: true
		validate :validar_endereco

		def razao_social
			"#{@razao_social}".to_valid_format_nf
		end

		def nome_fantasia
			"#{@nome_fantasia}".to_valid_format_nf
		end
		
	end
end