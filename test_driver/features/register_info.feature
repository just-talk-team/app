Feature: Register the personal information of a new user
  As a user I want to be able to configure the personal information to have the application ready to be used

  Scenario: Full fill
    Given a user who is in the data registration section
    When he select a gender and his date of birth
    Then he will be directed to the nickname registration section

  Scenario: Incomplete fill
    Given a user who is in the data registration section
    When he dont select a gender or his date of birth
    Then it will not go to the nickname registration section
