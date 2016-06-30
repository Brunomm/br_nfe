module BrNfe
	module Service
		module SC
			module Florianopolis
				class Cancellation < BrNfe::Service::SC::Florianopolis::Base
					
					# Descrição do motivo do cancelmanto <OPCIONAL>
					#
					# <b>Type: </b> _Text_
					#
					attr_accessor :motive
					
					# Número de série da nota fiscal <OPCIONAL>
					#
					# <b>Type: </b> _Text_
					#
					attr_accessor :serie_number
					
					validates :serie_number, presence: true
					validates :motive,       length:       {maximum: 120}, allow_blank: true
					validates :serie_number, numericality: {only_integer: true, less_than_or_equal_to: 999999},  allow_blank: true

					def xml_builder
						render_xml 'cancellation', dir_path: "#{BrNfe.root}/lib/br_nfe/service/sc/florianopolis/xml"
					end					
				end
			end
		end
	end
end