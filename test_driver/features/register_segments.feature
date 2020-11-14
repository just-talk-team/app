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



Feature: Configure Segments
    As a user I want to be able to configure segments to be able to have a better chance of meeting people who are part of my environment.

    Scenario: Valid segmentation email
        Given a user who is in the segment registration section
        When he write a valid email "xmaple@hotmail.com" and press the add button
        Then the segment "xmaple@hotmail.com" will be added to the list

    Scenario: Invalid segmentation email
        Given a user who is in the segment registration section
        When he write an invalid email "xmaplehotmail.com" or already selected and press the add button
        Then the segment "xmaplehotmail.com" will not be added to the list