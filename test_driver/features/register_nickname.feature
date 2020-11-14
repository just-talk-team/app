Feature: Register the nickname of a new user
  As a user I want to be able to configure a nickname to be able to show it during my conversations in Just Talk.

  Scenario: Valid nickname
    Given a user who is in the nickname registration section
    When enter a valid nickname
    Then he will be directed to the avatar registration section


  Scenario: Invalid nickname
    Given a user who is in the nickname registration section
    When enter an invalid or empty nickname
    Then it will not go to the avatar registration section