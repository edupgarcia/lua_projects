Copas = {1958, 1962, 1970, 1994, 2002}

print(#Copas)
Copas[10] = 2021
print(#Copas)

-- for i = 1, 10 do
for i = 1, #Copas do
    print(i, Copas[i])
end

-- print(#Copas)

-- for indice, valor in ipairs(Copas) do
--     print(indice, valor)
-- end
