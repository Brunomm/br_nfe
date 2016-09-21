# encoding: utf-8
require 'br_nfe/version'
require 'active_model'
require 'active_support/core_ext/class'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

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

# Carrega os modules que contém os paths para buildar a resposta das requisições
require 'br_nfe/service/response/paths/base.rb'
require 'br_nfe/service/response/paths/v1/tc_nfse.rb'

require 'br_nfe/service/response/paths/v1/servico_consultar_lote_rps_resposta.rb'
require 'br_nfe/service/response/paths/v1/servico_consultar_nfse_resposta.rb'
require 'br_nfe/service/response/paths/v1/servico_consultar_nfse_rps_resposta.rb'
require 'br_nfe/service/response/paths/v1/servico_consultar_situacao_lote_rps_resposta.rb'
require 'br_nfe/service/response/paths/v1/servico_enviar_lote_rps_resposta.rb'
# Copyright (C) 2015 Bruno M. Mergen
#
# @author Bruno Mucelini Mergen <brunomergen@gmail.com>
#
#
module BrNfe
	def self.root
		File.expand_path '../..', __FILE__
	end

	Time::DATE_FORMATS[:br_nfe]     = "%Y-%m-%dT%H:%M:%S"
	DateTime::DATE_FORMATS[:br_nfe] = "%Y-%m-%dT%H:%M:%S"
	Date::DATE_FORMATS[:br_nfe]     = "%Y-%m-%d"

	def self.true_values
		[true, :true, 'true', 't', :t, 1, '1', :TRUE, 'TRUE', 'T']
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
			
			module Build
				extend ActiveSupport::Autoload
				autoload :Base
				autoload :Cancelamento
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
				module ResponsePaths
					extend ActiveSupport::Autoload
					autoload :ServicoConsultarLoteRpsResposta
					autoload :ServicoConsultarNfseResposta
					autoload :ServicoConsultarNfseRpsResposta
				end
				extend ActiveSupport::Autoload
				autoload :Gateway
				autoload :ConsultaLoteRps
				autoload :ConsultaNfse
				autoload :ConsultaNfsPorRps
				autoload :CancelamentoNfs
				autoload :ConsultaSituacaoLoteRps
				autoload :RecepcaoLoteRps
			end
		end
		module Thema
			module V1
				module ResponsePaths
					extend ActiveSupport::Autoload
					autoload :ServicoConsultarNfseRpsResposta
				end
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
				module ResponsePaths
					extend ActiveSupport::Autoload
					autoload :ServicoConsultarLoteRpsResposta
					autoload :ServicoConsultarNfseRpsResposta
					autoload :ServicoConsultarNfseResposta
					autoload :ServicoConsultarSituacaoLoteRpsResposta
					autoload :ServicoEnviarLoteRpsResposta
				end
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
		module Gateway
			extend ActiveSupport::Autoload
			autoload :Base
			autoload :WebServiceSVRS
		end
		autoload :Emitente
		autoload :ValueNf
		autoload :Base
		autoload :ConsultaStatusServico
	end


	########################## CONFIGURAÇÕES ###########################
	# Pode ser configurado
	# BrNfe.setup do |config|
	# 	config.endereco_class = MyCustomClassAddress
	# end
	# -----------------------------------------------------------------

	mattr_accessor :endereco_class
	@@endereco_class = BrNfe::Endereco

	# Define as classes que serão usadas para instanciar o objeto
	# Emitente para as notas de Serviço e Produto
	mattr_accessor :emitente_service_class
	mattr_accessor :emitente_product_class
	@@emitente_service_class = BrNfe::Service::Emitente
	@@emitente_product_class = BrNfe::Product::Emitente

	mattr_accessor :destinatario_service_class
	@@destinatario_service_class = BrNfe::Service::Destinatario

	mattr_accessor :intermediario_service_class
	@@intermediario_service_class = BrNfe::Service::Intermediario

	mattr_accessor :condicao_pagamento_class
	@@condicao_pagamento_class = BrNfe::CondicaoPagamento

	mattr_accessor :rps_class
	@@rps_class = BrNfe::Service::Rps

	mattr_accessor :service_item_class
	@@service_item_class = BrNfe::Service::Item

	mattr_accessor :client_wsdl_log
	@@client_wsdl_log = false
	
	mattr_accessor :client_wsdl_pretty_print_xml
	@@client_wsdl_pretty_print_xml = false
	
	def self.setup
		yield self
	end

	######################### END CONFIGURAÇÕES #########################

	include Helper
	include Service
end
