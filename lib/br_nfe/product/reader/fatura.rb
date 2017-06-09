module BrNfe
	module Product
		module Reader
			class Fatura
				class << self
					def new xml, path
						@xml      = xml
						@path     = path
						@fatura = BrNfe::Product::Nfe::Cobranca::Fatura.new
						populate!
						@fatura
					end
				private
					def populate!
						@fatura.numero_fatura  = @xml.css(@path[:fatura][:numero_fatura]).text
						@fatura.valor_original = @xml.css(@path[:fatura][:valor_original]).text.to_f
						@fatura.valor_desconto = @xml.css(@path[:fatura][:valor_desconto]).text.to_f
						@fatura.valor_liquido  = @xml.css(@path[:fatura][:valor_liquido]).text.to_f
						build_duplicatas!
					end

					def build_duplicatas!
						@xml.css(@path[:fatura][:duplicatas][:root]).each do |xml_dup|
							@fatura.duplicatas << {
								numero_duplicata: xml_dup.css(@path[:fatura][:duplicatas][:numero_duplicata]).text,
								total:            xml_dup.css(@path[:fatura][:duplicatas][:total]).text.to_f,
								vencimento:       parse_date(xml_dup.css(@path[:fatura][:duplicatas][:vencimento]).text)
							}
						end
					end

					def parse_date value
						Date.parse(value)
					rescue
						nil
					end
				end
			end
		end
	end
end