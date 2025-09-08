DROP DATABASE IF EXISTS sinasp;
CREATE DATABASE sinasp;
USE sinasp;

CREATE TABLE uf (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  sigla                 CHAR(2)       UNIQUE NOT NULL,
  nome                  VARCHAR(255)  NOT NULL
);

CREATE TABLE cidade (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  uf_id                 INT           NOT NULL,
  FOREIGN KEY (uf_id) REFERENCES uf(id)
);

CREATE TABLE bairro (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  cidade_id             INT           NOT NULL,
  FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

CREATE TABLE rua (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  bairro_id             INT,
  cep                   VARCHAR(20),
  FOREIGN KEY (bairro_id) REFERENCES bairro(id)
);

CREATE TABLE endereco (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  rua_id                INT,
  numero                VARCHAR(20),
  complemento           VARCHAR(255),
  latitude              DECIMAL(10,7),
  longitude             DECIMAL(10,7),
  FOREIGN KEY (rua_id) REFERENCES rua(id)
);

CREATE TABLE telefone (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  numero                VARCHAR(50)   UNIQUE NOT NULL,
  descricao             VARCHAR(255),
  tipo                  ENUM('FIXO',
                             'CELULAR',
                             'COMERCIAL',
                             'RECADO')
);

CREATE TABLE pessoa (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  data_nascimento       DATE,
  sexo                  ENUM('M', 'F', 'O'),
  descricao             TEXT
);

CREATE TABLE pessoa_endereco (
  pessoa_id             INT,
  endereco_id           INT,
  descricao             VARCHAR(50),
  principal             BOOLEAN       DEFAULT FALSE,
  PRIMARY KEY (pessoa_id, endereco_id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE pessoa_telefone (
  pessoa_id             INT,
  telefone_id           INT,
  PRIMARY KEY (pessoa_id, telefone_id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (telefone_id) REFERENCES telefone(id)
);

CREATE TABLE condutor (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           UNIQUE NOT NULL,
  cnh                   VARCHAR(50)   UNIQUE,
  validade              DATE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE condutor_categoria (
  condutor_id           INT,
  categoria             ENUM('A', 'B', 'C', 'D', 'E'),
  PRIMARY KEY (condutor_id, categoria),
  FOREIGN KEY (condutor_id) REFERENCES condutor(id)
);

CREATE TABLE cidadao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           UNIQUE,
  cpf                   VARCHAR(20)   UNIQUE,
  rg                    VARCHAR(20)   UNIQUE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE agencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  tipo                  ENUM('POLICIA',
                             'BOMBEIRO',
                             'DEFESA_CIVIL',
                             'TRANSITO',
                             'JUDICIAL',
                             'FISCAL',
                             'OUTRO') NOT NULL,
  sede_endereco_id      INT,
  FOREIGN KEY (sede_endereco_id) REFERENCES endereco(id)
);

CREATE TABLE agencia_telefone (
  agencia_id            INT,
  telefone_id           INT,
  PRIMARY KEY (agencia_id, telefone_id),
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (telefone_id) REFERENCES telefone(id)
);

CREATE TABLE unidade (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id            INT           NOT NULL,
  nome                  VARCHAR(255)  NOT NULL,
  tipo                  ENUM('DELEGACIA',
                             'BATALHAO',
                             'BASE',
                             'SEDE',
                             'POSTO'),
  endereco_id           INT           NOT NULL,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE profissao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id            INT           NOT NULL,
  nome                  VARCHAR(255)  NOT NULL,
  patente               VARCHAR(255),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE pessoa_profissao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           NOT NULL,
  profissao_id          INT           NOT NULL,
  data_inicio           DATE,
  data_fim              DATE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (profissao_id) REFERENCES profissao(id)
);

CREATE TABLE veiculo (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  placa                 VARCHAR(20)   UNIQUE,
  renavam               VARCHAR(50),
  modelo                VARCHAR(255),
  cor                   VARCHAR(50),
  descricao             TEXT,
  proprietario_id       INT,
  unidade_id            INT,
  tipo                  ENUM('CARRO',
                             'MOTO',
                             'CAMINHAO',
                             'VAN',
                             'ONIBUS',
                             'CAMINHONETE',
                             'TRATOR',
                             'MOTOCICLETA',
                             'BARCO',
                             'JET_SKI',
                             'LANCHA',
                             'BOTE',
                             'DRONE',
                             'HELICOPTERO',
                             'AVIAO',
                             'AMBULANCIA',
                             'VEICULO_CRIMINOSO'),
  FOREIGN KEY (proprietario_id) REFERENCES pessoa(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE restricao_veicular (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  veiculo_id            INT           NOT NULL,
  motivo                TEXT,
  data_inicio           DATE,
  data_fim              DATE,
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE viatura (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  veiculo_id            INT           NOT NULL,
  status                ENUM('DISPONIVEL',
                             'EM_SERVICO',
                             'EM_MANUTENCAO',
                             'FORA_DE_SERVICO',
                             'RESERVADA'),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE equipamento (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id            INT,
  patrimonio            VARCHAR(255)  UNIQUE,
  nome                  VARCHAR(255),
  tipo                  VARCHAR(50),
  descricao             TEXT,
  status                VARCHAR(50),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE revisao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  equipamento_id        INT,
  veiculo_id            INT,
  descricao             TEXT,
  data_inicio           DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_fim              DATETIME,
  status                VARCHAR(50),
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE manutencao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  revisao_id            INT,
  descricao             TEXT,
  data_inicio           DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_fim              DATETIME,
  status                VARCHAR(50),
  FOREIGN KEY (revisao_id) REFERENCES revisao(id)
);

CREATE TABLE patio_apreensao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255),
  endereco_id           INT           NOT NULL,
  capacidade            INT           NOT NULL,
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE apreensao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  patio_id              INT,
  equipamento_id        INT,
  veiculo_id            INT,
  data_entrada          DATETIME DEFAULT CURRENT_TIMESTAMP,
  data_saida            DATETIME,
  FOREIGN KEY (patio_id) REFERENCES patio_apreensao(id),
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE orgao_fiscal (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  unidade_id            INT,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE infracao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  codigo                VARCHAR(255),
  descricao             TEXT,
  pontuacao             INT,
  orgao_fiscal_id       INT,
  FOREIGN KEY (orgao_fiscal_id) REFERENCES orgao_fiscal(id)
);

CREATE TABLE multa (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  infracao_id           INT,
  condutor_id           INT,
  veiculo_id            INT,
  numero_multa          VARCHAR(255),
  valor                 DECIMAL(12,2),
  data_emissao          DATE,
  data_vencimento       DATE,
  status                VARCHAR(50),
  FOREIGN KEY (infracao_id) REFERENCES infracao(id),
  FOREIGN KEY (condutor_id) REFERENCES condutor(id),
  FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE TABLE recurso_infracao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  multa_id              INT,
  requerente_id         INT,
  data_protocolo        DATE,
  motivo                TEXT,
  status                VARCHAR(50),
  FOREIGN KEY (multa_id) REFERENCES multa(id),
  FOREIGN KEY (requerente_id) REFERENCES pessoa(id)
);

CREATE TABLE tipo_crime (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL,
  codigo_legal          VARCHAR(255)
);

CREATE TABLE crime (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  codigo                VARCHAR(50),
  descricao             TEXT,
  tipo_crime_id         INT,
  gravidade             INT,
  FOREIGN KEY (tipo_crime_id) REFERENCES tipo_crime(id)
);

CREATE TABLE tipo_ocorrencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255)  NOT NULL
);

CREATE TABLE ocorrencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  tipo_ocorrencia_id    INT,
  data_hora             DATETIME,
  endereco_id           INT,
  resumo                TEXT,
  status                VARCHAR(50),
  unidade_id            INT,
  FOREIGN KEY (tipo_ocorrencia_id) REFERENCES tipo_ocorrencia(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE participante_ocorrencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id         INT,
  pessoa_id             INT,
  papel                 ENUM('VITIMA',
                             'SUSPEITO',
                             'TESTEMUNHA',
                             'COMUNICANTE',
                             'AGENTE'),
  descricao             TEXT,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE alocacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  equipamento_id        INT,
  viatura_id            INT,
  ocorrencia_id         INT,
  data_inicio           DATETIME,
  data_fim              DATETIME,
  FOREIGN KEY (equipamento_id) REFERENCES equipamento(id),
  FOREIGN KEY (viatura_id) REFERENCES viatura(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE alerta_preventivo (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id         INT,
  texto                 TEXT,
  nivel                 VARCHAR(50),
  data_emissao          DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE investigacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  agencia_id            INT           NOT NULL,
  descricao             TEXT,
  status                VARCHAR(50),
  data_inicio           DATE,
  data_encerramento     DATE,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id)
);

CREATE TABLE investigacao_ocorrencia (
  investigacao_id       INT,
  ocorrencia_id         INT,
  PRIMARY KEY (investigacao_id, ocorrencia_id),
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE inquerito_policial (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  investigacao_id       INT,
  ocorrencia_id         INT,
  numero_protocolo      VARCHAR(255),
  data_abertura         DATE,
  data_encerramento     DATE,
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE laudo (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  investigacao_id       INT,
  titulo                VARCHAR(255),
  conteudo              TEXT,
  elaborado_por         INT,
  data_emissao          DATE,
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (elaborado_por) REFERENCES pessoa_profissao(id)
);

CREATE TABLE evidencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  tipo                  VARCHAR(255),
  descricao             TEXT,
  coleta_endereco_id    INT,
  data_coletado         DATETIME,
  FOREIGN KEY (coleta_endereco_id) REFERENCES endereco(id)
);

CREATE TABLE evidencia_digital (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  evidencia_id          INT,
  arquivo_referencia    TEXT,
  hash                  VARCHAR(255),
  plataforma            VARCHAR(255),
  descricao             TEXT,
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE laudo_evidencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  laudo_id              INT,
  evidencia_id          INT,
  descricao             TEXT,
  FOREIGN KEY (laudo_id) REFERENCES laudo(id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE vestigio (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  descricao             TEXT,
  tipo                  VARCHAR(255)
);

CREATE TABLE evidencia_vestigio (
  evidencia_id INT,
  vestigio_id INT,
  PRIMARY KEY (evidencia_id, vestigio_id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id),
  FOREIGN KEY (vestigio_id) REFERENCES vestigio(id)
);

CREATE TABLE denuncia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  denunciante_id        INT,
  descricao             TEXT,
  data_registro         DATETIME,
  FOREIGN KEY (denunciante_id) REFERENCES pessoa(id)
);

CREATE TABLE boletim (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id         INT,
  numero_boletim        VARCHAR(255),
  texto                 TEXT,
  data_registro         DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE processo (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  numero                VARCHAR(255) UNIQUE,
  tipo                  VARCHAR(255),
  status                VARCHAR(50),
  data_inicio           DATE,
  agencia_id            INT           NOT NULL,
  FOREIGN KEY (agencia_id) REFERENCES agencia(id)
);

CREATE TABLE mandado (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  tipo                  VARCHAR(255),
  numero                VARCHAR(255),
  data_emissao          DATE,
  data_validade         DATE,
  FOREIGN KEY (processo_id) REFERENCES processo(id)
);

CREATE TABLE prisao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT,
  ocorrencia_id         INT,
  mandado_id            INT,
  data_prisao           DATETIME,
  prisao_endereco_id    INT,
  custodia              BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (mandado_id) REFERENCES mandado(id),
  FOREIGN KEY (prisao_endereco_id) REFERENCES endereco(id)
);

CREATE TABLE sistema_penitenciario (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255),
  endereco_id           INT,
  capacidade            INT,
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE sentenca (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  texto                 TEXT,
  data_sentenca         DATE,
  pena                  VARCHAR(255),
  autor_id              INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (autor_id) REFERENCES pessoa(id)
);

CREATE TABLE habeas_corpus (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  requerente_id         INT,
  juiz_id               INT,
  data_peticao          DATE,
  status                VARCHAR(50),
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (requerente_id) REFERENCES pessoa(id),
  FOREIGN KEY (juiz_id) REFERENCES pessoa(id)
);

CREATE TABLE fianca (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  valor                 DECIMAL(12,2),
  data_pagamento        DATE,
  pagante_id            INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (pagante_id) REFERENCES pessoa(id)
);

CREATE TABLE protecao_testemunha (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT,
  nivel_protecao        VARCHAR(255),
  data_inicio           DATE,
  data_fim              DATE,
  descricao             TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE vitima_violencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           UNIQUE NOT NULL,
  descricao             TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE agressor (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           UNIQUE NOT NULL,
  descricao             TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE medida_protetiva (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  vitima_id             INT           NOT NULL,
  agressor_id           INT           NOT NULL,
  tipo                  VARCHAR(50),
  data_inicio           DATE,
  data_fim              DATE,
  descricao             TEXT,
  FOREIGN KEY (vitima_id) REFERENCES vitima_violencia(id),
  FOREIGN KEY (agressor_id) REFERENCES agressor(id)
);

CREATE TABLE alocacao_recursos (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id            INT,
  recurso_tipo          VARCHAR(255),
  data_hora             DATETIME,
  descricao             TEXT,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE operacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255),
  descricao             TEXT,
  data_inicio           DATETIME,
  data_fim              DATETIME
);

CREATE TABLE operacao_unidade (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id           INT           NOT NULL,
  unidade_id            INT           NOT NULL,
  papel                 VARCHAR(255),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE operacao_ocorrencia (
  operacao_id           INT,
  ocorrencia_id         INT,
  PRIMARY KEY (operacao_id, ocorrencia_id),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE pertences (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id           INT,
  pessoa_id             INT,
  descricao             TEXT,
  valor_estimado        DECIMAL(12,2),
  apreendido            BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (operacao_id) REFERENCES operacao(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE organizacao_criminosa (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255),
  descricao             TEXT,
  grau_organizacao      VARCHAR(255)
);

CREATE TABLE analise_vinculo_criminoso (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT           NOT NULL,
  org_criminosa_id      INT           NOT NULL,
  tipo_vinculo          VARCHAR(50),
  descricao             TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (org_criminosa_id) REFERENCES organizacao_criminosa(id)
);

CREATE TABLE criminoso (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  org_criminosa_id      INT,
  pessoa_id             INT           NOT NULL,
  papel                 VARCHAR(255),
  data_entrada          DATE,
  data_saida            DATE,
  FOREIGN KEY (org_criminosa_id) REFERENCES organizacao_criminosa(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE treinamento_capacitacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id            INT           NOT NULL,
  titulo                VARCHAR(255),
  descricao             TEXT,
  data_inicio           DATE,
  data_fim              DATE,
  endereco_id           INT,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id),
  FOREIGN KEY (endereco_id) REFERENCES endereco(id)
);

CREATE TABLE agente_treinamento (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT,
  treinamento_id        INT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id)
);

CREATE TABLE participante_treinamento (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  treinamento_id        INT,
  pessoa_id             INT,
  status                VARCHAR(50),
  nota                  DECIMAL(5,2),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id),
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE certificacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  participante_id       INT           NOT NULL,
  treinamento_id        INT,
  descricao             TEXT,
  validade              DATE,
  FOREIGN KEY (participante_id) REFERENCES participante_treinamento(id),
  FOREIGN KEY (treinamento_id) REFERENCES treinamento_capacitacao(id)
);

CREATE TABLE monitoramento_eletronico (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  pessoa_id             INT,
  tipo_monitoramento    VARCHAR(255),
  data_inicio           DATE,
  data_fim              DATE,
  dispositivo_info TEXT,
  FOREIGN KEY (pessoa_id) REFERENCES pessoa(id)
);

CREATE TABLE escala_plantao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  operacao_id           INT,
  data_inicio           DATETIME,
  data_fim              DATETIME,
  papel                 VARCHAR(255),
  FOREIGN KEY (operacao_id) REFERENCES operacao(id)
);

CREATE TABLE horario_trabalho (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  escala_plantao_id     INT,
  dia_semana            ENUM('DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB'),
  hora_inicio           TIME,
  hora_fim              TIME,
  FOREIGN KEY (escala_plantao_id) REFERENCES escala_plantao(id)
);

CREATE TABLE meta_operacional (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  unidade_id            INT,
  nome                  VARCHAR(255),
  descricao             TEXT,
  periodo_inicio        DATE,
  periodo_fim           DATE,
  FOREIGN KEY (unidade_id) REFERENCES unidade(id)
);

CREATE TABLE incidente_cibernetico (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id         INT,
  descricao             TEXT,
  vetor_ataque          VARCHAR(255),
  impacto               VARCHAR(255),
  data_detectado        DATETIME,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id)
);

CREATE TABLE ocorrencia_evidencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  ocorrencia_id         INT,
  evidencia_id          INT,
  descricao             TEXT,
  FOREIGN KEY (ocorrencia_id) REFERENCES ocorrencia(id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE evidencia_digital_link (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  evidencia_digital_id  INT,
  url                   VARCHAR(500),
  armazenado_em         VARCHAR(255),
  FOREIGN KEY (evidencia_digital_id) REFERENCES evidencia_digital(id)
);

CREATE TABLE processo_mandado (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  mandado_id            INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (mandado_id) REFERENCES mandado(id)
);

CREATE TABLE processo_sentenca (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  sentenca_id           INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (sentenca_id) REFERENCES sentenca(id)
);

CREATE TABLE processo_prisao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  processo_id           INT,
  prisao_id             INT,
  FOREIGN KEY (processo_id) REFERENCES processo(id),
  FOREIGN KEY (prisao_id) REFERENCES prisao(id)
);

CREATE TABLE denuncia_investigacao (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  denuncia_id           INT,
  investigacao_id       INT,
  FOREIGN KEY (denuncia_id) REFERENCES denuncia(id),
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id)
);

CREATE TABLE investigacao_inquerito (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  investigacao_id       INT,
  inquerito_id          INT,
  FOREIGN KEY (investigacao_id) REFERENCES investigacao(id),
  FOREIGN KEY (inquerito_id) REFERENCES inquerito_policial(id)
);

CREATE TABLE inquerito_evidencia (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  inquerito_id          INT,
  evidencia_id          INT,
  FOREIGN KEY (inquerito_id) REFERENCES inquerito_policial(id),
  FOREIGN KEY (evidencia_id) REFERENCES evidencia(id)
);

CREATE TABLE escala_horario (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  escala_id             INT,
  horario_trabalho_id   INT,
  FOREIGN KEY (escala_id) REFERENCES escala_plantao(id),
  FOREIGN KEY (horario_trabalho_id) REFERENCES horario_trabalho(id)
);

CREATE TABLE horario_turno (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  nome                  VARCHAR(255),
  hora_inicio           TIME,
  hora_fim              TIME
);

CREATE TABLE usuario (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  profissional_id       INT,
  login                 VARCHAR(255) UNIQUE NOT NULL,
  senha_hash            VARCHAR(255) NOT NULL,
  nome_completo         VARCHAR(255),
  email                 VARCHAR(255),
  FOREIGN KEY (profissional_id) REFERENCES pessoa_profissao(id)
);

CREATE TABLE usuario_nivel_acesso (
  usuario_id            INT,
  nivel                 INT,
  PRIMARY KEY (usuario_id, nivel),
  FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

CREATE TABLE usuario_log (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id            INT,
  acao                  VARCHAR(255),
  detalhes              TEXT,
  data_hora             DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);
