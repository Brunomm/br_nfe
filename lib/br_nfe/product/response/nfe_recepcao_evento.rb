module BrNfe
	module Product
		module Response
			class NfeRecepcaoEvento < Base
				# Atributos presentes na classe Base
				#  - environment  [tpAmb]
				#  - app_version  [verAplic]
				#  - processed_at [dhRecbto]
				#  - protocol     [nRec]

				attr_accessor :codigo_orgao
				alias_attribute :cOrgao, :codigo_orgao

				attr_accessor :xml

				has_many :events, 'BrNfe::Product::Response::Event'
			end
		end
	end
end