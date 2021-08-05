# TallerRubyMooveIt

## Ejecucion

Para la ejecucion del codigo, se tendra que correr el siguiente comando "ruby index.rb".

## Prerequisito

Para la correcta ejecucion del codigo se debe crear dentro de la carpeta config un archivo llamado "local_env.yml" con informacion como la especificada a continuacion:

HOSTNAME: 'localhost'    |Direccion en la que se levanta el servidor|

PORT: 2000   |Puerto en el que se levanta el servidor|

TIMEOUT: 60   |Tiempo que puede esperar el servidor por un meensaje del cliente|

KEYPURGER: 60   |Tiempo que demora en ejecutarse el borrado de keys|

## Cliente

Para probar la conexion, se puede correr un cliente de prueba con el siguiente comando "ruby .index_client.rb".
Al establecer la conexion, se pueden mandar los comandos especificados en la documentacion. Como por ejemplo:

set test 0 0 4  |  test

get test

gets test

cas test 0 0 12 1  |  updated_test

append test 0 0 5  |  right

prepend test 0 0 4  |  left

add test1 0 0 5  |  test1

replace test1 0 0 13  |  replaced_test


## Testing

Para poder ejecutar todas las pruebas, hay que correr el comando "rspec --pattern test/*_spec.rb".
Para poder ejcutar un archivo especifico de pruebas, lo haremos mediante el comando "rspec ./test/x.rb", como por ejemplo "rspec .test/command_set_spec.rb".
