-- DROP TYPES:
    DROP TYPE tp_garantir_acesso;
    DROP TYPE tp_show;
    DROP TYPE tp_cronograma;
    -- NAO SEI SE É NECESSARIO, MAS colaborante É DO TIPO tp_atracao 
    ALTER TYPE tp_atracao MODIFY ATTRIBUTE (colaborante);
    DROP TYPE tp_atracao;
    DROP TYPE tp_contatos;
    DROP TYPE tp_disponibiliza;
    DROP TYPE tp_palco;
    DROP TYPE tp_encarrega;
    DROP TYPE tp_equipamento;
    DROP TYPE tp_nome_preco;
    DROP TYPE tp_compra;
    DROP TYPE tp_ingresso;
    DROP TYPE tp_dia_preco;
    DROP TYPE tp_visitante;
    DROP TYPE tp_vendedor;
    DROP TYPE tp_tecnico;
    DROP TYPE tp_manutencao;
    DROP TYPE tp_funcionario;
    DROP TYPE tp_pessoa;
    DROP TYPE tp_endereco;
    DROP TYPE tp_telefone;

-- TIPOS:

CREATE OR REPLACE TYPE tp_endereco AS OBJECT(
    cep VARCHAR2(9), 
    rua VARCHAR2(30), 
    cidade VARCHAR2(30), 
    pais VARCHAR2(30), 
    estado VARCHAR2(20)
 	
);
/

CREATE TYPE varray_telefone AS VARRAY (3) OF VARCHAR(13); 
/

CREATE OR REPLACE TYPE tp_pessoa AS OBJECT(
    cpf CHAR(11),
    nome VARCHAR2(40),
    endereco REF tp_endereco,
    numero VARCHAR(5),
    comp VARCHAR(5),
    telefone varray_telefone,  

    MEMBER PROCEDURE exibirDetalhesPessoa,
    MEMBER FUNCTION get_cpf RETURN CHAR,
    FINAL MEMBER PROCEDURE exibirNomeECpf

)NOT FINAL NOT INSTANTIABLE;
/


/*   ERBERT - Fiz umas alteracoes que não sei se são interessantes pra concepção atual, por isso deixei comentado

CREATE OR REPLACE TYPE tp_endereco AS OBJECT(
    cep VARCHAR2(9), 
    rua VARCHAR2(30), 
    cidade VARCHAR2(30), 
    pais VARCHAR2(30), 
    estado VARCHAR2(20),
    numero VARCHAR(5),
    comp VARCHAR(5),
 	MEMBER FUNCTION exibir_detalhes ( SELF tp_endereco) RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE tp_telefone AS VARRAY(3) OF VARCHAR2(12);
/

CREATE OR REPLACE TYPE tp_pessoa AS OBJECT(
    cpf CHAR(11),
    nome VARCHAR2(40),
    
    telefone tp_telefone,  
    endereco tp_endereco,

 	MEMBER FUNCTION exibir_detalhes (SELF tp_pessoa) RETURN VARCHAR2,
    MEMBER FUNCTION get_cpf RETURN CHAR,
 	MEMBER FUNCTION get_telefones (SELF tp_pessoa) RETURN VARCHAR2

)NOT FINAL NOT INSTANTIABLE;
/

CREATE OR REPLACE TYPE tp_visitante UNDER tp_pessoa( );
/

/ */




---------------------------------------------------------------------------------v
CREATE OR REPLACE TYPE BODY tp_pessoa AS

	MEMBER PROCEDURE exibirDetalhesPessoa IS
	
	BEGIN
	DBMS_OUTPUT.PUT_LINE('Detalhes de Pessoa')
	DBMS_OUTPUT.PUT_LINE(SELF.nome)
	DBMS_OUTPUT.PUT_LINE(SELF.cpf)
	DBMS_OUTPUT.PUT_LINE(SELF.cep)
	DBMS_OUTPUT.PUT_LINE(SELF.numero)
	DBMS_OUTPUT.PUT_LINE(SELF.comp)
	
	-- Obtém o objeto de endereço a partir da REF usando uma consulta SQL
	SELECT DEREF(SELF.endereco) INTO endereco_obj FROM DUAL;
	
	DBMS_OUTPUT.PUT_LINE('Detalhes do Endereço:');
	DBMS_OUTPUT.PUT_LINE('CEP: ' || endereco_obj.cep);
	DBMS_OUTPUT.PUT_LINE('Rua: ' || endereco_obj.rua);
	DBMS_OUTPUT.PUT_LINE('Cidade: ' || endereco_obj.cidade);
	DBMS_OUTPUT.PUT_LINE('País: ' || endereco_obj.pais);
	DBMS_OUTPUT.PUT_LINE('Estado: ' || endereco_obj.estado);
	END;

	FINAL MEMBER PROCEDURE exibirNomeECpf IS     
		
	BEGIN         
	DBMS_OUTPUT.PUT_LINE('Nome: ' || SELF.nome)         
	DBMS_OUTPUT.PUT_LINE('CPF: ' || SELF.cpf)         
	END; 
