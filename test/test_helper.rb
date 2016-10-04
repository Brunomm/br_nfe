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

class MiniTest::Spec
	include Savon::SpecHelper
	include Shoulda::Matchers::ActiveModel
	include FactoryGirl::Syntax::Methods
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

	def must_have_alias_attribute(alias_name, attribute, test_value=1)
		subject.send("#{attribute}=", test_value)
		subject.send(alias_name).must_equal test_value

		subject.send("#{alias_name}=", test_value)
		subject.send(attribute).must_equal test_value
	end

private

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