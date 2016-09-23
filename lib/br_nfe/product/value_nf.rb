module BrNfe
	module Product
		module ValueNf
			def value_nf_tp_amb value, xml_version=:v3_10
				value == :production ? '1' : '2'
			end
		end
	end
end