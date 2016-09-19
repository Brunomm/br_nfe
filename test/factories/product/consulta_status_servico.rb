FactoryGirl.define do
	factory :product_consulta_status_servico, class:  BrNfe::Product::ConsultaStatusServico do
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
		end
		env                         :test
		emitente                    { FactoryGirl.build(:emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'
	end
end