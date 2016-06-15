import pygame

TEXT_OFF_X = 0
TEXT_OFF_Y = 150

TEXT_COLOR = (255, 255, 255)
BG_COLOR = (159, 182, 205)

FONT_SIZE = 50

pygame.init()
screen = pygame.display.set_mode( (640,480) )
pygame.display.set_caption('Typing in things')
screen.fill(BG_COLOR)

font = pygame.font.Font(None, FONT_SIZE)

enemy = pygame.image.load('art/theboss.png').convert()


def display_enemy():
    enemyRect = enemy.get_rect()
    enemyRect.centerx = screen.get_rect().centerx
    enemyRect.centery = screen.get_rect().centery
    screen.blit(enemy, enemyRect)


def display_text(str):
    text = font.render(str, True, TEXT_COLOR, BG_COLOR)
    textRect = text.get_rect()
    textRect.centerx = screen.get_rect().centerx + TEXT_OFF_X
    textRect.centery = screen.get_rect().centery + TEXT_OFF_Y

    screen.blit(text, textRect)

def display(str):
    screen.fill(BG_COLOR)
    display_enemy()
    display_text(str)
    pygame.display.update()

def main():
    num = 0
    done = False
    disp_str = ''

    letter_keys = range(pygame.K_a, pygame.K_z+1)
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    while not done:
        display(disp_str)

        for event in pygame.event.get():
            if event.type == pygame.KEYDOWN:
                if event.key in letter_keys:
                    disp_str += alphabet[event.key-pygame.K_a]
                elif event.key == pygame.K_BACKSPACE:
                    disp_str = disp_str[:-1]
                elif event.key == pygame.K_ESCAPE:
                    done = True

if __name__ == '__main__':
    main()
