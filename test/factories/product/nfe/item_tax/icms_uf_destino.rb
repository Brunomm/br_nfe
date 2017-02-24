FactoryGirl.define do
	factory :product_item_tax_icms_uf_destino, class:  BrNfe::Product::Nfe::ItemTax::IcmsUfDestino do
		total_base_calculo          345.64
		percentual_fcp              1.0
		aliquota_interna_uf_destino 17.0
		aliquota_interestadual      12.0
		total_fcp_destino           3.46
		total_destino               35.26
		total_origem                16.59
	end
end