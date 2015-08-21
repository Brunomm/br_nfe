module BrNfe
	class ActiveModelBase
		include ActiveModel::Model

		def initialize(attributes = {})
			attributes = default_values.merge!(attributes)
			assign_attributes(attributes)
			yield self if block_given?
		end

		def assign_attributes(attributes)
			attributes ||= {}
			attributes.each do |name, value|
				send("#{name}=", value)
			end
		end

		def default_values
			{}
		end			
	end
end