module BrNfe
	module Product
		module Gateway
			class Base < BrNfe::ActiveModelBase

				attr_accessor :env

				def env_production?; env == :production end
			end
		end
	end
end