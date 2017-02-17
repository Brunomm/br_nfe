# encoding: UTF-8
require 'bundler/setup'
Bundler.require(:default, :test)

ENV["RAILS_ENV"] = "test"
require "rails/test_help"
require 'minitest/autorun'
require "minitest/rails"
require 'minitest/matchers_vaccine'

require 'shoulda/matchers'
require "minitest/reporters"
require 'mocha/mini_test'
require 'webmock/minitest'

WebMock.disable_net_connect!(allow: 'codeclimate.com')

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start


require 'factory_girl_rails'

require 'pry'

require "savon/mock/spec_helper"

ENV['TZ'] = 'UTC'
Time.zone = 'Brasilia'

Minitest::Reporters.use!

if ActiveSupport.version >= Gem::Version.new('4.2')
	ActiveSupport::TestCase.test_order = :sorted
end

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

class Module
	include Minitest::Spec::DSL
end

class Object
  alias context describe
end


class Shoulda::Matchers::ActiveModel::ValidateLengthOfMatcher
	def string_of_length(length)
		MiniTest::Spec.string_for_validation_length * length
	end
end

class MiniTest::Spec
	include Savon::SpecHelper
	include Shoulda::Matchers::ActiveModel
	include FactoryGirl::Syntax::Methods

	# Utilizado para que seja possível cusotmizar o valor utilizado
	# na validação de length 
	mattr_accessor :string_for_validation_length
	@@string_for_validation_length = 'x'
	

	let(:sequence_1) { sequence('sequence_1') }

	def open_fixture(path)
		file_path = File.expand_path('../fixtures', __FILE__) + '/'+ path
		File.open(file_path)
	end

	def read_fixture(path)
		file_path = File.expand_path('../fixtures', __FILE__) + '/'+ path
		File.read(file_path)
	end

	def wont_be_message_error(column, message=nil, msg_params={}, exec_valid = true)
		message = get_message(message, msg_params, column) if message
		subject.valid? if exec_valid
		messages = subject.errors.messages[column.to_sym]
		if message.nil?
			messages.nil?.must_equal true, "Não deveria ter mensagem de erro para o atributo #{column}, mas foi encontrado os erros: \n -> #{messages ? messages.join("\n -> ") : '' }"
		elsif messages.blank?
			assert true
		elsif messages.include?(message) 
			flunk "Não deveria ter o erro \"#{message}\" para o atributo \"#{column}\"" 
		end
	end

	def must_be_message_error(column, message=nil, msg_params={}, exec_valid = true)
		message = get_message(message, msg_params, column) if message
		subject.valid? if exec_valid
		messages = subject.errors.messages[column.to_sym]
		if message.nil?
			messages.nil?.must_equal false, "Deveria ter alguma mensagem de erro para o atributo #{column}"
		elsif messages.blank?
			flunk "Deveria ter o erro \"#{message}\" para o atributo \"#{column}\", porém não há erro algum." 
		elsif messages.include?(message) 
			assert true
		else
			flunk "Deveria ter o erro \"#{message}\" para o atributo \"#{column}\", mas foi encontrado apenas os erros: \n -> #{messages.join("\n -> ") }" 			
		end
	end

	def must_have_alias_attribute(alias_name, attribute, test_value=1, expect_value=nil)
		expect_value ||= test_value
		if test_value.is_a?(Time)
			expect_value = test_value = Time.zone.parse('10/05/2017 03:58:47.000')
			subject.send("#{attribute}=", test_value)
			subject.send(alias_name).must_be_close_to expect_value

			subject.send("#{alias_name}=", test_value)
			subject.send(attribute).must_be_close_to expect_value
		else
			subject.send("#{attribute}=", test_value)
			subject.send(alias_name).must_equal expect_value

			subject.send("#{alias_name}=", test_value)
			subject.send(attribute).must_equal expect_value
		end
	end

	def must_accept_only_numbers attribute, opts={}
		options = {size: 5, set: '1'}
		options.merge!(opts)

		set_numbers = ''.rjust(options[:size], options[:set])

		subject.send("#{attribute}=", "AB$#{set_numbers}-CD".insert(5, '.'))
		subject.send(attribute).must_equal set_numbers
	end

	def must_returns_an_array attribute, opts={}
		options = {set1: '1', set2: '2', init_how_array: true}
		options.merge!(opts)
		set1 = options[:set1]
		set2 = options[:set2]

		if options[:init_how_array]
			# deve  inicializar com um array vazio
			subject.class.new.send(attribute).must_be_kind_of Array
			subject.class.new.send(attribute).must_be_empty
		end
		
		# mesmo que setar um valor qualquer deve sempre retornar um array
		subject.send("#{attribute}=", set1)
		subject.send(attribute).must_equal([set1])
		subject.send("#{attribute}=", set2)
		subject.send(attribute).must_equal([set2])
		subject.send("#{attribute}=", [set2,set1])
		subject.send(attribute).must_equal([set2,set1])
		
		# deve desconsiderar os valores nil
		subject.send("#{attribute}=", [nil,set1,nil,set2,nil])
		subject.send(attribute).must_equal([set1,set2])
		subject.send("#{attribute}=", nil)
		subject.send(attribute).must_equal([])
		subject.send("#{attribute}=", [nil])
		subject.send(attribute).must_equal([])
	end

	def must_validate_length_has_many attribute, klass, *args
		options = {
			condition: false, inverse_of: :reference
		}.merge(args.extract_options!)

		MiniTest::Spec.string_for_validation_length = [klass.new]
		if options[:condition]
			subject.stubs(options[:condition]).returns(true)
		end
		
		must(validate_length_of(attribute).is_at_most(options[:maximum])) if options[:maximum]
		must(validate_length_of(attribute).is_at_least(options[:minimum])) if options[:minimum]
		must(validate_length_of(attribute).is_at_least(options[:in].min).is_at_most(options[:in].max)) if options[:in]
		
		validate_have_many_inverse_of(attribute, klass, options)

		if options[:condition]
			subject.stubs(options[:condition]).returns(false)
			wont(validate_length_of(attribute).is_at_most(options[:maximum])) if options[:maximum]
			wont(validate_length_of(attribute).is_at_least(options[:minimum])) if options[:minimum]
			wont(validate_length_of(attribute).is_at_least(options[:in].min).is_at_most(options[:in].max)) if options[:in]
		end
		MiniTest::Spec.string_for_validation_length = 'x'
	end

	def must_validates_has_many attribute, klass, translation, *args
		options = {
			condition: false
		}.merge(args.extract_options!)

		object1 =  klass.new
		object2 =  klass.new
		object3 =  klass.new
		object1.stubs(:valid?).returns(true)
		
		object2.errors.add(:base, 'Erro do object 2')
		object2.stubs(:valid?).returns(false)
		
		object3.errors.add(:base, 'Erro do object 3')
		object3.stubs(:valid?).returns(false)

		subject.send("#{attribute}=", [object1, object2, object3])

		if options[:condition]
			subject.stubs(options[:condition]).returns(true)
		end

		must_be_message_error :base, translation, {index: 2, error_message: 'Erro do object 2'}
		must_be_message_error :base, translation, {index: 3, error_message: 'Erro do object 3'}, false

		if options[:condition]
			subject.stubs(options[:condition]).returns(false)
			wont_be_message_error :base, translation, {index: 2, error_message: 'Erro do object 2'}
			wont_be_message_error :base, translation, {index: 3, error_message: 'Erro do object 3'}, false
		end
	end

	def must_have_many attribute, klass, attrs={}
		subject.class.new.send(attribute).must_be_kind_of Array, 'deve inicializar o objeto com um Array'
		
		new_object = klass.new
		
		subject.send("#{attribute}=", [new_object, 1, 'string', nil, {}, [], :symbol, attrs, true])
		subject.send(attribute).size.must_equal 2
		subject.send(attribute)[0].must_equal new_object

		attrs.each do |attr_key, value|
			subject.send(attribute)[1].send(attr_key).must_equal value, 'Deveria setar o attributo se passar um hash'
		end

		subject.send("#{attribute}=", [])
		# posso adicionar valores com << 
		new_subject = subject.class.new
		new_subject.send(attribute) << new_object
		new_subject.send(attribute) << 1
		new_subject.send(attribute) << nil
		new_subject.send(attribute) << attrs

		new_subject.send(attribute).size.must_equal 2
		new_subject.send(attribute)[0].must_equal new_object

		attrs.each do |attr_key, value|
			new_subject.send(attribute)[1].send(attr_key).must_equal value, 'Deveria setar o attributo se passar um hash'
		end
	end

	def must_have_one attribute, klass, hash_attributes, *args
		options = {null: true, inverse_of: :reference}.merge(args.extract_options!)
		validate_have_one_accept_only_object_of_class(attribute, klass, options)
		validate_have_one_set_hash_values(attribute, klass, hash_attributes, options)
		validate_have_one_set_block_values(attribute, klass, hash_attributes, options)
		validate_have_one_inverse_of(attribute, klass, options)
		
		if options[:null]
			subject.send("#{attribute}=", hash_attributes)
			subject.send(attribute).must_be_kind_of klass

			subject.send("#{attribute}=", nil)
			subject.send(attribute).must_be_nil "Deveria aceitar setar nil no atributo #{attribute}"
		end
	end

	def must_validate_have_one attribute, klass, i18n_message
		msg_erro_1 = "Mensagem 1"
		msg_erro_2 = "Mensagem 2"
		object = klass.new
		object.errors.add :base, msg_erro_1
		object.errors.add :base, msg_erro_2
		object.expects(:invalid?).returns(true)
		subject.send("#{attribute}=", object)
		
		must_be_message_error(:base, i18n_message, {error_message: msg_erro_1})
		must_be_message_error(:base, i18n_message, {error_message: msg_erro_2}, false) # Para não executar mais o valid?
	end

	def wont_validate_have_one attribute, klass, i18n_message
		msg_erro_1 = "Mensagem 1"
		msg_erro_2 = "Mensagem 2"
		object = klass.new
		object.errors.add :base, msg_erro_1
		object.errors.add :base, msg_erro_2
		object.stubs(:invalid?).returns(true)
		subject.send("#{attribute}=", object)
		
		wont_be_message_error(:base, i18n_message, {error_message: msg_erro_1})
		wont_be_message_error(:base, i18n_message, {error_message: msg_erro_2}, false) # Para não executar mais o valid?
	end

	def must_returns_a_integer_for attribute
		subject.send("#{attribute}=", 1)
		subject.send(attribute).must_equal 1
		subject.send("#{attribute}=", '2')
		subject.send(attribute).must_equal 2
		subject.send("#{attribute}=", '')
		subject.send(attribute).must_be_nil
	end
	def must_returns_a_boolean_for attribute
		######### TRUE validations #########
		subject.send("#{attribute}=", 1)
		subject.send(attribute).must_equal true
		subject.send("#{attribute}=", '1')
		subject.send(attribute).must_equal true
		subject.send("#{attribute}=", 't')
		subject.send(attribute).must_equal true
		subject.send("#{attribute}=", true)
		subject.send(attribute).must_equal true
		######### FALSE validations #########
		subject.send("#{attribute}=", 0)
		subject.send(attribute).must_equal false
		subject.send("#{attribute}=", '0')
		subject.send(attribute).must_equal false
		subject.send("#{attribute}=", 'f')
		subject.send(attribute).must_equal false
		subject.send("#{attribute}=", false)
		subject.send(attribute).must_equal false
	end

	def must_have_default_value_for attribute, default_value
		msg = "O atributo #{attribute} deveria ter por padrão o valor #{default_value}."
		subject.class.new.send(attribute).must_equal default_value, msg
	end

	def nfe_must_be_valid_by_schema schema_name
		Dir.chdir(BrNfe.root+'/test/fixtures/product/schemas') do
			schema = Nokogiri::XML::Schema(IO.read(schema_name))
			document = Nokogiri::XML(subject.xml_builder)
			errors = schema.validate(document)
			errors.must_be_empty
		end
	end

