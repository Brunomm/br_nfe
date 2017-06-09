module BrNfe
	module Product
		module Reader
			class Emitente
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@emitente = BrNfe::Product::Emitente.new
						populate!
						@emitente
					end
				private
					def populate!
						@emitente.inscricao_estadual_st    = @xml.css(@path[:emitente][:inscricao_estadual_st]).text
						@emitente.cnae_code                = @xml.css(@path[:emitente][:cnae_code]).text
						@emitente.cpf_cnpj                 = @xml.css(@path[:emitente][:cnpj]).text
						@emitente.cpf_cnpj                 = @xml.css(@path[:emitente][:cpf]).text if @emitente.cpf_cnpj.blank?
						@emitente.razao_social             = @xml.css(@path[:emitente][:razao_social]).text
						@emitente.nome_fantasia            = @xml.css(@path[:emitente][:nome_fantasia]).text
						@emitente.telefone                 = @xml.css(@path[:emitente][:telefone]).text
						@emitente.inscricao_municipal      = @xml.css(@path[:emitente][:inscricao_municipal]).text
						@emitente.inscricao_estadual       = @xml.css(@path[:emitente][:inscricao_estadual]).text
						@emitente.codigo_regime_tributario = @xml.css(@path[:emitente][:codigo_regime_tributario]).text
						@emitente.endereco_uf              = @xml.css(@path[:emitente][:endereco_uf]).text
						@emitente.endereco_cep             = @xml.css(@path[:emitente][:endereco_cep]).text
						@emitente.endereco_bairro          = @xml.css(@path[:emitente][:endereco_bairro]).text
						@emitente.endereco_numero          = @xml.css(@path[:emitente][:endereco_numero]).text
						@emitente.endereco_nome_pais       = @xml.css(@path[:emitente][:endereco_nome_pais]).text
						@emitente.endereco_logradouro      = @xml.css(@path[:emitente][:endereco_logradouro]).text
						@emitente.endereco_codigo_pais     = @xml.css(@path[:emitente][:endereco_codigo_pais]).text
						@emitente.endereco_complemento     = @xml.css(@path[:emitente][:endereco_complemento]).text
						@emitente.endereco_nome_municipio  = @xml.css(@path[:emitente][:endereco_nome_municipio]).text
					end
				end
			end
		end
	end
end