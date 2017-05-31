module BrNfe
	class Base < BrNfe::ActiveModelBase
		include BrNfe::Association::HaveEmitente

		attr_accessor :certificate_pkcs12_password
		attr_accessor :certificate_pkcs12_path
		attr_accessor :certificate_pkcs12_value
		attr_accessor :env

		# Código IBGE da cidade emitente
		attr_accessor :ibge_code_of_issuer_city
		def ibge_code_of_issuer_city
			"#{@ibge_code_of_issuer_city ||= emitente.endereco.codigo_municipio}"
		end

		# Código IBGE do estado emitente
		attr_accessor :ibge_code_of_issuer_uf
		def ibge_code_of_issuer_uf
			"#{@ibge_code_of_issuer_uf ||= emitente.endereco.codigo_ibge_uf}"
		end

		validate :validar_emitente
		validates :certificate, :certificate_key, presence: true, if: :certificado_obrigatorio?

		# Método que deve ser sobrescrito para as ações que necessitam do certificate_pkcs12 para assinatura
		def certificado_obrigatorio?
			false
		end

		def env
			@env ||= :production
		end

		def env_test?
			env == :test
		end

		def original_response
			@original_response
		end

		def response
			@response
		end
		
		# Namespace da requisição SOAP
		#
		def env_namespace
			:soapenv
		end

		# Para saber se deve add o attr id na assinatura
		def id_attribute?
			true
		end

		# Deve conter o LINK do webservice a ser chamado
		# TODO: Remover método quando reconfigurar a emissão das notas de serviço
		#
		def url_wsdl
			raise "Não implementado."
		end

		# Método que contem qual a operação que deverá ser chamada
		# do WS SOAP.
		#
		def method_wsdl
			raise "Não implementado."
		end

		# O xml_builder é o que contém o conteúdo de cada tipo de requisição
		# e deve ser sobrescrito em cada classe implementada. Por exemplo:
		# recepcao_lote_rps, consulta_lote_rps, cancelamento_nfs, etc..
		#
		def xml_builder
			raise "Não implementado."
		end

		# Esse método serve para ser utilizado no Base de cada orgão emissor
		# onde em alguns casos é necessário colocar o xml em um CDATA
		# É esse método que é passado dentro do Body da equisição SOAP
		#
		def content_xml
			xml_builder
		end

		# O Namespace Indentifier é utilizado para adicionar o
		# namespace na tag principal da requisição. Normalmente deve seguir 
		# o namespace utilizado para identificar o namespace da mensagem.
		#
		# Exemplo: se o método message_namespaces for {xmlns:ns1="http...."} então
		# o namespace_identifier deveria ser 'ns1:'.
		# E com isso irá adicionar o namespace na tag principal da requsição. 
		# Exemplo com a requisição EnviarLoteRps:
		# COM namespace_identifier => ns1:EnviarLoteRpsEnvio
		# SEM namespace_identifier => EnviarLoteRpsEnvio
		#
		# <b>Tipo de retorno: </b> _String_ OR _Nil_
		#
		def namespace_identifier
		end

		# Utilizado para colocar o namespace nas tags de valores
		# Exemplo:
		# <ns1:LoteRps id="123">
		#   <ns1:NumeroLote>3311</ns1:NumeroLote>
		#   <ns1:Cnpj>23020443000140</ns1:Cnpj>
		def namespace_for_tags
		end

		# Utilizado para colocar o namespace nas tags da assiantura
		# Exemplo:
		# <ns2:Signature Id="?">
		#    <ns2:SignedInfo Id="?">
		#      <ns2:CanonicalizationMethod Algorithm="?">?</ns2:CanonicalizationMethod>
		#      ..... 
		# 
		def namespace_for_signature
		end

		def message_namespaces
			{}
		end

		def soap_namespaces
			{
				'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
				'xmlns:ins0'    => 'http://www.w3.org/2000/09/xmldsig#',
				'xmlns:xsd'     => 'http://www.w3.org/2001/XMLSchema',
				'xmlns:xsi'     => 'http://www.w3.org/2001/XMLSchema-instance'
			}
		end

		def wsdl_encoding
			"UTF-8"
		end

		def response_encoding
			"UTF-8"
		end

		# Tag XML que vai na requisição SOAP
		#
		# <b>Tipo de retorno: </b> _String_
		#
		def tag_xml
			"<?xml version=\"1.0\" encoding=\"#{wsdl_encoding}\"?>"
		end

		# XML que irá na requisição SOAP
		#
		# <b>Tipo de retorno: </b> _String XML_
		#
		def soap_xml
			@soap_xml ||= "#{tag_xml}#{render_xml('soap_env')}".html_safe
		end

		# Versão do XML utilizado 
		# Cada Cidade pode utilizar uma versão diferente do XML
		#
		# <b>Tipo de retorno: </b> _Symbol_
		#
		def xml_version
			:v1
		end

		def client_wsdl_params
			{
				wsdl:             url_wsdl,
				log:              BrNfe.client_wsdl_log,
				pretty_print_xml: BrNfe.client_wsdl_pretty_print_xml,
				ssl_verify_mode:  :none
			}
		end

		# Cliente WSDL utilizado para fazer a requisição.
		# Utilizando a gem savon.
		# Veja mais detalhes em http://savonrb.com/version2/client.html
		def client_wsdl
			@client_wsdl ||= Savon.client client_wsdl_params
		end

		# Caso não tenha o certificate_pkcs12 salvo em arquivo, pode setar a string do certificate_pkcs12 direto pelo atributo certificate_pkcs12_value
		# Caso tenha o certificate_pkcs12 em arquivo, basta setar o atributo certificate_pkcs12_path e deixar o atributo certificate_pkcs12_value em branco
		def certificate_pkcs12_value
			@certificate_pkcs12_value ||= File.read(certificate_pkcs12_path)
		end

		def certificate_pkcs12
			return @certificate_pkcs12 if @certificate_pkcs12
			@certificate_pkcs12 = nil
			
			# É utilizado uma Thread e limpado os errors do OpenSSL para evitar perda de 
			# conexão com o banco de dados PostgreSQL.
			# Veja: http://stackoverflow.com/questions/33112155/pgconnectionbad-pqconsumeinput-ssl-error-key-values-mismatch/36283315#36283315
			# Veja: https://github.com/tedconf/front_end_builds/pull/66
			Thread.new do 
				@certificate_pkcs12 = OpenSSL::PKCS12.new(certificate_pkcs12_value, certificate_pkcs12_password) 
				OpenSSL.errors.clear
			end.join
			OpenSSL.errors.clear

			@certificate_pkcs12 
		rescue
		end

		def certificate_pkcs12=(value)
			@certificate_pkcs12 = value
		end

		def certificate=(value)
			@certificate = value
		end

		def certificate
			@certificate ||= certificate_pkcs12.try :certificate
		end

		def certificate_key
			@certificate_key ||= certificate_pkcs12.try :key
		end

		def certificate_key=(value)
			@certificate_key = value
		end   

		# Renderiza o xml a partir do nome de um arquivo 
		# Irá procurar o arquivo a partir dos seguintes diretórios>
		# 1° - A partir do parâmetro  :dir_path
		# 2° - A partir do método   xml_current_dir_path
		# 3° - A partir do método  xml_default_dir_path
		# 
		# Se não encontrar o arquivo em nenhum dos diretórios irá execurar
		# uma excessão de RuntimeError
		#
		# Utilização
		# `render_xml('file_name', {dir_path: '/my/custom/dir', context: Object}`
		# 
		# <b>Tipo de retorno: <b> _String_ (XML)
		#
		def render_xml file_name, opts={}
			opts ||= {}
			default_options = opts.extract!(:dir_path, :context)
			default_options[:context] ||= self
			
			# Inicializa a variavel xml com nil para comparar se oa rquivo foi de fato encontrado.
			xml = nil
			get_xml_dirs(default_options[:dir_path]).each do |dir|
				if xml = find_xml(file_name, dir, default_options[:context], opts)
					break # Stop loop
				end
			end

			# Lança uma excessão se não for encontrado o xml
			# Deve verificar se é nil pois o arquivo xml pode estar vazio
			if xml.nil?
				raise "Arquivo #{file_name}.xml.slim não encontrado nos diretórios #{get_xml_dirs(default_options[:dir_path])}" 
			end
			xml
		end

		def find_xml(file_name, dir, context=nil, options={})
			if File.exists?("#{dir}/#{file_name}.xml.slim")
				Slim::Template.new("#{dir}/#{file_name}.xml.slim").render(context, options).html_safe 
			end
		end

		def get_xml_dirs(custom_dir_path=nil)
			[custom_dir_path, xml_current_dir_path, xml_default_dir_path].flatten.select(&:present?)
		end

		# Diretório personalizado para cada classe
		# Podendo ser sobrescrito em cada herança
		#
		def xml_current_dir_path
			[]
		end
		 
		# Diretório padrão dos arquivos XML
		#
		def xml_default_dir_path
			"#{BrNfe.root}/lib/br_nfe/xml"
		end

		# Existem 2 tipos de assinatura da NFS-e
		# * [+:default+]
		#   Assina o XML no momento em que está sendo montado. Funciona normalmente para a 
		#   maiora das prefeituras.
		#   Primeiro assina cada RPS individualmente e adiciona a tag da assinatura e depois
		#   Assina o LOTE RPS com todas os RPSs assinados
		#
		# * [+:method_sign+]
		#   Assina o XML após a montagem do mesmo. Utiliza a gem 'signer' para assinar os nós do XML.
		#   Adiciona toda a assinatura no final do XML, diferente do que é descrito nas documentações.
		#   Porém em algumas cidades só consegui validar a assinatura utilizando esse método
		#   Estava dando o erro: E515 - Erro ao validar assinatura. - Remessa adulterada após a assinatura.
		#
		def signature_type
			:default
		end
		def signature_type?(type)
			signature_type == type
		end

		# USE EXAMPLE
		#  @xml = <?xml version="1.0" encoding="ISO-8859-1"?>
		#          <EnviarLoteRpsEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">
		#            <LoteRps id="L2">
		#              ...
		#              <ListaRps>
		#                <Rps>
		#                  <InfRps id="R2">
		#                    ...
		#                  </>InfRps
		#                </Rps>
		#                <Rps>
		#                  <InfRps id="R3">
		#                    ...
		#                  </>InfRps
		#                </Rps>
		#              </ListaRps>
		#            </LoteRps>
		#          </EnviarLoteRpsEnvio>
		# sign_nodes = [
		#   {
		# 	   node_path: "//nf:EnviarLoteRpsEnvio/nf:LoteRps/nf:ListaRps/nf:Rps/nf:InfRps", 
		# 	   node_namespaces: {nf: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'},
		# 	   node_ids: ['R2','R3']
		#   },
		#   {
		#     node_path: "//nf:EnviarLoteRpsEnvio/nf:LoteRps", 
		#     node_namespaces: {nf: 'http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd'},
		#     node_ids: ['L2']
		#   },
		# ]
		# 
		# Call Method:
		# sign_xml(@xml, sign_nodes)
		#
		def sign_xml(xml, sign_nodes=[])
			return xml unless certificate
			signer = Signer.new(xml)
			signer.cert        = certificate
			signer.private_key = certificate_key

			# Como o documento não é um envelope SOAP preciso setar o security_node e o security_token_id
			signer.security_node = signer.document.root
			signer.security_token_id = ""

			sign_nodes.each do |options|
				node_ids = [options[:node_ids]].flatten
				signer.document.xpath(options[:node_path], options[:node_namespaces]).each_with_index do |node, i|
					# digo quais tags devem ser assinadas
					signer.digest!(node, id: "#{node_ids[i]}", enveloped: true)
				end				
			end
			
			# Assina o XML
			signer.sign!(security_token: false, issuer_serial: true)

			signer.to_xml
		end

	private

		def tag_cpf_cnpj(xml, cpf_cnpj)
			cpf_cnpj = BrNfe::Helper::CpfCnpj.new(cpf_cnpj)
			if cpf_cnpj.cnpj?
				xml.Cnpj cpf_cnpj.sem_formatacao
			elsif cpf_cnpj.cpf?       
				xml.Cpf  cpf_cnpj.sem_formatacao
			end
		end


		def assinatura_xml(data_xml, uri='')
			data_xml = format_data_xml_for_signature(data_xml)
			ass = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.Signature(xmlns: 'http://www.w3.org/2000/09/xmldsig#') do |signature|
					
					info = canonicalize(signed_info(data_xml, uri).doc.root())
					signature.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( info.to_s ) 
					
					signature.SignatureValue xml_signature_value(info)
					
					signature.KeyInfo {
						signature.X509Data {
							signature.X509Certificate certificate.to_s.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")
						}
					}
				end
			end.doc.root
			canonicalize ass
		end

		def canonicalization_method_algorithm
			'http://www.w3.org/2001/10/xml-exc-c14n#'
		end

		def signed_info(data_xml, uri='')
			Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.SignedInfo(xmlns: "http://www.w3.org/2000/09/xmldsig#") do |info|
					info.CanonicalizationMethod(Algorithm: canonicalization_method_algorithm)
					info.SignatureMethod(Algorithm: 'http://www.w3.org/2000/09/xmldsig#rsa-sha1')
					info.Reference('URI' => uri){ 
						info.Transforms{
							info.Transform(:Algorithm => 'http://www.w3.org/2000/09/xmldsig#enveloped-signature')
							info.Transform(:Algorithm => 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315')
						}
						info.DigestMethod(:Algorithm => 'http://www.w3.org/2000/09/xmldsig#sha1')
						info.DigestValue xml_digest_value(data_xml)
					}
				end
			end
		end

		def xml_signature_value(xml)
			sign_canon = canonicalize(xml)
			signature_hash  = certificate_key.sign(OpenSSL::Digest::SHA1.new, sign_canon)
			remove_quebras Base64.encode64( signature_hash )
		end

		def xml_digest_value(xml)
			xml_canon = canonicalize(xml)
			remove_quebras Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon))
		end

		def remove_quebras(str)
			str.gsub(/\n/,'').gsub(/\t/,'').strip
		end

		def format_data_xml_for_signature(data_xml)
			data_xml
		end

		def validar_emitente
			if emitente.invalid?
				emitente.errors.full_messages.map{|msg| errors.add(:base, "Emitente: #{msg}") }
			end
		end

	end
end