-- Recursos

CREATE TABLE veiculo_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE veiculo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proprietario_id INT,
  unidade_id INT,
  tipo_id INT,
  placa VARCHAR(20) UNIQUE,
  renavam VARCHAR(50),
  modelo VARCHAR(255),
  cor VARCHAR(50),
  descricao TEXT,
  FOREIGN KEY (proprietario_id) REFERENCES pessoa(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id),
  FOREIGN KEY (tipo_id) REFERENCES veiculo_tipo(id)
);

CREATE TABLE restricao_veicular (
  id INT AUTO_INCREMENT PRIMARY KEY,
  veiculo_id INT NOT NULL,
  motivo TEXT,
  data_inicio DATE,
  data_fim DATE,
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE viatura_status (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE viatura (
  id INT AUTO_INCREMENT PRIMARY KEY,
  veiculo_id INT UNIQUE NOT NULL,
  status_id INT,
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id),
  FOREIGN KEY (status_id) REFERENCES viatura_status(id)
);

CREATE TABLE equipamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id INT,
  patrimonio VARCHAR(255) UNIQUE,
  nome VARCHAR(255),
  tipo VARCHAR(50),
  descricao TEXT,
  status VARCHAR(50),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE arma_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE arma (
  id INT AUTO_INCREMENT PRIMARY KEY,
  equipamento_id INT UNIQUE NOT NULL,
  tipo_id INT,
  numero_serie VARCHAR(255) UNIQUE,
  descricao TEXT,
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (tipo_id) REFERENCES arma_tipo(id)
);

CREATE TABLE alocacao_recurso (
  id INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id INT,
  equipamento_id INT,
  viatura_id INT,
  data_inicio DATETIME,
  data_fim DATETIME,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id),
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (viatura_id) REFERENCES viatura(id)
);

CREATE TABLE revisao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  equipamento_id INT,
  veiculo_id INT,
  descricao TEXT,
  data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_fim DATETIME,
  status VARCHAR(50),
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE manutencao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  revisao_id INT,
  descricao TEXT,
  data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_fim DATETIME,
  status VARCHAR(50),
  FOREIGN KEY (revisao_id) REFERENCES revisao(id)
);

CREATE TABLE patio_apreensao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  endereco_id INT NOT NULL,
  nome VARCHAR(255),
  capacidade INT NOT NULL,
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE apreensao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patio_id INT,
  equipamento_id INT,
  veiculo_id INT,
  data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_saida DATETIME,
  FOREIGN KEY (patio_id) REFERENCES patio_apreensao(id),
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);
