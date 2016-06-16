import models.common
import models.skills

class Enemy(models.common.Entity):
    def __init__(self, maxHP=30, name='anderson', attack_damage=1):
        super(Enemy, self).__init__(maxHP, name, attack_damage)
        self.passives.append(models.skills.skill_attack_player(attack_damage))

class DoubleLetterEnemy(Enemy):
    def __init__(self, maxHP=10, name='phillip', attack_damage=1):
        super(DoubleLetterEnemy, self).__init__(maxHP, name, attack_damage)

    def calculate_damage_taken(self, attack_word):
        has_double_letter = False
        for i in range(len(attack_word)-1):
            if attack_word[i]==attack_word[i+1]:
                has_double_letter = True

        if has_double_letter:
            return len(attack_word)
        else:
            return 1
