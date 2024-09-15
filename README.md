# Technical_Test_DevOps


### Cuestiones generales ###

Tanto el nombramiento de variables como los comentarios del código están escritos en inglés. Este readme está escrito en castellano en aras de la claridad.  He pretendido ser lo más claro posible en lo que se refiere a los comentarios

El repo tiene 3 partes principales, en primer lugar, la carpeta /helm-chart, que contiene los cambios realizados a la chart de helm, principalmente:

    El aislamiento de nodos con concretos, para esto he añadido una comprobación para que los pods no se deplieguen en nodos que tengan la etiqueta, que hay que añdir ping-restricted.
    También, la antiafinidad en los pods para que no compartan nodo.
    El despliegue en distantas zonas de disponibilidad de los pods
    El script aleatorio, de una lista que se supone, para ello he usado un update hook con un script de bash. Para el update hook he usado esta fuente https://helm.sh/docs/topics/charts_hooks/. He supuesto una lista de escripts donde escoger, alojados en un volumen por ejemplo, por escribir un script en bash un poco más elaborado. 



En segundo lugar, la carpeta /terraform contiene la respuesta al segundo ejercicio. En esta tenemos tres archivos, main.tf, variables.tf y output.tf. 
Hay una rama no terminada (resource creation branch) en la que se crean el grupo de recursos y el cluster de AKS, tras leer la tercera pregunta me he dado cuenta de que podía asumir la existencia de estos recursos, entonces he optado por separarlo en una rama a parte y cambiar develop. Esta es esta rama que ha quedado incompleta y que contiene la creación de los recursos en el módulo de terraform
    Con respecto a este segundo ejercicio decir que he trabajado más con AWS que con Azure, entonces me he apoyado en la documentación oficial de terraform (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster)

El módulo de terraform:

    Crea un grupo de recursos.
    Crea un clúster de AKS. 
    Crea un registro de contenedores en Azure con SKU Premium.
    Asigna el rol AcrPull al clúster de AKS para permitir que extraiga imágenes del ACR.
    Importa Helm charts desde un registro de referencia al ACR utilizando un script local.



