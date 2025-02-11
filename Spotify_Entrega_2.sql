-- =========================================
-- CREACIÓN DE LA BASE DE DATOS
-- =========================================

DROP DATABASE IF EXISTS SpotifyDB;
CREATE DATABASE SpotifyDB;
USE SpotifyDB;

-- =========================================
-- CREACIÓN DE TABLAS
-- =========================================

CREATE TABLE Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(50)
);

CREATE TABLE Albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio INT,
    id_artista INT,
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista) ON DELETE CASCADE
);

CREATE TABLE Canciones (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    id_album INT,
    duracion_ms INT,
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE
);

CREATE TABLE Caracteristicas (
    id_cancion INT PRIMARY KEY,
    energia DECIMAL(3,2),
    bailabilidad DECIMAL(3,2),
    instrumentalidad DECIMAL(3,2),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

CREATE TABLE Popularidad (
    id_cancion INT PRIMARY KEY,
    popularidad INT CHECK (popularidad BETWEEN 0 AND 100),
    reproducciones BIGINT,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- =========================================
-- CREACIÓN DE VISTAS
-- =========================================

CREATE VIEW v_canciones_mas_populares_por_artista AS
SELECT a.nombre AS artista, c.titulo AS cancion, p.popularidad
FROM Canciones c
JOIN Albumes al ON c.id_album = al.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
JOIN Popularidad p ON c.id_cancion = p.id_cancion
ORDER BY a.nombre, p.popularidad DESC;

CREATE VIEW v_duracion_promedio_albumes AS
SELECT al.titulo AS album, a.nombre AS artista, AVG(c.duracion_ms) AS duracion_promedio_ms
FROM Canciones c
JOIN Albumes al ON c.id_album = al.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
GROUP BY al.id_album, al.titulo, a.nombre;

CREATE VIEW v_artistas_canciones_mas_populares AS
SELECT a.nombre AS artista, c.titulo AS cancion, p.reproducciones
FROM Canciones c
JOIN Albumes al ON c.id_album = al.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
JOIN Popularidad p ON c.id_cancion = p.id_cancion
ORDER BY p.reproducciones DESC;

CREATE VIEW v_canciones_por_genero AS
SELECT a.genero, COUNT(c.id_cancion) AS total_canciones
FROM Canciones c
JOIN Albumes al ON c.id_album = al.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
GROUP BY a.genero
ORDER BY total_canciones DESC;

CREATE VIEW v_albumes_mas_canciones AS
SELECT al.titulo AS album, a.nombre AS artista, COUNT(c.id_cancion) AS total_canciones
FROM Canciones c
JOIN Albumes al ON c.id_album = al.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
GROUP BY al.id_album, al.titulo, a.nombre
ORDER BY total_canciones DESC;

-- =========================================
-- CREACIÓN DE FUNCIONES
-- =========================================

DELIMITER //
CREATE FUNCTION calcular_duracion_promedio_album(id_album_param INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE duracion_promedio DECIMAL(10,2);
    SELECT AVG(duracion_ms) INTO duracion_promedio
    FROM Canciones
    WHERE id_album = id_album_param;
    RETURN duracion_promedio;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION calcular_popularidad_media_artista(id_artista_param INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE popularidad_media DECIMAL(10,2);
    SELECT AVG(p.popularidad) INTO popularidad_media
    FROM Popularidad p
    JOIN Canciones c ON p.id_cancion = c.id_cancion
    JOIN Albumes a ON c.id_album = a.id_album
    WHERE a.id_artista = id_artista_param;
    RETURN popularidad_media;
END;
//
DELIMITER ;

-- =========================================
-- CREACIÓN DE STORED PROCEDURES
-- =========================================

DELIMITER //
CREATE PROCEDURE insertar_artista(IN nombre_artista VARCHAR(100), IN genero_artista VARCHAR(50))
BEGIN
    INSERT INTO Artistas (nombre, genero) VALUES (nombre_artista, genero_artista);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insertar_cancion(IN titulo_cancion VARCHAR(200), IN id_album_param INT, IN duracion_ms_param INT)
BEGIN
    INSERT INTO Canciones (titulo, id_album, duracion_ms) VALUES (titulo_cancion, id_album_param, duracion_ms_param);
END;
//
DELIMITER ;

-- =========================================
-- CREACIÓN DE TRIGGERS
-- =========================================

DELIMITER //
CREATE TRIGGER before_delete_cancion
BEFORE DELETE ON Canciones
FOR EACH ROW
BEGIN
    DELETE FROM Popularidad WHERE id_cancion = OLD.id_cancion;
    DELETE FROM Caracteristicas WHERE id_cancion = OLD.id_cancion;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_insert_cancion
AFTER INSERT ON Canciones
FOR EACH ROW
BEGIN
    INSERT INTO Popularidad (id_cancion, popularidad, reproducciones) VALUES (NEW.id_cancion, 0, 0);
END;
//
DELIMITER ;

-- =========================================
-- INSERCIÓN DE DATOS
-- =========================================

INSERT INTO Artistas (nombre, genero) VALUES 
('The Beatles', 'Rock'),
('Coldplay', 'Pop Rock'),
('Taylor Swift', 'Pop'),
('Daft Punk', 'Electrónica'),
('Adele', 'Soul');

INSERT INTO Albumes (titulo, anio, id_artista) VALUES
('Abbey Road', 1969, 1),
('Parachutes', 2000, 2),
('1989', 2014, 3),
('Discovery', 2001, 4),
('25', 2015, 5);

INSERT INTO Canciones (titulo, id_album, duracion_ms) VALUES
('Come Together', 1, 259000),
('Yellow', 2, 266000),
('Shake It Off', 3, 219000),
('One More Time', 4, 320000),
('Hello', 5, 295000);
