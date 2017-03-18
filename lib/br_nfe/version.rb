module BrNfe
	module Version
		MAJOR = 2 #inclui alterações de API e pode quebrar compatibilidade com versões anteriores
		MINOR = 2 #inclui novas funcionalidades, sem quebrar APIs existentes
		PATCH = 0 #corrige bugs ou traz melhorias em implementações já existentes
		CURRENT = "#{MAJOR}.#{MINOR}.#{PATCH}"
	end
end
