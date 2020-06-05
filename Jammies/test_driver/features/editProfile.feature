Feature: Edit Profile

Scenario: the User edits their profile any time after registration
Given the user is logged in
When the User clicks on the My Profile button
And the User selects Edit Profile on their profile screen
Then all text fields are changed to editable text fields