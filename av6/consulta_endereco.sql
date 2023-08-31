-- CONSULTA VISITANTE QUE MORA NA RUA 'Av dos Bobos'

SELECT
    V.cpf,
    V.nome,
    DEREF(V.endereco).cep AS cep,
    V.numero, DEREF(V.endereco).rua AS rua,
    DEREF(V.endereco).cidade AS cidade,
    DEREF(V.endereco).estado AS estado,
    DEREF(V.endereco).pais AS pais,
    V.comp AS complemento
FROM tb_visitante V
WHERE DEREF(V.endereco).rua = 'Av dos Bobos';
/

-- Mostre quantos clientes têm por cep, e quantos deles tem o cep igual ao de Carlos
SELECT v.nome, DEREF(v.endereco).cep AS CEP, COUNT(DEREF(v.endereco).cep) AS QUANTIDADE FROM tb_visitante v
    group by v.nome, DEREF(v.endereco).cep
    HAVING DEREF(v.endereco).cep = (SELECT DEREF(v1.endereco).cep FROM tb_visitante v1
    where v1.nome = 'Carlos');
