*---------------------------------------------------------------------------------------------------
* Title      : Text Based Project
* Written by : C00166672 Mark Mukiiza
* Date       : February 2025
* Description: Project Starter Kit Option 1. Dungeon crawl based game.
* Bugs       : The ascii drawings aren't printing correctly and the inputs are to the side of the screen.
*----------------------------------------------------------------------------------------------------
        ORG     $1000                 * Set starting address for the program

* =======================================================
* PROGRAM ENTRY POINT
* =======================================================
START:
    MOVE.W  #$64, BRAVERY      * Initialize BRAVERY to 100 decimal ($64)
    BSR     WELCOME           * Call WELCOME subroutine (character, potion, weapon selection)
    BSR     GAME              * Call GAME subroutine (main game logic)

* Main code at $3000
        ORG     $3000                 * Set code starting address for main game logic

* =======================================================
* GAME SUBROUTINE
* =======================================================
GAME:
    BSR     GAMELOOP          * Call the main game loop
    RTS                       * Return from GAME

* =======================================================
* GAMELOOP =>
* 1) ROOM_SELECTION => choose door (1..4)
* 2) HUD => show Bravery
* 3) REPLAY => user can press '0' to exit
* =======================================================
GAMELOOP:
    BSR     ROOM_SELECTION    * Call ROOM_SELECTION subroutine to choose a door
    BSR     HUD               * Call HUD subroutine to display current Bravery
    BSR     REPLAY            * Call REPLAY subroutine (prompt to replay or quit)
    RTS                       * Return from GAMELOOP

* =======================================================
* ROOM_SELECTION => single-char read
* 1=NORTH
* 2=EAST
* 3=SOUTH
* 4=WEST
* =======================================================
ROOM_SELECTION:
    BSR     ENDL              * Print a new line (CRLF)
    LEA     ROOM_SELECT_MSG, A1  * Load address of room selection message
    MOVE.B  #14, D0           * Set function code for output
    TRAP    #15               * Output the room selection message

    BSR     INPUT             * Read a single character input
    MOVE.B  D0, D1            * Copy the input character into D1

    CMP.B   #'1', D1          * Compare input to '1'
    BEQ     NORTH_ROOM        * Branch to NORTH_ROOM if equal
    CMP.B   #'2', D1          * Compare input to '2'
    BEQ     EAST_ROOM         * Branch to EAST_ROOM if equal
    CMP.B   #'3', D1          * Compare input to '3'
    BEQ     SOUTH_ROOM        * Branch to SOUTH_ROOM if equal
    CMP.B   #'4', D1          * Compare input to '4'
    BEQ     WEST_ROOM         * Branch to WEST_ROOM if equal
    RTS                       * Return from ROOM_SELECTION

* =======================================================
* WELCOME SUBROUTINE => pick character & potions & weapon
* =======================================================
WELCOME:
    BSR     ENDL              * Print a new line
    LEA     WELCOME_MSG, A1   * Load welcome message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the welcome message
    BSR     ENDL              * Print a new line

    LEA     CHOOSE_CHAR_MSG, A1 * Load choose character message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the choose character message

    * Read character selection input:
    BSR     INPUT             * Call INPUT to read a character
    MOVE.B  D0, D1            * Copy returned value to D1 for comparison
    CMP.B   #'1', D1          * Compare input with '1'
    BEQ     ASSIGN_KNIGHT     * If equal, branch to ASSIGN_KNIGHT
    CMP.B   #'2', D1          * Compare input with '2'
    BEQ     ASSIGN_EXPLORER   * If equal, branch to ASSIGN_EXPLORER

* If invalid input, default to Knight:
ASSIGN_KNIGHT:
    MOVE.B  #1, CHAR_SELECTION  * Set character selection to 1 (Knight)
    MOVE.W  #$64, HEALTH     * Set HEALTH to 100
    MOVE.W  #$32, ARMOUR     * Set ARMOUR to 50
    MOVE.W  #$19, SPEED      * Set SPEED to 25
    BSR     ENDL              * Print a new line
    LEA     MINI_SELECTED_MSG, A1 * Load Knight selection message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output selection message
    BSR     ENDL              * Print a new line
    BRA     SELECT_WEAPON     * Branch to weapon selection

ASSIGN_EXPLORER:
    MOVE.B  #2, CHAR_SELECTION  * Set character selection to 2 (Explorer)
    MOVE.W  #$50, HEALTH     * Set HEALTH to 80
    MOVE.W  #$19, ARMOUR     * Set ARMOUR to 25
    MOVE.W  #$32, SPEED      * Set SPEED to 50
    BSR     ENDL              * Print a new line
    LEA     EXPLORER_SELECTED_MSG, A1 * Load Explorer selection message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output selection message
    BSR     ENDL              * Print a new line

* Next => pick weapon
SELECT_WEAPON:
    MOVE.B  CHAR_SELECTION, D0  * Move character selection into D0
    CMP.B   #1, D0            * Compare with 1 (Knight)
    BEQ     MINI_WPN_LIST     * If equal, branch to Knight weapon list
    CMP.B   #2, D0            * Compare with 2 (Explorer)
    BEQ     EXPLORER_WPN_LIST * If equal, branch to Explorer weapon list
    RTS                       * Return from SELECT_WEAPON

* Knight Weapons List:
MINI_WPN_LIST:
    LEA     MINI_WPN_MSG, A1  * Load Knight weapons message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the Knight weapons message

    BSR     INPUT             * Read input for weapon selection
    MOVE.B  D0, D1            * Copy input to D1
    CMP.B   #'1', D1         * Compare input with '1'
    BEQ     SET_NEEDLE        * Branch if '1'
    CMP.B   #'2', D1         * Compare input with '2'
    BEQ     SET_ACORN         * Branch if '2'
    CMP.B   #'3', D1         * Compare input with '3'
    BEQ     SET_LANCE         * Branch if '3'
    CMP.B   #'4', D1         * Compare input with '4'
    BEQ     SET_SPEAR         * Branch if '4'
    CMP.B   #'5', D1         * Compare input with '5'
    BEQ     SET_HAMMER        * Branch if '5'
    BRA     SET_NEEDLE        * Default branch to SET_NEEDLE

SET_NEEDLE:
    MOVE.W  NEEDLE_SWORD_DMG, SELECTED_WEAPON_DMG  * Set selected weapon damage to Needle Sword (10)
    BRA     ASK_POTIONS       * Branch to potion selection

SET_ACORN:
    MOVE.W  ACORN_SHIELD_DMG, SELECTED_WEAPON_DMG  * Set damage to Acorn Shield (5)
    BRA     ASK_POTIONS

SET_LANCE:
    MOVE.W  TINY_LANCE_DMG, SELECTED_WEAPON_DMG    * Set damage to Tiny Lance (12)
    BRA     ASK_POTIONS

SET_SPEAR:
    MOVE.W  MINI_SPEAR_DMG, SELECTED_WEAPON_DMG      * Set damage to Mini Spear (14)
    BRA     ASK_POTIONS

SET_HAMMER:
    MOVE.W  WALNUT_HAMMER_DMG, SELECTED_WEAPON_DMG   * Set damage to Walnut Hammer (16)
    BRA     ASK_POTIONS

