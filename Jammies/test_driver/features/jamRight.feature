Feature: Swiping

  Scenario: User swipes right on another user
    Given the user is on the jam screen
    When the user swipes right on the current user
    Then the user sees the green background confirming they swiped right
