module BrNfe
	module Service
		module Govbr
			module V1
				class Base < BrNfe::Service::Base

					def ssl_request?
						true
					end

					def get_wsdl_by_city
						{
							# Guarapari-ES
							'3202405' => "http://nfse.guarapari.es.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Boa Esperança-MG
							'3107109' => "http://receita.boaesperanca.mg.gov.br:8082/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",
							
							# Contagem-MG
							'3118601' => "http://#{env == :test ? 'teste' : 'nfse'}.contagem.mg.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",
							
							# Naviraí-MS
							'5005707' => "http://187.6.10.202:9191/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Altonia-PR
							'410050' => (env == :test ? :unknow : "http://201.87.233.17:5620/NFSEWS/Services.svc?wsdl"),

							# Apucarana-PR
							'410140' => (env == :test ? :unknow : "http://cetil.apucarana.pr.gov.br/NFSEWS/Services.svc?wsdl"),

							# Assis Chateaubriand-PR
							'410200' => "http://177.38.165.34:8184/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Itaipulândia-PR
							'4110953' => (env == :test ? :unknow : "http://177.10.24.51:9091/NFSEWS/Services.svc?wsdl"),

							# Jacarezinho-PR
							'4111803' => "http://186.251.15.6:8486/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Jandaia Do Sul-PR
							'4112108' => (env == :test ? :unknow : "http://187.109.161.3:8082/nfseWS/Services.svc?wsdl"),

							# Marmeleiro-PR
							'4115408' => "http://nfse.marmeleiro.pr.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Matinhos-PR
							'4115705' => (env == :test ? :unknow : "http://nfse.matinhos.pr.gov.br/NFSEWS/Services.svc?wsdl"),

							# Medianeira-PR
							'4115804' => (env == :test ? :unknow : "http://nfse.medianeira.pr.gov.br:8080/NFSEWS/Services.svc?wsdl"),

							# Pato Branco-PR
							'4118501' => "http://nfse.patobranco.pr.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Rolândia-PR
							'4122404' => (env == :test ? :unknow : "http://nfse.rolandia.pr.gov.br/NFSEWS/Services.svc?wsdl"),

							# Santa Terezinha de Itaipu-PR
							'4124053' => (env == :test ? :unknow : "http://nfse.stitaipu.pr.gov.br/NFSEWS/Services.svc?wsdl"),

							# Santo Antônio da Platina-PR
							'4124103' => (env == :test ? :unknow : "http://186.251.15.12:90/NFSEWS/Services.svc?wsdl"),

							# Tupãssi-PR
							'4127957' => (env == :test ? :unknow : "http://200.195.176.227/nfsews/services.svc?wsdl"),
							
							# Santo Antônio de Pádua-RJ
							'3304706' => "http://sistemas.padua.rj.gov.br/nfsews#{'teste' if env == :test}/services.svc?wsdl",

							# Vassouras-RJ
							'3306206' => "http://186.226.210.213/nfsews#{'teste' if env == :test}/services.svc?wsdl",

							# Camaquã-RS
							'4303509' => "http://portal.camaqua.rs.gov.br#{':8181' if env == :test}/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Feliz-RS
							'4308102' => "http://187.84.56.#{env == :test ? '69:8082' : '68:8081'}/nfsews#{'teste' if env == :test}/Services.svc?wsdl",

							# Guaporé-RS
							'4309407' => "http://nfse.guapore.rs.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Ijuí-RS
							'4310207' => "http://#{env == :test ? 'ambienteteste' : 'server21'}.ijui.rs.gov.br/nfsews#{'teste' if env == :test}/Services.svc?wsdl",

							# Nova Santa Rita-RS
							'4313375' => "http://nfse.novasantarita.rs.gov.br#{':8181' if env == :test}/NFSEWS#{'TESTE' if env == :test}//Services.svc?wsdl",

							# Picada Café-RS
							'4314423' => "http://portal.picadacafe.rs.gov.br:#{env == :test ? '8383' : '8585'}/nfsews#{'teste' if env == :test}/Services.svc?wsdl",

							# São Gabriel-RS
							'4318309' => "http://191.36.145.163/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Soledade-RS
							'4320800' => "http://nfsesoledade.ddns.net/nfsews#{'teste' if env == :test}/services.svc?wsdl",

							# Três Coroas-RS
							'4321709' => "http://nfse#{'teste' if env == :test}.pmtcoroas.com.br/nfsews#{'teste' if env == :test}/Services.svc?wsdl",

							# Triunfo-RS (Dueto-GovBr)
							'4322004' => "#{env == :test ? 'http://189.30.16.212:90/nfsewsteste/Services.svc?wsdl' : 'http://deiss.triunfo.rs.gov.br:90/nfsews/Services.svc?wsdl'}",

							# Uruguaiana-RS
							'4322400' => (env == :test ? :unknow : "http://177.36.44.89:7778/NFSEWS/Services.svc?wsdl"),

							# Barrinha-SP
							'3505609' => (env == :test ? :unknow : "http://186.232.87.226:90/NFSEWS/Services.svc?wsdl"),

							# Catanduva-SP
							'3511102' => "http://nfse.catanduva.sp.gov.br/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Charqueada-SP
							'3511706' => "http://189.109.40.26:49392/nfsews#{'teste' if env == :test}/services.svc?wsdl",

							# Colina-SP
							'3512001' => "http://200.144.17.186/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Mirassol-SP
							'3530300' => "http://nfse.mirassol.sp.gov.br:5557/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Regente Feijó-SP 
							'3542404' => "http://nfse.regentefeijo.sp.gov.br:81/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Rosana-SP
							'3544251' => "http://200.159.122.139/NFSEWS#{'TESTE' if env == :test}/Services.svc?wsdl",

							# Salto Grande-SP
							'3545407' => "http://200.192.244.89/nfsews#{'teste' if env == :test}/services.svc?wsdl",

						}
					end

					def wsdl
						if gtw = get_wsdl_by_city[ibge_code_of_issuer_city]
							gtw == :unknow ? unknow_env_test : gtw
						else # Default for tdd
							"http://nfse.patobranco.pr.gov.br/NFSEWSTESTE/Services.svc?wsdl"
						end
					end

					# def wsdl
					# 	if env == :test
					# 		'http://nfse.guapore.rs.gov.br/NFSEWSTESTE/Services.svc?wsdl'
					# 	else 
					# 		'http://nfse.guapore.rs.gov.br/NFSEWS/Services.svc?wsdl'
					# 	end
					# end

					# Declaro que o método `render_xml` irá verificar os arquivos também presentes
					# no diretório especificado
					#
					# <b>Tipo de retorno: </b> _Array_
					#
					def xml_current_dir_path
						["#{BrNfe.root}/lib/br_nfe/service/govbr/v1/xml"]+super
					end

					def canonicalization_method_algorithm
						'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
					end

					def message_namespaces
						{
							'xmlns:ns4'     =>  "http://tempuri.org/tipos_complexos.xsd",
							# xmlns: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'
						}
					end

					def namespace_identifier
						'ns3:'
					end

					def namespace_for_tags
						'ns4:'
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
						dados =  "<#{soap_body_root_tag} xmlns=\"http://tempuri.org/\">"
						# dados <<    '<cabecalho versao="1.00" xmlns="http://tempuri.org">'
						# dados <<      '<versaoDados>1.00</versaoDados>'
						# dados <<    '</cabecalho>'
						dados <<    '<xmlEnvio>'
						dados <<      "<![CDATA[<?xml version=\"1.0\" encoding=\"UTF-8\"?>#{xml_builder.html_safe}]]>"
						dados <<    '</xmlEnvio>'
						dados << "</#{soap_body_root_tag}>"
						dados
					end
				end
			end
		end
	end
end