* Explorer Weapons List:
EXPLORER_WPN_LIST:
    LEA     EXPLORER_WPN_MSG, A1 * Load Explorer weapons message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the Explorer weapons message

    BSR     INPUT             * Read input for weapon selection
    MOVE.B  D0, D1            * Copy input to D1
    CMP.B   #'1', D1         * Compare input with '1'
    BEQ     SET_DAGGER        * Branch if '1'
    CMP.B   #'2', D1         * Compare input with '2'
    BEQ     SET_BOW           * Branch if '2'
    CMP.B   #'3', D1         * Compare input with '3'
    BEQ     SET_SLING         * Branch if '3'
    CMP.B   #'4', D1         * Compare input with '4'
    BEQ     SET_KNIVES        * Branch if '4'
    CMP.B   #'5', D1         * Compare input with '5'
    BEQ     SET_RAPIER        * Branch if '5'
    BRA     SET_DAGGER        * Default branch to SET_DAGGER

SET_DAGGER:
    MOVE.W  DAGGER_DMG, SELECTED_WEAPON_DMG        * Set selected weapon damage to Dagger (8)
    BRA     ASK_POTIONS

SET_BOW:
    MOVE.W  SHORT_BOW_DMG, SELECTED_WEAPON_DMG       * Set damage to Short Bow (10)
    BRA     ASK_POTIONS

SET_SLING:
    MOVE.W  SLINGSHOT_DMG, SELECTED_WEAPON_DMG       * Set damage to Slingshot (7)
    BRA     ASK_POTIONS

SET_KNIVES:
    MOVE.W  THROWING_KNIVES_DMG, SELECTED_WEAPON_DMG  * Set damage to Throwing Knives (11)
    BRA     ASK_POTIONS

SET_RAPIER:
    MOVE.W  LIGHT_RAPIER_DMG, SELECTED_WEAPON_DMG    * Set damage to Light Rapier (13)
    BRA     ASK_POTIONS

* Single char read for number of potions (expects '1', '2', or '3'):
ASK_POTIONS:
   POTION_PROMPT:
    BSR     ENDL              * Print a new line
    LEA     POTIONS_MSG, A1   * Load potions message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the potions message

    BSR     INPUT             * Read input for potion quantity
    MOVE.B  D0, D1            * Copy input to D1
    CMP.B   #'1', D1         * Compare with '1'
    BEQ     VALID_POTION      * Branch if valid
    CMP.B   #'2', D1         * Compare with '2'
    BEQ     VALID_POTION      * Branch if valid
    CMP.B   #'3', D1         * Compare with '3'
    BEQ     VALID_POTION      * Branch if valid

    BRA     POTION_PROMPT     * If not valid, re-prompt

VALID_POTION:
    MOVE.B  D1, NUM_POTIONS   * Store the valid potion quantity
    RTS                       * Return from ASK_POTIONS

* =======================================================
* NORTH_ROOM => talk/attack/sneak.
* EAST_ROOM  => trickster riddle.
* SOUTH_ROOM => spider fight, etc.
* WEST_ROOM  => cursed fountain.
* BOSS_ROOM  => aura kill or trophy.
* All follow below.
* =======================================================

* ======================================================
* ================== NORTH ROOM ========================
* ======================================================
NORTH_ROOM:
    BSR     CLEAR_SCREEN      * Clear the screen
    BSR     ENDL              * Print a new line
    LEA     NORTH_ROOM_MSG, A1 * Load North Room message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output North Room message

    * Set enemy health for North Room (Undead) to 15
    MOVE.W  #15, ENEMY_HEALTH

NORTH_LOOP:
    BSR     CHECK_DEAD        * Check if player is dead
    MOVE.W  ENEMY_HEALTH, D5   * Load enemy health into D5
    CMP.W   #0, D5            * Compare enemy health with 0
    BLE     NORTH_UNDEAD_DEFEATED * If enemy health <= 0, branch to defeat routine

    BSR     ENDL              * Print a new line
    LEA     NORTH_ROOM_OPTIONS, A1 * Load North Room options message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output North Room options

    BSR     INPUT             * Read player's input for North Room choice
    MOVE.B  D0, D1            * Copy input to D1
    CMP.B   #'1', D1         * Compare input with '1'
    BEQ     NORTH_TALK        * If '1', branch to TALK routine
    CMP.B   #'2', D1         * Compare input with '2'
    BEQ     NORTH_ATTACK      * If '2', branch to ATTACK routine
    CMP.B   #'3', D1         * Compare input with '3'
    BEQ     NORTH_SNEAK       * If '3', branch to SNEAK routine
    BRA     NORTH_LOOP        * Otherwise, loop back

NORTH_TALK:
    MOVE.W  HEALTH, D5        * Load player's health into D5
    SUB.W   #$14, D5          * Subtract 20 (damage from talking)
    MOVE.W  D5, HEALTH        * Update player's health

    BSR     ENDL              * Print a new line
    LEA     UNDEAD_TALK_MSG, A1 * Load message for talking to the Undead
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output talk message
    
    BSR     CONTINUE          * Wait for player to continue
    BSR     CHECK_DEAD        * Check if player died from the damage
    BRA     NORTH_ATTACK      * Branch to the ATTACK routine

NORTH_ATTACK:
    BSR     CLEAR_SCREEN      * Clear the screen for the attack menu
    BSR     ENDL              * Print a new line
    LEA     ATTACK_MENU_MSG, A1 * Load the attack menu message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output the attack menu

    * Clear registers for fresh input:
    CLR.B   D0
    CLR.B   D1
    BSR     INPUT             * Read player's input for attack type
    MOVE.B  D0, D1            * Copy input to D1
    CMP.B   #'1', D1         * If input is '1'
    BEQ     ATTACK_WITH_WEAPON * Branch to weapon attack routine
    CMP.B   #'2', D1         * If input is '2'
    BEQ     PUNCH_ATTACK      * Branch to punch attack routine
    CMP.B   #'3', D1         * If input is '3'
    BEQ     KICK_ATTACK       * Branch to kick attack routine
    BRA     NORTH_ATTACK      * If invalid input, re-display attack menu

ATTACK_WITH_WEAPON:
    * Weapon attack: subtract selected weapon damage from enemy health
    MOVE.W  SELECTED_WEAPON_DMG, D5 * Load weapon damage into D5
    MOVE.W  ENEMY_HEALTH, D6  * Load enemy health into D6
    SUB.W   D5, D6          * Subtract weapon damage from enemy health
    MOVE.W  D6, ENEMY_HEALTH * Update enemy health variable
    BSR     ENDL            * Print a new line
    LEA     UNDEAD_ATTACK_MSG, A1 * Load message "You strike the enemy!" into A1
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output weapon attack message
    BRA     AFTER_ATTACK    * Branch to common attack continuation

PUNCH_ATTACK:
    * Punch attack: subtract punch damage (5) from enemy health
    MOVE.W  PUNCH_DMG, D5   * Load punch damage into D5
    MOVE.W  ENEMY_HEALTH, D6 * Load enemy health into D6
    SUB.W   D5, D6          * Subtract punch damage from enemy health
    MOVE.W  D6, ENEMY_HEALTH * Update enemy health variable
    BSR     ENDL            * Print a new line
    LEA     PUNCH_ATTACK_MSG, A1 * Load message "You punch the Undead!" into A1
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output punch attack message
    BRA     AFTER_ATTACK    * Branch to common attack continuation

KICK_ATTACK:
    * Kick attack: subtract kick damage (8) from enemy health
    MOVE.W  KICK_DMG, D5    * Load kick damage into D5
    MOVE.W  ENEMY_HEALTH, D6 * Load enemy health into D6
    SUB.W   D5, D6          * Subtract kick damage from enemy health
    MOVE.W  D6, ENEMY_HEALTH * Update enemy health variable
    BSR     ENDL            * Print a new line
    LEA     KICK_ATTACK_MSG, A1 * Load message "You kick the Undead!" into A1
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output kick attack message
    BRA     AFTER_ATTACK    * Branch to common attack continuation

