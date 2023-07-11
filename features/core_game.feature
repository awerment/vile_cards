Feature: Game

  Scenario: Creating a new game
    Given an empty state
    When a new game is started
    | game_id | admin_id | admin_name | black_cards | white_cards   |
    | game-id | admin-id | admin-name | 1, 2, 3     | 1, 2, 3, 4, 5 |
    Then a new game with id "game-id" exists
    And a player with id "admin-id" and name "admin-name" exists
    And the deck has 3 black cards on the draw pile
    And the deck has 0 black cards on the discard pile
    And the deck has 5 white cards on the draw pile
    And the deck has 0 white cards on the discard pile
    And the game round is 0
    And no czar is picked
    And no black card is drawn

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