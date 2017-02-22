module BrNfe
	module Service
		module Fisslex
			module V1
				class Base < BrNfe::Service::Base

					def gateway
						{
							'5101704' => { # Barra do Bugres - MT
								cancelar_nfse:               'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://barradobugres.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://barradobugres.fisslex.com.br
							}, 

							'5105101' => { # Juara - MT
								cancelar_nfse:               'https://juara.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://juara.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://juara.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://juara.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://juara.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://juara.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://juara.fisslex.com.br
							}, 

							'5105150' => { # Juina - MT
								cancelar_nfse:               'https://juina.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://juina.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://juina.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://juina.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://juina.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://juina.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://juina.fisslex.com.br
							}, 

							'5106232' => { # Nova Olimpia - MT
								cancelar_nfse:               'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://novaolimpia.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://novaolimpia.fisslex.com.br
							}, 

							'5107248' => { # Santa Carmem - MT
								cancelar_nfse:               'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://santacarmem.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://santacarmem.fisslex.com.br
							},  

							'5107800' => { # Santo António do Leverger - MT
								cancelar_nfse:               'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://leverger.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://leverger.fisslex.com.br
							},   

							'5107875' => { # Sapezal - MT
								cancelar_nfse:               'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://sapezal.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://sapezal.fisslex.com.br
							},   
							
							'5107909' => { # Sinop - MT
								cancelar_nfse:               'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://sinop.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://sinop.fisslex.com.br
							},  

							'1100106' => { # Guajará-Mirim - RO
								cancelar_nfse:               'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://guajara.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
								# Documentação: https://guajara.fisslex.com.br
							},  
						}
					end

					def get_wsdl_by_city
						if env == :test
							{
								cancelar_nfse:               'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
							}
						elsif gtw = gateway[ibge_code_of_issuer_city]
							gtw
						else # Default for tdd
							{
								cancelar_nfse:               'https://demo.fisslex.com.br/fiss-lex/servlet/aws_cancelarnfse?wsdl',
								consultar_nfse:              'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultanfse?wsdl',
								consultar_lote_rps:          'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultaloterps?wsdl',
								consultar_nfse_por_rps:      'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultanfseporrps?wsdl',
								consultar_situacao_lote_rps: 'https://demo.fisslex.com.br/fiss-lex/servlet/aws_consultarsituacaoloterps?wsdl',
								recepcionar_lote_rps:        'https://demo.fisslex.com.br/fiss-lex/servlet/aws_recepcionarloterps?wsdl',
							}
						end
						
					end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/fisslex/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{}
					end

					def message_namespaces_enviar_lote
						{'xmlns' => "http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd",}
					end

					def namespace_identifier
						'fiss:'
					end

					def soap_namespaces
						super.merge({
							'xmlns:fiss'  =>  "FISS-LEX"
						})
					end

					def method_wsdl
						:execute
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

					# Método é sobrescrito para atender o padrão do órgão emissor.
					# 
					# <b><Tipo de retorno: /b> _String_ XML
					#
					def content_xml
						dados =  "<fiss:#{soap_body_root_tag}>"
						dados << 	"#{xml_builder.html_safe}"
						dados << "</fiss:#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end