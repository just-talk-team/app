Feature: Registrar configuración inicial
    Como usuario quiero poder registrar mi configuración inicial para tener lista la aplicación para ser usada.

    Scenario: Datos de configuracion válidos
        Given un usuario que se encuentra en la seccion de registro de segmentos
        And ha completado todos los datos del registro
        When da click en el boton de "Finalizar"
        Then sera añadido y llevado a la pantalla "Preference"

    Scenario: Datos de configuracion no válidos
        Given un usuario que se encuentra en la seccion de registro de segmentos
        And no ha completado alguno de los datos del registro
        When da click en el boton de "Finalizar"
        Then no sera añadido y dirigido a la pantalla "Preference"