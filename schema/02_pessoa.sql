-- Pessoa

CREATE TABLE telefone_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE telefone (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_id INT,
  numero VARCHAR(50) UNIQUE NOT NULL,
  descricao VARCHAR(255),
  FOREIGN KEY (tipo_id) REFERENCES telefone_tipo(id)
);

CREATE TABLE pessoa_sexo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE pessoa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sexo_id INT,
  nome VARCHAR(255) NOT NULL,
  data_nascimento DATE,
  descricao TEXT,
  FOREIGN KEY (sexo_id) REFERENCES pessoa_sexo(id)
);

CREATE TABLE pessoa_endereco (
  pessoa_id INT,
  endereco_id INT,
  descricao TEXT,
  principal BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (pessoa_id, endereco_id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE pessoa_telefone (
  pessoa_id INT,
  telefone_id INT,
  PRIMARY KEY (pessoa_id, telefone_id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (telefone_id) REFERENCES telefone(id)
);

CREATE TABLE condutor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT UNIQUE NOT NULL,
  cnh VARCHAR(50) UNIQUE,
  cnh_validade DATE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE categoria_cnh (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE condutor_categoria (
  condutor_id INT,
  categoria_cnh_id INT,
  PRIMARY KEY (condutor_id, categoria_cnh_id),
  FOREIGN KEY (condutor_id) REFERENCES condutor(id),
  FOREIGN KEY (categoria_cnh_id) REFERENCES categoria_cnh(id)
);

CREATE TABLE cidadao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT UNIQUE NOT NULL,
  cpf VARCHAR(20) UNIQUE,
  rg VARCHAR(20) UNIQUE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);