END;
/
CREATE OR REPLACE TYPE BODY tp_pessoa AS
    -- Implemente a member function que retorna o CPF
    MEMBER FUNCTION get_cpf RETURN CHAR IS
    BEGIN
    	RETURN self.cpf;
    END;
END;
/ 
---------------------------------------------------------------------------------^

CREATE OR REPLACE TYPE tp_funcionario UNDER tp_pessoa(
    turno VARCHAR2(6),
    salario NUMBER
    -- criar uma funcao exibir dados de um funcionario
)NOT FINAL NOT INSTANTIABLE;
/
---------------------------------------------------------------------------------v
CREATE OR REPLACE TYPE BODY tp_funcionario AS

   OVERRIDING MEMBER PROCEDURE exibirDetalhesPessoa IS
    
   BEGIN
    DBMS_OUTPUT.PUT_LINE('Detalhes de Funcionario')
    DBMS_OUTPUT.PUT_LINE(SELF.nome)
    DBMS_OUTPUT.PUT_LINE(SELF.cpf)
    DBMS_OUTPUT.PUT_LINE(SELF.cep)
    DBMS_OUTPUT.PUT_LINE(SELF.numero)
    DBMS_OUTPUT.PUT_LINE(SELF.comp)

    -- Especificacoes de Funcioanrio

    DBMS_OUTPUT.PUT_LINE(SELF.salario)
    DBMS_OUTPUT.PUT_LINE(SELF.turno)

      -- Obtém o objeto de endereço a partir da REF usando uma consulta SQL
      SELECT DEREF(SELF.endereco) INTO endereco_obj FROM DUAL;
      
      DBMS_OUTPUT.PUT_LINE('Detalhes do Endereço:');
      DBMS_OUTPUT.PUT_LINE('CEP: ' || endereco_obj.cep);
      DBMS_OUTPUT.PUT_LINE('Rua: ' || endereco_obj.rua);
      DBMS_OUTPUT.PUT_LINE('Cidade: ' || endereco_obj.cidade);
      DBMS_OUTPUT.PUT_LINE('País: ' || endereco_obj.pais);
      DBMS_OUTPUT.PUT_LINE('Estado: ' || endereco_obj.estado);
      
   END;

END;
/
---------------------------------------------------------------------------------^
CREATE OR REPLACE TYPE tp_manutencao UNDER tp_funcionario();
/

CREATE OR REPLACE TYPE tp_tecnico UNDER tp_funcionario();
/

CREATE OR REPLACE TYPE tp_vendedor UNDER tp_funcionario();
/

CREATE OR REPLACE TYPE tp_visitante UNDER tp_pessoa();
/

/*
CONSTRUCTOR FUNCTION tp_visitante (
    cpf CHAR,
    nome VARCHAR2,
    cep VARCHAR2,
    numero VARCHAR,
    comp VARCHAR,
    telefone REF tp_telefone,
    endereco REF tp_endereco

    ) RETURN SELF AS RESULT IS
    
    BEGIN 

	SELF.cpf := cpf;
	SELF.nome := nome;
	SELF.cep := cep;
	SELF.numero := numero;
	SELF.comp := comp;
	SELF.telefone := telefone;
	SELF.endereco := endereco;
	RETURN;
END;
/
*/

CREATE OR REPLACE TYPE tp_dia_preco AS OBJECT(
    dia_evento DATE,
    preco NUMBER
);
/

CREATE OR REPLACE TYPE tp_ingresso AS OBJECT(
    id_comprad REF tp_visitante,
    num_ingresso INTEGER,
    dia_evento REF tp_dia_preco
);
/

CREATE OR REPLACE TYPE tp_compra AS OBJECT(
    id_visitant REF tp_ingresso,
    num_ingresso REF tp_ingresso,
    vendedor REF tp_vendedor
);
/

