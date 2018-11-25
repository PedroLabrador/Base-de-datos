/* Grupo 1 */
select ap.nombre, sum(ap.costo) from aplicacion ap
join descarga de
on de.ver_apl_id = ap.id
group by ap.nombre
having sum(ap.costo) > (select sum(ap.costo) from aplicacion ap
join descarga de
on de.ver_apl_id = ap.id) * 0.10;

select nombre 
from usuario
minus select u.nombre 
from descarga de 
join otro o on de.otro_id = o.id 
join usuario u on de.uso_id = u.id
where tipo = 'Pelicula';

select pa.nombre "Pais", count(distinct u.nombre) "Cantidad usuarios", count(de.ver_apl_id) "Cantidad aplicaciones" from usuario u
join descarga de
on de.uso_id = u.id
join pais pa
on pa.id = u.pais_id
group by pa.nombre;

/*select * from
(select nombre, rownum test
from (select ap.nombre, de.valor  
      from aplicacion ap
      join descarga de on ap.id = de.ver_apl_id
      group by nombre, de.valor
      order by de.valor desc)
where rownum < 20)
where test > 5;
*/
select *
from (select ap.nombre
      from aplicacion ap
      join descarga de on ap.id = de.ver_apl_id
      group by nombre, de.valor
      order by de.valor desc)
where rownum <= 5;

select u.nombre, COUNT(ap.nombre) from descarga de
join usuario u ON u.id = de.uso_id
join aplicacion ap on ap.id = de.ver_apl_id
where lower(u.nombre) like lower('%&nombre%') and ap.costo = 0
group by u.nombre;

select Mes, sum(Aplicaciones) Aplicaciones, sum(Otros) Otros 
from (select to_char(de.fecha, 'Month') Mes, to_char(de.fecha, 'yyyy') Anio, sum(ap.costo) Aplicaciones, 0 Otros, de.fecha Fecha 
      from descarga de
      join aplicacion ap on de.ver_apl_id = ap.id
      group by to_char(de.fecha, 'Month'), to_char(de.fecha, 'yyyy'), de.fecha 
    union
      select to_char(de.fecha, 'Month') Mes, to_char(de.fecha, 'yyyy') Anio, 0 Aplicaciones, sum(o.costo) Otros, de.fecha Fecha
      from descarga de
      join otro o on de.otro_id = o.id
      group by to_char(de.fecha, 'Month'), to_char(de.fecha, 'yyyy'), de.fecha) 
where Anio = '&Ingrese_año'
group by Mes;

/* Grupo2 */
select o.nombre, sum(o.costo) from otro o
join descarga de
on de.otro_id = o.id
where o.tipo = 'Libro'
group by o.nombre
having sum(o.costo) > (select sum(o.costo) from otro o
join descarga de
on de.otro_id = o.id) * 0.10;

  select nombre 
  from usuario
minus 
  select u.nombre 
  from descarga de 
  join otro o on de.otro_id = o.id 
  join usuario u on de.uso_id = u.id
  where tipo = 'Pelicula' or tipo = 'Musica';
  
select Nombre, sum(uno) "Cantidad Libros", sum(dos) "Cantidad Albums", sum(tres) "Cantidad Peliculas"
from (select u.nombre Nombre, count(o.tipo) uno, 0 dos, 0 tres from usuario u
      join descarga de
      on de.uso_id = u.id
      join otro o
      on o.id = de.otro_id
      where o.tipo = 'Libro'
      group by u.nombre
    union
      select u.nombre Nombre, 0 uno, count(o.tipo) dos, 0 tres from usuario u
      join descarga de
      on de.uso_id = u.id
      join otro o
      on o.id = de.otro_id
      where o.tipo = 'Musica'
      group by u.nombre
    union
      select u.nombre Nombre, 0 uno, 0 dos, count(o.tipo) tres from usuario u
      join descarga de
      on de.uso_id = u.id
      join otro o
      on o.id = de.otro_id
      where o.tipo = 'Pelicula'
      group by u.nombre)
group by Nombre;
  
select Nombre
from (select ap.nombre, sum(ap.costo)
      from aplicacion ap
      join descarga de on ap.id = de.ver_apl_id
      group by nombre
      order by sum(ap.costo) desc)
where rownum <= 5;

select u.nombre, COUNT(ap.nombre) from descarga de
join usuario u ON u.id = de.uso_id
join aplicacion ap on ap.id = de.ver_apl_id
where lower(u.nombre) like lower('%&nombre%') and ap.costo > 0
group by u.nombre;

select to_char(fecha, 'Month') Mes, count(*) Descargas
from descarga
where to_char(fecha, 'yyyy') = '&Ingrese_año'
group by to_char(fecha, 'Month');

/* Grupo 3 */





