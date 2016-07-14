module BrNfe
	module Service
		class Base < BrNfe::Base
			include BrNfe::Helper::ValuesTs::ServiceV1
			
			# Declaro que o método `render_xml` irá verificar os arquivos também presentes
			# no diretório especificado
			#
			# <b>Tipo de retorno: </b> _Array_
			#
			def xml_current_dir_path
				["#{BrNfe.root}/lib/br_nfe/service/xml/#{xml_version}"]+super
			end

		end
	end
end