DROP DATABASE IF EXISTS sinasp;
CREATE DATABASE sinasp;
USE sinasp;

-- Exemplos de usuários para o sistema:

---- USUÁRIO ADMINISTRADOR GERAL
--CREATE USER 'admin_sinasp'@'%' IDENTIFIED BY 'SenhaForte123!';
--GRANT ALL PRIVILEGES ON sinasp.* TO 'admin_sinasp'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIOS DE LEITURA (para relatórios e dashboards)
--CREATE USER 'reporting_user'@'%' IDENTIFIED BY 'Relatorio2025!';
--GRANT SELECT ON sinasp.* TO 'reporting_user'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIO DE MÓDULO DE OCORRÊNCIAS
--CREATE USER 'ocorrencia_user'@'%' IDENTIFIED BY 'Ocorrencia2025!';
--GRANT SELECT, INSERT, UPDATE ON sinasp.ocorrencia TO 'ocorrencia_user'@'%';
--GRANT SELECT ON sinasp.condutor, sinasp.pessoa, sinasp.veiculo TO 'ocorrencia_user'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIO DE MÓDULO DE INFRAÇÕES E MULTAS
--CREATE USER 'infracao_user'@'%' IDENTIFIED BY 'Infracao2025!';
--GRANT SELECT, INSERT, UPDATE ON sinasp.infracao, sinasp.multa, sinasp.recurso_infracao TO 'infracao_user'@'%';
--GRANT SELECT ON sinasp.condutor, sinasp.veiculo, sinasp.pessoa TO 'infracao_user'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIO DE MÓDULO DE RECURSOS (veículos, armas, equipamentos)
--CREATE USER 'recursos_user'@'%' IDENTIFIED BY 'Recursos2025!';
--GRANT SELECT, INSERT, UPDATE ON sinasp.veiculo, sinasp.equipamento, sinasp.armamento TO 'recursos_user'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIO DE MÓDULO DE INVESTIGAÇÃO E PROCESSOS
--CREATE USER 'investigacao_user'@'%' IDENTIFIED BY 'Investigacao2025!';
--GRANT SELECT, INSERT, UPDATE ON sinasp.investigacao, sinasp.evidencia TO 'investigacao_user'@'%';
--GRANT SELECT ON sinasp.ocorrencia, sinasp.pessoa, sinasp.usuario TO 'investigacao_user'@'%';
--FLUSH PRIVILEGES;
--
---- USUÁRIO DE SUPORTE (apenas leitura para auditoria)
--CREATE USER 'auditoria_user'@'%' IDENTIFIED BY 'Auditoria2025!';
--GRANT SELECT ON sinasp.* TO 'auditoria_user'@'%';
--FLUSH PRIVILEGES;

-- A ordem de importação é crucial devido às dependências de chave estrangeira.

-- 1. Tabelas de localização
SOURCE schema/01_localizacao.sql;
-- 2. Tabelas relacionadas a pessoas
SOURCE schema/02_pessoa.sql;
-- 3. Tabelas de agências, unidades e profissionais
SOURCE schema/03_agencia.sql;
-- 4. Tabelas de recursos (veículos, equipamentos, armas)
SOURCE schema/04_recursos.sql;
-- 5. Tabelas de infrações e crimes
SOURCE schema/05_infracao_crime.sql;
-- 6. Tabelas de ocorrências e operações
SOURCE schema/06_ocorrencia.sql;
-- 7. Tabelas de investigação e evidências
SOURCE schema/07_investigacao.sql;
-- 8. Tabelas de processos judiciais
SOURCE schema/08_processo.sql;
-- 9. Tabelas de usuários do sistema
SOURCE schema/09_usuario.sql;
-- 10. Views do sistema
SOURCE schema/10_views.sql;
-- 11. Procedures do sistema
SOURCE schema/11_procedures.sql
-- 12. Triggers do sistema
SOURCE schema/12_triggers.sql
-- 13. Events do sistema
SOURCE schema/13_events.sql

-- Índices de performance. Eles podem acelerar consultas frequentes,
-- filtros por datas, status, nomes e atributos críticos sem
-- UNIQUE/PRIMARY KEY.
-- cidade
CREATE INDEX idx_cidade_nome ON cidade(nome);
-- bairro
CREATE INDEX idx_bairro_nome ON bairro(nome);
-- rua
CREATE INDEX idx_rua_nome ON rua(nome);
-- endereco
CREATE INDEX idx_endereco_latitude ON endereco(latitude);
CREATE INDEX idx_endereco_longitude ON endereco(longitude);
-- pessoa
CREATE INDEX idx_pessoa_nome ON pessoa(nome);
CREATE INDEX idx_pessoa_data_nascimento ON pessoa(data_nascimento);
-- condutor
CREATE INDEX idx_condutor_cnh_validade ON condutor(cnh_validade);
-- veiculo
CREATE INDEX idx_veiculo_renavam ON veiculo(renavam);
CREATE INDEX idx_veiculo_modelo ON veiculo(modelo);
CREATE INDEX idx_veiculo_cor ON veiculo(cor);
-- multa
CREATE INDEX idx_multa_data_emissao ON multa(data_emissao);
CREATE INDEX idx_multa_data_vencimento ON multa(data_vencimento);
CREATE INDEX idx_multa_valor ON multa(valor);
-- ocorrencia
CREATE INDEX idx_ocorrencia_data_hora ON ocorrencia(data_hora);
CREATE INDEX idx_ocorrencia_status ON ocorrencia(status);
-- investigacao
CREATE INDEX idx_investigacao_data_inicio ON investigacao(data_inicio);
CREATE INDEX idx_investigacao_data_encerramento ON investigacao(data_encerramento);
-- laudo
CREATE INDEX idx_laudo_data_emissao ON laudo(data_emissao);
-- inquerito_policial
CREATE INDEX idx_inquerito_data_abertura ON inquerito_policial(data_abertura);
CREATE INDEX idx_inquerito_data_encerramento ON inquerito_policial(data_encerramento);
-- evidencia
CREATE INDEX idx_evidencia_data_coletada ON evidencia(data_coletada);
-- incidente_cibernetico
CREATE INDEX idx_incidente_cibernetico_data_detectado ON incidente_cibernetico(data_detectado);
-- processo
CREATE INDEX idx_processo_data_inicio ON processo(data_inicio);