AFTER_ATTACK:
    BSR     DELAY           * Call delay routine (pause)
    CMP.W   #0, D6          * Check if enemy health <= 0
    BLE     LAST_ATTACK     * If enemy defeated, branch to defeat routine

    * Enemy counterattack:
    MOVE.W  HEALTH, D7      * Load player's health into D7
    SUB.W   #$14, D7        * Subtract 20 from player's health (enemy attack)
    MOVE.W  D7, HEALTH      * Update player's health
    BSR     ENDL            * Print a new line
    LEA     ENEMY_COUNTER_MSG, A1 * Load enemy counterattack message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output counterattack message
    BSR     DELAY           * Call delay routine again
    BSR     CHECK_DEAD      * Check if player is dead after counterattack
    BRA     NORTH_ATTACK    * Loop back to attack menu for next attack turn

DELAY:
    MOVE.L  #150000, D0    * Set delay counter (approx. 2 seconds)
DELAY_LOOP:
    SUBQ.L  #1, D0        * Decrement delay counter
    BNE     DELAY_LOOP    * Loop until counter reaches 0
    RTS                   * Return from DELAY

LAST_ATTACK:
    BRA     NORTH_UNDEAD_DEFEATED * Branch to routine for when enemy is defeated

NORTH_SNEAK:
    BSR     ENDL            * Print a new line
    LEA     UNDEAD_SNEAK_MSG, A1 * Load sneak message into A1
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output sneak message

    MOVE.B  CHAR_SELECTION, D5 * Load character selection into D5
    CMP.B   #1, D5         * Compare if character is Knight (1)
    BEQ     UNDEAD_SNEAK_KNIGHT * If Knight, branch to specific sneak routine
    LEA     UNDEAD_SNEAK_IMPALED_MSG, A1 * Otherwise, load impaled message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output impaled message
    BRA     GAME_OVER      * Branch to game over

UNDEAD_SNEAK_KNIGHT:
    LEA     UNDEAD_SNEAK_DECAP_MSG, A1 * Load decapitation message for Knight sneak
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output decapitation message
    BRA     GAME_OVER      * Branch to game over

NORTH_UNDEAD_DEFEATED:
    BSR     ENDL            * Print a new line
    LEA     UNDEAD_DEFEATED_MSG, A1 * Load enemy defeated message into A1
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output defeated message
    
    BSR     OFFER_POTION_USE * Call subroutine to offer potion use after combat

NORTH_POST:
    BSR     ENDL            * Print a new line
    LEA     UNDEAD_POST_OPTIONS, A1 * Load post-combat options message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output post-combat options message

    BSR     INPUT            * Read player's input for post-combat choice
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'1', D1        * Compare input with '1'
    BEQ     NORTH_CONTINUE  * If '1', branch to continue routine
    CMP.B   #'2', D1        * Compare input with '2'
    BEQ     NORTH_OPEN_CHEST * If '2', branch to chest opening routine
    BRA     NORTH_POST      * Otherwise, loop back to post-combat options

NORTH_CONTINUE:
    BSR     ENDL            * Print a new line
    LEA     TWO_UNDEAD_MSG, A1 * Load message for encountering two Undead
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output the message

    MOVE.W  HEALTH, D1      * Load player's health into D1
    SUB.W   #$28, D1        * Subtract 40 (damage from two enemy attacks)
    MOVE.W  D1, HEALTH      * Update player's health
    BSR     CHECK_DEAD      * Check if player is dead

    BSR     ENDL            * Print a new line
    LEA     TWO_UNDEAD_DEFEATED_MSG, A1 * Load message for defeating two Undead
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output defeat message

    * Increase player's Bravery by 20
    MOVE.W  BRAVERY, D1     * Load current Bravery into D1
    ADD.W   #$14, D1        * Add 20 to Bravery
    MOVE.W  D1, BRAVERY     * Update Bravery variable

    BSR     OFFER_POTION_USE * Offer potion use after combat

NORTH_CONTINUE2:
    BSR     ENDL            * Print a new line
    LEA     BOSS_EXIT_MSG, A1 * Load boss exit options message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output boss exit message

    BSR     INPUT            * Read player's input for boss exit choice
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'1', D1        * Compare input with '1'
    BEQ     BOSS_ROOM       * If '1', branch to boss room routine
    CMP.B   #'2', D1        * Compare input with '2'
    BEQ     DUNGEON_EXIT    * If '2', branch to dungeon exit routine
    BRA     NORTH_CONTINUE2 * Otherwise, loop back to boss exit options

NORTH_OPEN_CHEST:
    BSR     ENDL            * Print a new line
    LEA     OPEN_CHEST_MSG, A1 * Load chest opening message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output chest opening message

    MOVE.B  CHAR_SELECTION, D5 * Load character selection into D5
    CMP.B   #1, D5          * Compare if character is Knight (1)
    BEQ     UNDEAD_SNEAK_KNIGHT * If Knight, branch to Knight-specific sneak routine
    LEA     UNDEAD_SNEAK_IMPALED_MSG, A1 * Otherwise, load impaled message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output impaled message
    BRA     GAME_OVER       * Branch to game over

* BOSS_ROOM => Increase Bravery by 50, then check if Health > 50
BOSS_ROOM:
    MOVE.W  BRAVERY, D1     * Load current Bravery into D1
    ADD.W   #$32, D1        * Add 50 to Bravery
    MOVE.W  D1, BRAVERY     * Update Bravery variable

    MOVE.W  HEALTH, D1      * Load player's Health into D1
    CMP.W   #$32, D1        * Compare Health with 50
    BGT     BOSS_WIN        * If Health > 50, branch to boss win routine
    BRA     BOSS_DEATH      * Otherwise, branch to boss death routine

BOSS_WIN:
    BSR     ENDL            * Print a new line
    LEA     BOSS_WIN_MSG, A1 * Load boss win message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output boss win message
    BRA     GAME_END        * Branch to game end

* BOSS_DEATH => Increase Bravery by 30
BOSS_DEATH:
    MOVE.W  BRAVERY, D1     * Load current Bravery into D1
    ADD.W   #$1E, D1        * Add 30 to Bravery
    MOVE.W  D1, BRAVERY     * Update Bravery variable

    BSR     ENDL            * Print a new line
    LEA     BOSS_AURA_DEATH_MSG, A1 * Load boss aura death message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output boss aura death message
    BRA     GAME_OVER       * Branch to game over

* DUNGEON_EXIT => Decrease Bravery by 50
DUNGEON_EXIT:
    MOVE.W  BRAVERY, D1     * Load current Bravery into D1
    SUB.W   #$32, D1        * Subtract 50 from Bravery
    MOVE.W  D1, BRAVERY     * Update Bravery variable

    BSR     ENDL            * Print a new line
    LEA     DUNGEON_EXIT_MSG, A1 * Load dungeon exit message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output dungeon exit message
    BRA     GAME_END        * Branch to game end

* ======================================================
* ================== EAST ROOM =========================
* ======================================================
EAST_ROOM:
    BSR     CLEAR_SCREEN    * Clear the screen
    BSR     ENDL            * Print a new line
    LEA     EAST_ROOM_MSG, A1 * Load East Room message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output East Room message

EAST_LOOP:
    BSR     ENDL            * Print a new line
    LEA     EAST_RIDDLE_OPTIONS, A1 * Load East Riddle Options message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output East Riddle Options message

    BSR     INPUT            * Read player's input for riddle answer
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'1', D1        * If input is '1'
    BEQ     EAST_CORRECT    * Branch to correct answer routine
    CMP.B   #'2', D1        * If input is '2'
    BEQ     EAST_WRONG      * Branch to wrong answer routine
    CMP.B   #'3', D1        * If input is '3'
    BEQ     EAST_WRONG      * Branch to wrong answer routine
    CMP.B   #'4', D1        * If input is '4'
    BEQ     EAST_WRONG      * Branch to wrong answer routine
    *BRA     EAST_LOOP      * (Commented out fallback loop)

