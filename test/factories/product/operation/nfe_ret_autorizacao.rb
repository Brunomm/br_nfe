FactoryGirl.define do
	factory :product_operation_nfe_ret_autorizacao, class:  BrNfe::Product::Operation::NfeRetAutorizacao do
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
		end
		env                         :test
		numero_recibo               '423002169035033'
		emitente                    { FactoryGirl.build(:service_emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'
	end
end