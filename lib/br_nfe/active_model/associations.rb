module BrNfe
	module ActiveModel
		module Associations
			extend ActiveSupport::Concern
			module ClassMethods

				# Método utilziado para definir uma associação 'has_many'.
				# Parâmetros para configuração:
				# 1° - Nome do atributo
				# 2° - Class que será utilizada para que considere apenas objetos dessa classe
				# 3° - Opções:
				#    + :validations -> Utilizado para validar todos os objetos do array.
				#                     Deve ser passado o symbol da tradução que será utilziada para a mensagem.
				#                     Irá passar por parâmetro para a tradução a key :index e :error_message.
				#                     Default: false
				#
				#    + :length     -> Deve ser passado as chaves para validação de tamanho maximo e munimo.
				#                     Passar os mesmos parametros da validação de lenght.
				#                     default: {}
				#
				#    + :validations_condition -> Deve receber uma string/symbol que é o nome do método para aplicar
				#                           na condição :if da validação de todos os objetos.
				#                           Default: false
				#    + :length_condition -> Deve receber uma string/symbol que é o nome do método para aplicar
				#                           na condição :if da validação de length.
				#                           Default: false
				#  Exemplo:
				#    class MyCustomClass
				#      include ::ActiveModel::Model
				#      include BrNfe::ActiveModel::Associations
				#
				#      has_many :books, 'Book', 
				#             validations:           :i18n_book_validation_message, 
				#             validations_condition: :should_validates_books?,
				#             length:                {minimum: 1, maximum: 10},
				#             length_condition:      :should_validates_books_length?
				#
				#      def should_validates_books?
				#        ...
				#      end
				#      def should_validates_books_length?
				#        ...
				#      end
				#    end
				#
				def has_many attr_name, class_name_str, *args
					options = {
						validations: false,
						length:      {},
						validations_condition: false,
						length_condition:       false
					}.merge(args.extract_options!)

					define_attr_has_many attr_name, class_name_str
					define_length_validation_for_has_many( attr_name, options) if options[:length].present?
					define_objects_validation_for_has_many(attr_name, options) if options[:validations]
				end

				# Define o atributo de associação 'has_many'
				#
				def define_attr_has_many attr_name, class_name
					attr_accessor attr_name
					define_method attr_name do					
						arry = [instance_variable_get("@#{attr_name}")].flatten.reject(&:blank?)
						arry_ok = arry.select{|v| v.is_a?(eval(class_name)) }
						arry.select!{|v| v.is_a?(Hash) }
						arry.map{ |hash| arry_ok.push(eval(class_name).new(hash)) }
						instance_variable_set("@#{attr_name}", arry_ok)
						instance_variable_get("@#{attr_name}")
					end
				end

				# Define as validações de length da associação 'has_many'
				#
				def define_length_validation_for_has_many attr_name, options
					if options[:length_condition].present?
						validates attr_name, length: options[:length], if: options[:length_condition]
					else
						validates attr_name, length: options[:length]
					end
				end

				# Define as validações de cada objeto da associação 'has_many'
				#
				def define_objects_validation_for_has_many attr_name, options
					if options[:validations_condition]
						validate "#{attr_name}_validations", if: options[:validations_condition]
					else
						validate "#{attr_name}_validations"
					end
					define_method "#{attr_name}_validations" do
						send(attr_name).each_with_index do |obj, i|
							send("add_#{attr_name}_errors", obj, i+1) if obj.invalid?
						end
					end

					define_method "add_#{attr_name}_errors" do |obj, index|
						obj.errors.full_messages.each do |message|
							errors.add(:base, options[:validations], {index: index, error_message: message})
						end
					end
				end
			end
		end
	end
end