EAST_CORRECT:
    MOVE.W  BRAVERY, D1     * Load current Bravery into D1
    ADD.W   #$14, D1        * Add 20 to Bravery
    MOVE.W  D1, BRAVERY     * Update Bravery variable

    BSR     ENDL            * Print a new line
    LEA     EAST_CORRECT_MSG, A1 * Load riddle correct message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output correct answer message
    BRA     GAME_END        * Branch to game end

EAST_WRONG:
    MOVE.W  HEALTH, D1      * Load current Health into D1
    SUB.W   #$32, D1        * Subtract 50 from Health
    MOVE.W  D1, HEALTH      * Update Health variable

    BSR     ENDL            * Print a new line
    LEA     EAST_WRONG_MSG, A1 * Load riddle wrong message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output wrong answer message

    BSR     CHECK_DEAD      * Check if player is dead
    BRA     EAST_LOOP       * Loop back to East Room riddle

* ======================================================
* ***   SOUTH ROOM    ***
* ======================================================
SOUTH_ROOM:
    BSR     CLEAR_SCREEN    * Clear the screen
    BSR     ENDL            * Print a new line
    LEA     SOUTH_ROOM_MSG, A1 * Load South Room message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output South Room message

    MOVE.W  #25, ENEMY_HEALTH * Set enemy (spider) health to 25

SOUTH_LOOP:
    BSR     CHECK_DEAD      * Check if player is dead
    MOVE.W  ENEMY_HEALTH, D5 * Load enemy health into D5
    CMP.W   #0, D5          * Compare enemy health with 0
    BLE     SOUTH_SPIDER_DEFEATED * If enemy defeated, branch to defeat routine

    BSR     ENDL            * Print a new line
    LEA     SOUTH_OPTIONS, A1 * Load South Room options message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output South Room options

    BSR     INPUT           * Read player's input for South Room choice
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'1', D1        * If input is '1'
    BEQ     SOUTH_FIGHT     * Branch to fight routine
    CMP.B   #'2', D1        * If input is '2'
    BEQ     SOUTH_FRIGHTEN  * Branch to frighten routine
    CMP.B   #'3', D1        * If input is '3'
    BEQ     SOUTH_FLEE      * Branch to flee routine
    BRA     SOUTH_LOOP      * Otherwise, loop back

SOUTH_FIGHT:
    MOVE.W  SELECTED_WEAPON_DMG, D5 * Load selected weapon damage into D5
    MOVE.W  ENEMY_HEALTH, D6  * Load enemy health into D6
    SUB.W   D5, D6          * Subtract weapon damage from enemy health
    MOVE.W  D6, ENEMY_HEALTH * Update enemy health
    CMP.W   #0, D6          * Compare enemy health with 0
    BLE     SOUTH_LOOP      * If enemy defeated, branch to loop

    MOVE.W  HEALTH, D1      * Load player's Health into D1
    SUB.W   #$0A, D1        * Subtract 10 from Health (enemy counterattack)
    MOVE.W  D1, HEALTH      * Update Health variable
    BSR     CHECK_DEAD      * Check if player is dead
    BRA     SOUTH_LOOP      * Loop back to South Room combat

SOUTH_FRIGHTEN:
    CMP.L   #$00001234, D2  * Compare D2 with literal (condition check* unclear purpose)
    BEQ     SOUTH_FRIGHT_SUCCESS * If condition met, branch to frighten success
    MOVE.W  HEALTH, D1      * Load player's Health into D1
    SUB.W   #$0A, D1        * Subtract 10 from Health
    MOVE.W  D1, HEALTH      * Update Health
    BSR     CHECK_DEAD      * Check if player is dead
    BRA     SOUTH_LOOP      * Loop back to combat

SOUTH_FRIGHT_SUCCESS:
    MOVE.W  #0, ENEMY_HEALTH * Set enemy health to 0 (enemy defeated)
    BSR     ENDL            * Print a new line
    LEA     SPIDER_FRIGHTEN_SUCCESS, A1 * Load spider frighten success message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output the success message
    BRA     SOUTH_SPIDER_DEFEATED * Branch to spider defeated routine

SOUTH_FLEE:
    BSR     ENDL            * Print a new line
    LEA     SPIDER_FLEE_MSG, A1 * Load spider flee message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output flee message
    BRA     GAME_END        * Branch to game end

SOUTH_SPIDER_DEFEATED:
    BSR     ENDL            * Print a new line
    LEA     SPIDER_DEFEATED_MSG, A1 * Load spider defeated message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output defeated message

    BSR     OFFER_POTION_USE * Offer potion use after combat
    BRA     GAME_END        * Branch to game end

* ======================================================
* ***   WEST ROOM     ***
* ======================================================
WEST_ROOM:
    BSR     CLEAR_SCREEN    * Clear the screen
    BSR     ENDL            * Print a new line
    LEA     WEST_ROOM_MSG, A1 * Load West Room message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output West Room message

WEST_LOOP:
    BSR     ENDL            * Print a new line
    LEA     WEST_OPTIONS, A1 * Load West Room options message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output West Room options

    BSR     INPUT           * Read player's input for West Room choice
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'1', D1        * If input is '1'
    BEQ     WEST_DRINK      * Branch to drink routine
    CMP.B   #'2', D1        * If input is '2'
    BEQ     WEST_INVESTIGATE * Branch to investigate routine
    CMP.B   #'3', D1        * If input is '3'
    BEQ     WEST_LEAVE      * Branch to leave routine
    BRA     WEST_LOOP       * Otherwise, loop back

WEST_DRINK:
    CMP.L   #$00001234, D2  * Compare D2 with literal (condition check)
    BEQ     WEST_GOOD_DRINK  * If condition met, branch to good drink routine

WEST_BAD:
    MOVE.W  HEALTH, D1      * Load player's Health into D1
    SUB.W   #$0A, D1        * Subtract 10 from Health (bad drink penalty)
    MOVE.W  D1, HEALTH      * Update Health variable
    BSR     ENDL            * Print a new line
    LEA     WEST_BAD_DRINK_MSG, A1 * Load bad drink message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output bad drink message
    BSR     CHECK_DEAD      * Check if player is dead
    BRA     WEST_LOOP       * Loop back to West Room options

WEST_GOOD_DRINK:
    MOVE.W  HEALTH, D1      * Load player's Health into D1
    ADD.W   #$0A, D1        * Add 10 to Health (good drink bonus)
    MOVE.W  D1, HEALTH      * Update Health
    BSR     ENDL            * Print a new line
    LEA     WEST_GOOD_DRINK_MSG, A1 * Load good drink message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output good drink message
    BRA     WEST_LOOP       * Loop back to West Room options

WEST_INVESTIGATE:
    BSR     ENDL            * Print a new line
    LEA     WEST_INVESTIGATE_MSG, A1 * Load investigation message address
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output investigation message
    BRA     GAME_END        * Branch to game end

WEST_LEAVE:
    BRA     GAME_END        * Branch to game end

