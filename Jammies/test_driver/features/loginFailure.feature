Feature: Login

Scenario: User cannot login with invalid email
    Given the user enters an invalid email
    And the user enters their password
    When the user hits the Login button
    Then the user should see an error message