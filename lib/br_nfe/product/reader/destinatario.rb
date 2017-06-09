module BrNfe
	module Product
		module Reader
			class Destinatario
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@destinatario = BrNfe::Product::Destinatario.new
						populate!
						@destinatario
					end
				private
					def populate!
						@destinatario.cpf_cnpj                  = @xml.css(@path[:destinatario][:cnpj]).text
						@destinatario.cpf_cnpj                  = @xml.css(@path[:destinatario][:cpf]).text if @destinatario.cpf_cnpj.blank?
						@destinatario.razao_social              = @xml.css(@path[:destinatario][:razao_social]).text
						@destinatario.indicador_ie              = @xml.css(@path[:destinatario][:indicador_ie]).text
						@destinatario.inscricao_estadual        = @xml.css(@path[:destinatario][:inscricao_estadual]).text
						@destinatario.suframa                   = @xml.css(@path[:destinatario][:suframa]).text
						@destinatario.inscricao_municipal       = @xml.css(@path[:destinatario][:inscricao_municipal]).text
						@destinatario.email                     = @xml.css(@path[:destinatario][:email]).text
						@destinatario.endereco_logradouro       = @xml.css(@path[:destinatario][:endereco_logradouro]).text
						@destinatario.endereco_numero           = @xml.css(@path[:destinatario][:endereco_numero]).text
						@destinatario.endereco_complemento      = @xml.css(@path[:destinatario][:endereco_complemento]).text
						@destinatario.endereco_bairro           = @xml.css(@path[:destinatario][:endereco_bairro]).text
						@destinatario.endereco_codigo_municipio = @xml.css(@path[:destinatario][:endereco_codigo_municipio]).text
						@destinatario.endereco_nome_municipio   = @xml.css(@path[:destinatario][:endereco_nome_municipio]).text
						@destinatario.endereco_uf               = @xml.css(@path[:destinatario][:endereco_uf]).text
						@destinatario.endereco_cep              = @xml.css(@path[:destinatario][:endereco_cep]).text
						@destinatario.endereco_codigo_pais      = @xml.css(@path[:destinatario][:endereco_codigo_pais]).text
						@destinatario.endereco_nome_pais        = @xml.css(@path[:destinatario][:endereco_nome_pais]).text
						@destinatario.telefone                  = @xml.css(@path[:destinatario][:telefone]).text
					end
				end
			end
		end
	end
end