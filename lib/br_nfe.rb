# encoding: utf-8
require 'br_nfe/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

require "signer"
require "savon"



# Copyright (C) 2015 Bruno M. Mergen <http://duobr.com.br>
#
# @author Bruno Mucelini Mergen <brunomergen@gmail.com>
#
#
module BrNfe
	extend ActiveSupport::Autoload
	autoload :ActiveModelBase
	autoload :Endereco
	autoload :Emitente
	autoload :Destinatario
	autoload :Base

	module Servico
		extend ActiveSupport::Autoload
		autoload :Intermediario
		autoload :Rps
		autoload :Base

		module Betha
			extend ActiveSupport::Autoload
			autoload :Gateway
			autoload :ConsultaLoteRps
			autoload :RecepcionaLoteRps

		end
	end

	module Helper
		extend ActiveSupport::Autoload
		autoload :CpfCnpj
		autoload :Number
		autoload :StringMethods
	end


	########################## CONFIGURAÇÕES ###########################
	# Pode ser configurado
	# BrNfe.setup do |config|
	# 	config.endereco_class = MyCustomClassAddress
	# end
	# -----------------------------------------------------------------

	mattr_accessor :endereco_class
	@@endereco_class = BrNfe::Endereco

	mattr_accessor :emitente_class
	@@emitente_class = BrNfe::Emitente

	mattr_accessor :destinatario_class
	@@destinatario_class = BrNfe::Destinatario

	
	def self.setup
		yield self
	end

	######################### END CONFIGURAÇÕES #########################

	include Helper
	include Servico
end
