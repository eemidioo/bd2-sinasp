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
