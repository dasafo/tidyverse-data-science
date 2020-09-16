library(tidyverse)
# Análisis exploratorio de datos
# * Modelar
# * Representación gráfica
# * Transformar datos

# * ¿Qué tipo de variaciones sufren las variables?
# * ¿Qué tipo de covariación sufren las variables?

# * variable: cantidad, factor o propiedad medible
# * valor: estado de una variable al ser medida
# * observación: conjunto de medidas tomadas en condiciones similares
#                data point, conjunto de valores tomados para cada variable
# * datos tabulares: conjunto de valores, asociado a cada variable y observación
#                si los datos están limpios, cada valor tiene su propia celda
#                cada variable tiene su columna, y cada observación su fila


#### VARIACIÓN
## Variables categóricas: factor o vector de caracteres
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x=cut))

?diamonds

diamonds %>%
  count(cut)

## Variable contínua: conjunto infinito de valores ordenados (números, fechas)
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>%
  count(cut_width(carat, 0.5))


ggplot(diamonds, mapping = aes(x = "Kilates", y = carat)) + 
  geom_boxplot()

diamonds %>%
  ggplot() + 
  geom_boxplot(mapping = aes(x = cut, y = carat, color = cut))

diamonds_filter <- diamonds %>%
  filter(carat<3)

ggplot(data = diamonds_filter) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)

ggplot(data = diamonds_filter, 
       mapping = aes(x = carat, color = cut))+
  geom_freqpoly(binwidth = 0.01)

# * Cuales son los valores más comunes? Por qué?
# * Cuales son los valores más raros? Por qué? Cumple con lo que esperábamos?
# * Vemos algún patrón característico o inusual? Podemos explicarlos?

# * Qué determina que los elementos de un cluster sean similares entre si?
# * Qué determina que clusters separados sean diferentes entre si?
# * Describir y explicar cada uno de los clusters.
# * Por qué alguna observación puede ser clasificada en el cluster erróneo...

View(faithful)
?faithful

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.2)

# outliers
  ggplot(diamonds) + 
    geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

diamonds %>%
  ggplot(mapping=aes(x = price)) + 
  geom_histogram(binwidth = 100)

diamonds %>%
  filter(price > 18000) %>%
  ggplot(mapping = aes(x = y))+
  geom_histogram()


unusual_diamonds <- diamonds %>%
  filter(y<2 | y >30) %>%
  select(price, x,y,z) %>%
  arrange(y)
View(unusual_diamonds)

#Eliminar toda la fila de valores atípicos
good_diamonds <- diamonds %>%
  filter(between(y, 2.5, 29.5))

#Reemplazar los valores atípicos con NAs
good_diamonds <- diamonds %>%
  mutate(y = ifelse(y<2 | y>30, NA, y))

?ifelse  

ggplot(data = good_diamonds, 
       mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = T)

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min/60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)


#Ejercicio 1
#Explora la distribución de las variables x, y, z del dataset 
#de diamonds. ¿Qué podemos inferir?
#Busca un diamante (por internet por ejemplo) y decide qué 
#dimensiones pueden ser aceptables para las medidas de longitud, 
#altura y anchura de un diamante.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = x), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = z), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

# Ejercicio 2
#Explora la distribución del precio (price) del dataset de diamonds. 
#¿Hay algo que te llame la atención o resulte un poco extraño?
#Recuerda hacer uso del parámetro binwidth para probar un rango 
#dispar de valores hasta ver algo que te llame la atención.

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = price), binwidth = 10) +
  coord_cartesian(xlim = c(1400,1600))

# Ejercicio 3
#¿Cuantos diamantes hay de 0.99 kilates? ¿Y de exactamente 1 kilate?
#¿A qué puede ser debida esta diferencia?

  ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)+
  coord_cartesian(xlim = c(0.95,1.05))

diamonds %>% 
  filter(between(carat, 0.95, 1.05)) %>%
  count(cut_width(carat, 0.01))

# Ejercicio 4
#Compara y contrasta el uso de las funciones coord_cartesian() 
#frente xlim() y ylim() para hacer zoom en un histograma.
#¿Qué ocurre si dejamos el parámetro binwidth sin configurar?
#¿Qué ocurre si hacemos zoom y solamente se ve media barra?

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)+
  coord_cartesian(xlim = c(0.95,1.05))

