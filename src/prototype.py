from __future__ import print_function, division
import pygame
import math

from models.gamestate import GameState, GameMode

# one frame = 10 ms
PRINT_GAMESTATE_FRAME = 500

ENEMY_OFF_X = -200
ENEMY_OFF_Y = -300
ENEMY_PAD = 5

PROJ_BEGIN = ENEMY_OFF_Y + 100
PROJ_DIST = 200
PROJ_END = PROJ_BEGIN + PROJ_DIST
PROJ_SIZE = (100, 100)

TEXT_OFF_X = 0
TEXT_OFF_Y = 210

PLAYER_OFF_X = 0
PLAYER_OFF_Y = 280

TILE_OFF_X = 0
TILE_OFF_Y = 150

#distance from right side of screen
SKILL_OFF_X = -100
#distance from top of screen
SKILL_OFF_Y = 400
SKILL_WIDTH = 50
SKILL_HEIGHT = 50
SKILL_PAD = 10

HBAR_HEIGHT = 15
NAMEBAR_HEIGHT = 15

BG_COLOR = (159, 182, 205)
HFILL_COLOR = (255, 0, 0)
HBACK_COLOR = (0, 0, 0)
TEXT_COLOR = (255, 255, 255)
TILE_COLOR = (200, 210, 140)
TILE_COLOR_DEFENSE = (100, 100, 100)
HP_TEXT_COLOR = (255, 255, 255)
NAME_TEXT_COLOR = (255, 255, 255)
SKILL_COOLDOWN_COLOR = (0, 255, 0)

FONT_SIZE = 50
HP_FONT_SIZE = 20
NAME_FONT_SIZE = 20
SKILL_FONT_SIZE = 70

pygame.init()
screen = pygame.display.set_mode( (1000,1000) )
pygame.display.set_caption('Typing in things')
screen.fill(BG_COLOR)

CENTER_X = screen.get_rect().centerx
CENTER_Y = screen.get_rect().centery

font = pygame.font.Font(None, FONT_SIZE)
hp_font = pygame.font.Font(None, HP_FONT_SIZE)
name_font = pygame.font.Font(None, HP_FONT_SIZE)
skill_font = pygame.font.Font(None, SKILL_FONT_SIZE)

enemy_sprite = pygame.image.load('../art/smallboss.png').convert()
proj_sprite = pygame.transform.scale(pygame.image.load('../art/rock.jpg').convert(), (PROJ_SIZE))
player_sprite = pygame.image.load('../art/player.png').convert()
recycle_sprite = pygame.image.load('../art/recycle.jpg').convert()

skill_bar_sprites = [recycle_sprite]

# Display functions
def display_tiles(gstate):
    if gstate.game_mode == GameMode.OFFENSE:
        color = TILE_COLOR
    else:
        color = TILE_COLOR_DEFENSE
    text = font.render(''.join(gstate.pool), True, color, BG_COLOR)
    text_rect = text.get_rect()
    text_rect.centerx = CENTER_X + TILE_OFF_X
    text_rect.centery = CENTER_Y + TILE_OFF_Y   

    screen.blit(text, text_rect)

def display_enemies(gstate):
    for ind, enemy in enumerate(gstate.enemies):
        # TODO: center these dudes
        offset_x = ind*(enemy_sprite.get_width() + ENEMY_PAD) + ENEMY_OFF_X
        display_entity(enemy, enemy_sprite, offset_x, ENEMY_OFF_Y)

def display_projectiles(gstate):
    print(len(gstate.projectiles))
    for ind, proj in enumerate(gstate.projectiles):
        yfrac = 1-proj.time / proj.max_time
        y = PROJ_BEGIN + PROJ_DIST * yfrac
        x = ind*(enemy_sprite.get_width() + ENEMY_PAD) + ENEMY_OFF_X
        display_entity(proj, proj_sprite, x, y)

def display_skills(gstate):
    for skill_button, skill in gstate.player.skill_bar.items():
        skill_index = int(skill_button)-1
        skill_sprite = skill_bar_sprites[skill_index]
        skill_sprite = pygame.transform.scale(skill_sprite, (SKILL_WIDTH, SKILL_HEIGHT))

        skill_rect = skill_sprite.get_rect()
        skill_rect.centerx = screen.get_rect().right + SKILL_OFF_X
        skill_rect.centery = skill_index*(SKILL_HEIGHT + SKILL_PAD) + SKILL_OFF_Y
        screen.blit(skill_sprite, skill_rect)

        #display cooldown text
        cooldown_seconds = int(math.ceil(skill.cooldown/100))
        cooldown_text = skill_font.render(str(cooldown_seconds), False, SKILL_COOLDOWN_COLOR)
        cooldown_transparent = pygame.Surface(cooldown_text.get_size())
        cooldown_transparent.blit(cooldown_text, (0,0))
        cooldown_transparent.set_colorkey((0,0,0))
        cooldown_transparent.set_alpha(150)
        cooldown_rect = cooldown_transparent.get_rect()
        cooldown_rect.centerx = skill_rect.centerx
        cooldown_rect.centery = skill_rect.centery
        screen.blit(cooldown_transparent, cooldown_rect)

        cooldown_proportion = skill.cooldown/skill.max_cooldown
        cooldown_background_width = int(cooldown_proportion*SKILL_WIDTH)
        cooldown_background = pygame.Surface((cooldown_background_width, SKILL_HEIGHT))
        cooldown_background.set_alpha(60)
        screen.blit(cooldown_background, skill_rect)

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

    # display entity name
    name_text = name_font.render(entity.name, True, NAME_TEXT_COLOR)
    name_text_rect = pygame.Rect(entity_rect.left, entity_rect.top - NAMEBAR_HEIGHT, entity_rect.width, NAMEBAR_HEIGHT)
    screen.blit(name_text, name_text_rect)

    hp_text = hp_font.render(entity.disp_str(), True, HP_TEXT_COLOR)
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
    display_projectiles(gstate)
    display_skills(gstate)
    display_text(display_str)

    pygame.display.update()

def main():
    gstate = GameState()
    ticks = 0

    done = False
    disp_str = ''

    letter_keys = range(pygame.K_a, pygame.K_z+1)
    skill_keys = range(pygame.K_1, pygame.K_9+1)
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    gstate.pretty_print()

    pygame.time.set_timer(pygame.USEREVENT, 10)

    while not done:
        display(gstate, disp_str)

        for event in pygame.event.get():
            if gstate.is_game_over(): # Eat events so we can still interact - only exit game is allowed
                if event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE:
                    done = True
                continue
            if event.type == pygame.KEYDOWN:
                if event.key in letter_keys:
                    disp_str += chr(event.key).upper()
                elif event.key in skill_keys:
                    skill_key = chr(event.key)
                    skill = gstate.player.skill_bar.get(skill_key, None)
                    if skill:
                        skill.activate(gstate)
                elif event.key == pygame.K_BACKSPACE:
                    disp_str = disp_str[:-1]
                elif event.key == pygame.K_RETURN:
                    if gstate.game_mode == GameMode.OFFENSE:
                        gstate.process_attack(disp_str)
                    elif gstate.game_mode == GameMode.DEFENSE:
                        gstate.process_defense(disp_str)
                    disp_str = ''
                    gstate.pretty_print()
                elif event.key == pygame.K_TAB:
                    gstate.switch_modes()
                elif event.key == pygame.K_ESCAPE:
                    done = True
            elif event.type == pygame.USEREVENT:
                ticks += 1
                gstate.tick()
                if ticks%PRINT_GAMESTATE_FRAME == 0:
                    gstate.pretty_print()

if __name__ == '__main__':
    main()
