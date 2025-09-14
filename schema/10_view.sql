CREATE VIEW vw_pessoa_detalhes AS
SELECT p.id AS pessoa_id,
  p.nome AS nome_pessoa,
  ps.nome AS sexo,
  p.data_nascimento,
  c.cpf,
  c.rg,
  co.cnh,
  co.cnh_validade,
  CONCAT(
    e.complemento,
    ', ',
    e.numero,
    ' - ',
    r.nome,
    ', ',
    b.nome,
    ', ',
    ci.nome,
    ' - ',
    u.sigla
  ) AS endereco_completo
FROM pessoa p
  LEFT JOIN pessoa_sexo ps ON p.sexo_id = ps.id
  LEFT JOIN cidadao c ON p.id = c.pessoa_id
  LEFT JOIN condutor co ON p.id = co.pessoa_id
  LEFT JOIN pessoa_endereco pe ON p.id = pe.pessoa_id
  AND pe.principal = TRUE
  LEFT JOIN endereco e ON pe.endereco_id = e.id
  LEFT JOIN rua r ON e.rua_id = r.id
  LEFT JOIN bairro b ON r.bairro_id = b.id
  LEFT JOIN cidade ci ON b.cidade_id = ci.id
  LEFT JOIN uf u ON ci.uf_id = u.id;
CREATE VIEW vw_profissional_detalhes AS
SELECT p.id AS pessoa_id,
  p.nome AS nome_profissional,
  prof.nome AS profissao,
  prof.patente,
  u.nome AS nome_unidade,
  a.nome AS nome_agencia,
  a.sigla AS sigla_agencia,
  pp.data_inicio,
  pp.data_fim
FROM pessoa_profissao pp
  JOIN pessoa p ON pp.pessoa_id = p.id
  JOIN profissao prof ON pp.profissao_id = prof.id
  JOIN unidade u ON prof.unidade_id = u.id
  JOIN agencia a ON u.agencia_id = a.id;
CREATE VIEW vw_ocorrencia_detalhes AS
SELECT o.id AS ocorrencia_id,
  ot.nome AS tipo_ocorrencia,
  o.data_hora,
  o.status,
  o.descricao,
  CONCAT(
    e.complemento,
    ', ',
    e.numero,
    ' - ',
    r.nome,
    ', ',
    b.nome,
    ', ',
    c.nome,
    ' - ',
    uf.sigla
  ) AS localizacao,
  u.nome AS unidade_responsavel
FROM ocorrencia o
  JOIN ocorrencia_tipo ot ON o.tipo_id = ot.id
  LEFT JOIN endereco e ON o.endereco_id = e.id
  LEFT JOIN rua r ON e.rua_id = r.id
  LEFT JOIN bairro b ON r.bairro_id = b.id
  LEFT JOIN cidade c ON b.cidade_id = c.id
  LEFT JOIN uf ON c.uf_id = uf.id
  LEFT JOIN unidade u ON o.unidade_id = u.id;
CREATE VIEW vw_usuario_detalhes AS
SELECT u.id AS usuario_id,
  u.login,
  u.nome_completo,
  u.email,
  p.nome AS nome_pessoa,
  una.nivel AS nivel_acesso
FROM sinasp_usuario u
  LEFT JOIN pessoa_profissao pp ON u.profissional_id = pp.id
  LEFT JOIN pessoa p ON pp.pessoa_id = p.id
  LEFT JOIN sinasp_usuario_nivel_acesso una ON u.id = una.usuario_id;
