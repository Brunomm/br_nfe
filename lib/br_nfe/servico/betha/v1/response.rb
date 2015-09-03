module BrNfe
	module Servico
		module Betha
			module V1
				class Response  < BrNfe::Response
					
					def messages
						xml["#{nfe_method.to_s}_resposta".to_sym]
					end

					def success?
						messages[:lista_mensagem_retorno].blank?
					end

					def error_messages
						@error_messages ||= []
						return @error_messages if success? || !@error_messages.blank?
						msgs = messages[:lista_mensagem_retorno][:mensagem_retorno]
						if msgs.is_a?(Hash)
							@error_messages << get_message(msgs)
						else #Array
							msgs.each do |msg|
								@error_messages << get_message(msg)
							end
						end
						@error_messages
					end

				private

					def get_message(hash)
						{
							codigo:  "#{hash[:codigo]}",
							message: "#{hash[:mensagem]}",
							correcao: hash[:correcao]
						}
					end
				end
			end
		end
	end
end