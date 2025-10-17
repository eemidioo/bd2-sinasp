-- Agência

-- 'POLICIA', 'BOMBEIRO', 'DEFESA_CIVIL', 'TRANSITO', 'JUDICIAL', 'FISCAL', ...
CREATE TABLE agencia_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE agencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_id INT,
  sigla VARCHAR(10) UNIQUE NOT NULL,
  nome VARCHAR(255) NOT NULL,
  FOREIGN KEY (tipo_id) REFERENCES agencia_tipo(id)
);

CREATE TABLE agencia_telefone (
  agencia_id INT,
  telefone_id INT,
  PRIMARY KEY (agencia_id, telefone_id),
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (telefone_id) REFERENCES telefone(id)
);

-- 'DELEGACIA', 'BATALHAO', 'BASE', 'SEDE', 'POSTO', ...
CREATE TABLE unidade_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE unidade (
  id INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id INT NOT NULL,
  tipo_id INT,
  endereco_id INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (tipo_id) REFERENCES unidade_tipo(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE profissao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  patente VARCHAR(255),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE pessoa_profissao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT NOT NULL,
  profissao_id INT NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (profissao_id) REFERENCES profissao(id)
);

CREATE TABLE treinamento_capacitacao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id INT NOT NULL,
  endereco_id INT,
  titulo VARCHAR(255),
  descricao TEXT,
  data_inicio DATE,
  data_fim DATE,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE agente_treinamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT,
  treinamento_id INT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id)
);

CREATE TABLE participante_treinamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  treinamento_id INT,
  pessoa_id INT,
  status VARCHAR(50),
  nota DECIMAL(5, 2),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE certificacao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  participante_id INT NOT NULL,
  treinamento_id INT,
  descricao TEXT,
  validade DATE,
  FOREIGN KEY (participante_id) REFERENCES participante_treinamento(id),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id)
);
