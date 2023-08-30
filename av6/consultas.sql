-------------------------- TABELA INGRESSOS/DIA-PREÇO --------------------------

                    --   vvvvvvvvvvvv MAP MEMBER FUNCTION venda_total:
SELECT DP.dia_evento, DP.venda_total() AS total_de_vendas FROM tb_dia_preco DP


-- [TESTAR] - Mostre quantos clientes têm por bairro,  e quantos deles tem o cep igual ao de João Francisco
SELECT COUNT(*), COUNT(DEREF(tb_visitante.endereco).cep), DEREF(tb_visitante.endereco).bairro, as bairro
FROM tb_visitante GROUP BY (DEREF(tb_visitante.endereco).bairro)
HAVING DEREF(tb_visitante.endereco).cep = (SELECT DEREF(tb_visitante.endereco).cep FROM tb_visitante 
    where REF(tb_visitante).nome = 'João Francisco'));