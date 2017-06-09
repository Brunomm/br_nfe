module BrNfe
	class Endereco < BrNfe::ActiveModelBase
		
		def default_values
			{
				codigo_pais: '1058',
				nome_pais:   'BRASIL'
			}
		end

		attr_accessor :logradouro
		attr_accessor :numero
		attr_accessor :complemento
		attr_accessor :bairro
		attr_accessor :nome_municipio
		attr_accessor :codigo_municipio # IBGE
		attr_accessor :uf
		attr_accessor :codigo_ibge_uf
		attr_accessor :cep
		attr_accessor :codigo_pais # defaul: 1058 (Brasil)
		attr_accessor :nome_pais   # defaul: BRASIL

		# Descrição do endereço. Utilizado para a leitura da NF-e quando a pessoa 
		# possui um unico campo com todos os dados do endereço
		attr_accessor :descricao

		# Código IBGE do Estado (UF)
		# Caso não seja setado um valor no atributo, irá pegar os primeiros 2
		# dígitos do código IBGE do município.
		#
		def codigo_ibge_uf
			@codigo_ibge_uf || "#{codigo_municipio}"[0..1]
		end

		validates :logradouro, :numero, :bairro, :codigo_municipio, :uf, :cep, presence: true
		validates :codigo_ibge_uf, inclusion: {in: BrNfe::Constants::CODIGO_IBGE_UF}, allow_blank: true

		def is_present?
			logradouro.present? || numero.present? || complemento.present? || 
			bairro.present? || nome_municipio.present? || codigo_municipio.present? || 
			cep.present?
		end

		def logradouro
			"#{@logradouro}".to_valid_format_nf
		end

		def complemento
			"#{@complemento}".to_valid_format_nf
		end

		def bairro
			"#{@bairro}".to_valid_format_nf
		end

		def nome_municipio
			"#{@nome_municipio}".to_valid_format_nf
		end

		def nome_pais
			"#{@nome_pais}".to_valid_format_nf
		end

		def exterior?
			codigo_pais.to_i != 1058
		end
	end
end