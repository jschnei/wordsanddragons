package;
import combat.CombatHandler;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
using Lambda;

class NPCScripts
{
    public static function interactItemGate(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.dialogueHUD;
        dialogueHUD.addLine("You may have gotten past the gates...");
        dialogueHUD.addLine("but I have one final question:");
        dialogueHUD.addLine("What is the answer to the puzzle?");
        //FlxTween.tween(npc, { x: 50}, .33, { ease: FlxEase.circOut});
        playState.startDialogue();
    }

    public static function speakItemGate(npc:NPCSprite, playState:PlayState, speech:String):Void
    {
        var actionQueue:ActionQueue = new ActionQueue();
        actionQueue.addAction(
            function()
            {
                var dialogueHUD:DialogueHUD = playState.dialogueHUD;
                if (speech=="BLADES")
                {
                    dialogueHUD.addLine("No, anything but the BLADES! Don't kill me!");
                    dialogueHUD.addLine("I'll let you through now!");
                    actionQueue.addAction(NPCActions.moveSprite(npc, actionQueue));
                }
                else
                {
                    dialogueHUD.addLine(speech + " is correct!!!!");
                    dialogueHUD.addLine("Just kidding.");
                }
                playState.startDialogue(actionQueue.next);
            });
        actionQueue.next();
    }

    public static function interactItemNPC(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.dialogueHUD;
        dialogueHUD.addLine("Hello, my name is " + npc.name + "!");
        dialogueHUD.addLine("I can open a gate, but you have to give me something I like.");
        switch(npc.name)
        {
            case "bob1":
                dialogueHUD.addLine("I like literally everything!");
            case "bob2":
                dialogueHUD.addLine("I like words that have double letters!");
            case "bob3":
                dialogueHUD.addLine("I like words that are 6 letters long!");
            case "bob4":
                dialogueHUD.addLine("I like words that begin and end with the same letter!");
            case "bob5":
                dialogueHUD.addLine("I like words that only contain one unique vowel!");
            case "bob6":
                dialogueHUD.addLine("I like words that are also words backwards!");
        }
        dialogueHUD.addLine("What do you want to give me?");
        playState.startDialogue();
    }

    public static function speakItemNPC(npc:NPCSprite, playState:PlayState, speech:String):Void
    {
        var actionQueue:ActionQueue = new ActionQueue();
        actionQueue.addAction(
            function()
            {
                var dialogueHUD:DialogueHUD = playState.dialogueHUD;
                var inventory:FlxTypedGroup<Item> = playState.inventoryHUD.inventory;
                if (!inventory.members.exists(function(item) return item.name==speech))
                {
                    dialogueHUD.addLine("You don't have " + speech + ", silly!");
                }
                else
                {
                    var npcLikes = false;
                    var npcNum = 0;
                    switch(npc.name)
                    {
                        case "bob1":
                            npcLikes = true;
                            npcNum = 1;
                        case "bob2":
                            npcLikes = hasDoubleLetter(speech);
                            npcNum = 2;
                        case "bob3":
                            npcLikes = (speech.length==6);
                            npcNum = 3;
                        case "bob4":
                            npcLikes = (speech.charAt(0)==speech.charAt(speech.length-1));
                            npcNum = 4;
                        case "bob5":
                            npcLikes = hasUniqueVowel(speech);
                            npcNum = 5;
                        case "bob6":
                            npcLikes = (speech=="SPOONS"); // only word in the english language which satisfies this property
                            npcNum = 6;
                    }
                    if (npcLikes)
                    {
                        var givenItem:Item = inventory.members.find(function(item) return item.name==speech);
                        inventory.remove(givenItem, true);
                        dialogueHUD.addLine("Thanks, I really like " + speech + "!");
                        dialogueHUD.addLine("I will open the gate now!");
                        var gate:NPCSprite = playState.level.grpNPCs.members.find(function(npc) return npc.name==("gate"+npcNum));
                        actionQueue.addAction(NPCActions.killSprite(gate, actionQueue));
                    }
                    else
                    {
                        dialogueHUD.addLine("I don't like " + speech + "!");
                    }

                }
                playState.startDialogue(actionQueue.next);
            });

        actionQueue.next();
    }

    private static function hasDoubleLetter(string:String):Bool
    {
        for (i in 0...string.length-1)
        {
            if (string.charAt(i)==string.charAt(i+1))
            {
                return true;
            }
        }
        return false;
    }

