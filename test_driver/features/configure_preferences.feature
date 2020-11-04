Feature: Configure preferences
    As a user I want to be able to edit preferences to select people with certain characteristics that make my conversation enjoyable

    Scenario: Free User
        Given a free user logged user who enters the "Just Talk" view 
        When he clicks on the preference icon 
        Then he is shown the Segments, Gender, Age and Badges options, of which he can only edit the Segment option and will only show static information of the other options.
    
    Scenario: Select Segment with user Free
        Given a premium user logged into the “Just Talk” view 
        When they click on the preference icon 
        Then they will be shown the Segments, Sex, Age and Badges options, from which they can select or edit all the options.

    Scenario: Select Sex with Free user
        Given a free logged in user who enters the “Just Talk” view 
        When he clicks on the preference icon 
        Then he cannot uncheck or select any gender, but the existing ones (Male, Female) will be shown disabled.

    Scenario: Select Age with Free user
        Given a free logged user who enters the “Just Talk” view 
        When he clicks on the preference icon 
        Then he cannot select an age range and the disabled fields will be shown with the values 18 to 100, which represent the ages available.

    Scenario: Select Badges with Free user
        Given a free logged user who entered the "Just Talk" view 
        When he clicks on the preference icon 
        Then he cannot select badges, but the existing ones (Good Listener, Good Talker, fun) are shown disabled.