module BrNfe
	module Version
		MAJOR = 1 #inclui alterações de API e pode quebrar compatibilidade com versões anteriores
		MINOR = 0 #inclui novas funcionalidades, sem quebrar APIs existentes
		PATCH = 2 #corrige bugs ou traz melhorias em implementações já existentes
		CURRENT = "#{MAJOR}.#{MINOR}.#{PATCH}"
	end
end
