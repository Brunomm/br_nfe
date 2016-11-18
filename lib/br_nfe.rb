# encoding: utf-8
require 'br_nfe/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'
require 'active_support/core_ext/module'

require "br_nfe/active_model/associations"

require "br_nfe/helper/string_methods"

require "signer"
require "savon"
require "slim"

require "br_nfe/association/have_address"
require "br_nfe/association/have_condicao_pagamento"
require "br_nfe/association/have_emitente"
require "br_nfe/association/have_destinatario"

require "br_nfe/service/association/have_intermediario"
require "br_nfe/service/association/have_rps"

# Formatação de valores para XML
require "br_nfe/service/concerns/values_ts/service_v1"

# Regras e atributos para as classes 
require "br_nfe/service/concerns/rules/recepcao_lote_rps"
require "br_nfe/service/concerns/rules/consulta_nfse"
require "br_nfe/service/concerns/rules/consulta_nfs_por_rps"
require "br_nfe/service/concerns/rules/cancelamento_nfs"

# Carrega os modules que contém os paths para buildar a nfs
require 'br_nfe/service/response/paths/v1/tc_nfse.rb'

# Copyright (C) 2015 Bruno M. Mergen
#
# @author Bruno Mucelini Mergen <brunomergen@gmail.com>
#
#
module BrNfe
	def self.root
		File.expand_path '../..', __FILE__
	end

	I18n.load_path += Dir[BrNfe.root+'/lib/config/locales/br_nfe/**/*.{rb,yml}']

	Time::DATE_FORMATS[:br_nfe]     = "%Y-%m-%dT%H:%M:%S"
	DateTime::DATE_FORMATS[:br_nfe] = "%Y-%m-%dT%H:%M:%S"
	Date::DATE_FORMATS[:br_nfe]     = "%Y-%m-%d"

	def self.true_values
		[true, :true, 'true', 't', :t, 1, '1', :TRUE, 'TRUE', 'T']
	end

	module Calculos
		extend ActiveSupport::Autoload
		autoload :FatoresDeMultiplicacao
		autoload :Modulo11
		autoload :Modulo11FatorDe2a9
		autoload :Modulo11FatorDe2a9RestoZero
	end

	extend ActiveSupport::Autoload
	autoload :Constants
	autoload :ActiveModelBase
	autoload :Endereco
	autoload :Person
	autoload :Base
	autoload :CondicaoPagamento


	module Service
		extend ActiveSupport::Autoload
		module Response
			extend ActiveSupport::Autoload
			autoload :Default
			autoload :NotaFiscal
			autoload :Cancelamento
			autoload :ConsultaLoteRps
			autoload :ConsultaNfsPorRps
			autoload :ConsultaNfse
			autoload :ConsultaSituacaoLoteRps
			autoload :RecepcaoLoteRps
			
			module Build
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :InvoiceBuild
				autoload :Cancelamento
				autoload :ConsultaLoteRps
				autoload :ConsultaNfsPorRps
				autoload :ConsultaNfse
				autoload :ConsultaSituacaoLoteRps
				autoload :RecepcaoLoteRps
			end
		end
		
		autoload :Emitente
		autoload :Destinatario
		autoload :Intermediario
		autoload :Item
		autoload :Rps
		autoload :Base

		module Betha
			extend ActiveSupport::Autoload
			autoload :Base
			module V1
				extend ActiveSupport::Autoload
				autoload :Gateway
				autoload :ConsultaLoteRps
				autoload :ConsultaNfse
				autoload :ConsultaNfsPorRps
				autoload :CancelaNfse
				autoload :ConsultaSituacaoLoteRps
				autoload :RecepcaoLoteRps
			end
		end
		module Thema
			module V1
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :CancelaNfse
				autoload :ConsultaSituacaoLoteRps
				autoload :ConsultaNfsPorRps
				autoload :RecepcaoLoteRps
				autoload :RecepcaoLoteRpsLimitado
				autoload :ConsultaNfse
				autoload :ConsultaLoteRps
			end
		end
		module Simpliss
			module V1
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :CancelaNfse
				autoload :ConsultaSituacaoLoteRps
				autoload :ConsultaNfsPorRps
				autoload :RecepcaoLoteRps
				autoload :RecepcaoLoteRpsLimitado
				autoload :ConsultaNfse
				autoload :ConsultaLoteRps
			end
		end
		module SC
			module Florianopolis
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :EmissionRPS
				autoload :Cancellation
			end
		end
	end

	module Helper
		extend ActiveSupport::Autoload
		autoload :CpfCnpj

		def self.only_number(value)
			"#{value}".gsub(/[^0-9]/,'')
		end
	end

	module Product
		extend ActiveSupport::Autoload

		module Nfe
			extend ActiveSupport::Autoload
			autoload :DeclaracaoImportacao
			autoload :AdicaoImportacao
			autoload :Item
			module Cobranca
				extend ActiveSupport::Autoload
				autoload :Fatura
				autoload :Duplicata
				autoload :Pagamento
			end
			module Transporte
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :Veiculo
				autoload :Volume
				autoload :Transportador
			end
		end
		module Gateway
			extend ActiveSupport::Autoload
			autoload :Base
			autoload :WebServiceAM
			autoload :WebServiceBA
			autoload :WebServiceCE
			autoload :WebServiceGO
			autoload :WebServiceMG
			autoload :WebServiceMS
			autoload :WebServiceMT
			autoload :WebServicePE
			autoload :WebServicePR
			autoload :WebServiceRS
			autoload :WebServiceSP
			autoload :WebServiceSVAN
			autoload :WebServiceSvcAN
			autoload :WebServiceSvcRS
			autoload :WebServiceSVRS
		end
		autoload :NfXmlValue
		autoload :Emitente
		autoload :Destinatario
		autoload :NotaFiscal
		
		autoload :Base
		autoload :NfeStatusServico
		autoload :NfeAutorizacao
	end


	########################## CONFIGURAÇÕES ###########################
	# Pode ser configurado
	# BrNfe.setup do |config|
	# 	config.endereco_class = MyCustomClassAddress
	# end
	# -----------------------------------------------------------------

	mattr_accessor :endereco_class
	@@endereco_class = BrNfe::Endereco

	mattr_accessor :condicao_pagamento_class
	@@condicao_pagamento_class = BrNfe::CondicaoPagamento

	mattr_accessor :client_wsdl_log
	@@client_wsdl_log = false
	
	mattr_accessor :client_wsdl_pretty_print_xml
	@@client_wsdl_pretty_print_xml = false
	
	#################################################################################
	################### DEFINIÇÃO DE CLASSES PADRÕES PARA NFS-e #####################
		mattr_accessor :emitente_service_class
		@@emitente_service_class = BrNfe::Service::Emitente
		mattr_accessor :destinatario_service_class
		@@destinatario_service_class = BrNfe::Service::Destinatario
		mattr_accessor :intermediario_service_class
		@@intermediario_service_class = BrNfe::Service::Intermediario
		mattr_accessor :rps_class
		@@rps_class = BrNfe::Service::Rps
		mattr_accessor :service_item_class
		@@service_item_class = BrNfe::Service::Item

	#################################################################################
	################### DEFINIÇÃO DE CLASSES PADRÕES PARA NF-E ######################
		mattr_accessor :destinatario_product_class
		@@destinatario_product_class = BrNfe::Product::Destinatario
		mattr_accessor :emitente_product_class
		@@emitente_product_class = BrNfe::Product::Emitente
		mattr_accessor :nota_fiscal_product_class
		@@nota_fiscal_product_class = BrNfe::Product::NotaFiscal
		mattr_accessor :declaracao_importacao_product_class
		@@declaracao_importacao_product_class = BrNfe::Product::Nfe::DeclaracaoImportacao
		mattr_accessor :adicao_importacao_product_class
		@@adicao_importacao_product_class = BrNfe::Product::Nfe::AdicaoImportacao

		############################# COBRANÇA #############################
		mattr_accessor :duplicata_product_class
		@@duplicata_product_class = BrNfe::Product::Nfe::Cobranca::Duplicata
		mattr_accessor :fatura_product_class
		@@fatura_product_class = BrNfe::Product::Nfe::Cobranca::Fatura
		mattr_accessor :pagamento_product_class
		@@pagamento_product_class = BrNfe::Product::Nfe::Cobranca::Pagamento

		############################ TRANSPORTE ############################
		mattr_accessor :transporte_product_class
		@@transporte_product_class = BrNfe::Product::Nfe::Transporte::Base

		mattr_accessor :veiculo_product_class
		@@veiculo_product_class = BrNfe::Product::Nfe::Transporte::Veiculo

		mattr_accessor :volume_transporte_product_class
		@@volume_transporte_product_class = BrNfe::Product::Nfe::Transporte::Volume
		
		mattr_accessor :transportador_product_class
		@@transportador_product_class = BrNfe::Product::Nfe::Transporte::Transportador
		
	
	def self.setup
		yield self
	end

	######################### END CONFIGURAÇÕES #########################

	include Helper
	include Service
end
