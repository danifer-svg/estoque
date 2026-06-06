CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    quantidade_estoque INT NOT NULL,
    disponibilidade VARCHAR(20)
);

CREATE TABLE funcionarios (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome_funcionario VARCHAR(100) NOT NULL
);

CREATE TABLE retiradas (
    id_retirada INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL,
    id_funcionario INT NOT NULL,
    quantidade_retirada INT NOT NULL,
    data_retirada DATETIME NOT NULL,

    FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto),

    FOREIGN KEY (id_funcionario)
        REFERENCES funcionarios(id_funcionario)
);

-- exemplos:

INSERT INTO produtos
(nome_produto, categoria, quantidade_estoque, disponibilidade)
VALUES
('Detergente', 'Limpeza', 100, 'Disponível'),
('Água Sanitária', 'Limpeza', 50, 'Disponível');

INSERT INTO funcionarios
(nome_funcionario)
VALUES
('João Silva'),
('Maria Souza');

INSERT INTO retiradas
(id_produto, id_funcionario, quantidade_retirada, data_retirada)
VALUES
(1, 1, 5, NOW());

--consultando historico

SELECT
    r.id_retirada,
    p.nome_produto,
    f.nome_funcionario,
    r.quantidade_retirada,
    r.data_retirada
FROM retiradas r
INNER JOIN produtos p
    ON r.id_produto = p.id_produto
INNER JOIN funcionarios f
    ON r.id_funcionario = f.id_funcionario
ORDER BY r.data_retirada DESC;

UPDATE produtos
SET quantidade_estoque = quantidade_estoque - 5
WHERE id_produto = 1;

CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON retiradas
FOR EACH ROW
UPDATE produtos
SET quantidade_estoque = quantidade_estoque - NEW.quantidade_retirada
WHERE id_produto = NEW.id_produto;