# Ejercicio 5
#¿Qué ocurre cuando hay NAs en un histograma? 
#¿Qué ocurre cuando hay NAs en un diagrama de barras?
#¿Qué diferencias observas?

na_diamonds <-good_diamonds %>%
  mutate(cut2 = ifelse(cut == "Fair", NA, cut))

ggplot(na_diamonds) + 
  geom_bar(mapping = aes(x = cut2))

ggplot(good_diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 1)


#### COVARIACIÓN

# Categoría vs Contínua

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(color = cut), binwidth = 50)

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 100)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median),
                             y = hwy))


ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median),
                             y = hwy)) + 
  coord_flip()


# Categoría vs Categoría
ggplot(data = diamonds) + 
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>%
  count(color, cut)

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) + 
    geom_tile(mapping = aes(fill = n))

#d3heatmap
#heatmaply

# Contínua vs Contínua

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), 
             alpha = 0.01)

install.packages("hexbin")
library(hexbin)

ggplot(data = diamonds) + 
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) + 
  geom_hex(mapping = aes(x = carat, y = price))

diamonds %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) + 
    geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = T)

diamonds %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) + 
    geom_boxplot(mapping = aes(group = cut_number(carat, 10)))

faithful %>%
  filter(eruptions > 3) %>%
  ggplot(aes(eruptions)) + 
    geom_freqpoly(binwidth = 0.2)

diamonds %>%
  count(cut, clarity) %>%
  ggplot(aes(clarity, cut, fill = n)) +
    geom_tile()

# Relaciones y los patrones
# * ¿Coincidencias?
# * ¿Relaciones que implica el patrón?
# * ¿Fuerza de la relación?
# * ¿Otras variables afectadas?
# * ¿Subgrupos?

ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))

library(modelr)
mod <- lm(log(price) ~log (carat), data = diamonds)
mod

diamonds_pred <- diamonds %>%
  add_residuals(mod) %>%
  mutate(res = exp(resid))

View(diamonds_pred)

ggplot(data = diamonds_pred) + 
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds_pred) +
  geom_boxplot(mapping = aes(x = cut, y = resid))


#Ejercicio 1
#Es hora de aplicar todo lo que hemos aprendido para visualizar mejor 
#los tiempos de salida para vuelos cancelados vs los no cancelados. 
#Recuerda bien qué tipo de dato tenemos en cada caso. ¿Qué deduces acerca 
#de los retrasos según la hora del día a la que está programada el vuelo 
#de salida?

nycflights13::flights %>%
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min/60
  ) %>%
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(y = ..density.., color = cancelled), binwidth = 1/4)


#Ejercicio 3
#Instala el paquete de ggstance y úsalo para crear un boxplot horizontal. 
#Compara el resultado con usar el coord_flip() que hemos visto en clase.

install.packages("ggstance")
library(ggstance)

ggplot(data = mpg,mapping = aes(x = hwy,
                                y = reorder(class, hwy, FUN = median),
                                fill = factor(class)
                                )
       ) + 
  geom_boxploth() 


#Ejercicio 4
#Los boxplots nacen en una época donde los datasets eran mucho más 
#pequeños y la palabra big data no era más que un concepto futurista. 
#De ahí que los datos considerados con outliers tuvieran sentido que 
#fueran representados con puntos dado que su existencia era más bien 
#escasa o nula. Para solucionar este problema, existe el letter value 
#plot del paquete lvplot. Instala dicho paquete y usa la geometría 
#geom_lv() para mostrar la distribución de precio vs cut de 
#los diamantes. ¿Qué observas y qué puedes interpretar a raíz de 
#dicho gráfico?
  
install.packages("lvplot")
library(lvplot)

ggplot(data = diamonds,
       mapping = aes(x = cut, y = price)
) + geom_lv() 

ggplot(data = diamonds,
       mapping = aes(x = cut, y = price)
) + geom_boxplot() 


#Ejercicio 5
#Compara el uso de la geometría geom_violin() con un facet 
#de geom_histogram() y contra un geom_freqpoly() coloreado. 
#Investiga cuales son los pros y los contras de cada uno de 
#los tipos de representación.

