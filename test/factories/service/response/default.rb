FactoryGirl.define do
	factory :response_default, class:  BrNfe::Service::Response::Default do
		success          true
		error_messages   {[]}
		notas_fiscais    { [FactoryGirl.build(:response_nota_fiscal)] }
		protocolo        '6988965463213549'
		data_recebimento { DateTime.parse('10/09/2015 03:00:00') }
		numero_lote      '111'
	end
end