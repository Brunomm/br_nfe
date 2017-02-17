FactoryGirl.define do
	factory :product_operation_nfe_download_nf, class:  BrNfe::Product::Operation::NfeDownloadNf do
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
		end
		env                         :test
		emitente                    { FactoryGirl.build(:product_emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'

		chave_nfe 42000082176983000186550000000000006313331836

	end
end