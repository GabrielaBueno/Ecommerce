-- Mateus Yi Muraoka  
-- Gabriela dos Reis Bueno  
-- Gabriel Zuin Jarduli 
-- O ecommerce é uma plataforma na qual seus clientes podem realizar pedidos através de um smartphone ou tablet. 
-- Diferente de um site comum, essa plataforma possui diversos recursos que tornam a experiência de compra mais confortável e 
-- segura para o usuário. Por exemplo, é possível adicionar produtos a um carrinho de compras virtual.

/*Exclui o role existente e user existente foi colocado devido a erro no programa*/
DROP ROLE IF EXISTS GERENCIA;
DROP USER IF EXISTS gerente@localhost;

/*Exclui o banco existente se existir*/
DROP DATABASE IF EXISTS ecommerce;

/*Criação do banco do dados ecommerce*/
CREATE DATABASE IF NOT EXISTS `ecommerce`;

/*Escolhendo o banco de dado ecommerce*/
USE `ecommerce`;

/*Criação de tabelas*/
/*Criação da tabela de cadastro do cliente*/
CREATE TABLE IF NOT EXISTS `cadastro`(
	`cpf_cliente` DECIMAL(11,0) NOT NULL,
    `nome_cliente` VARCHAR(45) NOT NULL,
    `endereco` VARCHAR(45) NOT NULL,
    `telefone` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`cpf_cliente`)
);

/*criação da tabela de cadastro do produto*/
CREATE TABLE IF NOT EXISTS `produto`(
	`cod_produto` INT NOT NULL,
    `nome_produto` VARCHAR(30) NOT NULL,
    `descricao` VARCHAR(45) NULL,
    `quantidade` INT NOT NULL,
    `preco` DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (`cod_produto`)
);

/*criação da tabela de cadastro do carrinho*/
CREATE TABLE IF NOT EXISTS `carrinho`(
	`cod_carrinho` DOUBLE NOT NULL,
    `cod_produto` INT NOT NULL,
    `cpf_cliente` DECIMAL(11,0) NOT NULL,
    PRIMARY KEY (`cod_carrinho`),
    CONSTRAINT `fk_carrinho_produto`
    FOREIGN KEY(`cod_produto`) 
    REFERENCES `produto` (`cod_produto`),
	CONSTRAINT `fk_carrinho_cadastro`
    FOREIGN KEY(`cpf_cliente`) 
    REFERENCES `cadastro`(`cpf_cliente`)
);

/*Inserção de dados na  tabela cadastro*/
INSERT INTO cadastro (cpf_cliente, nome_cliente, endereco, telefone) 
	VALUES(34783584346, 'Caio Augusto Silva', 'Rua Jose Algusta,2021', 5543175951769),
		(43426153475, 'Angela Maria da Silva', 'Rua Joao Paulo,1021', 5543632438979),
        (15112357983, 'Carlo Edson Ferreira', 'Rua das Palmeiras,421', 5543710632732),
        (41338418246, 'Francisco Oliveira', 'Rua Lagoa Azul,111', 5543061205102),
        (34710519536, 'Maicon Jackson dos Santos','Rua Cactos do Deserto,405', 5543902065248);
        
/*Inserção de dados na  tabela produto*/
INSERT INTO produto (cod_produto, nome_produto, descricao, quantidade, preco) 
	VALUES(0001, 'Placa Mae', 'Asus', 1, 1500.00),
		(0002, 'Memoria Ram', 'Corsair 16 GB', 1, 400.00),
        (0003, 'Placa de Video', 'Super Rtx 2070', 1, 2500.00),
        (0004, 'Processador', 'i9-10850K ', 1, 3000.00),
        (0005, 'Gabinete','Hyper Ex', 1, 900.00);

/*Inserção de dados na  tabela carrinho*/
INSERT INTO carrinho (cod_carrinho, cod_produto, cpf_cliente)
	VALUES(0101, 0005, 34710519536),
		(0202, 0003, 34710519536),
		(0303, 0001, 41338418246),
		(0404, 0004, 15112357983),
		(0505, 0002,43426153475);
 
 /*Criacao de Indice*/
 CREATE INDEX Idx_cadastro ON cadastro(nome_cliente);
 CREATE INDEX Idx_produto ON produto(nome_produto);
 CREATE INDEX Idx_carrinho ON carrinho(cpf_cliente);
 
 /*Consulta com operação JOIN */
SELECT * 
FROM cadastro INNER JOIN produto INNER JOIN carrinho  
WHERE cadastro.cpf_cliente = carrinho.cpf_cliente AND  produto.cod_produto = carrinho.cod_produto;

/*Transacao exclusão de cliente e adicao de novo cliente*/
START TRANSACTION;
		SELECT * 
        FROM carrinho;
	DELETE FROM carrinho WHERE carrinho.cod_carrinho = 0404;
    
		START TRANSACTION;
				SELECT * 
                FROM cadastro;
                INSERT INTO cadastro VALUES(76891529246, 'Machado de Assis', 'Sao Paulo,1129', 5543967295312);
		COMMIT;
COMMIT;

/*Verificar a execucao da transacao*/
SELECT *
FROM carrinho;

SELECT *
FROM cadastro;

/*Criacao de papel e atribuicao de privilegio total*/
CREATE ROLE GERENCIA;
GRANT ALL ON ecommerce.* TO GERENCIA; 

/*Criacao de usuario e atribuicao de privilegio utilizando o role*/
CREATE USER gerente@localhost IDENTIFIED BY '12345678';
GRANT GERENCIA TO gerente@localhost;

/*Criacao de View*/
CREATE OR REPLACE VIEW cliente_cadastrados AS
	SELECT *
	FROM cadastro NATURAL JOIN carrinho NATURAL JOIN produto
    WHERE cadastro.cpf_cliente = carrinho.cpf_cliente AND  produto.cod_produto = carrinho.cod_produto;
    
/*Consultar tabela atraves do uso de uma visao*/
SELECT *
FROM cliente_cadastrados;


