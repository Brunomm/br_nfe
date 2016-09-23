module BrNfe
	module Product
		module Gateway
			class Base < BrNfe::ActiveModelBase

				attr_accessor :env

				def env_production?; env == :production end

				##########################################################################################
				################################  NFE STATUS SERVIÇO  ####################################
					# Serviço destinado à consulta do status do serviço prestado pelo 
					# Portal da Secretaria de Fazenda Estadual
					# Traduzindo: Utilizado para saber se o SEFAZ do estado está em operação
					#
					# O processamento do pedido de consulta de status de Serviço pode resultar em uma
					# mensagem de erro ou retornar a situação atual do Servidor de Processamento, códigos de
					# situação 
					#   + 107 - Serviço em Operação
					#   + 108 - Serviço Paralisado Temporariamente
					#   + 109 - Serviço Paralisado sem Previsão
					# A critério da UF o campo xObs pode ser utilizado para
					# fornecer maiores informações ao contribuinte, como por exemplo: “manutenção programada”,
					# “modificação de versão do aplicativo”, “previsão de retorno”, etc.
					#
					# Processo: síncrono.
					# Método: nfeStatusServico
					def wsdl_status_servico
						raise "O método #wsdl_status_servico deve ser implementado no webservice de cada estado"
					end
					def operation_status_servico
						raise "O método #operation_status_servico deve ser implementado no webservice de cada estado"
					end
					def version_xml_status_servico
						raise "O método #version_xml_status_servico deve ser implementado no webservice de cada estado"
					end
					# URL que é adicionado nas tags Header/nfeCabecMsg e Body/nfeDadosMsg
					def url_xmlns_status_servico
						raise "O método #url_xmlns_status_servico deve ser implementado no webservice de cada estado"
					end

				##########################################################################################
				################################  NFE AUTORIZAÇÃO  #######################################
					# Serviço destinado à recepção de mensagens de lote de NF-e.
					# Traduzindo: Serviço destinando a enviar as notas fiscais para o SEFAZ
					#
					# Processo: assíncrono.
					# Método: nfeAutorizacaoLote
					#
					def wsdl_autorizacao
					end
					def operation_autorizacao
					end
					def version_xml_autorizacao
					end					
					# URL que é adicionado nas tags Header/nfeCabecMsg e Body/nfeDadosMsg
					def url_xmlns_autorizacao
					end
			end
		end
	end
end