vignette("tibble")
library(tidyverse)

View(iris)
class(iris)

iris_tibble <- as_tibble(iris)
class(iris_tibble)

t <- tibble(
  x = 1:10,
  y = pi,
  z = y * x ^ 2
)

View(t)
t[2,3]

t2 <- tibble(
  `:)` =  "smilie",
  ` ` = "space",
  `1988` = "number"
)

t2$`:)`

tribble(
  ~x, ~y, ~z,
#|---|--|------|
  "a", 4,  3.14,
  "b", 8,  6.28,
  "c", 9, -1.25
)


tibble(
  a = lubridate::now() + runif(1e3)*24*60*60,
  b = 1:1e3,
  c = lubridate::today() + runif(1e3)*30,
  d = runif(1e3), 
  e = sample(letters, 1e3, replace = T)
)

lubridate::today()

nycflights13::flights %>%
  print(n = 12, width = Inf)
  

options(tibble.print_max = 12, tibble.print_min = 12)
options(dplyr.print_min = Inf)
options(tibble.width = Inf)
  
nycflights13::flights %>% #....
  View()
  

# [['nombre_variable']]
# [[posicion_variable]]
# $nombre_variable

df <- tibble(
  x = rnorm(10),
  y = runif(10)
)

df$x
df$y

df %>% .$x
df %>% .$y

sapply(df, FUN = function(x) {
  x+1
  })

?sapply

df[["x"]]
df[["y"]]

df %>% .[["x"]]

df[[1]]
df[[2]]

df %>% .[[1]]


class(as.data.frame(df))

#[[]]
dplyr::filter()
dplyr::select()
#[[]] sobre un data.frame, puede devolver un data.frame o un vector
#[[]] sobre una tibble, siempre devuelve una tibble


# Ejercicio 1
#¿Tibble o no tibble? ¿Cómo sabes si un objeto es una tibble o no?
#Pista: imprime los objetos mtcars por un lado y nycflights13::flights 
#que son respectivamente un data.frame y una tibble.

mtcars
nycflights13::flights 

# Ejercicio 2
#Compara y contrasta las siguientes operaciones en el data frame y 
#su equivalente en tibble. 
# df <- data.frame(abc = 1, xyz = "a")
# df$x
# df[,"xyz"]
# df[,c("abc","xyz")]
#¿En qué se parecen? 
#¿En qué difieren? 
#¿Por qué a veces el data frame por defecto nos puede causar mucha frustración?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[,"xyz"]
df[,c("abc","xyz")]

df2 <- tibble(abc = 1, xyz = "a")
df2$x
df2[,"xyz"]
df2[,c("abc","xyz")]

# Ejercicio 3
#Si tenemos el nombre de una variable almacenada en un objeto tipo 
#string (por ejemplo myvar <- "mpg"), ¿cómo podemos extraer la variable 
#referenciada de una tibble? ¿Y en un data frame?
  
var <- "mpg"
mtcars[,var]
as_tibble(mtcars)[[var]]

#Ejercicio 4 
#Toma la siguiente tibble formada por variables con nombres no sintácticos.
# df <- tibble(
#  `1` = 1:12,
#  `2` = `1` * 2 + `1`*runif(length(`1`))
# )
#Extrae el valor de la variable `1`
#Haz un scatterplot de la variable `1`contra la variable `2`
#Crea una nueva columna llamada `3`que sea el cociente de `2`entre `1`.
#Renombra las columnas para que se llamen x, y, z respectivamente.
#¿Qué nombre crees que es mejor?

df <- tibble(
  `1` = 1:12,
  `2` = `1` * 2 + `1`*runif(length(`1`))
)
df$`1`

df %>% ggplot(mapping = aes(x = `1`, y = `2`)) + 
  geom_point()

df <- df%>%
  mutate(`3` = `2`/`1`)

df %>%
  rename(x = `1`, 
         y = `2`,
         z = `3`) 


#Ejercicio 5
#Investiga acerca de la función tibble:enframe() y tibble:deframe(). 
#¿Qué hace y para qué puede servirte?

enframe(1:10)
deframe(enframe(1:10))
enframe(c(x = 3, y = 5))

#Ejercicio 6
#¿Cómo podemos controlar cuantos nombres de columna adicionales se 
#imprimen en el footer de una tibble?

?print.tbl_df

