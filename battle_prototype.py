import random

ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
LETTER_FREQ = [.08167, .01492, .02782, .04253, .12702, .02228, .02015, .06094, .06966, .00153, .00772, .04025, .02406, .06749, .07507, .01929, .00095, .05987, .06327, .09056, .02758, .00978, .02361, .00150, .01974, .00074]
POOL_SIZE = 10

def weighted_choice(choices):
   total = sum(w for c, w in choices)
   r = random.uniform(0, total)
   upto = 0
   for c, w in choices:
      if upto + w >= r:
         return c
      upto += w
   assert False, "Shouldn't get here"

def generate_pool(partial=[]):
    assert len(partial) <= POOL_SIZE, "Too many letters in partial pool"
    choices = zip(ALPHABET, LETTER_FREQ)
    return partial + [weighted_choice(choices) for _ in xrange(POOL_SIZE - len(partial))]

def generate_enemy():
    return Enemy()

def get_damage(attack):
    return 1
    
def process_attack(attack, pool):
    used_pool = [[p, False] for p in pool]
    
    for letter in attack:
        try:
            letter_index = used_pool.index([letter, False])
        except ValueError:
            return False
        used_pool[letter_index][1] = True
        
    new_pool = [p[0] for p in used_pool if not p[1]]
    return new_pool

class Enemy:
    def __init__(self):
        self.HP = 10
        self.name = 'standard_enemy'
        self.attack_damage = 1
        self.alive = True

    def take_damage(self, damage):
        self.HP -= damage
        if self.HP <=0:
            self.die()

    def die(self):
        print 'I died'
        self.alive = False

    def attack(self, target):
        target.take_damage(self.attack_damage)

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ']'

class Player:
    def __init__(self):
        self.HP = 50
        self.name = 'player'
        self.attack_damage = 1
        self.alive = True

    def take_damage(self, damage):
        self.HP -= damage
        if self.HP <=0:
            self.die()

    def die(self):
        print 'I died'
        self.alive = False

    def __str__(self):
        return '['+self.name + ' ' + str(self.HP) + ']'


def main():
    player = Player()
    pool = generate_pool()
    enemy = generate_enemy()
    enemies = [enemy]
    dead_enemies = []
    turn = 0
    while(True):
        turn += 1
        print pool
        print player
        for enemy in enemies:
            print enemy
        attack = raw_input('Type a word from the pool: ').upper()
        new_pool = process_attack(attack, pool)
        if not new_pool:
            print("You dumbo!")
        else:           
            # resolve combat
            damage = get_damage(attack)  
            for enemy in enemies:
                enemy.take_damage(damage)
                if not enemy.alive:
                    dead_enemies.append(enemy)
                else:
                    enemy.attack(player)
            for dead in dead_enemies:
                enemies.remove(enemy) # does this work
            dead_enemies = []
            
            # update the pool
            pool = generate_pool(new_pool)

        if turn % 10 == 0:
            enemies.append(generate_enemy())

    print ('You won!')


main()