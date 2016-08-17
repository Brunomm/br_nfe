module BrNfe
	module Service
		module Betha
			class Base < BrNfe::Service::Base
				# Código de item da lista de serviço
				#
				def ts_item_lista_servico value
					BrNfe::Helper.only_number(value).max_size(5).rjust(4, '0')
				end
			end
		end
	end
end