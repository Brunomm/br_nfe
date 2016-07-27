module BrNfe
	module Service
		class Intermediario  < BrNfe::ActiveModelBase
			
			attr_accessor :cpf_cnpj
			attr_accessor :inscricao_municipal
			attr_accessor :razao_social

			validates :cpf_cnpj, :razao_social, presence: true

			def razao_social
				"#{@razao_social}".to_valid_format_nf
			end
			
		end
	end
end