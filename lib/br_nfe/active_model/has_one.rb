module BrNfe
	module ActiveModel
		module HasOne
			extend ActiveSupport::Concern
			module ClassMethods
				def has_one attr_name, class_name, *args
					options = {null: true, inverse_of: :reference}.merge(args.extract_options!)

					define_method attr_name do |&block|
						block.call(send("#{attr_name}_force_instance")) if block
						if instance_variable_get("@#{attr_name}").is_a?(eval(class_name)) 
							instance_variable_get("@#{attr_name}").instance_variable_set("@#{options[:inverse_of]}", self) if instance_variable_get("@#{attr_name}").send(options[:inverse_of]).blank?
							instance_variable_get("@#{attr_name}")
						else
							if options[:null] then nil else send("#{attr_name}_force_instance") end
						end
					end

					define_method "#{attr_name}=" do |value|
						if value.is_a?(eval(class_name)) 
							instance_variable_set("@#{attr_name}", value)
						elsif value.is_a?(Hash)
							send("#{attr_name}_force_instance").assign_attributes(value)
						elsif value.blank?
							instance_variable_set("@#{attr_name}", nil)
						end
					end

					define_method "#{attr_name}_force_instance" do
						instance_variable_set("@#{attr_name}", eval(class_name).new) unless instance_variable_get("@#{attr_name}").is_a?(eval(class_name))
						instance_variable_get("@#{attr_name}").instance_variable_set("@#{options[:inverse_of]}", self) if instance_variable_get("@#{attr_name}").send(options[:inverse_of]).blank?
						instance_variable_get("@#{attr_name}")
					end
				end

				def validate_has_one attr_name, *args
					options = {message: "invalid_#{attr_name}".to_sym}
					options.merge!(args.extract_options!)
					if options[:if]
						if options[:if].is_a?(Proc)
							validate  "#{attr_name}_validation", if: lambda{|rec| rec.send(attr_name) && options[:if].call(rec) }
						else
							validate  "#{attr_name}_validation", if: lambda{|rec| rec.send(attr_name) && rec.send(options[:if]) }
						end
					else
						validate  "#{attr_name}_validation", if: attr_name
					end
					define_method "#{attr_name}_validation" do
						if send(attr_name).invalid?
							send(attr_name).errors.full_messages.each { |msg| errors.add(:base, options[:message], {error_message: msg}) }
						end
					end
				end
			end
		end
	end
end