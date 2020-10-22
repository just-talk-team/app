Feature: Configurar segmentos
    Como usuario quiero poder configurar segmentos para poder tener más posibilidades de encontrarme con personas que forman parte de mi entorno.

    Scenario: Correo de segmentacion valido
        Given un usuario que se encuentra en la seccion de registro de segmentos
        When escriba un correo valido "xmaple@hotmail.com" y presione el boton de agregar
        Then el segmento "xmaple@hotmail.com" sera agregado a la lista

    Scenario: Correo de segmentacion no valido
        Given un usuario que se encuentra en la seccion de registro de segmentos
        When escriba un correo invalido "xmaplehotmail.com" o ya seleccionado y presione el boton agregar
        Then el segmento "xmaplehotmail.com" no sera agregado a la lista

