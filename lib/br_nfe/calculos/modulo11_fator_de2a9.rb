# encoding: utf-8
module BrNfe
  module Calculos
    # === Módulo 11 Fator de 2 a 9
    #
    # === Passos
    #
    # 1) Tomando-se os algarismos multiplique-os, iniciando-se da direita para a esquerda,
    # pela seqüência numérica de 2 a 9 (2, 3, 4, 5, 6, 7, 8, 9 ... e assim por diante).
    #
    # 2) Some o resultado de cada produto efetuado e determine o total como (N).
    #
    # 3) Divida o total (N) por 11 e determine o resto obtido da divisão como Mod 11(N).
    #
    # 4) Calcule o dígito verificador (DAC) através da expressão:
    #
    #     DIGIT = 11 - Mod 11 (n)
    #
    # <b>OBS.:</b> Se o resultado desta expressão for igual a 0, 1, 10 ou 11, considere DAC = 1.
    #
    # ==== Exemplo
    #
    # Considerando o seguinte número: '89234560'.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      8    9    2    3    4    5    6    0
    #      *    *    *    *    *    *    *    *
    #      9    8    7    6    5    4    3    2
    #
    # 2) Soma-se o resultado dos produtos obtidos no item “1” acima:
    #
    #      72 + 72 + 14 + 18 + 20 + 20 + 18 + 0
    #      # => 234
    #
    # 3) Determina-se o resto da Divisão:
    #
    #      234 % 11
    #      # => 3
    #
    # 4) Calcula-se o DAC:
    #
    #      11 - 3
    #      # => 8 =============> Resultado final retornado.
    #
    # @param [String]: Corresponde ao número a ser calculado o Módulo 11 no fator de 2 a 9.
    # @return [String] Retorna o resultado do cálculo descrito acima.
    #
    # @example
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a9.new('1')
    #    # => '9'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a9.new('91')
    #    # => '4'
    #
    #    BrBoleto::Calculos::Modulo11FatorDe2a9.new('189')
    #    # => '9'
    #
    class Modulo11FatorDe2a9 < Modulo11
      # Sequência numérica de 2 a 9 que será feito a multiplicação de cada dígito
      # do número passado no #initialize.
      #
      # @return [Array] Sequência numérica
      #
      def fatores
        [2, 3, 4, 5, 6, 7, 8, 9]
      end

      # Calcula o número pelos fatores de multiplicação de 2 a 9.
      # Depois calcula o resto da divisão por 11 e subtrai por 11.
      # Se o resultado desse cálculo for igual a 0, 1, 10 ou 11, considere DAC = 1.
      #
      # @return [Fixnum]
      #
      def calculate
        return 1 if total > 9

        total
      end
    end
  end
end