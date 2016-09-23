require 'test_helper'

describe BrNfe::Service::Concerns::ValuesTs::ServiceV1 do
	
	class HelperValuesTsServiceV1Test < BrNfe::ActiveModelBase
		include BrNfe::Service::Concerns::ValuesTs::ServiceV1
	end

	subject { HelperValuesTsServiceV1Test.new } 

	describe "#ts_numero_nfse" do
		it "deve retornar apenas números" do
			subject.ts_numero_nfse('AB123456CD7E').must_equal '1234567'
		end
		it "deve retornar no maximo 15 números" do
			subject.ts_numero_nfse('12345678901234567890').must_equal '123456789012345'
		end
	end

	describe "#ts_codigo_verificacao" do
		it "deve retornar no maximo 9 caracteres" do
			subject.ts_codigo_verificacao('ABC4567890123').must_equal 'ABC456789'
		end
	end

	describe "#ts_status_rps" do
		it "deve retornar apenas números" do
			subject.ts_status_rps('A1').must_equal '1'
		end
		it "deve retornar no maximo 1 número" do
			subject.ts_status_rps('A2123').must_equal '2'
		end
	end

	describe "#ts_status_nfse" do
		it "deve retornar apenas números" do
			subject.ts_status_nfse('A1').must_equal '1'
		end
		it "deve retornar no maximo 1 número" do
			subject.ts_status_nfse('A2123').must_equal '2'
		end
	end

	describe "#ts_natureza_operacao" do
		it "deve retornar apenas números" do
			subject.ts_natureza_operacao('A1').must_equal '1'
		end
		it "deve retornar no maximo 2 número" do
			subject.ts_natureza_operacao('A2123').must_equal '21'
		end
	end

	describe "#ts_regime_especial_tributacao" do
		it "deve retornar apenas números" do
			subject.ts_regime_especial_tributacao('A1').must_equal '1'
		end
		it "deve retornar no maximo 2 número" do
			subject.ts_regime_especial_tributacao('A2123').must_equal '21'
		end
	end

	describe "#ts_sim_nao" do
		it "para valores que representam o valor TRUE/SIM deve retornar 1" do
			[true, '1', 't', 'true', 1, :t].each do |v_true|
				subject.ts_sim_nao(v_true).must_equal '1'
			end
		end
		it "para valores que representam o valor FALSE/NÃO deve retornar 2" do
			[false, 0, '0', 'false', 'qqcoisa'].each do |v_tfalse|
				subject.ts_sim_nao(v_tfalse).must_equal '2'
			end
		end
	end

	describe "#ts_quantidade_rps" do
		it "deve retornar apenas números" do
			subject.ts_quantidade_rps('X456E').must_equal '456'
		end
		it "deve retornar no maximo 4 número" do
			subject.ts_quantidade_rps('A123456').must_equal '1234'
		end
	end

	describe "#ts_numero_rps" do
		it "deve retornar apenas números" do
			subject.ts_numero_rps('X456E').must_equal '456'
		end
		it "deve retornar no maximo 15 número" do
			subject.ts_numero_rps('A12345678901234567890BC').must_equal '123456789012345'
		end
	end

	describe "#ts_serie_rps" do
		it "deve retornar no maximo 5 caracteres" do
			subject.ts_serie_rps('AB123456').must_equal 'AB123'
		end
	end

	describe "#ts_tipo_rps" do
		it "deve retornar apenas números" do
			subject.ts_tipo_rps('A1').must_equal '1'
		end
		it "deve retornar no maximo 1 número" do
			subject.ts_tipo_rps('A2123').must_equal '2'
		end
	end

	describe "#ts_outras_informacoes" do
		it "deve retornar no maximo 255 caracteres" do
			v = 'A1'*150 # 300 A1
			subject.ts_outras_informacoes(v).must_equal ('A1'*127)+'A'
		end
	end

	describe "#ts_valor" do
		it "deve retornar o valor com 2 casas decimais" do
			subject.ts_valor(4_756.5123).must_equal 4_756.51
		end
		it "se passar um valor nil deve retornaar nil" do
			subject.ts_valor(nil).must_be_nil			
		end
	end

	describe "#ts_item_lista_servico" do
		it "se passar um valor já formatado deve retornar esse mesmo valor" do
			subject.ts_item_lista_servico('7.90').must_equal '7.90'
		end
		it "se passar um valor inteiro deve formatar para NN.NN" do
			subject.ts_item_lista_servico(1785).must_equal '17.85'
		end
		it "se passar um valor inteiro com apenas 1 caracter deve retornar esse unico caractere" do
			subject.ts_item_lista_servico(1).must_equal '1'
		end
		it "se passar um valor com mais de 4 posições deve reotrnar apenas 4 numeros e 1 ponto" do
			subject.ts_item_lista_servico(123456).must_equal '12.34'
		end
		it "se passar nil deve retornar o um valor em branco e não da erro" do
			subject.ts_item_lista_servico(nil).must_be_nil
		end
		it "deve ignorar os Zeros da frente do número" do
			subject.ts_item_lista_servico('0458').must_equal '4.58'
		end
	end

	describe "#ts_codigo_cnae" do
		it "deve retornar apenas números" do
			subject.ts_codigo_cnae('A1456').must_equal '1456'
		end
		it "deve retornar no maximo 7 números" do
			subject.ts_codigo_cnae('A1B2C3D4567890').must_equal '1234567'
		end
	end

	describe "#ts_codigo_tributacao" do
		it "deve retornar no maximo 20 caracteres" do
			subject.ts_codigo_tributacao('A3'*15).must_equal 'A3'*10
		end
	end

	describe "#ts_aliquota" do
		it "deve retornar com no máximo 4 posições após a virgula" do
			subject.ts_aliquota(0.123456789).must_equal 0.1235
		end
	end

	describe "#ts_discriminacao" do
		it "deve retornar no maximo 2_000 caracteres" do
			v = 'A1'*1_001 
			subject.ts_discriminacao(v).must_equal ('A1'*1_000)
		end
	end

	describe "#ts_codigo_municipio_ibge" do
		it "deve retornar apenas números" do
			subject.ts_codigo_municipio_ibge('A1456').must_equal '1456'
		end
		it "deve retornar no maximo 7 números" do
			subject.ts_codigo_municipio_ibge('A1B2C3D4567890').must_equal '1234567'
		end
	end

	describe "#ts_inscricao_municipal" do
		it "deve retornar no maximo 15 caracteres" do
			v = 'A1'*8
			subject.ts_inscricao_municipal(v).must_equal ('A1'*7)+'A'
		end
	end

	describe "#ts_razao_social" do
		it "deve retornar no maximo 115 caracteres" do
			v = 'A1'*60
			subject.ts_razao_social(v).must_equal ('A1'*57)+'A'
		end
	end

	describe "#ts_nome_fantasia" do
		it "deve retornar no maximo 60 caracteres" do
			v = 'A1'*31
			subject.ts_nome_fantasia(v).must_equal ('A1'*30)
		end
	end

	describe "#ts_cnpj" do
		it "deve trazer apenas os numeros do CNPJ" do
			subject.ts_cnpj('123.456.78/0001-58').must_equal '12345678000158'
		end

		it "deve trazer no máximo 14 caracteres" do
			subject.ts_cnpj('123.456.78/0001-4499999').must_equal '12345678000144'
		end
	end

	describe "#ts_endereco" do
		it "deve retornar no maximo 125 caracteres" do
			v = 'A1'*65
			subject.ts_endereco(v).must_equal ('A1'*62)+'A'
		end
	end

	describe "#ts_numero_endereco" do
		it "deve retornar no maximo 10 caracteres" do
			v = 'A1'*6
			subject.ts_numero_endereco(v).must_equal ('A1'*5)
		end
	end

	describe "#ts_complemento_endereco" do
		it "deve retornar no maximo 60 caracteres" do
			subject.ts_complemento_endereco(''.rjust(61, 'X')).must_equal ''.rjust(60, 'X')
		end
	end

	describe "#ts_bairro" do
		it "deve retornar no maximo 60 caracteres" do
			subject.ts_bairro(''.rjust(61, 'X')).must_equal ''.rjust(60, 'X')
		end
	end

	describe "#ts_uf" do
		it "deve retornar no maximo 2 caracteres" do
			subject.ts_uf('SCP').must_equal 'SC'
		end
	end

	describe "#ts_cep" do
		it "deve retornar apenas os números do CEP" do
			subject.ts_cep('89885-000').must_equal '89885000'
		end
		it "deve retornar no máximo 8 numeros" do
			subject.ts_cep('89885-00099999').must_equal '89885000'
		end
		it "se não tiver 8 digitos deve preencher a direita com Zero" do
			subject.ts_cep('12345-').must_equal '12345000'
		end
		it "se passar um valor nil ou em branco deve retornar nil" do
			subject.ts_cep(nil).must_be_nil
			subject.ts_cep('').must_be_nil
		end
	end

	describe "#ts_email" do
		it "deve retornar no maximo 80 caracteres" do
			subject.ts_email(''.rjust(81, 'X')).must_equal ''.rjust(80, 'X')
		end
	end

	describe "#ts_telefone" do
		it "deve retornar apenas números" do
			subject.ts_telefone('(49) 3645-1500').must_equal '4936451500'
		end
		it "deve retornar no maximo 11 números" do
			subject.ts_telefone('(49) 93645-1500785').must_equal '49936451500'
		end
	end

	describe "#ts_cpf" do
		it "deve retornar apenas números" do
			subject.ts_cpf('938.542.939-86').must_equal '93854293986'
		end
		it "deve retornar no maximo 11 números" do
			subject.ts_cpf('123.456.789-0123456').must_equal '12345678901'
		end
	end

	describe "#ts_indicacao_cpf_cnpj" do
		it "deve retornar apenas números" do
			subject.ts_indicacao_cpf_cnpj('A9XX').must_equal '9'
		end
		it "deve retornar no maximo 1 número" do
			subject.ts_indicacao_cpf_cnpj('A&*)780980JKGHH').must_equal '7'
		end
	end

	describe "#ts_codigo_obra" do
		it "deve retornar no maximo 15 caracteres" do
			subject.ts_codigo_obra(''.rjust(16, 'X')).must_equal ''.rjust(15, 'X')
		end
	end

	describe "#ts_art" do
		it "deve retornar no maximo 15 caracteres" do
			subject.ts_art(''.rjust(16, 'X')).must_equal ''.rjust(15, 'X')
		end
	end

	describe "#ts_numero_protocolo" do
		it "deve retornar no maximo 50 caracteres" do
			subject.ts_numero_protocolo('B1'*30).must_equal 'B1'*25
		end
	end

	describe "#ts_situacao_lote_rps" do
		it "deve retornar apenas números" do
			subject.ts_situacao_lote_rps('A9XX').must_equal '9'
		end
		it "deve retornar no maximo 1 número" do
			subject.ts_situacao_lote_rps('A&*)780980JKGHH').must_equal '7'
		end
	end

	describe "#ts_codigo_mensagem_alerta" do
		it "deve retornar no maximo 4 caracteres" do
			subject.ts_codigo_mensagem_alerta('12ABCDEFGH').must_equal '12AB'
		end
	end

	describe "#ts_descricao_mensagem_alerta" do
		it "deve retornar no maximo 200 caracteres" do
			subject.ts_descricao_mensagem_alerta('X'*201).must_equal 'X'*200
		end
	end

	describe "#ts_codigo_cancelamento_nfse" do
		it "deve retornar no maximo 4 caracteres" do
			subject.ts_codigo_cancelamento_nfse('X'*10).must_equal 'X'*4
		end
	end

	describe "#ts_id_tag" do
		it "deve retornar no maximo 255 caracteres" do
			subject.ts_id_tag('X'*300).must_equal 'X'*255
		end
	end

	describe "#ts_datetime" do
		context "deve sempre formatar a datahora no formato YYYY-MM-DDTHH:MM:SS" do
			it "quando passar um objeto do tipo Time" do
				subject.ts_datetime(Time.parse('24/12/2015 03:45:27')).must_equal '2015-12-24T03:45:27'
			end
			it "quando passar um a string" do
				subject.ts_datetime('24/11/2015 14:25').must_equal '2015-11-24T14:25:00'
			end
			it "quando passar um valor com formati inválido deve retornar um valor em branco" do
				subject.ts_datetime('24qwe645/2015 asd:25').must_equal ''
			end			
		end
	end

	describe "#ts_date" do
		context "deve sempre formatar a data no formato YYYY-MM-DD" do
			it "quando passar um objeto do tipo Time" do
				subject.ts_date(Time.parse('24/12/2015 03:45:27')).must_equal '2015-12-24'
			end
			it "quando passar um objeto do tipo Date" do
				subject.ts_date(Date.parse('24/11/2015')).must_equal '2015-11-24'
			end
			it "quando passar um a string" do
				subject.ts_date('31/10/2000').must_equal '2000-10-31'
			end
			it "quando passar um valor com formati inválido deve retornar um valor em branco" do
				subject.ts_date('24qwe645/2015 asd:25').must_equal ''
			end			
		end
	end

end