FactoryGirl.define do
	factory :product_operation_nfe_inutilizacao, class:  BrNfe::Product::Operation::NfeInutilizacao do
		transient do
			endereco_emitente { FactoryGirl.build(:endereco, codigo_municipio: '4216008') }
		end
		env                         :test
		emitente                    { FactoryGirl.build(:service_emitente, endereco: endereco_emitente) }
		ibge_code_of_issuer_uf      '42'
		certificate_pkcs12_path     { "#{BrNfe.root}/test/cert.pfx" }
		certificate_pkcs12_password 'associacao'

		ano                16
		modelo_nf          55
		serie              01
		numero_nf_inicial  5
		numero_nf_final    5
		justificativa      'Foi necessário inutilizar a numeração pois o cliente cancelou a venda e NF-e já estava pronta para ser emitida, porém não foi.'
	end
end