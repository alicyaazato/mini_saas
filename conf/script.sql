CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(150) UNIQUE,
    especialidade_id INT REFERENCES especialidades(id) ON DELETE SET NULL
);

CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F', 'O')),
    telefone VARCHAR(20) NOT NULL,
    convenio VARCHAR(100) DEFAULT 'Particular',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE consultas (
    id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL REFERENCES pacientes(id) ON DELETE CASCADE,
    medico_id INT NOT NULL REFERENCES medicos(id) ON DELETE RESTRICT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'Agendada' CHECK (status IN ('Agendada', 'Realizada', 'Cancelada', 'Ausente')),
    motivo VARCHAR(255)
);

CREATE TABLE prontuarios (
    id SERIAL PRIMARY KEY,
    consulta_id INT NOT NULL UNIQUE REFERENCES consultas(id) ON DELETE CASCADE,
    sintomas TEXT,
    diagnostico TEXT NOT NULL,
    observacoes TEXT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prescricoes (
    id SERIAL PRIMARY KEY,
    prontuario_id INT NOT NULL REFERENCES prontuarios(id) ON DELETE CASCADE,
    medicamento_ou_exame VARCHAR(255) NOT NULL,
    posologia_ou_instrucao TEXT NOT NULL
);

CREATE INDEX idx_consultas_data ON consultas(data_hora);
CREATE INDEX idx_consultas_medico ON consultas(medico_id);
CREATE INDEX idx_consultas_paciente ON consultas(paciente_id);

INSERT INTO especialidades (nome) VALUES ('Cardiologia'), ('Pediatria');

INSERT INTO medicos (nome, crm, especialidade_id) VALUES 
('Dra. Ana Costa', 'CRM/SP 123456', 1);

INSERT INTO pacientes (nome, cpf, data_nascimento, telefone) VALUES 
('Carlos Eduardo', '123.456.789-00', '1985-06-15', '(11) 98765-4321');

INSERT INTO consultas (paciente_id, medico_id, data_hora, motivo) VALUES 
(1, 1, '2026-10-05 14:00:00', 'Check-up anual / Dor no peito');

SELECT 
    c.id AS consulta_id,
    c.data_hora,
    p.nome AS paciente,
    p.telefone,
    p.convenio,
    c.status
FROM consultas c
JOIN pacientes p ON c.paciente_id = p.id
WHERE c.medico_id = 1 AND c.status = 'Agendada'
ORDER BY c.data_hora ASC;