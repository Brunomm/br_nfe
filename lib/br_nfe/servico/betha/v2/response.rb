module BrNfe
	module Servico
		module Betha
			module V2
				class Response  < BrNfe::Response
					
					def messages
						Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym }).parse(xml.to_s)["#{nfe_method.to_s}_resposta".to_sym]
					end

					def success?
						raise "Não implementado"
					end

					def errors
						raise "Não implementado"
					end
				end
			end
		end
	end
end