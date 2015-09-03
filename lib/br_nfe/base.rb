module BrNfe
	class Base < BrNfe::ActiveModelBase
		
		attr_accessor :certificado_password
		attr_accessor :certificado_path
		attr_accessor :certificado_value

		# Caso não tenha o certificado salvo em arquivo, pode setar a string do certificado direto pelo atributo certificado_value
		# Caso tenha o certificado em arquivo, basta setar o atributo certificado_path e deixar o atributo certificado_value em branco
		def certificado_value
			@certificado_value ||= File.read(certificado_path)
		end
		
		attr_accessor :env

		def certificado_path
			'/home/bruno/cert.pfx'
		end

		def certificado_password
			'CONTA123'
		end

		def env
			@env ||= :production
		end

		def emitente
			@emitente.is_a?(BrNfe.emitente_class) ? @emitente : @emitente = BrNfe.emitente_class.new()
		end


		def emitente=(value)
			if value.is_a?(BrNfe.emitente_class) 
				@emitente = value
			elsif value.is_a?(Hash)
				emitente.assign_attributes(value)
			end
		end

		def response
			@response
		end
		
		def wsdl
			raise "Não implementado."
		end

		def env_namespace
			:soapenv
		end

		def method_wsdl
			raise "Não implementado."
		end

		def xml_builder
			raise "Não implementado."
		end

		def namespace_identifier
			raise 'Não implementado.'
		end

		def namespaces
			{}
		end

		def certificado
			@certificado ||= OpenSSL::PKCS12.new(certificado_value, certificado_password)
		end

		def client_wsdl
			@client_wsdl ||= Savon.client({
				namespaces:            namespaces,
				env_namespace:         env_namespace,
				wsdl:                  wsdl,
				namespace_identifier:  namespace_identifier,
				log:                   true,#BrNfe.client_wsdl_log,
				pretty_print_xml:      true,#BrNfe.client_wsdl_pretty_print_xml,
				ssl_verify_mode:       BrNfe.client_wsdl_ssl_verify_mode,
				ssl_cert_file:         BrNfe.client_wsdl_ssl_cert_file,
				ssl_cert_key_file:     BrNfe.client_wsdl_ssl_cert_key_file,
				ssl_cert_key_password: BrNfe.client_wsdl_ssl_cert_key_password
			})
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

		def data_formatada(data)
			data = Date.parse(data.to_s)
			data.to_s(:br_nfe)
		rescue
			return ''
		end

		def data_hora_formatada(data)
			data_hora = DateTime.parse(data.to_s)
			data_hora.to_s(:br_nfe)
		rescue
			return ''
		end

		def assinatura_xml(data_xml, uri='')
			# data_xml = format_data_xml_for_signature(data_xml)
			ass = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.Signature(xmlns: 'http://www.w3.org/2000/09/xmldsig#') do |signature|
					
					info = canonicalize(signed_info(data_xml, uri).doc.root())
					signature.__send__ :insert, Nokogiri::XML::DocumentFragment.parse( info.to_s ) 
					
					signature.SignatureValue xml_signature_value(info)
					
					signature.KeyInfo {
						signature.X509Data {
							signature.X509Certificate certificado.certificate.to_s.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")
						}
					}
				end
			end.doc.root
			canonicalize ass
		end

		def signed_info(data_xml, uri='')
			Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				xml.SignedInfo(xmlns: "http://www.w3.org/2000/09/xmldsig#") do |info|
					info.CanonicalizationMethod(Algorithm: 'http://www.w3.org/2001/10/xml-exc-c14n#')
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
			signature_hash  = certificado.key.sign(OpenSSL::Digest::SHA1.new, sign_canon)
			remove_quebras Base64.encode64( signature_hash )
		end

		def xml_digest_value(xml)
			xml_canon = canonicalize(xml)
			remove_quebras Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon))
		end


		def canonicalize(xml)
			xml = Nokogiri::XML(xml.to_s, &:noblanks)
			xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
		end

		def remove_quebras(str)
			str.gsub(/\n/,'').gsub(/\t/,'').strip
		end

	end
end