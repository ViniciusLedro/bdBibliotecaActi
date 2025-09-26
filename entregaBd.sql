CREATE DATABASE sistema_biblioteca;
GO

USE sistema_biblioteca;
GO

DROP TABLE IF EXISTS Usuario
GO

DROP TABLE IF EXISTS Livro
GO

DROP TABLE IF EXISTS Emprestimo
GO

CREATE TABLE Usuario (
  idUsuario INT IDENTITY(1,1) PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
  );

CREATE TABLE Livro (
  idLivro INT IDENTITY(1,1) PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  anoPublicacao INT NOT NULL
  );

CREATE TABLE Emprestimo (
  idEmprestimo INT IDENTITY(1,1) PRIMARY KEY,
  idLivro INT NOT NULL,
  idUsuario INT NOT NULL,
  dataEmprestimo DATETIME NOT NULL,
  dataDevolucao DATETIME NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'EM_ABERTO',
  FOREIGN KEY (idLivro) REFERENCES Livro(idLivro),
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
  CHECK (status IN ('EM_ABERTO', 'DEVOLVIDO'))
  );

-- CRUD - Tabela Livro

-- INSERT Livro
CREATE OR ALTER PROCEDURE sp_livro_insert
    @titulo VARCHAR(100),
    @autor VARCHAR(100),
    @anoPublicacao INT
AS
BEGIN
    INSERT INTO Livro (titulo, autor, anoPublicacao)
    VALUES (@titulo, @autor, @anoPublicacao)
END
GO

-- SELECT Livro
CREATE OR ALTER PROCEDURE sp_livro_select
    @idLivro INT = NULL
AS
BEGIN
    IF @idLivro IS NULL
        SELECT * FROM Livro;
    ELSE
        SELECT * FROM Livro WHERE idLivro = @idLivro;
END
GO
  
-- UPDATE Livro
CREATE OR ALTER PROCEDURE sp_livro_update 
    @idLivro INT,
    @titulo VARCHAR(100),
    @autor VARCHAR(100),
    @anoPublicacao INT
AS
BEGIN
    UPDATE Livro
    SET titulo = @titulo,
        autor = @autor,
        anoPublicacao = @anoPublicacao
    WHERE idLivro = @idLivro;
END
GO

-- DELETE Livro
CREATE OR ALTER PROCEDURE sp_livro_delete
    @idLivro INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Emprestimo WHERE idLivro = @idLivro)
    BEGIN
        RAISERROR('Não é possível excluir este livro, pois ele possui emprestimos relacionados.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Livro WHERE idLivro = @idLivro;
    END
END
GO

-- CRUD - Tabela Usuario
  
-- INSERT Usuario
CREATE OR ALTER PROCEDURE sp_usuario_insert
    @nome VARCHAR(100),
    @email VARCHAR(100)
AS
BEGIN
    INSERT INTO Usuario (nome, email)
    VALUES (@nome, @email);
END
GO

-- SELECT Usuario
CREATE OR ALTER PROCEDURE sp_usuario_select
    @idUsuario INT = NULL
AS
BEGIN
    IF @idUsuario IS NULL
        SELECT * FROM Usuario;
    ELSE
        SELECT * FROM Usuario WHERE idUsuario = @idUsuario;
END
GO  

-- UPDATE Usuario
CREATE OR ALTER PROCEDURE sp_usuario_update
    @idUsuario INT,
    @nome VARCHAR(100),
    @email VARCHAR(100)
AS
BEGIN
    UPDATE Usuario
    SET nome = @nome,
        email = @email
    WHERE idUsuario = @idUsuario;
END
GO

-- DELETE Usuario
CREATE OR ALTER PROCEDURE sp_usuario_delete
    @idUsuario INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Emprestimo WHERE idUsuario = @idUsuario)
    BEGIN
        RAISERROR('Não é possível excluir este usuário, pois ele possui empréstimos relacionados.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Usuario WHERE idUsuario = @idUsuario;
    END
END
GO

-- CRUD - Tabela Emprestimo

-- INSERT Emprestimo
CREATE OR ALTER PROCEDURE sp_emprestimo_insert
    @idLivro INT,
    @idUsuario INT,
    @dataEmprestimo DATETIME = NULL,
    @dataDevolucao DATETIME = NULL,
    @status VARCHAR(20) = 'EM_ABERTO'
AS
BEGIN
    INSERT INTO Emprestimo (idLivro, idUsuario, dataEmprestimo, dataDevolucao, status)
    VALUES (@idLivro, @idUsuario, ISNULL(@dataEmprestimo, GETDATE()), @dataDevolucao, @status);
END
GO

  -- SELECT Emprestimo
CREATE OR ALTER PROCEDURE sp_emprestimo_select
    @idEmprestimo INT = NULL
AS
BEGIN
    SELECT e.idEmprestimo,
           l.titulo AS tituloLivro,
           u.nome AS nomeUsuario,
           e.dataEmprestimo,
           e.dataDevolucao,
           e.status
    FROM Emprestimo e
    INNER JOIN Livro l ON e.idLivro = l.idLivro
    INNER JOIN Usuario u ON e.idUsuario = u.idUsuario
    WHERE @idEmprestimo IS NULL OR e.idEmprestimo = @idEmprestimo;
END
GO

-- UPDATE Emprestimo
CREATE OR ALTER PROCEDURE sp_emprestimo_update
    @idEmprestimo INT,
    @idLivro INT,
    @idUsuario INT,
    @dataEmprestimo DATETIME,
    @dataDevolucao DATETIME = NULL,
    @status VARCHAR(20) = 'EM_ABERTO'
AS
BEGIN
    UPDATE Emprestimo
    SET idLivro = @idLivro,
        idUsuario = @idUsuario,
        dataEmprestimo = @dataEmprestimo,
        dataDevolucao = @dataDevolucao,
        status = @status
    WHERE idEmprestimo = @idEmprestimo;
END
GO

-- DELETE Emprestimo
CREATE OR ALTER PROCEDURE sp_emprestimo_delete
    @idEmprestimo INT
AS
BEGIN
    DELETE FROM Emprestimo
    WHERE idEmprestimo = @idEmprestimo;
END
GO






