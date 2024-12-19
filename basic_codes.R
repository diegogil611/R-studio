library(tidyverse)  # Colección de paquetes para manipulación y visualización de datos, incluyendo dplyr, ggplot2, tidyr, etc.

library(readxl)     # Para leer archivos de Excel (.xls, .xlsx) en R.

library(writexl)    # Para escribir dataframes de R en archivos de Excel (.xlsx) sin necesidad de Java.
install.packages("openxlsx")
library(openxlsx)   # Para leer y escribir archivos de Excel (.xlsx) en R. Ofrece opciones avanzadas de manipulación de archivos Excel.

library(readr)      # Herramientas para la lectura de datos rectangulares (como los que se encuentran en archivos CSV y de texto plano).

rm(list=ls())
# Lectura de información
diarias1 <- read_excel("data/raw/Diarias-20240207-161828.xlsx")
diarias2 <- read_excel("data/raw/Diarias-20240207-161848.xlsx")
diarias3 <- read_excel("data/raw/Diarias-20240207-161909.xlsx")

# Vista de información
head(diarias1)
head(diarias2)
head(diarias3)

# Renombramos los DF
tc_compra <- diarias1
tc_venta <- diarias2
bvl <- diarias3

rm(diarias1, diarias2, diarias3)

head(tc_compra)

# Tipo de cambio compra
#======================
head(tc_compra)
colnames(tc_compra) <- c('fecha', 'tc_compra')
head(tc_compra)

# Missings
is.na(tc_compra$tc_compra)
sum(is.na(tc_compra$tc_compra)) # Pero realmente no existen missings? Vamos a ver los valores y tipos de datos
str(tc_compra) # -> tiene strings!
tc_compra$tc_compra <- as.numeric(tc_compra$tc_compra)
str(tc_compra)
tc_compra_ordenado <- tc_compra[order(tc_compra$tc_compra), ]
head(tc_compra_ordenado)
tail(tc_compra_ordenado) # Existen algunos valores con n.d.!

# Reemplazamos valores
tc_compra$tc_compra[tc_compra$tc_compra == "n.d."] <- "9999"
tc_compra$tc_compra <- as.numeric(tc_compra$tc_compra)
str(tc_compra)
tc_compra$tc_compra[tc_compra$tc_compra == 9999] <- NA

# Tipo de cambio venta
#======================
head(tc_venta)
colnames(tc_venta) <- c('fecha', 'tc_venta')
head(tc_venta)

# Missings
is.na(tc_venta$tc_venta)
sum(is.na(tc_venta$tc_venta)) # Pero realmente no existen missings? Vamos a ver los valores y tipos de datos
str(tc_venta) # -> tiene strings!
tc_venta_ordenado <- tc_venta[order(tc_venta$tc_venta), ]
head(tc_venta_ordenado)
tail(tc_venta_ordenado) # Existen algunos valores con n.d.!
str(tc_venta_ordenado)
# Reemplazamos valores
tc_venta$tc_venta[tc_venta$tc_venta == "n.d."] <- "9999"
tc_venta$tc_venta <- as.numeric(tc_venta$tc_venta)
str(tc_venta)
tc_venta$tc_venta[tc_venta$tc_venta == 9999] <- NA

# Unión de ambos dataframes
#==========================
head(tc_compra)
head(tc_venta)
tc_total <- merge(tc_compra, tc_venta, by='fecha', all=TRUE)
head(tc_total)

# Eliminamos todos los missings
# Eliminar filas con valores NA en las columnas "columna1" y "columna2"
tc_total <- tc_total[complete.cases(tc_total$tc_compra, tc_total$tc_venta), ]
head(tc_total)

# Creamos tipo de camibo promedio
tc_total$tc_promedio <- (tc_total$tc_compra+tc_total$tc_venta)/2
head(tc_total)
tc_total$des <- (tc_total$tc_compra-3.50)
summary(tc_total)

# Exportamos el dataframe
write.xlsx(tc_total, file="data/final/tc_final.xlsx")

# Ejercicio para clase (1 punto para TG3, basta con que 1 por grupo lo presente) - Fecha límite: viernes 09 hasta el mediodía:
# Hacer una limpieza del dataframe "bvl" y unirlo con tc_total. Esta información tienen que exportarla a un excel.



