-- Procedures

DELIMITER $$

CREATE PROCEDURE endereco_criar (
  IN p_uf_sigla CHAR(2),
  IN p_uf_nome VARCHAR(255),
  IN p_cidade_nome VARCHAR(255),
  IN p_bairro_nome VARCHAR(255),
  IN p_cep VARCHAR(20),
  IN p_rua_nome VARCHAR(255),
  IN p_numero VARCHAR(20),
  IN p_complemento VARCHAR(255),
  IN p_latitude DECIMAL(10,7),
  IN p_longitude DECIMAL(10,7),
  OUT p_endereco_id INT
)
BEGIN
  DECLARE v_uf_id INT;
  DECLARE v_cidade_id INT;
  DECLARE v_bairro_id INT;
  DECLARE v_rua_id INT;
  START TRANSACTION;
  -- Crie o UF caso não exista.
  INSERT INTO uf (sigla, nome) VALUES (UPPER(p_uf_sigla), p_uf_nome)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  SET v_uf_id = LAST_INSERT_ID();
  -- Crie a cidade caso não exista.
  INSERT INTO cidade (uf_id, nome) VALUES (v_uf_id, p_cidade_nome)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  SET v_cidade_id = LAST_INSERT_ID();
  -- Crie o bairro caso não exista.
  INSERT INTO bairro (cidade_id, nome) VALUES (v_cidade_id, p_bairro_nome)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  SET v_bairro_id = LAST_INSERT_ID();
  -- Crie a rua caso não exista.
  INSERT INTO rua (bairro_id, cep, nome) VALUES (v_bairro_id, p_cep, p_rua_nome)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  SET v_rua_id = LAST_INSERT_ID();
  -- Cria o endereço caso não exista.
  INSERT INTO endereco (rua_id, numero, complemento, latitude, longitude)
  VALUES (v_rua_id, p_numero, p_complemento, p_latitude, p_longitude)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  -- Retorne o ID em p_endereco_id.
  SET p_endereco_id = LAST_INSERT_ID();
  COMMIT;
END $$
-- Exemplo de utilização de 'endereco_criar':
-- CALL endereco_criar(
--        'PE', 'Pernambuco', 'Salgueiro', 'Centro', '56000000',
--        'Av. Antônio Angelim', '570', '2º andar', NULL, NULL,
--        @endereco_id);

CREATE PROCEDURE pessoa_criar (
  IN p_nome VARCHAR(255),
  IN p_sexo VARCHAR(50), -- M, F, etc.
  IN p_data_nascimento DATE,
  IN p_descricao TEXT,
  OUT p_pessoa_id INT
)
BEGIN
  DECLARE v_sexo_id INT;
  START TRANSACTION;
  INSERT INTO pessoa_sexo (nome) VALUES (p_sexo)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
  SET v_sexo_id = LAST_INSERT_ID();
  INSERT INTO pessoa (sexo_id, nome, data_nascimento, descricao)
    VALUES (v_sexo_id, p_nome, p_data_nascimento, p_descricao);
  SET p_pessoa_id = LAST_INSERT_ID();
  COMMIT;
END $$

CREATE PROCEDURE multas_recentes_resumo (
  IN p_data_inicio DATE,
  IN p_data_fim DATE
)
BEGIN
  CREATE TEMPORARY TABLE tmp_multas (
    condutor_id INT,
    total_multas INT,
    total_valor DECIMAL(12, 2)
  );

  INSERT INTO tmp_multas (condutor_id, total_multas, total_valor)
  SELECT
    i.condutor_id,
    COUNT(m.id) AS total_multas,
    SUM(m.valor) AS total_valor
  FROM infracao i
  JOIN multa m ON m.infracao_id = i.id
  WHERE m.data_emissao BETWEEN p_data_inicio AND p_data_fim
  GROUP BY i.condutor_id;

  SELECT
    c.id AS condutor_id,
    p.nome AS condutor_nome,
    t.total_multas,
    t.total_valor
  FROM tmp_multas t
  JOIN condutor c ON c.id = t.condutor_id
  JOIN pessoa p ON p.id = c.pessoa_id
  ORDER BY t.total_valor DESC;

  DROP TEMPORARY TABLE IF EXISTS tmp_multas;
END $$

DELIMITER ;
