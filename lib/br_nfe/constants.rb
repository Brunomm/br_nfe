module BrNfe
	module Constants
		CODIGO_IBGE_UF = [
			'11', #  Rondônia
			'12', #  Acre
			'13', #  Amazonas
			'14', #  Roraima
			'15', #  Pará
			'16', #  Amapá
			'17', #  Tocantins
			'21', #  Maranhão
			'22', #  Piauí
			'23', #  Ceará
			'24', #  Rio Grande do Norte
			'25', #  Paraíba
			'26', #  Pernambuco
			'27', #  Alagoas
			'28', #  Sergipe
			'29', #  Bahia
			'31', #  Minas Gerais
			'32', #  Espírito Santo
			'33', #  Rio de Janeiro
			'35', #  São Paulo
			'41', #  Paraná
			'42', #  Santa Catarina
			'43', #  Rio Grande do Sul
			'50', #  Mato Grosso do Sul
			'51', #  Mato Grosso
			'52', #  Goiás
			'53', #  Distrito Federal	
		]
		SIGLAS_UF = [
			'AC', # Acre
			'AL', # Alagoas
			'AP', # Amapá
			'AM', # Amazonas
			'BA', # Bahia
			'CE', # Ceará
			'DF', # Distrito Federal
			'ES', # Espírito Santo
			'GO', # Goiás
			'MA', # Maranhão
			'MT', # Mato Grosso
			'MS', # Mato Grosso do Sul
			'MG', # Minas Gerais
			'PA', # Pará
			'PB', # Paraíba
			'PR', # Paraná
			'PE', # Pernambuco
			'PI', # Piauí
			'RJ', # Rio de Janeiro
			'RN', # Rio Grande do Norte
			'RS', # Rio Grande do Sul
			'RO', # Rondônia
			'RR', # Roraima
			'SC', # Santa Catarina
			'SP', # São Paulo
			'SE', # Sergipe
			'TO', # Tocantins
			'EX'  # Exterior
		]

		FORMAS_PAGAMENTO = [1, 2, 3, 4, 5, 10, 11, 12, 13, 99, '1', '2', '3', '4', '5', '01', '02', '03', '04', '05', '10', '11', '12', '13', '99']

		NFE_STATUS_SUCCESS    = %w[100 101 102 103 104 107 111 112 124 128 135 138 139 140 150 151]
		NFE_STATUS_PROCESSING = %w[105]
		NFE_STATUS_OFFLINE    = %w[108 109]
		NFE_STATUS_DENIED     = %w[110 205 301 302 303]

		NFE_SITUATION_AUTORIZED = %w[100 124 139 140 150]
		NFE_SITUATION_ADJUSTED  = %w[128 135 136]
		NFE_SITUATION_CANCELED  = %w[101 151 218]
		NFE_SITUATION_DENIED    = %w[110 205 301 302 303]
		NFE_SITUATION_DRAFT     = %w[105 106 108 109 137 142]
	end
end