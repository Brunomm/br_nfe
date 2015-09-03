# encoding: utf-8
require 'br_nfe/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

require "signer"
require "savon"

require "br_nfe/helper/have_address"



# Copyright (C) 2015 Bruno M. Mergen
#
# @author Bruno Mucelini Mergen <brunomergen@gmail.com>
#
#
module BrNfe
	Time::DATE_FORMATS[:br_nfe]     = "%Y-%m-%dT%H:%M:%S"
	DateTime::DATE_FORMATS[:br_nfe] = "%Y-%m-%dT%H:%M:%S"
	Date::DATE_FORMATS[:br_nfe]     = "%Y-%m-%d"

	extend ActiveSupport::Autoload
	autoload :ActiveModelBase
	autoload :Endereco
	autoload :Emitente
	autoload :Destinatario
	autoload :Response
	autoload :Base
	autoload :Seed
	autoload :CondicaoPagamento

	module Servico
		extend ActiveSupport::Autoload
		autoload :Intermediario
		autoload :Rps
		autoload :Base

		module Betha
			extend ActiveSupport::Autoload
			autoload :Base
			module V1
				extend ActiveSupport::Autoload
				autoload :Gateway
				autoload :Response
				autoload :ConsultaLoteRps
				autoload :ConsultaNfse
				autoload :ConsultaNfsPorRps
				autoload :CancelamentoNfs
				autoload :ConsultaSituacaoLoteRps
				autoload :RecepcaoLoteRps
			end
			module V2
				extend ActiveSupport::Autoload
				autoload :Gateway
				autoload :Response
				autoload :ConsultaLoteRps
				autoload :RecepcionaLoteRps
			end
		end
	end

	module Helper
		extend ActiveSupport::Autoload
		autoload :CpfCnpj
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

	mattr_accessor :intermediario_class
	@@intermediario_class = BrNfe::Servico::Intermediario

	mattr_accessor :condicao_pagamento_class
	@@condicao_pagamento_class = BrNfe::CondicaoPagamento

	# Configurações do Cliente WSDL
	mattr_accessor :client_wsdl_ssl_verify_mode
	@@client_wsdl_ssl_verify_mode = :none

	mattr_accessor :client_wsdl_ssl_cert_file
	mattr_accessor :client_wsdl_ssl_cert_key_file
	mattr_accessor :client_wsdl_ssl_cert_key_password
	
	mattr_accessor :client_wsdl_log
	@@client_wsdl_log = false
	
	mattr_accessor :client_wsdl_pretty_print_xml
	@@client_wsdl_pretty_print_xml = false
	
	def self.setup
		yield self
	end

	######################### END CONFIGURAÇÕES #########################

	include Helper
	include Servico
end
