Feature: Game

  Scenario: Players joining a game are added to the players map
    Given a new game
    When a player with id "id-1" and name "name-1" joins
    Then a player with id "id-1" and name "name-1" exists
    And the player with id "id-1" has score 0
    And the player with id "id-1" has empty hand
    And the player with id "id-1" has empty pick

  Scenario: Players leaving a game are removed from the players map
    Given a new game
    When a player with id "id-1" and name "name-1" joins
    And a player with id "id-1" leaves
    Then no player with id "id-1" exists