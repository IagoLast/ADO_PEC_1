# Objetivos

Aunque los inhibidores de factores de necrosis tumoral [TNF](https://es.wikipedia.org/wiki/Factor_de_necrosis_tumoral) son [utilizados en el tratamiento de enfermedades inflamatorias crónicas](https://www.ncbi.nlm.nih.gov/pubmed/15370396) no existe demasiada información acerca de cómo pueden afectar estos tratamientos al funcionamiento normal del sistema nervioso central.

En este trabajo se analizarán Microarrays de ARN para buscar diferencias estadísticamente significativas entre muestras sin tratar (WT) y muestras sometidas a tratamientos de inhibición de TNF.

# Materiales y Métodos

Este trabajo se basa en estúdio de comparación de grupos (class comparison) donde se han tomado muestras correspondientes al dia 13.5 de la fase embrionaria (E13.5) al séptimo día de vida (P7) y en adultos de 2 y 4 meses de vida (A2 y A4 respectivamente) de un grupo de control (WT) de ratones [C57BL/6](https://en.wikipedia.org/wiki/C57BL/6) y un segundo grupo de ratones tratados (TNF-/-).

Los microarrays utilizados son del modelo GeneChip Mouse Gene 1.0 ST Array de Affymetrix que según su especificación contienen aproximadamente 25 sondas (probes) diseñadas para cubrir 28,853 genes bien conocidos y anotados.

![GeneChip Mouse Gene 1.0 ST](https://assets.thermofisher.com/TFS-Assets/LSG/product-images/GeneChip_generic_microarray_300dpi_noshad_wht.jpg-250.jpg)


\newpage

# Procedimiento de trabajo

En un primer paso se analizaron gráficamente [los archivos .CEL originales](https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE134178&format=file) buscando posibles errores en los datos. Aunque tanto el histograma como el boxplot mostraron datos de intensidades bastante uniformes se realizó una comprobación adicional utilizando el paquete `arrayQualityMetrics` para verificar que los datos no contenían errores.

\begin{figure}
    \centering
    \includegraphics[width=5cm]{img/raw_data_histogram.png}
    \qquad
    \includegraphics[width=5cm]{img/raw_data_boxplot.png}
    \caption{Distribución de intensidades en los datos originales.}
\end{figure}

## Normalización

Para poder realizar un análisis de la expresión diferencial de los datos es necesario transformar los datos para que sean comparables entre sí. 

Esta transformación se ha realizado utilizado el algorimo [Robust Multichip Analysis (RMA)](https://www.ncbi.nlm.nih.gov/pubmed/?term=12925520) que a grandes rasgos corrige el ruido de forndo, normaliza los datos y realiza una estimación final de la intensidad.

Una vez obtenidos los datos normalizados se repite el control de calidad sobre los mismos.

\begin{figure}
    \centering
    \includegraphics[width=5cm]{img/eset_rma_histogram.png}
    \qquad
    \includegraphics[width=5cm]{img/eset_rma_boxplot.png}
    \caption{Distribución de intensidades en los datos normalizados.}
\end{figure}

\newpage

## Filtrado

Antes de empezar el análisis es interesante eliminar los genes cuya variabilidad puede ser consecuencia de un ruído aleatorio y aquellos de los que no se
dispone de anotaciones.

\begin{figure}
    \centering
    \includegraphics[width=5cm]{img/variability_original.png}
    \qquad
    \includegraphics[width=5cm]{img/variability_filtered.png}
    \caption{Variabilidad de los genes antes y después del filtrado.}
\end{figure}

Para ello se ha utilizado la función `nsFilter` paquete `geneFilter` para eliminar 1594 genes duplicados, 15225 con una variabilidad irrelevante y 12866 de los que actualmente no se disponen anotaciones

|                    |          |
|:-------------------|---------:|
|numDupsRemoved      | 1594     |
|numLowVar           | 15225    |
|numRemoved.ENTREZID | 12866    |

\newpage

## Selección de genes

Para escoger los genes se han utilizado dos aproximaciones. 

Por un lado se ha realizado un t-test (`rowttest`) y por otro se ha utilizado el [método de Smyth (`limma`)](https://www.ncbi.nlm.nih.gov/pubmed/16646809) visto en prácticas previas.

Debido al grán número de genes procesados se ha optado por aplicar una corrección sobre el p-valor. Dado que estamos dispuestos a asumir falsos positivos a cambio de maximizar los genes candidatos el método seleccionado es el de Benjamini & Hochber. Los genes seleccionados mediante rowtest y limma respectivamente han sido:

|SYMBOL        |        BH|
|:-------------|---------:|
|9430060I03Rik | 0.0431307|
|Gm10787       | 0.0431307|
|Gm10024       | 0.0431307|
|Gm11696       | 0.0431307|
|Dnmt3aos      | 0.0491421|
|Gm10782       | 0.0431307|
|BC025933      | 0.0431307|
|Gm10536       | 0.0431307|
|Gm10532       | 0.0431307|
|Gm10857       | 0.0431307|
|Gm10804       | 0.0491421|
|Gm10714       | 0.0431307|
|Oog3          | 0.0431307|
|Gm10369       | 0.0431307|
|Gm10445       | 0.0491421|
|Gm10610       | 0.0431307|
|Fam129c       | 0.0431307|
|Gm10655       | 0.0431307|

| **PROBE_ID** | SYMBOL  | adj.P.Val |
| :----------- | :------ | --------: |
| 10423836     | Cthrc1  | 0.0311910 |
| 10418205     | Plac9b  | 0.0311910 |
| 10566326     | Trim12a | 0.0311910 |
| 10471675     | Glo1    | 0.0311910 |
| 10398432     | Mir377  | 0.0311910 |
| 10572130     | Lpl     | 0.0361161 |
| 10412394     | Nnt     | 0.0410250 |



## Interpretación biológica de los resultados

Con esto se ha podido realizar un análisis enrich dando como resultado las siguientes vías:

\begin{figure}
    \centering
    \includegraphics[width=5cm]{img/vias_t_test.png}
    \qquad
    \includegraphics[width=5cm]{img/vias_limma.png}
    \caption{Vías con mayor significancia entre los grupos estudiados.}
\end{figure}

# Resultados

## Keratinization

Es interesante porque hay [un estudio previo](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0159151) que relaciona los anti-TNF con los keratinocitos.



## Chylomicron remodeling

Vemos que la primera vía implicada es [chylomicron remodeling](https://www.ebi.ac.uk/QuickGO/term/GO:0034371).

[https://www.sciencedirect.com/topics/medicine-and-dentistry/chylomicron](https://www.sciencedirect.com/topics/medicine-and-dentistry/chylomicron)

(Se relaciona con TNF y LPS)

## Assembly of active LPL and LIPC lipase complexes

[http://scielo.isciii.es/pdf/nh/v27n6/01articuloespecial01.pdf](http://scielo.isciii.es/pdf/nh/v27n6/01articuloespecial01.pdf)
[https://www.ncbi.nlm.nih.gov/pubmed/3495531](https://www.ncbi.nlm.nih.gov/pubmed/3495531)

## Plasma lipoprotein remodeling

[https://www.ncbi.nlm.nih.gov/pubmed/8572227](https://www.ncbi.nlm.nih.gov/pubmed/8572227)

## Pyruvate metabolism

[https://www.ncbi.nlm.nih.gov/pubmed/29358703](https://www.ncbi.nlm.nih.gov/pubmed/29358703) 
[https://www.ncbi.nlm.nih.gov/pubmed/9450646](https://www.ncbi.nlm.nih.gov/pubmed/9450646)


## Retinoid metabolism and transport

## Metabolism of fat-soluble vitamins

## Pyruvate metabolism and cytric acid (TCA) cycle

# Discusión

- Los dos métodos dan vias diferentes que a la vez son diferentes a las del propio paper.

# Apéndice

**Estudio:**  https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE134178

**ID_DATA**: GSE134178

**BioProject:** https://www.ncbi.nlm.nih.gov/bioproject/PRJNA554146