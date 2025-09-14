DROP DATABASE IF EXISTS sinasp;
CREATE DATABASE sinasp;
USE sinasp;
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
