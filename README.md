# TallerRubyMooveIt

## Ejecucion

Para la ejecucion del codigo, se tendra que correr el siguiente comando "ruby index.rb"

## Prerequisito

Para la correcta ejecucion del codigo se debe crear dentro de la carpeta config un archivo llamado "local_env.yml" con informacion como la especificada a continuacion:

HOSTNAME: 'localhost'

PORT: 2000

## Cliente

Para probar la conexion, se puede correr un cliente de prueba con el siguiente comando "ruby ./index_client.rb".
Al establecer la conexion, se pueden mandar los comandos especificados en la documentacion.

## Testing

Para poder ejecutar todas las pruebas, hay que correr el comando "rspec --pattern test/*_spec.rb".
Para poder ejcutar un archivo especifico de pruebas, lo haremos mediante el comando "rspec ./test/x.rb", como por ejemplo "rspec .test/command_set_spec.rb".
