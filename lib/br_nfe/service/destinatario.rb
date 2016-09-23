module BrNfe
	module Service
		class Destinatario  < BrNfe::Person			
			validate :validar_endereco			
		end
	end
end