* ===========================================================
* OFFER_POTION_USE => show status then prompt for potion use
* ===========================================================
OFFER_POTION_USE:
    BSR     DISPLAY_STATUS  * Display current Health and Bravery

    MOVE.B  NUM_POTIONS, D5 * Load number of potions into D5
    CMP.B   #1, D5         * Check if at least 1 potion is available
    BLT     POTION_EXIT    * If less than 1, branch to exit

    BSR     ENDL            * Print a new line
    LEA     POTION_USE_MSG, A1 * Load potion use prompt message
    MOVE.B  #14, D0         * Set output function code
    TRAP    #15             * Output potion use prompt

    BSR     INPUT           * Read player's input (expecting 'y' or not)
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'y', D1        * Compare input with 'y'
    BNE     POTION_EXIT    * If not 'y', branch to potion exit

    MOVE.W  HEALTH, D1      * Load player's Health into D1
    ADD.W   #$0A, D1        * Add 10 to Health (potion effect)
    MOVE.W  D1, HEALTH      * Update Health

    MOVE.B  NUM_POTIONS, D5 * Load current number of potions
    SUB.B   #$01, D5        * Subtract one potion
    MOVE.B  D5, NUM_POTIONS * Update potion count

POTION_EXIT:
    RTS                     * Return from OFFER_POTION_USE

* ======================================================
* DISPLAY_STATUS => show player's current Health and Bravery
* ======================================================
DISPLAY_STATUS:
    * Display Health:
    BSR     ENDL              * Print a new line
    LEA     HEALTH_DISPLAY_MSG, A1 * Load Health display label
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output Health label
    MOVE.W  HEALTH, D1        * Load player's Health value
    MOVE.B  #3, D0           * Set function code for numeric display
    TRAP    #15               * Output Health value

    * Display Bravery:
    BSR     ENDL              * Print a new line
    LEA     BRAVERY_DISPLAY_MSG, A1 * Load Bravery display label
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output Bravery label
    MOVE.W  BRAVERY, D1       * Load player's Bravery value
    MOVE.B  #3, D0           * Set function code for numeric display
    TRAP    #15               * Output Bravery value
    RTS                     * Return from DISPLAY_STATUS

* ==============================================================
* CHECK_DEAD => if Health <= 0, subtract 50 Bravery and end game
* ==============================================================
CHECK_DEAD:
    MOVE.W  HEALTH, D1        * Load player's Health into D1
    CMP.W   #1, D1           * Compare Health with 1
    BGE     CD_EXIT         * If Health >= 1, branch to CD_EXIT

    BSR     ENDL              * Print a new line
    LEA     DEAD_MSG, A1      * Load death message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output death message

    MOVE.W  BRAVERY, D1       * Load player's Bravery into D1
    SUB.W   #$32, D1          * Subtract 50 from Bravery
    MOVE.W  D1, BRAVERY       * Update Bravery variable

    BRA     GAME_OVER       * Branch to GAME_OVER subroutine

CD_EXIT:
    RTS                     * Return from CHECK_DEAD

* =====================================================================
* GAME_OVER => Set Health to 0, print message, then branch to GAME_END
* =====================================================================
GAME_OVER:
    MOVE.W  #0, HEALTH       * Set player's Health to 0
    BSR     ENDL              * Print a new line
    LEA     GAME_OVER_MSG, A1 * Load GAME OVER message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output GAME OVER message
    
    * Now display final status:
    BSR     ENDL              * Print a new line
    LEA     FINAL_STATUS_MSG, A1 * Load final status label address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output final status label

    BSR     DISPLAY_STATUS    * Display final Health and Bravery
    BRA     GAME_END          * Branch to GAME_END

* ======================================================
* GAME_END => Return to main loop or end game
* ======================================================
GAME_END:
    SIMHALT                 * Halt the simulator

* =====================================================================
* REPLAY => Read a character* if '0', exit* otherwise, replay game loop
* =====================================================================
REPLAY:
    BSR     ENDL              * Print a new line
    LEA     REPLAY_MSG, A1    * Load replay prompt message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output replay prompt

    BSR     INPUT             * Read player's input for replay
    MOVE.B  D0, D1          * Copy input to D1
    CMP.B   #'0', D1         * Compare input with '0'
    BEQ     GAME_END        * If '0', branch to GAME_END (exit)
    BRA     GAMELOOP        * Otherwise, branch back to GAMELOOP

* ======================================================
* HUD => Display current Bravery from variable BRAVERY
* ======================================================
HUD:
    BSR     ENDL              * Print a new line
    LEA     HUD_MSG, A1       * Load HUD label message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output HUD label

    MOVE.W  BRAVERY, D1       * Load player's Bravery into D1
    MOVE.B  #3, D0           * Set function code for numeric display
    TRAP    #15               * Output Bravery value
    RTS                     * Return from HUD

* ======================================================
* CLEAR_SCREEN => Clear the display using TRAP #15
* ======================================================
CLEAR_SCREEN:
    MOVE.B  #11, D0           * Set function code for clearing screen
    MOVE.W  #$FF00, D1        * Set parameter for clear screen (if needed)
    TRAP    #15               * Call TRAP #15 to clear screen
    RTS                     * Return from CLEAR_SCREEN

* ======================================================
* ==================  CONTINUE ====================
* ======================================================
CONTINUE:
    BSR     ENDL              * Print a new line
    LEA     CONTINUE_MSG, A1  * Load continue prompt message address
    MOVE.B  #14, D0           * Set output function code
    TRAP    #15               * Output continue prompt message
    MOVE.B  #4, D0            * Set function code (likely to wait for enter key)
    TRAP    #15               * Wait for player's key press
    RTS                     * Return from CONTINUE

* -------------------------------------------------------
* ENDL => Print a Carriage Return/Line Feed (CRLF)
* -------------------------------------------------------
ENDL:
    MOVEM.L D0/A1, -(A7)     * Save registers D0 and A1 on stack
    MOVE    #14, D0          * Set output function code for printing string
    LEA     CRLF, A1         * Load address of CRLF string
    TRAP    #15              * Output CRLF
    MOVEM.L (A7)+, D0/A1     * Restore registers D0 and A1 from stack
    RTS                     * Return from ENDL

* -------------------------------------------------------
* INPUT => Read a single ASCII character from input
* -------------------------------------------------------
INPUT:
    MOVE.W  #5, D0            * Set function code for single-character input
    TRAP    #15               * Call TRAP #15 to read input
    MOVE.B  D1, D0            * Move returned character from D1 to D0
    RTS                     * Return from INPUT

* =======================================================
* DATA: MESSAGES, VARIABLES, WEAPON DAMAGE
* =======================================================
CRLF:   DC.B $0D,$0A,0       * Define CRLF (Carriage Return, Line Feed, Null terminator)

WELCOME_MSG:
    DC.B '**************************************************************************************************************************************************************************************************',$0D,$0A
    DC.B '                                                              WELCOME TO THE MINIATURE KINGDOM!                                                            ',$0D,$0A
    DC.B ' __      _____ _    ___ ___  __  __ ___   _____ ___    _____ _  _ ___   __  __ ___ _  _ ___   _ _____ _   _ ___ ___   ___  _   _ _  _  ___ ___ ___  _  _ _ ',$0D,$0A
    DC.B ' \ \    / | __| |  / __/ _ \|  \/  | __| |_   _/ _ \  |_   _| || | __| |  \/  |_ _| \| |_ _| /_|_   _| | | | _ | __| |   \| | | | \| |/ __| __/ _ \| \| | |',$0D,$0A
    DC.B '  \ \/\/ /| _|| |_| (_| (_) | |\/| | _|    | || (_) |   | | | __ | _|  | |\/| || || .` || | / _ \| | | |_| |   | _|  | |) | |_| | .` | (_ | _| (_) | .` |_|',$0D,$0A
    DC.B '   \_/\_/ |___|____\___\___/|_|  |_|___|   |_| \___/    |_| |_||_|___| |_|  |_|___|_|\_|___/_/ \_|_|  \___/|_|_|___| |___/ \___/|_|\_|\___|___\___/|_|\_(_)',$0D,$0A                                                                                                                                                      
    DC.B '                                                                  CHOOSE YOUR ADVENTURER:                                                                  ',$0D,$0A
    DC.B '                                                              1. MINI KNIGHT (TINY BUT BRAVE)                                                              ',$0D,$0A
    DC.B '                                                                 Health: 100                                                                               ',$0D,$0A
    DC.B '                                                                 Armour: 50                                                                                ',$0D,$0A
    DC.B '                                                                 Speed: 25                                                                                 ',$0D,$0A
    DC.B '                                                              2. TINY EXPLORER (FAST AND CLEVER)                                                           ',$0D,$0A
    DC.B '                                                                 Health: 80                                                                                ',$0D,$0A
    DC.B '                                                                 Armour: 25                                                                                ',$0D,$0A
    DC.B '                                                                 Speed: 50                                                                                 ',$0D,$0A
    DC.B '***********************************************************************************************************************************************************',$0D,$0A,0

