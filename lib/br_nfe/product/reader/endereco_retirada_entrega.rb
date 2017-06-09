module BrNfe
	module Product
		module Reader
			class EnderecoRetiradaEntrega
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@endereco = BrNfe::Endereco.new
						populate!
						@endereco
					end
				private
					def populate!
						@endereco.logradouro       = @xml.css(@path[:logradouro]).text
						@endereco.numero           = @xml.css(@path[:numero]).text
						@endereco.complemento      = @xml.css(@path[:complemento]).text
						@endereco.bairro           = @xml.css(@path[:bairro]).text
						@endereco.codigo_municipio = @xml.css(@path[:codigo_municipio]).text
						@endereco.nome_municipio   = @xml.css(@path[:nome_municipio]).text
						@endereco.uf               = @xml.css(@path[:uf]).text
					end
				end
			end
		end
	end
end