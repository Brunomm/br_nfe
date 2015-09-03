module BrNfe
	class Endereco < BrNfe::ActiveModelBase
		
		def default_values
			{
				codigo_pais: '1058',
				nome_pais: 'BRASIL'
			}
		end

		attr_accessor :logradouro
		attr_accessor :numero
		attr_accessor :complemento
		attr_accessor :bairro
		attr_accessor :nome_municipio
		attr_accessor :codigo_municipio
		attr_accessor :uf
		attr_accessor :cep
		attr_accessor :codigo_pais # defaul: 1058 (Brasil)
		attr_accessor :nome_pais   # defaul: BRASIL


	end
end