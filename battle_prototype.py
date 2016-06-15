from __future__ import print_function, division

from models import GameState

def main():
    gstate = GameState()
    while(True):
        print(gstate.pool)
        print(gstate.player)
        for enemy in gstate.enemies:
            print(enemy)

        attack = input('Type a word from the pool: ').strip().upper()
        gstate.process_attack(attack)

#        if turn % 10 == 0:
            #enemies.add(generate_enemy())


if __name__ == '__main__':
    main()
