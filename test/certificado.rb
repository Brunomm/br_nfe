#
# Esta classe é utilizada apenas para simular um certificado
# E assim não havendo a necessidade de ter um arquivo com um certificado para efetuar os testes
#
class Certificado
	def key
		@key ||= OpenSSL::PKey::RSA.new(2048)
	end
	def certificate
		@certificate ||= OpenSSL::X509::Certificate.new
	end
end
