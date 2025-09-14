-- Investigação

CREATE TABLE investigacao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id INT NOT NULL,
  status VARCHAR(50),
  descricao TEXT,
  data_inicio DATE,
  data_encerramento DATE,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id)
);

CREATE TABLE investigacao_ocorrencia (
  investigacao_id INT,
  ocorrencia_id INT,
  PRIMARY KEY (investigacao_id, ocorrencia_id),
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE investigacao_pessoa (
  investigacao_id INT,
  pessoa_id INT,
  descricao TEXT,
  PRIMARY KEY (investigacao_id, pessoa_id),
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE laudo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  investigacao_id INT,
  perito_id INT,
  titulo VARCHAR(255),
  conteudo TEXT,
  data_emissao DATE,
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (perito_id) REFERENCES pessoa_profissao(id)
);

CREATE TABLE inquerito_policial (
  id INT AUTO_INCREMENT PRIMARY KEY,
  investigacao_id INT,
  ocorrencia_id INT,
  numero_protocolo VARCHAR(50),
  data_abertura DATE,
  data_encerramento DATE,
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE evidencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  coleta_endereco_id INT,
  tipo VARCHAR(255),
  descricao TEXT,
  data_coletada DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (coleta_endereco_id) REFERENCES endereco(id)
);

CREATE TABLE evidencia_digital (
  id INT AUTO_INCREMENT PRIMARY KEY,
  evidencia_id INT,
  descricao TEXT,
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE evidencia_digital_arquivo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  evidencia_dig_id INT,
  hash VARCHAR(255),
  plataforma VARCHAR(255),
  conteudo TEXT,
  FOREIGN KEY (evidencia_dig_id) REFERENCES evidencia_digital(id)
);

CREATE TABLE monitoramento_eletronico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT,
  tipo_monitoramento VARCHAR(255),
  data_inicio DATE,
  data_fim DATE,
  dispositivo_info TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE incidente_cibernetico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  monit_id INT,
  descricao TEXT,
  vetor_ataque VARCHAR(255),
  impacto VARCHAR(255),
  data_detectado DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (monit_id) REFERENCES monitoramento_eletronico(id)
);

CREATE TABLE incidente_cibernetico_evidencia (
  incidente_id INT,
  evidencia_id INT,
  PRIMARY KEY (incidente_id, evidencia_id),
  FOREIGN KEY (incidente_id) REFERENCES incidente_cibernetico(id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE laudo_evidencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  laudo_id INT,
  evidencia_id INT,
  descricao TEXT,
  FOREIGN KEY (laudo_id) REFERENCES laudo(id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE vestigio (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo VARCHAR(50),
  descricao TEXT
);

CREATE TABLE evidencia_vestigio (
  evidencia_id INT,
  vestigio_id INT,
  PRIMARY KEY (evidencia_id, vestigio_id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id),
  FOREIGN KEY (vestigio_id) REFERENCES vestigio(id)
);

CREATE TABLE denuncia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id INT,
  denunciante_id INT,
  descricao TEXT,
  data_registro DATETIME,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (denunciante_id) REFERENCES pessoa(id)
);

CREATE TABLE denuncia_investigacao (
  denuncia_id INT,
  investigacao_id INT,
  PRIMARY KEY (denuncia_id, investigacao_id),
  FOREIGN KEY (denuncia_id) REFERENCES denuncia(id),
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id)
);

CREATE TABLE boletim (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  numero VARCHAR(50) UNIQUE,
  texto TEXT,
  data_registro DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);
