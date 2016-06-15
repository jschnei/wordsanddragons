from __future__ import print_function, division

from models import GameState

def main():
    gstate = GameState()
    while(True):
        gstate.pretty_print()

        attack = input('Type a word from the pool: ').strip().upper()
        gstate.process_attack(attack)


if __name__ == '__main__':
    main()