CREATE OR REPLACE TYPE tp_nome_preco AS OBJECT(
    nome VARCHAR2(30),
    preco NUMBER
);
/

CREATE OR REPLACE TYPE tp_equipamento AS OBJECT(
    num_serie VARCHAR(30),
    nome REF tp_nome_preco,
    tipo VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE tp_encarrega AS OBJECT(
    id_maut REF tp_manutencao,
    numserie REF tp_equipamento
);
/

CREATE OR REPLACE TYPE tp_palco AS OBJECT(
    numero NUMBER,
    tamanho VARCHAR2(9)
);
/

CREATE OR REPLACE TYPE tp_disponibiliza AS OBJECT(
    palco REF tp_palco,
    num_serie REF tp_equipamento
);
/

CREATE TYPE varray_contatos AS VARRAY (5) OF VARCHAR2(50);
/

CREATE OR REPLACE TYPE tp_cronograma AS OBJECT(
    data_hora_inicio DATE, -- <DD/MM HH:mm> (dps mudar para TIMESTAMP)
    data_hora_termino DATE
);
/

CREATE TYPE tp_nt_cronograma AS TABLE OF tp_cronograma;
/

CREATE OR REPLACE TYPE tp_atracao AS OBJECT(
    nome VARCHAR2(30),
    cache NUMBER,
    contatos varray_contatos,
    cronograma tp_nt_cronograma
);
/

ALTER TYPE tp_atracao ADD ATTRIBUTE (colaborante REF tp_atracao);
/

CREATE OR REPLACE TYPE tp_show AS OBJECT(
    atracao REF tp_atracao,
    placo REF tp_palco,
    horario VARCHAR2(25),
    id_tecn REF tp_tecnico
);
/

CREATE OR REPLACE TYPE tp_garantir_acesso AS OBJECT(
    show tp_show,
    ingresso tp_ingresso
);
/

-- TABELAS:

CREATE TABLE tb_endereco of tp_endereco(
    cep PRIMARY KEY
);
/

CREATE TABLE tb_pessoa OF tp_pessoa(
    cpf PRIMARY KEY,
    endereco WITH ROWID REFERENCES tb_endereco
);
/
	
CREATE TABLE tb_funcionario OF tp_funcionario(
    cpf PRIMARY KEY
);
/

CREATE TABLE tb_visitante OF tp_visitante(
    cpf PRIMARY KEY
);
/

CREATE TABLE tb_atracao OF tp_atracao(
    nome PRIMARY KEY
) NESTED TABLE cronograma STORE AS tb_nt_cronograma;
/

INSERT INTO tb_endereco VALUES (
    tp_endereco(
        '52130090',
        'Av. dos Bobos', 
        'Fortaleza',
        'Brasil',
        'Ceara'
    )
);
/

INSERT INTO tb_visitante VALUES (
    tp_visitante(
        '999999999',
        'Claudio',
        (SELECT REF(E) FROM tb_endereco E WHERE E.cep = '52130090'),
        '300',
        '202',
        varray_telefone('83985478965', '83977489654', '83966534789')
    )
);
/

--SELECT V.cpf, V.nome, V.endereco.cep AS cep, V.endereco.cidade AS cidade, V.numero, V.comp, T.* FROM tb_visitante V, TABLE (V.telefone) T;

INSERT INTO tb_atracao VALUES(
    tp_atracao(
        'Megadeth',
        20000,
        varray_contatos(
            '(+12)39867398',
            'megadeth@gmail.com'
        ),
        tp_nt_cronograma(
            tp_cronograma(
                TO_DATE('2023-07-20 18:00', 'YYYY-MM-DD HH24:MI'), 
                TO_DATE('2023-07-20 20:00', 'YYYY-MM-DD HH24:MI')
                ),
            tp_cronograma(
                TO_DATE('2023-07-21 18:00', 'YYYY-MM-DD HH24:MI'), 
                TO_DATE('2023-07-21 20:00', 'YYYY-MM-DD HH24:MI')
                ),
            tp_cronograma(
                TO_DATE('2023-07-21 21:00', 'YYYY-MM-DD HH24:MI'), 
                TO_DATE('2023-07-21 22:00', 'YYYY-MM-DD HH24:MI')
                )
        ),
        NULL
    )
);
/

--SELECT A.nome, A.cache, C.* FROM tb_atracao A, TABLE (A.cronograma) C