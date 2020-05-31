Feature: Swiping

  Scenario: User swipes right on another user
    Given the user is on the jam screen
    When the user swipes left on the current user
    Then the user sees the red background confirming they swiped left