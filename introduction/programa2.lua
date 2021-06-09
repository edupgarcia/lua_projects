UltimaCopa = {
  -- ['ano'] = 2002,
  -- ['sede'] = 'Japão e Coréia do Sul'
    ano = 2002,
    sede = 'Japão e Coréia do Sul',
    jogadores = {'Cafu', 'Ronaldo'},
    imprime = function (self)
      for k, v in ipairs(self.jogadores) do
        print(k, v)
      end
    end
}

print(UltimaCopa['ano'])
print(UltimaCopa.ano)

UltimaCopa.capitao = 'Cafu'
print(UltimaCopa.capitao)

print(UltimaCopa.jogadores[1])
print(UltimaCopa.jogadores[2])

table.insert(UltimaCopa.jogadores, 'Rivaldo')
table.insert(UltimaCopa.jogadores, 'Zico')
table.remove(UltimaCopa.jogadores, 4)

-- for k, v in ipairs(UltimaCopa.jogadores) do
--   print(k, v)
-- end

UltimaCopa.imprime(UltimaCopa)
UltimaCopa:imprime()