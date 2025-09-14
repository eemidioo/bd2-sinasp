CREATE TABLE orgao_fiscal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id INT,
  nome VARCHAR(255) NOT NULL,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);
CREATE TABLE infracao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  condutor_id INT NOT NULL,
  veiculo_id INT NOT NULL,
  orgao_fiscal_id INT,
  codigo VARCHAR(255),
  descricao TEXT,
  pontuacao INT,
  FOREIGN KEY (condutor_id) REFERENCES condutor(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id),
  FOREIGN KEY (orgao_fiscal_id) REFERENCES orgao_fiscal(id)
);
CREATE TABLE multa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  infracao_id INT,
  numero VARCHAR(50),
  valor DECIMAL(12, 2),
  data_emissao DATE,
  data_vencimento DATE,
  status VARCHAR(50),
  FOREIGN KEY (infracao_id) REFERENCES infracao(id)
);
CREATE TABLE recurso_infracao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  infracao_id INT,
  requerente_id INT,
  data_protocolo DATE,
  motivo TEXT,
  status VARCHAR(50),
  FOREIGN KEY (infracao_id) REFERENCES infracao(id),
  FOREIGN KEY (requerente_id) REFERENCES pessoa(id)
);
CREATE TABLE crime_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) UNIQUE NOT NULL,
  codigo_legal VARCHAR(255)
);
CREATE TABLE crime (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_id INT,
  pessoa_id INT NOT NULL,
  descricao TEXT,
  gravidade INT,
  FOREIGN KEY (tipo_id) REFERENCES crime_tipo(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);
CREATE TABLE organizacao_criminosa (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255),
  descricao TEXT,
  grau_organizacao VARCHAR(255)
);
CREATE TABLE analise_vinculo_criminoso (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id INT NOT NULL,
  org_criminosa_id INT NOT NULL,
  tipo_vinculo VARCHAR(50),
  descricao TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (org_criminosa_id) REFERENCES organizacao_criminosa(id)
);
CREATE TABLE criminoso_organizado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  org_criminosa_id INT,
  pessoa_id INT NOT NULL,
  papel VARCHAR(255),
  data_entrada DATE,
  data_saida DATE,
  FOREIGN KEY (org_criminosa_id) REFERENCES organizacao_criminosa(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);
