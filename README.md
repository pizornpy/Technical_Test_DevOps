# Technical_Test_DevOps


### Cuestiones generales ###

Tanto el nombramiento de variables como los comentarios del código están escritos en inglés. Este readme está escrito en castellano en aras de la claridad.  He pretendido ser lo más claro posible en lo que se refiere a los comentarios

El repo tiene 3 partes principales, en primer lugar, la carpeta /helm-chart, que contiene los cambios realizados a la chart de helm, principalmente:
    El aislamiento de nodos con concretos, para esto he añadido una comprobación para que los pods no se deplieguen en nodos que tengan la etiqueta, que hay que añdir ping-restricted.
    También, la antiafinidad en los pods para que no compartan nodo.
    El despliegue en distantas zonas de disponibilidad de los pods
    El script aleatorio, de una lista que se supone, para ello he usado un update hook con un script de bash. Para el update hook he usado esta fuente https://helm.sh/docs/topics/charts_hooks/




En segundo lugar, la carpeta /terraform contiene la respuesta al segundo ejercicio. En esta tenemos tres archivos, main.tf, variables.tf y output.tf. 
Hay una rama no terminada (resource creation branch) en la que se crean el grupo de recursos y el cluster de AKS, tras leer la tercera pregunta me he dado cuenta de que podía asumir la existencia de estos recursos, entonces he optado por separarlo en una rama a parte y cambiar develop.
    Con respecto a este segundo ejercicio decir que he trabajado más con AWS que con Azure, entonces me he apoyado en la documentación oficial de terraform (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster)

El módulo de terraform:
    Obtiene información del grupo de recursos existente.
    Obtiene información del clúster de AKS existente
    Crea un registro de contenedores en Azure con SKU Premium.
    Asigna el rol AcrPull al clúster de AKS para permitir que extraiga imágenes del ACR.
    Importa Helm charts desde un registro de referencia al ACR utilizando un script local.


En tercer lugar, en el directorio .github\workflows está deploy-helm-chart.yml
    No tengo mucha experiencia con los workflows de github, entonces he optado por buscar en la documentación oficial y adaptar, según he visto conveniente esto: https://github.com/actions/starter-workflows/blob/main/deployments/azure-kubernetes-service-helm.yml
    
A grandes rasgos, el workflow:
    Clona el código del repositorio.
    Configura Terraform.
    Inicia sesión en Azure.
    Ejecuta terraform init y terraform apply para desplegar la infraestructura.
    Clona el código del repositorio de nuevo.
    Inicia sesión en Azure. 
    Construye y publica la imagen de contenedor en Azure Container Registry (ACR).
    Configura el acceso a AKS.
    Instala Helm.
    Usa Helm para desplegar o actualizar la aplicación en AKS.
