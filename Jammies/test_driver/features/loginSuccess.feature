Feature: Login Success
  User should be able to login with an valid credentials.

Scenario: User can login
    Given the user enters a valid email
    And the user enters their password
    When the user hits the Login button
    Then the user should see the jam screen