    private static function hasUniqueVowel(string:String):Bool
    {
        var vowelCounts = [0,0,0,0,0];
        for (i in 0...string.length)
        {
            if (string.charAt(i)=="A")
                vowelCounts[0]++;
            if (string.charAt(i)=="E")
                vowelCounts[1]++;
            if (string.charAt(i)=="I")
                vowelCounts[2]++;
            if (string.charAt(i)=="O")
                vowelCounts[3]++;
            if (string.charAt(i)=="U")
                vowelCounts[4]++;
        }
        return (vowelCounts.count(function(i) return i==0)>=4);
    }

    public static function interactGate(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.dialogueHUD;
        dialogueHUD.addLine("It's a gate. You can't get past it.");
        dialogueHUD.addLine("I know it looks like a trashcan, but pretend it's a gate.");
        playState.startDialogue();
    }

    public static function interactGuard(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.dialogueHUD;
        dialogueHUD.addLine("I AM THE GUARD!");
        dialogueHUD.addLine("WHAT IS THE PASSWORD?");
        dialogueHUD.addLine("ANSWER INCORRECTLY, AND DIE!");
        playState.startDialogue();
    }

    public static function speakGuard(npc:NPCSprite, playState:PlayState, speech:String)
    {
        var actionQueue:ActionQueue = new ActionQueue();
        actionQueue.addAction(
            function()
            {
                var dialogueHUD:DialogueHUD = playState.dialogueHUD;
                dialogueHUD.addLine("YOU SAID " + speech + ".");
                if(speech=="SWORDFISH")
                {
                    dialogueHUD.addLine("THAT IS THE PASSWORD.");
                    dialogueHUD.addLine("YOU MAY PROCEED.");
                    actionQueue.addAction(
                        function()
                        {
                            npc.immovable=false;
                            actionQueue.next();
                        });
                }
                else
                {
                    dialogueHUD.addLine("INCORRECT!");
                    actionQueue.addAction(NPCActions.killSprite(playState.level.player, actionQueue));
                }
                playState.startDialogue(actionQueue.next);
            });

        actionQueue.next();
    }

    public static function interactTeller(npc:NPCSprite, playState:PlayState):Void
    {
        var dialogueHUD:DialogueHUD = playState.dialogueHUD;
        dialogueHUD.addLine("psst.");
        dialogueHUD.addLine("the password is");
        dialogueHUD.addLine("SWORDFISH");
        playState.startDialogue();
    }

    public static function speakBob(npcStr:String, speech:String)
    {
        var playState:PlayState = Registry.currPlayState;
        var npc:NPCSprite = playState.level.getNPCByName(npcStr);

        var actionQueue:ActionQueue = new ActionQueue();
        actionQueue.addAction(
            function()
            {
                var dialogueHUD:DialogueHUD = playState.dialogueHUD;
                dialogueHUD.addLine("You said " + speech);
                dialogueHUD.addLine("I like " + speech + "!");
                if(speech=="SWORDFISH")
                {
                    dialogueHUD.addLine("You solved the puzzle!");
                    actionQueue.addAction(NPCActions.killSprite(npc, actionQueue));
                }
                else
                {
                    actionQueue.addAction(NPCActions.oneLiner("I'm not dead yet!", actionQueue));
                }
                playState.startDialogue(actionQueue.next);
            });

        actionQueue.next();
    }

    public static function interactBob(npcStr:String):Void
    {
        var npc:NPCSprite = Registry.currPlayState.level.getNPCByName(npcStr);
        var actionQueue:ActionQueue = new ActionQueue();

        actionQueue.addAction(NPCActions.oneLiner("Prepare to die!", actionQueue));
        
        var combatAction = function(outcome:CombatOutcome) {
            if (outcome == CombatOutcome.WIN)
                return NPCActions.oneLiner("You won! You're so strong!", actionQueue);
            else if (outcome == CombatOutcome.LOSS)
                return NPCActions.oneLiner("You lost! You're so weak!", actionQueue);
            else
                return NPCActions.oneLiner("how did you get here", actionQueue);
        };

        actionQueue.addAction(NPCActions.doCombat(npc, actionQueue, combatAction));
        actionQueue.addAction(
            function(){
                var playState:PlayState = Registry.currPlayState;
                var npc:NPCSprite = playState.level.getNPCByName(npcStr);
                var dialogueHUD:DialogueHUD = playState.dialogueHUD;
                dialogueHUD.addLine("Yo, I'm " + npc.name + "!");
                dialogueHUD.addLine("Who are you?");
                playState.startDialogue(actionQueue.next);
            });
        actionQueue.next();
    }

}
