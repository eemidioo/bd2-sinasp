-- Processo

CREATE TABLE processo_status (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE processo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id INT,
  orgao_fiscal_id INT,
  contra_pessoa_id INT,
  status_id INT,
  numero VARCHAR(50) UNIQUE,
  tipo VARCHAR(255),
  data_inicio DATE,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (orgao_fiscal_id) REFERENCES orgao_fiscal(id),
  FOREIGN KEY (contra_pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (status_id) REFERENCES processo_status(id)
);

CREATE TABLE processo_denuncia (
  processo_id INT,
  denuncia_id INT,
  PRIMARY KEY (processo_id, denuncia_id),
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (denuncia_id) REFERENCES denuncia(id)
);

CREATE TABLE intimacao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  processo_id INT NOT NULL,
  pessoa_id INT NOT NULL,
  data_envio DATE NOT NULL,
  data_cumprimento DATE,
  meio VARCHAR(50),
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE sentenca (
  id INT AUTO_INCREMENT PRIMARY KEY,
  processo_id INT,
  numero VARCHAR(50) UNIQUE,
  texto TEXT,
  pena TEXT,
  data_sentenca DATE,
  FOREIGN KEY (processo_id) REFERENCES processo(id)
);

CREATE TABLE sistema_penitenciario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255),
  endereco_id INT,
  capacidade INT,
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE prisao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sistema_id INT,
  sentenca_id INT,
  data_prisao DATETIME,
  custodia BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (sistema_id) REFERENCES sistema_penitenciario(id),
  FOREIGN KEY (sentenca_id) REFERENCES sentenca(id)
);

CREATE TABLE historico_criminal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT NOT NULL,
  crime_id INT,
  processo_id INT,
  descricao TEXT,
  data_ocorrencia DATE,
  status VARCHAR(50),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (crime_id) REFERENCES crime(id),
  FOREIGN KEY (processo_id) REFERENCES processo(id)
);

CREATE TABLE habeas_corpus (
  id INT AUTO_INCREMENT PRIMARY KEY,
  prisao_id INT,
  requerente_id INT,
  juiz_id INT,
  data_peticao DATE,
  status VARCHAR(50),
  FOREIGN KEY (prisao_id) REFERENCES prisao(id),
  FOREIGN KEY (requerente_id) REFERENCES pessoa(id),
  FOREIGN KEY (juiz_id) REFERENCES pessoa(id)
);

CREATE TABLE fianca (
  id INT AUTO_INCREMENT PRIMARY KEY,
  prisao_id INT,
  pagante_id INT,
  valor DECIMAL(12, 2),
  data_pagamento DATE,
  FOREIGN KEY (prisao_id) REFERENCES prisao(id),
  FOREIGN KEY (pagante_id) REFERENCES pessoa(id)
);

CREATE TABLE mandado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  processo_id INT,
  pessoa_id INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE vitima_violencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT UNIQUE NOT NULL,
  descricao TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE agressor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT UNIQUE NOT NULL,
  descricao TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE medida_protetiva (
  id INT AUTO_INCREMENT PRIMARY KEY,
  vitima_id INT NOT NULL,
  agressor_id INT NOT NULL,
  tipo VARCHAR(50),
  data_inicio DATE,
  data_fim DATE,
  descricao TEXT,
  FOREIGN KEY (vitima_id) REFERENCES vitima_violencia(id),
  FOREIGN KEY (agressor_id) REFERENCES agressor(id)
);

CREATE TABLE protecao_testemunha (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT,
  nivel_protecao VARCHAR(255),
  data_inicio DATE,
  data_fim DATE,
  descricao TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE IF NOT EXISTS processo_relatorio_mensal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  periodo CHAR(7) UNIQUE NOT NULL, -- formato YYYY-MM
  total_processos INT DEFAULT 0,
  total_investigacoes INT DEFAULT 0,
  data_geracao DATETIME DEFAULT NOW()
);
