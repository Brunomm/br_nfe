FactoryGirl.define do
	factory :product_nfe_consulta_protocolo, class:  BrNfe::Product::NfeConsultaProtocolo do
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
		end
		env                         :test
		chave_nfe                  '42000082176983000186550000000000006313331836'
		emitente                    { FactoryGirl.build(:service_emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'
	end
end