CHOOSE_CHAR_MSG:        
    DC.B '                                                      PRESS 1 FOR MINI KNIGHT, 2 FOR TINY EXPLORER: ',0
MINI_SELECTED_MSG:      
    DC.B $0D,$0A,'                                                              You''ve selected the Mini Knight!',0
EXPLORER_SELECTED_MSG:  
    DC.B $0D,$0A,'                                                              You''ve selected the Tiny Explorer!',0
FINAL_STATUS_MSG:       
    DC.B '                                                                      Final Status:',13,10,0

MINI_WPN_MSG:           
    DC.B $0D,$0A
    DC.B '                                                          SELECT YOUR MINI KNIGHT WEAPON (5 OPTIONS):',13,10
    DC.B '                                                                  1. Needle Sword (Damage: 10)',13,10,$0D,$0A 
    DC.B '                                                                  2. Acorn Shield (Damage: 5)',13,10,$0D,$0A
    DC.B '                                                                  3. Tiny Lance (Damage: 12)',13,10,$0D,$0A
    DC.B '                                                                  4. Mini Spear (Damage: 14)',13,10,$0D,$0A
    DC.B '                                                                  5. Walnut Hammer (Damage: 16)',13,10,$0D,$0A,0

EXPLORER_WPN_MSG:       
    DC.B $0D,$0A
    DC.B '                                                          SELECT YOUR TINY EXPLORER WEAPON (5 OPTIONS):',13,10
    DC.B '                                                                  1. Dagger (Damage: 8)',13,10,$0D,$0A
    DC.B '                                                                  2. Short Bow (Damage: 10)',13,10,$0D,$0A
    DC.B '                                                                  3. Slingshot (Damage: 7)',13,10,$0D,$0A
    DC.B '                                                                  4. Throwing Knives (Damage: 11)',13,10,$0D,$0A
    DC.B '                                                                  5. Light Rapier (Damage: 13)',13,10,$0D,$0A,0
POTIONS_MSG:            
    DC.B '                                                                      Collect Health Potions.',13,10
    DC.B '                                                          You have a choice of 1, 2 or 3 Health Potions',13,10
    DC.B '                                                                          Enter Quantity: ',0
CONTINUE_MSG:           
    DC.B '                                                                      PRESS ENTER TO CONTINUE: ',0

ROOM_SELECT_MSG:
    DC.B $0D,$0A        
    DC.B '                                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@###________###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',13,10
    DC.B '                                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@    NORTH     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              #								                              #',13,10
    DC.B '                                              #								                              #',13,10
    DC.B '                                              |								                              |',13,10
    DC.B '                                              |WEST							                          EAST|',13,10
    DC.B '                                              |								                              |',13,10
    DC.B '                                              #								                              #',13,10
    DC.B '                                              #								                              #',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@							                               @@@',13,10
    DC.B '                                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@     SOUTH    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@',13,10
    DC.B '                                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@###________###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',13,10
    DC.B $0D,$0A
    DC.B '                                                You wake up in a dark room, with no memory of how you got there.',13,10
    DC.B '                                                Standing up you adjust your equipment and check your body for any damage.',13,10
    DC.B '                                                            Looking around the room you notice 4 doors.',13,10
    DC.B '                                                            One door to the North, East, South and West.',13,10
    DC.B '                                                Instead of starving to death in this room you decide to move forward.',13,10
    DC.B $0D,$0A
    DC.B '                                                            Which door would you like to try?',13,10
    DC.B '                                                                      1. NORTHERN DOOR',13,10
    DC.B '                                                                      2. EASTERN DOOR',13,10
    DC.B '                                                                      3. SOUTHERN DOOR',13,10
    DC.B '                                                                      4. WESTERN DOOR ',13,10,0

NORTH_ROOM_MSG:          
    DC.B '                                                NORTH ROOM: You enter the room and notice a dishevelled Adventurer',13,10
    DC.B '                                                          in the middle of the room facing away from you.',13,10
    DC.B '                                                  You also notice a chest to the right of the Adventurer and',13,10
    DC.B '                                                                  a door behind the Adventurer',13,0

NORTH_ROOM_OPTIONS:      
    DC.B $0D,$0A
    DC.B '                                                  1) Try talking to the Adventurer and see if they are okay.',13,10
    DC.B '                                                  2) Attack the Adventurer as they are currently distracted.',13,10
    DC.B '                                                  3) Try to sneak to chest. There might be food and water in there.',13,10,0

UNDEAD_TALK_MSG:          
    DC.B $0D,$0A
    DC.B '                                                      You walk up to the Adventurer and tap their shoulder.',13,10
    DC.B '                                                      The Adventurer quickly turns around and surprises you!',13,10
    DC.B '                                                              Turns out it is an Undead Adveturer!',13,10
    DC.B $0D,$0A
    DC.B '                                                                      .// ',13,10
    DC.B '                                                                     / / ',13,10
    DC.B '                                                                    / /',13,10
    DC.B '                                                                   / /',13,10
    DC.B '                                                                  / /',13,10
    DC.B '                                                                 / /',13,10
    DC.B '                                                                / /',13,10
    DC.B '                                                               / /',13,10    
    DC.B '                                                              / /',13,10        
    DC.B '                                                             __|/',13,10
    DC.B '                                                          ,-\__\',13,10
    DC.B '                                                         |\\  //|',13,10
    DC.B '                                                          \\\///',13,10
    DC.B '                                                            ===                            __ _ ',13,10
    DC.B '                                                            |||                          /       \,',13,10
    DC.B '                                                             \\\                        / _   _   \',13,10
    DC.B '                                                              \\\                       )(_) (_)(|}',13,10
    DC.B '                                                               \\\                      {  /\   } /',13,10
    DC.B '                                                                \\\                      \wwwww/\ ',13,10
    DC.B '                                                                 \\\                     /      /',13,10
    DC.B '                                                                  \\\______________      \mmmmm//',13,10
    DC.B '                                                                   \________________)(".  \_>-<_/ ',13,10
    DC.B '                                                                                \_"-._.__G G_c__.-__<"/ ( \',13,10
    DC.B '                                                                                    <"-._>__-,G_.___)\   \7\',13,10
    DC.B '                                                                                   ("-.__.| \"<.__.-" )   \ \',13,10    
    DC.B '                                                                                   |"-.__"\  |"-.__.-".\   \ \',13,10
    DC.B '                                                                                   ("-.__"". \"-.__.-".|    \_\',13,10
    DC.B '                                                                                   \"-.__""|!|"-.__.-".)     \ \',13,10
    DC.B '                                                                                    "-.__""\_|"-.__.-"./      \ l',13,10
    DC.B '                                                                                     ".__""">G>-.__.-">       .--,_',13,10
    
    DC.B '                                                               The Undead hits you for 20 damage!',0

