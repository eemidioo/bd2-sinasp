-- Localização

CREATE TABLE uf (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sigla CHAR(2) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  UNIQUE KEY (sigla)
);

CREATE TABLE cidade (
  id INT AUTO_INCREMENT PRIMARY KEY,
  uf_id INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  UNIQUE KEY (uf_id, nome),
  FOREIGN KEY (uf_id) REFERENCES uf(id)
);

CREATE TABLE bairro (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cidade_id INT NOT NULL,
  nome VARCHAR(255) NOT NULL,
  UNIQUE KEY (cidade_id, nome),
  FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

CREATE TABLE rua (
  id INT AUTO_INCREMENT PRIMARY KEY,
  bairro_id INT,
  cep VARCHAR(20),
  nome VARCHAR(255) NOT NULL,
  UNIQUE KEY (bairro_id, cep, nome),
  FOREIGN KEY (bairro_id) REFERENCES bairro(id)
);

CREATE TABLE endereco (
  id INT AUTO_INCREMENT PRIMARY KEY,
  rua_id INT,
  numero VARCHAR(20),
  complemento VARCHAR(255),
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7),
  UNIQUE KEY (rua_id, numero, complemento),
  FOREIGN KEY (rua_id) REFERENCES rua(id)
);
