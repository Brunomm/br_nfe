module BrNfe
	module Product
		module Response
			class NfeInutilizacao < Base

				# Código da UF que atendeu a solicitação
				# 
				# <b>Type:     </b> _String_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _SC_
				# <b>Length:   </b> _2_
				# <b>tag:      </b> cUF
				#
				attr_accessor :uf
				alias_attribute :cUF, :uf

				####################################################################
				#        OS DADOS A SEGUIR APENAS SERÃO PREENCHIDOS SE A           #
				#     HOMOLOGAÇÃO DA INUTILIZAÇÃO OBTIVER SUCESSO (cStat=102)      #
				####################################################################
					# Ano de inutilização da numeração
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _SC_
					# <b>Length:   </b> _2_
					# <b>tag:      </b> cUF
					#
					attr_accessor :year
					alias_attribute :ano, :year

					# CNPJ do emitente
					# 
					# <b>Type:     </b> _String_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _12345678901234_
					# <b>Length:   </b> _14_
					# <b>tag:      </b> CNPJ
					#
					attr_accessor :cnpj
					alias_attribute :CNPJ, :cnpj

					# Modelo da NF-e
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _55_
					# <b>Length:   </b> _2_
					# <b>tag:      </b> mod
					#
					attr_accessor :nf_model
					alias_attribute :mod, :nf_model

					# Série da NF-e
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1_
					# <b>Length:   </b> _min: 1, max: 3_
					# <b>tag:      </b> serie
					#
					attr_accessor :nf_series
					alias_attribute :serie, :nf_series

					# Número da NF-e inicial a ser inutilizada
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1_
					# <b>Length:   </b> _min: 1, max: 3_
					# <b>tag:      </b> nNFIni
					#
					attr_accessor :start_invoice_number
					alias_attribute :nNFIni, :start_invoice_number

					# Número da NF-e final a ser inutilizada
					# 
					# <b>Type:     </b> _Number_
					# <b>Required: </b> _No_
					# <b>Example:  </b> _1_
					# <b>Length:   </b> _min: 1, max: 3_
					# <b>tag:      </b> nNFFin
					#
					attr_accessor :end_invoice_number
					alias_attribute :nNFFin, :end_invoice_number
			end
		end
	end
end