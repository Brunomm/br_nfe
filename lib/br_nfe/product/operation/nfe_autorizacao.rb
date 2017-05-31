module BrNfe
	module Product
		module Operation
			class NfeAutorizacao < Base

				# NÚMERO DO LOTE
				# Identificador de controle do envio do lote.
				# Número sequencial autoincremental, de controle
				# correspondente ao identificador único do lote
				# enviado. A responsabilidade de gerar e controlar
				# esse número é exclusiva do contribuinte.
				# 
				# <b>Type:     </b> _Number_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _20161230135547_
				# <b>Length:   </b> _max: 15_
				# <b>tag:      </b> idLote
				#
				attr_accessor :numero_lote
				alias_attribute :idLote, :numero_lote

				# INDICADOR DO PROCESSAMENTO SINCRONO OU ASINCRONO
				# false = 0=Não. (Default)
				# true  = 1=Empresa solicita processamento síncrono do
				#         Lote de NF-e (sem a geração de Recibo para consulta futura);
				#
				# Nota: O processamento síncrono do Lote corresponde a entrega 
				# da resposta do processamento das NF-e do Lote, sem a geração
				# de um Recibo de Lote para consulta futura. A resposta de forma 
				# síncrona pela SEFAZ Autorizadora só ocorrerá se:
				# - a empresa solicitar e constar unicamente uma NF-e no Lote;
				# - a SEFAZ Autorizadora implementar o processamento síncrono 
				#   para a resposta do Lote de NF-e.
				# 
				# <b>Type:     </b> _Boolean_
				# <b>Required: </b> _Yes_
				# <b>Example:  </b> _true_
				# <b>Default:  </b> _false_
				# <b>tag:      </b> indSinc
				#
				attr_accessor :sincrono
				def sincrono
					convert_to_boolean(@sincrono)
				end
				alias_attribute :indSinc, :sincrono

				# Array com as notas fiscais a serem emitidas
				# Pode ser adicionado os dados das notas fiscais em forma de `Hash` ou
				# O próprio objeto da NF-e.
				#
				# Exemplo com Hash:
				#    self.notas_fiscais = [{serie: 1, numero_nf: 1143, ...},{serie: 1, numero_nf: 1144, ...}]
				#    self.notas_fiscais << {serie: 1, numero_nf: 1145, ...}
				#    self.notas_fiscais << {serie: 1, numero_nf: 1146, ...}
				#
				# Exemplo com Objetos:
				#    self.notas_fiscais = [BrNfe::Product::NotaFiscal.new({serie: 1, numero_nf: 1143, ...}),{serie: 1, numero_nf: 1144, ...}]
				#    self.notas_fiscais << BrNfe::Product::NotaFiscal.new({serie: 1, numero_nf: 1145, ...})
				#    self.notas_fiscais << {serie: 1, numero_nf: 1146, ...}
				#
				# Sempre vai retornar um Array de objetos da class configurada em `BrNfe.nota_fiscal_product_class`
				#
				# <b>Tipo: </b> _BrNfe.nota_fiscal_product_class (BrNfe::Product::NotaFiscal)_
				# <b>Min: </b> _1_
				# <b>Max: </b> _50_
				# <b>Default: </b> _[]_
				#
				has_many :notas_fiscais, 'BrNfe.nota_fiscal_product_class'

				validate_has_many :notas_fiscais, message: :invalid_invoice
				validates :notas_fiscais, length: {in: 1..50}
				validates :numero_lote, presence: true
				validates :numero_lote, numericality: {only_integer: true}, allow_blank: true
				validates :numero_lote, length: {maximum: 15}, allow_blank: true

				def operation_name
					:autorizacao
				end

				# XML que será enviado no body da requisição SOAP contendo as informações
				# específicas de cada operação.
				def xml_builder
					@xml_builder ||= render_xml 'root/NfeAutorizacao'
				end

				def response_class_builder
					BrNfe::Product::Response::Build::NfeAutorizacao
				end
			end
		end
	end
end