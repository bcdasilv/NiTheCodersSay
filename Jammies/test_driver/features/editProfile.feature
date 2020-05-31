Feature: Edit Profile

Scenario: the User edits their profile any time after registration
Given the User has already registered a profile and has logged in
When the User selects “Edit Profile’ on their profile screen
Then all text fields are changed to editable text fields