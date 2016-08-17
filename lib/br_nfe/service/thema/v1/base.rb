module BrNfe
	module Service
		module Thema
			module V1
				class Base < BrNfe::Service::Base

					def get_wsdl_by_city
						if ibge_code_of_issuer_city == '4205902' # Gaspar-SC
							{
								send:    "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl",
								consult: "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfse#{'hml' if env == :test}.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl"
							}
						else # Default for tdd
							{
								send:    "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEremessa?wsdl",
								consult: "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEconsulta?wsdl",
								cancel:  "http://nfsehml.gaspar.sc.gov.br/nfse/services/NFSEcancelamento?wsdl"
							}
						end
						
					end

					# Assinatura através da gem signer
					def signature_type
						:method_sign
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{"xmlns" => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"}
					end

					def soap_namespaces
						super.merge({"xmlns:ns1" => "http://server.nfse.thema.inf.br"})
					end

					# Setado manualmente em content_xml
					#
					def namespace_identifier
					end

					# Método que deve ser sobrescrito em cada subclass.
					# É utilizado para saber qual a tag root de cada requisição
					# 
					# <b><Tipo de retorno: /b> _String_
					#
					def soap_body_root_tag
						# 'recepcionarLoteRps' < Exemplo
						raise "Deve ser sobrescrito nas subclasses"
					end

					def response_encoding
						'ISO-8859-1'
					end

					def nfse_xml_path
						'//*' #Começa o XMl a partir do body e pega a tag ConsultarNfseResposta
					end

					# Método é sobrescrito para atender o padrão do órgão emissor.
					# Deve ser enviado o XML da requsiução dentro da tag CDATA
					# seguindo a estrutura requerida.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						xml_signed = xml_builder.html_safe

						dados = "<ns1:#{soap_body_root_tag}>"
						dados += '<ns1:xml>'
						dados += '<![CDATA['
						dados += '<?xml version="1.0" encoding="ISO-8859-1"?>' unless xml_signed.include?('<?xml')
						dados += xml_signed
						dados += ']]>'
						dados += '</ns1:xml>'
						dados += "</ns1:#{soap_body_root_tag}>"
						dados
					end

					# Alíquota. Valor percentual.
					#  Formato: 0.XXXX
					#  Ex: 1% = 0.01
					#  25,5% = 0.255
					#  100% = 1.0
					# Irá receber o valor decimal do percentual da aliquota
					# e irá dividir por 100 conforme indicado na documentação.
					#
					def ts_aliquota value
						value = value.to_f/100
						value_monetary(value, 4)
					end

				end
			end
		end
	end
end