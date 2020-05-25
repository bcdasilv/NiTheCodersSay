Feature: Login Failure
  User should not be able to login with an invalid credentials.

Scenario: User cannot login with invalid email
    Given I expect the user enters email
    And I expect the user enters password
    When user hits Login button
    Then user should see an error message