ATTACK_MENU_MSG:
    DC.B $0D,$0A
    DC.B '                                                                     1. Attack enemy with weapon: ',13,10
    DC.B '                                                                     2. Punch enemy: ',13,10
    DC.B '                                                                     3. Kick enemy: ',13,10,0

UNDEAD_ATTACK_MSG:        
    DC.B $0D,$0A
    DC.B '                                                                     You strike the enemy!',0

ENEMY_COUNTER_MSG:        
    DC.B $0D,$0A
    DC.B '                                                                    The enemy strikes back!',0

PUNCH_ATTACK_MSG:
    DC.B $0D,$0A 
    DC.B '                                                                     You punch the Undead!',0

KICK_ATTACK_MSG:
    DC.B $0D,$0A
    DC.B '                                                                     You kick the Undead!',0

UNDEAD_SNEAK_MSG:         
    DC.B $0D,$0A
    DC.B '                                                              You quietly make your way to the chest.',13,10
    DC.B '                                                           Looking over the chest you notice its unlocked',13,10
    DC.B '                                                           You slowly lift the lid, however it springs open!',13,10
    DC.B '                                                               A spike comes fyling out of the chest!',13,10,0

UNDEAD_SNEAK_DECAP_MSG:   
    DC.B '                                              The spike impales you straight through your head and kills you instantly!',13,10
    DC.B '                                                                   The chest is actually a Mimic!',13,10,0

UNDEAD_SNEAK_IMPALED_MSG: 
    DC.B '                                              You notice the shine as a spike flies out of the chest straight for your head!',13,10
    DC.B '                                                      Moving your head out of the way just in time you dodge the spike!',13,10
    DC.B '                                              Unfortunately for you the chest shuts its lid hard on your hands amputating them!',13,10
    DC.B '                                              As you bleed to death you notice the chest is actually a Mimic and curse your luck!',13,10,0

UNDEAD_DEFEATED_MSG:      
    DC.B '                                                                  You defeated the Undead!',0

UNDEAD_POST_OPTIONS:      
    DC.B $0D,$0A
    DC.B '                                                        1) Continue forward to the door that was behind the Undead.',13,10
    DC.B '                                                        2) Move to the chest and try to open it.',13,10,0

TWO_UNDEAD_MSG:          
    DC.B $0D,$0A	
    DC.B '                                          		      _.--""-._                                                 _.--""-._              ',13,10
    DC.B '                             .                         ."         ".                   .                         ."         ".           ',13,10   
    DC.B '                            / \    ,^.         /(     Y             |      )\         / \    ,^.         /(     Y             |      )\     ',13,10
    DC.B '                            /   `---. |--"\    (  \__.."--   -   -- -"""-.-"  )       /   `---. |--"\    (  \__.."--   -   -- -"""-.-"  )    ',13,10
    DC.B '                            |        :|    `>   ".     l_..-------.._l      ."        |        :|    `>   ".     l_..-------.._l      ."      ',13,10
    DC.B '                            |      __l;__ ."      "-.__.||_.-"v"-._||`"----"          |      __l;__ ."      "-.__.||_.-"v"-._||`"----"        ',13,10
    DC.B '                             \  .-" | |  `              l._       _."                  \  .-" | |  `              l._       _."               ',13,10
    DC.B '                              \/    | |                   l`^^"^^"j                    \/     | |                   l`^^"^^"j                 ',13,10 
    DC.B '                                    | |                _   \_____/     _                      | |                _   \_____/     _            ',13,10
    DC.B '                                    j |               l `--__)-"(__.--" |                     j |               l `--__)-"(__.--" |          ',13,10 
    DC.B '                                    | |               | /`---``-----""1 |  .-----.            | |               | /`---``-----""1 |  .-----. ',13,10
    DC.B '                                    | |               )/  `--" "---"   \"-"  ___  `-.         | |               )/  `--" "---"   \"-/  ___  `-.',13,10
    DC.B '                                    | |              //  `-"  "`----"  /  /-"   I`.  \        | |              //  `-"  "`----"  /  /-"   I`.  \',13,10
    DC.B '                                   _L |_            //  `-.-."`-----" /  /  |   |  `. \     _ L |_            //  `-.-."`-----" /  /  |   |  `. \',13,10
    DC.B '                                 "._" / \         _/(   `/   )- ---" ;  /__.J   L.__.\ :   "._" / \         _/(   `/   )- ---" ;  /__.J   L.__.\ :',13,10
    DC.B '                                 `._;/7(-......."  /        ) (     |  |            | |     `._;/7(-......."  /        ) (     |  |            | |',13,10
    DC.B '                                 `._;l _"--------_/        )-"/     :  |___.    _._./ ;     `._;l _"--------_/        )-"/     :  |___.    _._./ ;',13,10
    DC.B '                                    | |                .__ )-"\  __  \  \  I   1   / /        | |                 .__ )-"\  __  \  \  I   1   / /',13,10
    DC.B '                                    `-"                /   `-\-(-"  \ \  `.|   | ," /         `-"                /   `-\-(-"   \ \  `.|   | ," /',13,10
    DC.B '                                                       \__  `-"    __/  `-. `---"",-2                            \__  `-"    __/  `-. `---"",-" ',13,10
    DC.B '                                                          )-._.-- (        `-----"                                  )-._.-- (        `-----"   ',13,10
    DC.B '                                                          )(   \   ("..-.                                           )(   \   ("..-.   ',13,10          
    DC.B '                                                   _..--" _"-" "--".-. |                                      _..--" _"-" "--".-. |   ',13,10           
    DC.B '                                           __,,-"" _,,-""            \ \                             __,,-"" _,,-""            \ \    ',13,10         
    DC.B '                                          f". _,,-"                   \ \                           f". _,,-"                   \ \    ',13,10        
    DC.B '                                         ()--  |                       \ \                         ()--  |                       \ \  ',13,10        
    DC.B '                                           \.  |                       /  \                          \.  |                       /  \  ',13,10        
    DC.B '                                             \ \                      |._  |                           \ \                      |._  | ',13,10       
    DC.B '                                              \ \                     |  ()|                            \ \                     |  ()|  ',13,10      
    DC.B '                                               \ \                     \  /                              \ \                     \  /  ',13,10      
    DC.B '                                               ) `-.                   | |                               ) `-.                   | |   ',13,10      
    DC.B '                                              // .__)                  | |                              // .__)                  | |   ',13,10      
    DC.B '                                           _.//7"                      | |                          _.//7"                       | |    ',13,10     
    DC.B '                                         "---"                         j_| `                     "---"                           j_| `  ',13,10                 
    DC.B '                                                                       |  \                                                      |  \  ',13,10             
    DC.B '                                                                       |lllj                                                     |lllj ',13,10           
    DC.B '                                                                       |||||                                                     ||||| ',13,10   
    DC.B '                                                As you walk through the door, two Undead Adventurers leap out at you!',13,10
    DC.B '                                           They both attack you, one cutting across your chest while the other slices your arm..',13,10
    DC.B '                                                            Luckily the combined attacks deal only 40 damage!',13,10,0

