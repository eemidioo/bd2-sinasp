DELIMITER $$

CREATE EVENT IF NOT EXISTS arquivar_ocorrencias_antigas
ON SCHEDULE EVERY 1 MONTH
STARTS TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y-%m-01') + INTERVAL 1 MONTH)
DO
BEGIN
  -- Arquiva ocorrências com mais de 10 anos
  INSERT INTO ocorrencia_historico (id, tipo_id, endereco_id, unidade_id, data_hora, status, descricao)
  SELECT id, tipo_id, endereco_id, unidade_id, data_hora, status, descricao
  FROM ocorrencia
  WHERE data_hora < NOW() - INTERVAL 10 YEAR;

  -- Remove da tabela principal
  DELETE FROM ocorrencia
  WHERE data_hora < NOW() - INTERVAL 10 YEAR;
END$$


CREATE EVENT IF NOT EXISTS gerar_relatorio_mensal
ON SCHEDULE EVERY 1 MONTH
STARTS TIMESTAMP(DATE_FORMAT(CURDATE(), '%Y-%m-01') + INTERVAL 1 MONTH) + INTERVAL 5 MINUTE
DO
BEGIN
  INSERT INTO relatorio_mensal (periodo, total_processos, total_investigacoes)
  SELECT 
    DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m') AS periodo,

    -- Processos iniciados no mês anterior
    (SELECT COUNT(*) 
     FROM processo 
     WHERE YEAR(data_inicio) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
       AND MONTH(data_inicio) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))) AS total_processos,

    -- Investigações iniciadas no mês anterior
    (SELECT COUNT(*) 
     FROM investigacao 
     WHERE YEAR(data_inicio) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
       AND MONTH(data_inicio) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))) AS total_investigacoes;

END$$

DELIMITER ;
