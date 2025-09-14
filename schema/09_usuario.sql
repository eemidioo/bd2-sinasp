-- Usuário do SINASP

CREATE TABLE sinasp_usuario (
  id INT AUTO_INCREMENT PRIMARY KEY,
  profissional_id INT,
  login VARCHAR(255) UNIQUE NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  nome_completo VARCHAR(255),
  email VARCHAR(255),
  FOREIGN KEY (profissional_id) REFERENCES pessoa_profissao(id)
);

CREATE TABLE sinasp_usuario_nivel_acesso (
  usuario_id INT,
  nivel INT,
  PRIMARY KEY (usuario_id, nivel),
  FOREIGN KEY (usuario_id) REFERENCES sinasp_usuario(id)
);

CREATE TABLE sinasp_usuario_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  acao VARCHAR(255),
  detalhes TEXT,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES sinasp_usuario(id)
);
