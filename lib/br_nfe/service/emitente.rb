module BrNfe
	module Service
		class Emitente  < BrNfe::Person
			validates :inscricao_municipal, :natureza_operacao, presence: true
			validate  :validar_endereco
		end
	end
end