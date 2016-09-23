#encoding UTF-8
module BrNfe
	module Service
		module Response
			module Build
				class Base  < BrNfe::ActiveModelBase
					# 1: A resposta da requisição soap
					attr_accessor :savon_response
					
					# 2: Um array com o caminho inicial padrão da requisição de retorno
					attr_accessor :keys_root_path

					# 3: Alguns Webservices trazem dentro do body da resposta SOAp
					# outro XML com as informações necessárias.
					# Quando isso aocntece é preciso converter esse XML para um HASH
					# para que possamos encontrar os valores necessários.
					attr_accessor :body_xml_path

					# 4: Codificação original do XML de resposta para que seja convertido 
					#    para UTF-8
					attr_accessor :xml_encode

					##############################################################################################################
					#######################   CAMINHOS PARA ENCONTRAR OS VALORES NA RESPOSTA DA REQUISIÇÃO   #####################
						#                                                                     Caminho para encontrar
						attr_accessor :lot_number_path                                     # o numero do lote
						attr_accessor :message_errors_path                                 # local para encontrar as mensagens de erro
						attr_accessor :message_code_key                                    # chave que representa o codigo do erro
						attr_accessor :message_msg_key                                     # chave que representa a mensagem do erro
						attr_accessor :message_solution_key                                # chave que representa a solução do erro
						
						def default_values
							super.merge({
								message_code_key:     :codigo,
								message_msg_key:      :mensagem,
								message_solution_key: :correcao,
							})
						end
					#######################   FIM DA DEFINIÇÃO DOS CAMINHOS   ############################
					######################################################################################
					
					def response
						raise "O método #response deve ser implementado na classe #{self.class}"
					end

					# Retorna o valor encontrado no body da resposta Savon
					# em formato de hash
					#
					# <b>Tipo de retorno: </b> _Hash_
					#
					def savon_body
						return @savon_body if @savon_body.present?
						if body_xml_path.present?
							@savon_body = Nori.new.parse(
								body_converted_to_xml
							).deep_transform_keys!{|k| k.to_s.underscore.to_sym}
						else
							@savon_body = savon_response.try(:body) || {}
						end
					end

					# Converte o body da requisição em XML (String)
					# Isso é necessário quando dentro do body vem a resposta com outro XML
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def body_converted_to_xml
						@body_converted_to_xml ||= canonicalize("#{find_value_for_keys(savon_response.try(:body), body_xml_path)}".encode(xml_encode).force_encoding('UTF-8'))
					end

					# Método utilizado para encontrar valores em um Hash
					# passando o caminho do valor em um array onde contém as chaves
					# ordenadas.
					# Recebe 2 parêmntros:
					# 1º um o hash onde contém o valor a ser encontrado
					# 2º um array com as chaves em sequencia formando o caminho para encontrar o valor.
					#
					# A funcionalidade desse método funciona parecido com o `.dig` da classe Hash do
					# Ruby 2.3.0. 
					# A diferença é que no caso de exmeplo a seguir não apresenta uma excessão par ao usuário
					# hash = {v1: {v2: 'valor string'}}
					# hash.dig(:v1, :v2, :v3) <- Dá erro
					# find_value_for_keys(hash, [:v1, :v2, :v3] <- Retorna nil e não da erro
					#
					# <b>Tipo de retorno: </b> _Anything_
					#
					def find_value_for_keys(hash, keys)
						return if keys.blank?
						keys = [keys] unless keys.is_a?(Array)
						
						result = hash
						keys.each do |key|
							if result.is_a?(Hash)
								result = result[key]
							else
								result = nil
								break
							end
						end
						result
					end

					# Quando para encontrar o valor de uma determinada chave
					# é necessaŕio percorer o hash de retorno dês do inicio do mesmo.
					# Como a mensagem tem uma chave 'root' padrão e pode ser diferente 
					# para cada orgaao emissor, é setado uma valor na variavel keys_root_path
					# para que não seja necessário ficar setando a mesma chave em todos os 
					# métodos utilizados para encontrar determinado valor
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def path_with_root(path)
						return if path.blank?
						keys_root_path + [path].flatten
					end

					# Método que retorna as mensagens de retorno da requisição
					# Quando procurar a mensagem a mesma pode retornar em 3 formatos:
					# Hash: Onde encontrou apenas 1 mensagem com Codigo, Mensagem e Solução
					# Array: Onde encontrou mais de uma mensagem com Codigo, Mensagem e Solução
					# String: Onde encontrou uma unica mensagem de texto
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def get_message_for_path(msg_path)
						messages = []
						_messages = find_value_for_keys(savon_body, path_with_root(msg_path) )
						if _messages.is_a?(Hash)
							messages << get_message_for_hash(_messages)
						elsif _messages.is_a?(Array)
							_messages.map{|msg| messages << get_message_for_hash(msg) if msg.present? }
						elsif _messages.present?
							messages << _messages
						end
						messages.uniq
					end

					# Método utilizado para quando encontrar uam mensagem que seja um HAsh,
					# onde nesse caso a mensagem terá um codigo de erro, uma mensagem, e uma 
					# mensagem de solução
					#
					# <b>Tipo de retorno: </b> _hash_
					#
					def get_message_for_hash(msg_hash)
						{
							code:     find_value_for_keys(msg_hash, message_code_key),
							message:  find_value_for_keys(msg_hash, message_msg_key),
							solution: find_value_for_keys(msg_hash, message_solution_key)
						}
					end

					
					# Método utilizado para pegar o número do lote RPS
					#
					# <b>Tipo de retorno: </b> _String_
					#
					def get_lot_number
						find_value_for_keys(savon_body, path_with_root(lot_number_path))
					end

					
				end
			end
		end
	end
end