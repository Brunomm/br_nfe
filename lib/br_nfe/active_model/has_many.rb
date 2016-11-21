module BrNfe
	module ActiveModel
		module HasMany
			extend ActiveSupport::Concern
			module ClassMethods

				# Método utilziado para definir uma associação 'has_many'.
				# Parâmetros para configuração:
				# 1° - Nome do atributo
				# 2° - Class que será utilizada para que considere apenas objetos dessa classe
				#  Exemplo:
				#    class MyCustomClass
				#      include ::ActiveModel::Model
				#      include BrNfe::ActiveModel::Associations
				#
				#      has_many :books, 'Book'
				#    end
				#
				def has_many attr_name, class_name_str, *args
					options = {inverse_of: :reference}.merge(args.extract_options!)
					attr_accessor attr_name
					define_method attr_name do
						arry = [instance_variable_get("@#{attr_name}")].flatten.reject(&:blank?)
						arry_ok = arry.select{|v| v.is_a?(eval(class_name_str)) }
						arry.select!{|v| v.is_a?(Hash) }
						arry.map{ |hash| arry_ok.push(eval(class_name_str).new(hash)) }
						add_reference_to_has_many(arry_ok, options[:inverse_of]) if options[:inverse_of]
						instance_variable_set("@#{attr_name}", arry_ok)
						instance_variable_get("@#{attr_name}")
					end

					define_method :add_reference_to_has_many do |collection, inverse_of|
						collection.map{|obj| obj.send("#{inverse_of}=", self)}
					end
				end

				def validate_has_many attr_name, *args
					options = {
						message: "invalid_#{attr_name.to_s.singularize}".to_sym
					}.merge(args.extract_options!)
					if options[:if]
						validate "#{attr_name}_validations", if: options[:if]
					elsif options[:unless]
						validate "#{attr_name}_validations", unless: options[:unless]
					else
						validate "#{attr_name}_validations"
					end

					define_method "#{attr_name}_validations" do
						send(attr_name).each_with_index do |obj, i|
							index = if options[:index_attr] then obj.send(options[:index_attr]) else i+1 end
							send("add_#{attr_name}_errors", obj, index) if obj.invalid?
						end
					end

					define_method "add_#{attr_name}_errors" do |obj, index|
						obj.errors.full_messages.each do |message|
							errors.add(:base, options[:message], {index: index, error_message: message})
						end
					end
				end
			end
		end
	end
end