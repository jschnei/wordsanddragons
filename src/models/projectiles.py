import random

import util

import models.common
import models.skills

class Projectile(models.common.Entity):
    def __init__(self, maxHP,
                       name,
                       attack_damage,
                       ttc):
        super(Projectile, self).__init__(maxHP, name, attack_damage)
        self.on_collide = None
        self.ttc = ttc
        self.max_ttc = self.ttc

    def defense_priority(self, attack):
        raise NotImplementedError()

    def process_defense(self, attack, gstate):
        raise NotImplementedError()

    def tick(self, gstate):
        self.ttc -= 1
        if self.ttc == 0:
            self.collide(gstate)

    def collide(self, gstate):
        gstate.player.take_damage(self.attack_damage)
        self.die()

class RockProjectile(Projectile):
    def __init__(self, maxHP=1,
                       name='rock',
                       attack_damage=6,
                       ttc=1000,
                       length=6):
        super(RockProjectile, self).__init__(maxHP, name, attack_damage, ttc)

        self.letters = sorted(util.random_word(length=length))
        random.shuffle(self.letters)
        print("QUICK ANAGRAM THIS: " + str(self.letters))

    def defense_priority(self, attack):
        if attack not in util.WORDLIST:
            return (0,)

        freq_attack = util.get_freq(attack)
        freq_letters = util.get_freq(self.letters)
        if not util.contained_in(freq_attack, freq_letters):
            return (0,)

        if len(attack)==len(self.letters):
            return (2, self.ttc)
        else:
            return (1, len(attack), self.ttc)

    def process_defense(self, attack, gstate):
        if attack not in util.WORDLIST:
            return

        freq_attack = util.get_freq(attack)
        freq_letters = util.get_freq(self.letters)
        if not util.contained_in(freq_attack, freq_letters):
            return

        gstate.player.take_damage(self.attack_damage - len(attack))
        self.die()

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ' ' + str(self.letters) + ']'
