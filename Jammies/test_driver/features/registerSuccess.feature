Feature: Register

  Scenario: User tries to register with a unique email
    Given the User’s email is unique
    When the User tries to register
    Then the User is logged in