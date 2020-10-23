Feature: Registrar el nickname de un nuevo usuario
  Como usuario quiero poder configurar un nickname para poder mostrarlo durante mis conversaciones en Just Talk.

  Scenario: Nickname valido
    Given un usuario que se encuentra en la seccion de registro de nickname
    When ingrese un nickname valido
    Then sera dirigido a la seccion de registro de avatar


  Scenario: Nickname no válido
    Given un usuario que se encuentra en la seccion de registro de nickname
    When ingrese un nickname invalido o vacio
    Then no pasara a la seccion de registro de avatar
