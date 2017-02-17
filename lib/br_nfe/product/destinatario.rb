module BrNfe
	module Product
		class Destinatario  < BrNfe::Person			
			validate :validar_endereco
		end
	end
end