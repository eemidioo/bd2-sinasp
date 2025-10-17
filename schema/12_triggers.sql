-- Triggers

DELIMITER $$

CREATE TRIGGER trg_pessoa_endereco_principal_ins
BEFORE INSERT ON pessoa_endereco
FOR EACH ROW
BEGIN
  IF NEW.principal = TRUE AND EXISTS
  (SELECT 1 FROM pessoa_endereco
    WHERE pessoa_id = NEW.pessoa_id AND principal = TRUE)
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Já existe um endereço principal para esta pessoa.';
  END IF;
END $$

CREATE TRIGGER trg_pessoa_endereco_principal_upd
BEFORE UPDATE ON pessoa_endereco
FOR EACH ROW
BEGIN
  IF NEW.principal = TRUE AND EXISTS
  (SELECT 1 FROM pessoa_endereco
    WHERE pessoa_id = NEW.pessoa_id AND principal = TRUE
    AND endereco_id != OLD.endereco_id)
  THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Já existe um endereço principal para esta pessoa.';
  END IF;
END $$

DELIMITER ;
