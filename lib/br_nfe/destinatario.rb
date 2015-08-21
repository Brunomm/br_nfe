module BrNfe
	class Destinatario  < BrNfe::ActiveModelBase
		
		attr_accessor :cpf_cnpj
		attr_accessor :inscricao_municipal
		attr_accessor :inscricao_estadual
		attr_accessor :inscricao_suframa
		attr_accessor :razao_social
		attr_accessor :nome_fantasia
		attr_accessor :telefone
		attr_accessor :email

		def endereco
			@endereco.is_a?(BrNfe::Endereco) ? @endereco : @endereco = BrNfe::Endereco.new()
		end

		def endereco=(value)
			if value.is_a?(BrNfe::Endereco) 
				@endereco = value
			elsif value.is_a?(Hash)
				endereco.assign_attributes(value)
			end
		end
	end
end