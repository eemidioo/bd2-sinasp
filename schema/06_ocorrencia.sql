CREATE TABLE ocorrencia_tipo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE ocorrencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_id INT,
  endereco_id INT,
  unidade_id INT,
  data_hora DATETIME,
  status VARCHAR(50),
  descricao TEXT,
  FOREIGN KEY (tipo_id) REFERENCES ocorrencia_tipo(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);
CREATE TABLE ocorrencia_crime (
  ocorrencia_id INT,
  crime_id INT,
  PRIMARY KEY (ocorrencia_id, crime_id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (crime_id) REFERENCES crime(id)
);
CREATE TABLE participante_ocorrencia_papel (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE participante_ocorrencia (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  pessoa_id INT,
  papel_id INT,
  descricao TEXT,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (papel_id) REFERENCES participante_ocorrencia_papel(id)
);
CREATE TABLE ocorrencia_depoimento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  participante_id INT,
  texto TEXT,
  data_hora DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (participante_id) REFERENCES participante_ocorrencia(id)
);
CREATE TABLE alerta_preventivo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id INT,
  texto TEXT,
  nivel VARCHAR(50),
  data_emissao DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);
CREATE TABLE chamada (
  id INT AUTO_INCREMENT PRIMARY KEY,
  telefone_id INT,
  agencia_id INT,
  ocorrencia_id INT,
  data_hora DATETIME,
  descricao TEXT,
  FOREIGN KEY (telefone_id) REFERENCES telefone(id),
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);
CREATE TABLE operacao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255),
  descricao TEXT,
  data_inicio DATETIME,
  data_fim DATETIME
);
CREATE TABLE operacao_unidade (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id INT NOT NULL,
  unidade_id INT NOT NULL,
  papel VARCHAR(255),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);
CREATE TABLE operacao_ocorrencia (
  operacao_id INT,
  ocorrencia_id INT,
  PRIMARY KEY (operacao_id, ocorrencia_id),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);
CREATE TABLE operacao_apreensao (
  operacao_id INT,
  apreensao_id INT,
  PRIMARY KEY (operacao_id, apreensao_id),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (apreensao_id) REFERENCES apreensao(id)
);
CREATE TABLE pertences (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id INT,
  pessoa_id INT,
  descricao TEXT,
  valor_estimado DECIMAL(12, 2),
  apreendido BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);
CREATE TABLE escala_plantao (
  id INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id INT,
  data_inicio DATETIME,
  data_fim DATETIME,
  papel VARCHAR(255),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id)
);
CREATE TABLE horario_trabalho (
  id INT AUTO_INCREMENT PRIMARY KEY,
  escala_plantao_id INT,
  dia_semana ENUM('DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB'),
  hora_inicio TIME,
  hora_fim TIME,
  FOREIGN KEY (escala_plantao_id) REFERENCES escala_plantao(id)
);
CREATE TABLE meta_operacional (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255),
  descricao TEXT,
  periodo_inicio DATE,
  periodo_fim DATE
);
CREATE TABLE operacao_meta_operacional (
  operacao_id INT,
  meta_id INT,
  PRIMARY KEY (operacao_id, meta_id),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (meta_id) REFERENCES meta_operacional(id)
);
