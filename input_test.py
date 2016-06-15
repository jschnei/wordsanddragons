import pygame

from models import GameState

GAME_FRAME = 5000

TEXT_OFF_X = 0
TEXT_OFF_Y = 210

TILE_OFF_X = 0
TILE_OFF_Y = 150

TEXT_COLOR = (255, 255, 255)
TILE_COLOR = (200, 210, 140)
BG_COLOR = (159, 182, 205)

FONT_SIZE = 50

pygame.init()
screen = pygame.display.set_mode( (640,480) )
pygame.display.set_caption('Typing in things')
screen.fill(BG_COLOR)

font = pygame.font.Font(None, FONT_SIZE)

enemy = pygame.image.load('art/theboss.png').convert()

# Display functions
def display_tiles(gstate):
    text = font.render(''.join(gstate.pool), True, TILE_COLOR, BG_COLOR)
    textRect = text.get_rect()
    textRect.centerx = screen.get_rect().centerx + TILE_OFF_X
    textRect.centery = screen.get_rect().centery + TILE_OFF_Y

    screen.blit(text, textRect)


def display_enemy(gstate):
    enemyRect = enemy.get_rect()
    enemyRect.centerx = screen.get_rect().centerx
    enemyRect.centery = screen.get_rect().centery
    screen.blit(enemy, enemyRect)

def display_text(display_str):
    text = font.render(display_str, True, TEXT_COLOR, BG_COLOR)
    textRect = text.get_rect()
    textRect.centerx = screen.get_rect().centerx + TEXT_OFF_X
    textRect.centery = screen.get_rect().centery + TEXT_OFF_Y

    screen.blit(text, textRect)

def display(gstate, display_str):
    screen.fill(BG_COLOR)

    display_enemy(gstate)
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
