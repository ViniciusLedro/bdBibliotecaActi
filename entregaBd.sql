CREATE DATABASE sistema_biblioteca;
GO

USE sistema_biblioteca;
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
    DELETE FROM Livro
    WHERE idLivro = @idLivro;
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
    DELETE FROM Usuario
    WHERE idUsuario = @idUsuario;
END
GO




