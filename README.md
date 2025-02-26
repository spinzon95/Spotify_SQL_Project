# Spotify_SQL_Project_2
# Spotify SQL Project 🎵

## Descripción  
Este proyecto implementa una **base de datos SQL** para gestionar y analizar información de **Spotify**, incluyendo canciones, artistas, álbumes y métricas de popularidad. Se desarrolló utilizando **MySQL** y se incluyen consultas optimizadas para obtener información relevante sobre la música almacenada.

## Estructura del Proyecto 📂  
El repositorio contiene los siguientes archivos:  
- **📄 `Spotify_Entrega_2.sql`** → Script SQL con la creación de la base de datos, tablas, vistas, funciones, stored procedures, triggers e inserción de datos.  
- **📄 `Spotify_Entrega_2.pdf`** → Documento con la documentación del proyecto, explicando su estructura y funcionalidades.  

## Vistas Implementadas 👀  
Se crearon vistas SQL para facilitar consultas de datos:  
- `v_canciones_mas_populares_por_artista` → Lista las canciones más populares por artista.  
- `v_duracion_promedio_albumes` → Calcula la duración promedio de las canciones por álbum.  
- `v_artistas_canciones_mas_populares` → Muestra los artistas con sus canciones más reproducidas.  
- `v_canciones_por_genero` → Cuenta cuántas canciones hay en cada género musical.  
- `v_albumes_mas_canciones` → Muestra los álbumes con más canciones registradas.  

## Funciones y Procedimientos Almacenados 🔍  
- **Funciones**:  
  - `calcular_duracion_promedio_album(id_album_param)`: Devuelve la duración promedio de un álbum.  
  - `calcular_popularidad_media_artista(id_artista_param)`: Calcula la popularidad media de un artista.  
- **Stored Procedures**:  
  - `insertar_artista(nombre, genero)`: Agrega un artista.  
  - `insertar_cancion(titulo, id_album, duracion_ms)`: Agrega una canción.  

## Triggers ⚡  
Se implementaron **triggers** para mantener la integridad de los datos:  
- `before_delete_cancion` → Borra registros de popularidad y características cuando se elimina una canción.  
- `after_insert_cancion` → Al insertar una canción, se le asigna automáticamente **popularidad en 0** y **reproducciones en 0**.  

## Cómo usar este proyecto 🛠️  
1. Clonar el repositorio:  
   ```bash
   git clone https://github.com/TU_USUARIO/Spotify_SQL_Project.git
