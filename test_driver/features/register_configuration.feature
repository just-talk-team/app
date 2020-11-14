
Feature: Register Initial Configuration
    As a user I want to be able to register my initial configuration to have the application ready to be used.

    Scenario: Valid configuration data
        Given a user who is in the segment registration section
        And has completed all the registration data
        When he clicks on the "Finish" button
        Then it will be added and taken to the "Preference" screen.

    Scenario: Invalid configuration data
        Given a user who is in the segment registration section
        And has not completed any of the registration data
        When he clicks on the "Finish" button
        Then it will not be added and directed to the "Preference" screen.