ggplot(diamonds, mapping = aes(x = cut, y = price)) + 
  geom_violin()

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = price), binwidth = 100)+ 
  facet_wrap(~cut, nrow = 3)

ggplot(diamonds) + 
  geom_freqpoly(mapping = aes(x = price, color = cut), binwidth = 100)


#Ejercicio 6
#Si tenemos datasets pequeños, a veces es útil usar la opción que ya 
#conocemos de geom_jitter() para ver la relación entre una variable 
#contínua y una variable categórica. El paquete de R ggbeeswarm tiene 
#un par de métodos similares a geom_jitter() que te pueden ayudar a 
#tal efecto. Listalos y haz un gráfico con cada uno de ellos para ver 
#qué descripción de los datos podemos extraer de cada uno. ¿A qué 
#gráfico de los que ya has visto durante esta práctica se parece?
  
install.packages("ggbeeswarm")
library(ggbeeswarm)

ggplot(diamonds,aes(cut, price)) + 
  geom_quasirandom()

#Ejercicio 7 
#Los mapas de calor que hemos visto tienen un claro problema de elección 
#de los colores. 
#¿Cómo podríamos reescalar el campo count dataset de diamantes cuando 
#cruzamos color y cut para observar mejor la distribución de dicho cruce?
#¿Por qué resulta mejor usar la estética aes(x = color, y = cut) en lugar 
#de aes(x=cut, y = color)?
  
diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) + 
  geom_tile(mapping = aes(fill = log(n)))

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = color, y = cut)) + 
  geom_tile(mapping = aes(fill = log(n)))

#Ejercicio 8
#Utiliza la geom_tile() junto con dplyr para explorar si el promedio 
#del retraso de los vuelos varía con respecto al destino y mes del año. 
#¿Qué hace que este gráfico sea dificil de leer o de interpretar?
#¿Cómo puedes mejorar la visualización?

  nycflights13::flights %>%
  count(month, dest) %>%
  ggplot(mapping = aes(x = dest, y = month)) + 
  geom_tile(mapping = aes(fill = n))

#Ejercicio 9
#En lugar de hacer un resumen de la distribución condicional de dos 
#variables numéricas con un boxplot, se puede usar un polígono de frecuencias. 
#¿Qué hay que tener en cuenta cuando usas cut_width() o cuando usas cut_number()?
#¿Cómo influye este hecho en la visualización 2D de carat y price
#Da la mejor visualización posible de carat dividido por price.

ggplot(diamonds, aes(price, colour = cut_width(carat, 1.0))) +
  geom_freqpoly()

ggplot(diamonds, aes(price, colour = cut_number(carat, 5))) +
  geom_freqpoly()

ggplot(diamonds, aes(carat, colour = cut_width(price, 5000))) +
  geom_freqpoly()

#Ejercicio 10
#Compara la distribución del precio de los diamantes grandes vs diamantes 
#pequeños. Elige el concepto de grande y pequeño que consideres. 
#Comenta el resultado.

diamonds %>%
  filter(between(x,2,20)) %>%
  filter(between(y,2,20)) %>%
  filter(between(z,2,20)) %>%
  ggplot(aes(price, x*y*z)) + 
   geom_bin2d()

#Ejercicio 11
#Combina diferentes técnicas de ggplot para visulaizar la distribución 
#combinada de cut, carat y precio.

diamonds %>%
  ggplot(aes(price, colour = cut)) + 
  geom_freqpoly() + 
  facet_wrap(~cut_number(carat, 5), nrow = 2)

diamonds %>%
  ggplot(aes(price)) + 
  geom_freqpoly() + 
  facet_wrap(cut~cut_number(carat, 5))

#Ejercicio 12
#Los plots en 2D pueden revelar outliers que no se ven en plots de una 
#sola dimensión. Por ejemplo, algunos puntos del plot dado por
# ggplot(data = diamonds) + 
#  geom_point(mapping = aes(x = x, y = y)) + 
#    coord_cartesian(xlim = c(4,12), ylim = c(4,12))
#hacen destacar muchísimo los outliers combinando x con y, a pesar de 
#que por separado parecen valores normales. 
#Intenta averiguar porqué un scatterplot resulta más efectivo en este 
#caso que un gráfico con agrupaciones.

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = x, y = y)) + 
  coord_cartesian(xlim = c(4,12), ylim = c(4,12))
