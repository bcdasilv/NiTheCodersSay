Feature: Login

Scenario: User can login with valid credentials
    Given the user enters a valid email
    And the user enters their password
    When the user hits the Login button
    Then the user should see the jam screen