library(tidyverse)
       
table <- read_csv("data/population.csv")
View(table)

table %>%  
  mutate(rate = cases/population*10000)

table %>%
  count(year, wt = cases)

table1 %>%
  ggplot(aes(year, cases)) + 
  geom_line(aes(group = country), color = "grey") + 
  geom_point(aes(color = country))

#(El código de esta sección sobre gather y spread ha cambiado 
#por pivot_long y pivot_wider respectivamente)
table4a %>%
  gather(`1999`,`2000`, key = "year", value = "cases") -> tidy4a

table4b %>%
  gather(`1999`, `2000`, key = "year", value = "population") -> tidy4b

left_join(tidy4a, tidy4b) -> tidy4 
 

table2 %>%
  spread(key = type, value = count)

#Ejercicio 4
#Las funciones spread y gather no son absolutamente simétricas. 
#Toma el siguiente ejemplo para explicarlo correctamente:

roi <- tibble(
  year = c(rep(2016,4), rep(2017,4), 2018),
  quarter = c(rep(c(1,2,3,4),2),1),
  return = rnorm(9, mean = 0.5, sd = 1)
)

roi %>%
  spread(year, return) %>%
  gather("year", "return", `2016`:`2018`)

#Ejercicio 5
?spread
# convert: If TRUE, type.convert() with asis = TRUE will be run 
# on each of the new columns. This is useful if the value column 
# was a mix of variables that was coerced to a string. If the 
# class of the value column was factor or date, note that will 
# not be true of the new columns that are produced, which are 
# coerced to character before type conversion.

#Ejercicio 7
#Explica porqué falla la función spread aplicada a la siguiente tribble de abajo.
#¿Crees que añadiendo alguna nueva columna se soluciona el problema? Di cual.

people <- tribble(
  ~name,         ~key,   ~value,
  #-------------|-------|-------
  "Juan Gabriel", "age",     18,
  "Juan Gabriel", "weight",  58,
  "Juan Gabriel", "age",     30,
  "Juan Gabriel", "weight",  71,
  "Ricardo",      "age",     55,
  "Ricardo",      "age",     75
)

#Ejercicio 8
#Limpia la siguiente tribble con la función de spread o gather que 
#creas más útil. Indica cuales son las nuevas variables después de 
#aplicar la función.

pregnancy <- tribble(
  ~pregnant, ~male, ~female,
  #--------|------|---------
  "yes",    NA,    32,
  "no",     85,    43
)

pregnancy %>%
  gather("male", "female", key = sex, value = count)  %>%
  mutate(pregnant = (pregnant == "yes"),
         female = (sex == "female")) %>%
  select(-sex)




table3 %>%
  separate(rate, into = c("cases", "population"), 
           sep = "/", convert = TRUE) %>%
  separate(year, sep = 2, into = c("century","year"), 
           convert = TRUE)

table5 %>%
  unite(new_year, century, year, sep = "")


tibble(x = c("a,b,c", "d,e,f,g","h,i,j")) %>%
  separate(x, c("x", "y", "z"), extra = "drop")

tibble(x = c("a,b,c", "d,e","f,g,h")) %>%
  separate(x, c("x", "y", "z"), fill = "right")



roi <- tibble(
  year = c(rep(2016,4), rep(2017,4), 2018),
  quarter = c(rep(c(1,2,3,4),2),1),
  return = rnorm(9, mean = 0.5, sd = 1)
)
roi$return[7] = NA

roi %>%
  spread(year, return) %>%
  gather(year, return, `2016`:`2018`, na.rm = TRUE)

roi %>%
  complete(year, quarter)


treatments <- tribble(
  ~name,         ~treatment,  ~response,
  "Juan Gabriel", 1,          8, 
  NA,             2,          10, 
  NA,             3,          4,
  "Ricardo",      1,          7,
  NA,             2,          9
)


treatments %>%
  fill(name)

## Ejemplo de tuberculosis de bbdd de la WHO

# 1-Limpieza Paso a paso
view(tidyr::who)
tidyr::who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE) ->who1
who1 %>% count(key) %>% View()

who2 <- who1 %>%  
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2 %>% count(key) %>% View()

who3 <- who2 %>%
 separate(key, c("new", "type", "sexage"), sep = "_")
who3 %>% View()

who4 <- who3 %>%
 select(-new, -iso2, -iso3)
who4 %>% View()

who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1)
who5 %>% View()

# 2- Limpieza en un solo pipe

view(tidyr::who)
tidyr::who %>%
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm = TRUE) %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "type", "sexage"), sep = "_") %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)
