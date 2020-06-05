Feature: Register

  Scenario: User tries to register with an already taken email
    Given the User’s email is not unique
    When the User tries to register
    Then the User is asked if they already have an account
    And the User is redirected to the login page