TWO_UNDEAD_DEFEATED_MSG: 
    DC.B $0D,$0A
    DC.B '                                               You survive the surprise attack and retaliate by decapitating one of the Undead and',13,10
    DC.B '                                                        crushing the others head with a punch, dealing critical damage!',13,10
    DC.B $0D,$0A
    DC.B $0D,$0A
    DC.B '                                                        After dealing with the Undead you notice two doors in the room.',13,10
    DC.B '                                           One is a giant red door with a knights helmet engraved into it. This could be the Northern Boss Room...',13,10
    DC.B '                                                        The other is a regular wooden door with exit written on top of it. Weird!',13,10,0

BOSS_EXIT_MSG:           
    DC.B $0D,$0A
    DC.B '                                                          1) Enter the Boss Room. No point quitting now!',13,10
    DC.B '                                                          2) Exit Dungeon. I need to get the hell outta here!',13,10,0

OPEN_CHEST_MSG:          
    DC.B $0D,$0A
    DC.B '                                                                You make your way over to the chest.',13,10
    DC.B '                                                            Looking over the chest you notice its unlocked',13,10
    DC.B '                                                            You slowly lift the lid, however it springs open!',13,10
    DC.B '                                                                A spike comes fyling out of the chest!',13,10,0

BOSS_WIN_MSG:            
    DC.B $0D,$0A
    DC.B '                                           Entering the boss room, you notice an Undead Knight and immediately engage in battle.',13,10 
    DC.B '                                                            The battle is fierce, and you barely defeat the enemy.',13,10 
    DC.B '                                           You are awarded the trophy "Undead''s Bane" and are teleported out of the dungeon..',13,10,0

BOSS_AURA_DEATH_MSG:     
    DC.B $0D,$0A
    DC.B '                                                        Entering the boss room you notice an Undead Knight.',13,10
    DC.B '                                                       You lock eyes with the Knight as it releases its aura.',13,10
    DC.B '                                                    As your health is too low the Knights aura immediately kills you!',13,10,0

DUNGEON_EXIT_MSG:        
    DC.B $0D,$0A
    DC.B '                                                        You sprint towards the exit, open it and see a portal.',13,10
    DC.B '                                                    You hestitate for a second but step through the portal and escape.',13,10,0

EAST_ROOM_MSG:              
    DC.B $0D,$0A
    DC.B '                                                        EAST ROOM: You enter the room, and reality seems to bend.',13,10
    DC.B '                                                        A figure wrapped in shadow appears before you, cackling:',13,10
    DC.B '                                                    "Solve my riddle, or be trapped here forever! You have two chances..."',13,10,0

EAST_RIDDLE_OPTIONS:     
    DC.B $0D,$0A
    DC.B '                                                   Riddle: "I have cities but no houses. I have mountains, but no trees.',13,10
    DC.B '                                                                I have water, but no fish. What am I?"',13,10
    DC.B '                                                                          1) A Map',13,10
    DC.B '                                                                          2) An Illusion',13,10
    DC.B '                                                                          3) The Sky',13,10
    DC.B '                                                                          4) A Puzzle Box',13,10,0
                         
EAST_CORRECT_MSG:        
    DC.B $0D,$0A
    DC.B '                                                               Correct! You receive a Mysterious Key. + 20 Bravery Points.',0

EAST_WRONG_MSG:          
    DC.B $0D,$0A
    DC.B '                                                   Wrong! The Trickster laughs as reality warps. You take 50 damage.',0

SOUTH_ROOM_MSG:         
    DC.B $0D,$0A
    DC.B '                                            SOUTH ROOM: You step into the room, where thick cobwebs coat every surface. ',13,10
    DC.B '                                            Suddenly, a Monstrous Spider skitters toward you, fangs dripping with venom!',13,10,0

SOUTH_OPTIONS:          
    DC.B $0D,$0A
    DC.B '                                                                         1) Fight',13,10
    DC.B '                                                                         2) Attempt to frighten it',13,10
    DC.B '                                                                         3) Flee back to main chamber',13,10,0

SPIDER_FRIGHTEN_SUCCESS:    
    DC.B $0D,$0A
    DC.B '                                                           The Spider recoils and skitters into the darkness.',0

SPIDER_FLEE_MSG:            
    DC.B $0D,$0A
    DC.B '                                                                 You flee back to the main chamber.',0

SPIDER_DEFEATED_MSG:        
    DC.B $0D,$0A
    DC.B '                                                    Your final blow is fatal! The Spider collapses to the ground.',0

WEST_ROOM_MSG:              
    DC.B $0D,$0A
    DC.B '                                              WEST ROOM: You enter a dimly lit room with a grand, glowing fountain at its',13,10
    DC.B '                                                        center. A plaque reads: "To drink is to embrace fate."',13,10,0

WEST_OPTIONS:               
    DC.B $0D,$0A
    DC.B '                                                                 1) Drink from the fountain',13,10
    DC.B '                                                                 2) Investigate the fountain',13,10
    DC.B '                                                                 3) Leave it alone',13,10,0

WEST_GOOD_DRINK_MSG:        
    DC.B $0D,$0A
    DC.B '                                                                    You gain +10 Health!',0

WEST_BAD_DRINK_MSG:         
    DC.B $0D,$0A
    DC.B '                                                              You lose 10 Health from the curse!',0

WEST_INVESTIGATE_MSG:       
    DC.B $0D,$0A
    DC.B '                                                     A hidden button drains the fountain, revealing a staircase.',0

* Misc messages

GAME_OVER_MSG:  
    DC.B '                                                                         GAME OVER!',0

DEAD_MSG:       
    DC.B '                                                              You have been killed! Game Over!',0

REPLAY_MSG:     
    DC.B '                                                        ENTER 0 TO QUIT, OR ANY OTHER KEY TO CONTINUE: ',0

HUD_MSG:        
    DC.B '                                                                     CURRENT BRAVERY: ',0

HEALTH_DISPLAY_MSG:   
    DC.B '                                                                         Health: ',0

BRAVERY_DISPLAY_MSG:  
    DC.B '                                                                    Bravery Points: ',0

POTION_USE_MSG: 
    DC.B '                                                                 Use 1 potion now? (y/n): ',0
    
* =======================================================
* VARIABLES
* =======================================================
CHAR_SELECTION:      DS.B 01          * Variable for character selection (1=Knight, 2=Explorer)
NUM_POTIONS:         DS.B 01          * Variable to store chosen number of potions
HEALTH:              DS.W 01          * Player's Health 
ARMOUR:              DS.W 01          * Player's Armour 
SPEED:               DS.W 01          * Player's Speed 
SELECTED_WEAPON_DMG: DS.W 01          * Damage value of the selected weapon
ENEMY_HEALTH:        DS.W 01          * Enemy's Health (word)
BRAVERY:             DS.W 01          * Player's Bravery (word)

NEEDLE_SWORD_DMG:    DC.W $0A         * Needle Sword damage (10)
ACORN_SHIELD_DMG:    DC.W $05         * Acorn Shield damage (5)
TINY_LANCE_DMG:      DC.W $0C         * Tiny Lance damage (12)
MINI_SPEAR_DMG:      DC.W $0E         * Mini Spear damage (14)
WALNUT_HAMMER_DMG:   DC.W $10         * Walnut Hammer damage (16)

DAGGER_DMG:          DC.W $08         * Dagger damage (8)
SHORT_BOW_DMG:       DC.W $0A         * Short Bow damage (10)
SLINGSHOT_DMG:       DC.W $07         * Slingshot damage (7)
THROWING_KNIVES_DMG: DC.W $0B         * Throwing Knives damage (11)
LIGHT_RAPIER_DMG:    DC.W $0D         * Light Rapier damage (13)

PUNCH_DMG:           DC.W $05         * Punch attack damage (5)
KICK_DMG:            DC.W $08         * Kick attack damage (8)
        
        END     START          


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
