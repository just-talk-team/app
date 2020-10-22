Feature: Registrar la informacion personal de un nuevo usuario
  Como usuario quiero poder configurar la información personal para tener listo aplicación para ser usad

  Scenario: Llenado completo
    Given un usuario que se encuentra en la seccion de registro de datos
    When seleccione un genero y su fecha de nacimiento 
    Then sera dirigido a la seccion de registro de nickname

  Scenario: Llenado incompleto
    Given un usuario que se encuentra en la seccion de registro de datos
    When no seleccione un genero o su fecha de nacimiento 
    Then no pasara a la seccion de registro de nickname 
