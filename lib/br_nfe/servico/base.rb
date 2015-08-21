module BrNfe
	module Servico
		class Base < BrNfe::Base

			def initialize(attributes = {})
				self.lote_rps = [] # Para poder utilizar o << para adicionar lote
				super
			end
			
			attr_accessor :lote_rps
			attr_accessor :numero_lote_rps
			attr_accessor :operacao

			def lote_rps
				[@lote_rps].flatten # Para retornar sempre um vetor
			end

			# def assinar(xml, uri='')
			# 	xml = Nokogiri::XML(xml.to_s, &:noblanks)

			# 	xml.root().add_child assinatura_node(xml, uri)

			# 	# Return XML
			# 	xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
			# end

			# def assinatura_node(xml, uri='')
			# 	# 1. Get Signature Node
			# 	signature = xml.xpath("//ds:Signature", "ds" => "http://www.w3.org/2000/09/xmldsig#").first
			# 	unless signature
			# 		signature = Nokogiri::XML::Node.new('Signature', xml)
			# 		signature.default_namespace = 'http://www.w3.org/2000/09/xmldsig#'
			# 	end

			# 	# 3. Add SignedInfo node to Signature
			# 	signature_info = signature_info_node(xml, uri)
			# 	signature.add_child( signature_info )

			# 	# 4 SignatureValue
			# 	signature.add_child signature_value_node(xml, signature_info)

			# 	# 5.2 Add KeyInfo
			# 	signature.add_child key_info_node(xml)

			# 	signature
			# end

			# def key_info_node(xml)
			# 	key_info = Nokogiri::XML::Node.new('KeyInfo', xml)

			# 	# 5.1 Add X509 Data and Certificate
			# 	x509_data = Nokogiri::XML::Node.new('X509Data', xml)
			# 	x509_certificate = Nokogiri::XML::Node.new('X509Certificate', xml)
			# 	x509_certificate.content = certificado.certificate.to_s.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")

			# 	x509_data.add_child x509_certificate
			# 	key_info.add_child x509_data
			# 	key_info
			# end

			# def signature_value_node(xml, signature_info)
			# 	sign_canon      = signature_info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
			# 	signature_hash  = certificado.key.sign(OpenSSL::Digest::SHA1.new, sign_canon)
			# 	signature_value = Base64.encode64( signature_hash ).gsub("\n", '')

			# 	# 4.1 Add SignatureValue
			# 	child_node = Nokogiri::XML::Node.new('SignatureValue', xml)
			# 	child_node.content = signature_value
			# 	child_node
			# end

			# def signature_info_node(xml, uri='')
			# 	signature_info = Nokogiri::XML::Node.new('SignedInfo', xml)

			# 	# Add CanonicalizationMethod
			# 	child_node = Nokogiri::XML::Node.new('CanonicalizationMethod', xml)
			# 	child_node['Algorithm'] = 'http://www.w3.org/2001/10/xml-exc-c14n#'
			# 	signature_info.add_child child_node

			# 	# Add SignatureMethod
			# 	child_node = Nokogiri::XML::Node.new('SignatureMethod', xml)
			# 	child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
			# 	signature_info.add_child child_node

			# 	# Create Reference
			# 	reference = Nokogiri::XML::Node.new('Reference', xml)
			# 	reference['URI'] = uri

			# 	# Add Transforms
			# 	transforms = Nokogiri::XML::Node.new('Transforms', xml)

			# 	child_node  = Nokogiri::XML::Node.new('Transform', xml)
			# 	child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
			# 	transforms.add_child child_node

			# 	child_node  = Nokogiri::XML::Node.new('Transform', xml)
			# 	child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
			# 	transforms.add_child child_node

			# 	reference.add_child transforms

			# 	# Add Digest
			# 	child_node  = Nokogiri::XML::Node.new('DigestMethod', xml)
			# 	child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#sha1'
			# 	reference.add_child child_node


			# 	# Add DigestValue
			# 	xml_canon = xml.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0)
			# 	xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip

			# 	child_node  = Nokogiri::XML::Node.new('DigestValue', xml)
			# 	child_node.content = xml_digest
			# 	reference.add_child child_node

			# 	# Add Reference and Signature Info
			# 	signature_info.add_child reference

			# 	signature_info
			# end

		end
	end
end