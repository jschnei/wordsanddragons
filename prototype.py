from __future__ import print_function, division
import pygame

from models import GameState

# one frame = 10 ms
GAME_FRAME = 500

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
HP_TEXT_COLOR = (255, 255, 255)

FONT_SIZE = 50
HP_FONT_SIZE = 20

pygame.init()
screen = pygame.display.set_mode( (1000,1000) )
pygame.display.set_caption('Typing in things')
screen.fill(BG_COLOR)

CENTER_X = screen.get_rect().centerx
CENTER_Y = screen.get_rect().centery

font = pygame.font.Font(None, FONT_SIZE)
hp_font = pygame.font.Font(None, HP_FONT_SIZE)

enemy_sprite = pygame.image.load('art/smallboss.png').convert()
player_sprite = pygame.image.load('art/player.png').convert()

# Display functions
def display_tiles(gstate):
    text = font.render(''.join(gstate.pool), True, TILE_COLOR, BG_COLOR)
    text_rect = text.get_rect()
    text_rect.centerx = CENTER_X + TILE_OFF_X
    text_rect.centery = CENTER_Y + TILE_OFF_Y

    screen.blit(text, text_rect)

def display_enemies(gstate):
    for ind, enemy in enumerate(gstate.enemies):
        # TODO: center these dudes
        offset_x = ind*(enemy_sprite.get_width() + ENEMY_PAD) + ENEMY_OFF_X
        display_entity(enemy, enemy_sprite, offset_x)

def display_entity(entity, sprite, offset_x=0, offset_y=0):
    entity_rect = sprite.get_rect()

    entity_rect.centerx = CENTER_X + offset_x
    entity_rect.centery = CENTER_Y + offset_y
    screen.blit(sprite, entity_rect)

    # display healthbar
    hback_rect = pygame.Rect(entity_rect.left,
                             entity_rect.bottom,
                             entity_rect.width,
                             HBAR_HEIGHT)
    prop_fill = entity.HP/entity.maxHP
    hfill_rect = pygame.Rect(entity_rect.left,
                             entity_rect.bottom,
                             int(entity_rect.width*prop_fill),
                             HBAR_HEIGHT)

    hp_text = hp_font.render(str(entity.HP)+'/'+str(entity.maxHP), True, HP_TEXT_COLOR)
    hp_text_rect = hp_text.get_rect()
    hp_text_rect.centerx = hback_rect.centerx
    hp_text_rect.centery = hback_rect.centery

    screen.fill(HBACK_COLOR, rect=hback_rect)
    screen.fill(HFILL_COLOR, rect=hfill_rect)
    screen.blit(hp_text, hp_text_rect)

def display_text(display_str):
    text = font.render(display_str, True, TEXT_COLOR, BG_COLOR)
    text_rect = text.get_rect()
    text_rect.centerx = CENTER_X + TEXT_OFF_X
    text_rect.centery = CENTER_Y + TEXT_OFF_Y

    screen.blit(text, text_rect)

def display(gstate, display_str):
    screen.fill(BG_COLOR)

    display_entity(gstate.player, player_sprite, offset_x=PLAYER_OFF_X, offset_y=PLAYER_OFF_Y)
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

    pygame.time.set_timer(pygame.USEREVENT, 10)

    while not done:
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
            elif event.type == pygame.USEREVENT:
                ticks += 1
                if ticks%GAME_FRAME == 0:
                    gstate.tick()
                    gstate.pretty_print()

if __name__ == '__main__':
    main()
