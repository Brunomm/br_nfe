FactoryGirl.define do
	factory :servico_betha_cancelamento_nfs, class:  BrNfe::Servico::Betha::V1::CancelamentoNfs do
		numero_nfse '3365'
		codigo_cancelamento '1'
		
	end
end