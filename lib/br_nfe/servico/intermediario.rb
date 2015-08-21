module BrNfe
	module Servico
		class Intermediario  < BrNfe::ActiveModelBase
			
			attr_accessor :cpf_cnpj
			attr_accessor :inscricao_municipal
			attr_accessor :razao_social
			
		end
	end
end