private
	
	################################################################################
	#######################  VALIDAÇÕES PARA HAVE_ONE  #############################
		def validate_have_one_accept_only_object_of_class attribute, klass, options
			subject.send("#{attribute}=", nil)
			subject.send("#{attribute}=", 123456)
			validate_have_one_different_object_class(attribute, klass, options)
			subject.send("#{attribute}=", 'aaaa')
			validate_have_one_different_object_class(attribute, klass, options)
			
			new_obj = klass.new
			subject.send("#{attribute}=", new_obj)
			subject.send(attribute).must_equal new_obj
		end
		def validate_have_one_different_object_class attribute, klass, options
			if options[:null]
				subject.send(attribute).must_be_nil
			else
				subject.send(attribute).must_be_kind_of klass
			end
		end
		def validate_have_one_set_hash_values(attribute, klass, hash_attributes, options)
			subject.send("#{attribute}=", nil)
			subject.send("#{attribute}=", hash_attributes)
			subject.send(attribute).must_be_kind_of klass

			hash_attributes.each do |key, value|
				subject.send(attribute).send("#{key}").must_equal value
			end
		end
		def validate_have_one_set_block_values(attribute, klass, hash_attributes, options)
			subject.send("#{attribute}=", nil)
			subject.send(attribute) do |e| 
				hash_attributes.each do |key, value|
					e.send("#{key}=", value)
				end
			end

			subject.send(attribute).must_be_kind_of klass
			hash_attributes.each do |key, value|
				subject.send(attribute).send("#{key}").must_equal value
			end
		end
		def validate_have_one_inverse_of(attribute, klass, options)
			new_object = klass.new
			subject.instance_variable_set("@#{attribute}", new_object)
			new_object.send(options[:inverse_of]).must_be_nil
			subject.send(attribute).send(options[:inverse_of]).must_equal subject, "Deve setar o atributo #{options[:inverse_of]} do objeto #{attribute} no método get"
			new_object.send(options[:inverse_of]).must_equal subject
		end
	################################################################################
	#######################  VALIDAÇÕES PARA HAVE_ONE  #############################
		def validate_have_many_inverse_of(attribute, klass, options)
			subject.send("#{attribute}=",[])
			new_object = klass.new
			new_object.send(options[:inverse_of]).must_be_nil
			subject.send(attribute) << new_object
			subject.send(attribute)[0].send(options[:inverse_of]).must_equal subject, "Deve setar o atributo #{options[:inverse_of]} para o registro da associação #{attribute} no método get"
			new_object.send(options[:inverse_of]).must_equal subject
		end

	def get_message(msg, msg_params, column=:base)
		if !msg.is_a?(Symbol)
			msg
		else
			if I18n.exists?("activemodel.errors.models.#{subject.class.model_name.i18n_key}.attributes.#{column}.#{msg}")
				I18n.t("activemodel.errors.models.#{subject.class.model_name.i18n_key}.#{msg}", msg_params)
			elsif I18n.exists?("activemodel.errors.models.#{subject.class.model_name.i18n_key}.#{msg}")
				I18n.t("activemodel.errors.models.#{subject.class.model_name.i18n_key}.#{msg}", msg_params)
			elsif I18n.exists?("activemodel.errors.models.#{subject.class.superclass.model_name.i18n_key}.#{msg}")
				I18n.t("activemodel.errors.models.#{subject.class.superclass.model_name.i18n_key}.#{msg}", msg_params)
			elsif I18n.exists?("errors.messages.#{subject.class.model_name.i18n_key}.#{msg}")
				I18n.t("errors.messages.#{subject.class.model_name.i18n_key}.#{msg}", msg_params)
			elsif I18n.exists?("activemodel.errors.messages.#{msg}")
				I18n.t("activemodel.errors.messages.#{msg}", msg_params)
			else
				I18n.t("errors.messages.#{msg}", msg_params)
			end					
		end
	end
end