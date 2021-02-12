# Marvel API App

## Description

La aplicación está escrita en Swift con RxSwift y MVVM. La capa de networking usa objetos APIRequest para configurar las peticiones y a través de APIClient se pueden hacer las llamadas al servicio. En este caso el APIClient es un singleton donde se concentran todas las llamadas, debido a que hay pocas. La vista mediante Rx y usando el ViewModel pinta los datos.