from __future__ import print_function, division
import pygame

from models import GameState

GAME_FRAME = 50 # for some reason my mac runs this like 100 times slower than jon's laptop???

ENEMY_OFF_X = -200
ENEMY_PAD = 5

TEXT_OFF_X = 0
TEXT_OFF_Y = 210

PLAYER_OFF_X = 0
PLAYER_OFF_Y = 280

TILE_OFF_X = 0
TILE_OFF_Y = 150

HBAR_HEIGHT = 15

BG_COLOR = (159, 182, 205)
HFILL_COLOR = (255, 0, 0)
HBACK_COLOR = (0, 0, 0)
TEXT_COLOR = (255, 255, 255)
TILE_COLOR = (200, 210, 140)


FONT_SIZE = 50

pygame.init()
screen = pygame.display.set_mode( (1000,1000) )
pygame.display.set_caption('Typing in things')
screen.fill(BG_COLOR)

font = pygame.font.Font(None, FONT_SIZE)

enemy_sprite = pygame.image.load('art/smallboss.png').convert()
player_sprite = pygame.image.load('art/player.png').convert()

# Display functions
def display_tiles(gstate):
    text = font.render(''.join(gstate.pool), True, TILE_COLOR, BG_COLOR)
    textRect = text.get_rect()
    textRect.centerx = screen.get_rect().centerx + TILE_OFF_X
    textRect.centery = screen.get_rect().centery + TILE_OFF_Y

    screen.blit(text, textRect)


def display_enemies(gstate):
    for ind, enemy in enumerate(gstate.enemies):
        display_enemy(ind, enemy)

# TODO: center these dudes
def display_enemy(ind, enemy):
    enemyRect = enemy_sprite.get_rect()
    offset_x = ind*(enemyRect.width + ENEMY_PAD) + ENEMY_OFF_X
    enemyRect.centerx = screen.get_rect().centerx + offset_x
    enemyRect.centery = screen.get_rect().centery
    screen.blit(enemy_sprite, enemyRect)

    # display healthbar
    hback_rect = pygame.Rect(enemyRect.left,
                             enemyRect.bottom,
                             enemyRect.width,
                             HBAR_HEIGHT)
    prop_fill = enemy.HP/enemy.maxHP
    hfill_rect = pygame.Rect(enemyRect.left,
                             enemyRect.bottom,
                             int(enemyRect.width*prop_fill),
                             HBAR_HEIGHT)
    screen.fill(HBACK_COLOR, rect=hback_rect)
    screen.fill(HFILL_COLOR, rect=hfill_rect)

def display_player(gstate):
    player = gstate.player
    playerRect = player_sprite.get_rect()
    playerRect.centerx = screen.get_rect().centerx + PLAYER_OFF_X
    playerRect.centery = screen.get_rect().centerx + PLAYER_OFF_Y
    screen.blit(player_sprite, playerRect)

    hback_rect = pygame.Rect(playerRect.left,
                             playerRect.bottom,
                             playerRect.width,
                             HBAR_HEIGHT)
    prop_fill = player.HP/player.maxHP
    hfill_rect = pygame.Rect(playerRect.left,
                             playerRect.bottom,
                             int(playerRect.width*prop_fill),
                             HBAR_HEIGHT)
    screen.fill(HBACK_COLOR, rect=hback_rect)
    screen.fill(HFILL_COLOR, rect=hfill_rect)

def display_text(display_str):
    text = font.render(display_str, True, TEXT_COLOR, BG_COLOR)
    textRect = text.get_rect()
    textRect.centerx = screen.get_rect().centerx + TEXT_OFF_X
    textRect.centery = screen.get_rect().centery + TEXT_OFF_Y

    screen.blit(text, textRect)

def display(gstate, display_str):
    screen.fill(BG_COLOR)

    display_player(gstate)
    display_enemies(gstate)
    display_tiles(gstate)
    display_text(display_str)

    pygame.display.update()

def main():
    gstate = GameState()
    ticks = 0

    done = False
    disp_str = ''

    letter_keys = range(pygame.K_a, pygame.K_z+1)
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    gstate.pretty_print()

    while not done:
        ticks += 1
        if ticks%GAME_FRAME == 0:
            gstate.tick()
            gstate.pretty_print()

        display(gstate, disp_str)

        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key in letter_keys:
                    disp_str += chr(event.key).upper()
                elif event.key == pygame.K_BACKSPACE:
                    disp_str = disp_str[:-1]
                elif event.key == pygame.K_RETURN:
                    gstate.process_attack(disp_str)
                    disp_str = ''
                    gstate.pretty_print()
                elif event.key == pygame.K_ESCAPE:
                    done = True

if __name__ == '__main__':
    main()
