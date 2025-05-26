'From Cuis7.3 [latest update: #7158] on 24 May 2025 at 4:26:24 pm'!
'Description '!
!provides: 'MemoryGameV3' 1 3!
SystemOrganization addCategory: 'MemoryGameV3'!


!classDefinition: #Command category: 'MemoryGameV3'!
Object subclass: #Command
   instanceVariableNames: 'presenter'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'Command class' category: 'MemoryGameV3'!
Command class
   instanceVariableNames: ''!

!classDefinition: #PlayCardCommand category: 'MemoryGameV3'!
Command subclass: #PlayCardCommand
   instanceVariableNames: 'status position'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'PlayCardCommand class' category: 'MemoryGameV3'!
PlayCardCommand class
   instanceVariableNames: ''!

!classDefinition: #CommandManager category: 'MemoryGameV3'!
Object subclass: #CommandManager
   instanceVariableNames: 'stack presenter'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'CommandManager class' category: 'MemoryGameV3'!
CommandManager class
   instanceVariableNames: ''!

!classDefinition: #MemoryCardModel category: 'MemoryGameV3'!
Object subclass: #MemoryCardModel
   instanceVariableNames: 'flipped done color'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'MemoryCardModel class' category: 'MemoryGameV3'!
MemoryCardModel class
   instanceVariableNames: ''!

!classDefinition: #MemoryGame category: 'MemoryGameV3'!
Object subclass: #MemoryGame
   instanceVariableNames: 'model view playing cmdManager'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'MemoryGame class' category: 'MemoryGameV3'!
MemoryGame class
   instanceVariableNames: ''!

!classDefinition: #MemoryGameModel category: 'MemoryGameV3'!
Object subclass: #MemoryGameModel
   instanceVariableNames: 'size tupleSize cards'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'MemoryGameModel class' category: 'MemoryGameV3'!
MemoryGameModel class
   instanceVariableNames: ''!

!classDefinition: #CommandStack category: 'MemoryGameV3'!
ReadWriteStream subclass: #CommandStack
   instanceVariableNames: ''
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'CommandStack class' category: 'MemoryGameV3'!
CommandStack class
   instanceVariableNames: ''!

!classDefinition: #MemoryGameWindow category: 'MemoryGameV3'!
SystemWindow subclass: #MemoryGameWindow
   instanceVariableNames: 'presenter statusBar playground'
   classVariableNames: ''
   poolDictionaries: ''
   category: 'MemoryGameV3'!
!classDefinition: 'MemoryGameWindow class' category: 'MemoryGameV3'!
MemoryGameWindow class
   instanceVariableNames: ''!


!Command commentStamp: '<historical>' prior: 0!
An abstract class to represent commands of user actions in the game.
presenter is the game presenter!

!CommandManager commentStamp: '<historical>' prior: 0!
A manager for user commands. At user actions, I create specific instances of command recorded in a stack.!

!MemoryGame commentStamp: '<historical>' prior: 0!
I am the presenter of the Memory Game. I create the model of the game and I handle the user interaction.!

!CommandStack commentStamp: '<historical>' prior: 0!
I am stack of command to execute or to unexecute user action in a Document!

!MemoryGameWindow commentStamp: '<historical>' prior: 0!
A memory game based on finding identical squares of the same color.!

!Command methodsFor: 'command' stamp: 'hlsf 9/10/2024 21:05:57'!
execute
   self subclassResponsibility ! !

!Command methodsFor: 'command' stamp: 'hlsf 9/10/2024 21:06:19'!
unexecute
   self subclassResponsibility ! !

!Command methodsFor: 'accessing' stamp: 'hlsf 5/23/2025 17:18:48'!
presenter: aPresenter
   presenter := aPresenter ! !

!Command methodsFor: 'initialize-release' stamp: 'hlsf 9/10/2024 21:06:12'!
release
"Let my child do some clean up"! !

!Command class methodsFor: 'instance creation' stamp: 'hlsf 5/23/2025 19:14:23'!
for: aPresenter
   ^ self basicNew 
      presenter: aPresenter ;
      initialize ! !

!PlayCardCommand methodsFor: 'updating' stamp: 'hlsf 5/23/2025 21:50:41'!
backupModels
   | size |
   size := presenter model cards size.
   1 to: size y do: [:y |
         1 to: size x do: [:x | | card |
            card := presenter model cards at: x@y.
            status at: x@y put: (Array with: card isFlipped  with: card isDone) ]]! !

!PlayCardCommand methodsFor: 'initialization' stamp: 'hlsf 5/23/2025 21:51:00'!
initialize
   status := Array2D newSize: presenter model cards size.
   ! !

!PlayCardCommand methodsFor: 'accessing' stamp: 'hlsf 5/23/2025 22:11:01'!
position: aPoint
   position := aPoint! !

!PlayCardCommand methodsFor: 'command' stamp: 'hlsf 5/23/2025 22:11:47'!
execute
   self backupModels.
   presenter flip: position! !

!PlayCardCommand methodsFor: 'command' stamp: 'hlsf 5/23/2025 22:26:00'!
unexecute
" Restore the status of the card models "
   | size |
   size := status size.
   1 to: size y do: [:y |
         1 to: size x do: [:x | | cardStatus card |
            card := presenter model cards at: x@y.
            cardStatus := status at: x@y.
            card 
               flip: cardStatus first;
               done: cardStatus second ] ]! !

!CommandManager methodsFor: 'initialize-release' stamp: 'hlsf 5/24/2025 10:00:33'!
initialize
   stack := CommandStack new! !

!CommandManager methodsFor: 'initialize-release' stamp: 'hlsf 5/24/2025 10:00:33'!
release
   stack contents do: [:c | c release].
   stack reset! !

!CommandManager methodsFor: 'commands' stamp: 'hlsf 5/24/2025 10:13:46'!
playCard: position
   | command |
   command := stack nextPut: (PlayCardCommand for: presenter).
   command position: position.
   ^ command execute! !

!CommandManager methodsFor: 'commands' stamp: 'hlsf 5/24/2025 10:00:33'!
redo
   | command |
   command := stack next.
   ^ command 
      ifNotNil:    [
         command execute.
         true]
      ifNil: [false]! !

!CommandManager methodsFor: 'commands' stamp: 'hlsf 5/24/2025 10:00:33'!
undo
   | command |
   command := stack previous.
   ^ command 
      ifNotNil: [
         command unexecute.
         true]
      ifNil: [false]! !

!CommandManager methodsFor: 'accessing' stamp: 'hlsf 5/23/2025 17:13:23'!
presenter: aPresenter
   presenter := aPresenter ! !

!CommandManager methodsFor: 'testing' stamp: 'hlsf 5/24/2025 10:02:15'!
canRedo
   ^ stack atEnd not! !

!CommandManager methodsFor: 'testing' stamp: 'hlsf 5/24/2025 10:02:06'!
canUndo
   ^ stack atStart not! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:14:16'!
backColor
   ^ Color white! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:31:11'!
color
   ^ color! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:31:11'!
color: anObject
   color := anObject! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 5/23/2025 22:22:01'!
done: boolean
   done = boolean ifTrue: [^ self].
   done := boolean.
   self triggerEvent: (done ifTrue: [#lock] ifFalse: [#unlock])! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 5/23/2025 22:18:00'!
flip: boolean
" Set my flip state and trigger a color event for my view accordingly to my flip state "
   | newColor |
   flipped = boolean ifTrue: [^ self].
   flipped := boolean.
   newColor := flipped ifTrue: [color ] ifFalse: [self backColor].
   self triggerEvent: #color with: newColor! !

!MemoryCardModel methodsFor: 'testing' stamp: 'hlsf 3/22/2025 13:30:12'!
isDone
   ^ done! !

!MemoryCardModel methodsFor: 'testing' stamp: 'hlsf 3/22/2025 13:15:39'!
isFlipped
   ^ flipped! !

!MemoryCardModel methodsFor: 'updating' stamp: 'hlsf 5/23/2025 21:56:48'!
flip
   " Reverse my flip state "
   self flip: flipped not! !

!MemoryCardModel methodsFor: 'updating' stamp: 'hlsf 5/23/2025 21:57:23'!
flipFlash
   " Flip & trigger a flash event for my view "
   self flip.
   self triggerEvent: #flash! !

!MemoryCardModel methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 13:28:57'!
initialize
   super initialize.
   done := flipped := false! !

!MemoryGame methodsFor: 'callback ui' stamp: 'hlsf 5/23/2025 21:53:20'!
flip: position
   | flippedCards |
   (model cards at: position) 
      flip;
      triggerEvent: #lock.   
   flippedCards := model flippedCards.
   " Do the flipped cards share the same color? "
   (flippedCards collect: [:aCard | aCard color]) asSet size = 1 ifFalse: [
      " NO "
      " Some delay for the player to see the colors of these flipped cards "
      view message: 'Colors do not match!!'.
      view world doOneCycleNow.
      (Delay forSeconds: 1) wait.
      " Unflip and unlock the flipped cards "
      flippedCards do: [:aCard | 
         aCard flip; 
            triggerEvent: #flash;
            triggerEvent: #unlock].
      ^ self].

   flippedCards size = model tupleSize ifTrue: [
      " We found a n-tuple!! "
      view message: 'Great!!' bold, ' You find a ', model tupleSize asString, '-tuple!!'.
      flippedCards do: [:aCard | 
         aCard triggerEvent: #flash;
         done: true].
      model isGameWon ifTrue: [
         view message: 'Congratuluation, you finished the game!!' bold red.
         playing := false] ]! !

!MemoryGame methodsFor: 'callback ui' stamp: 'hlsf 3/22/2025 22:28:33'!
startGame
   model installCardModels.
   view installCards.
   view message: 'Starting a new game' bold green.
   view setLabel: 'P L A Y I N G'.
   playing := true.
! !

!MemoryGame methodsFor: 'callback ui' stamp: 'hlsf 5/24/2025 16:24:36'!
stopGame
   playing := false.
   cmdManager release.
   view message: 'Game over'.
   view setLabel: 'G A M E   S T O P P E D'.
   model undoneCards do: [:aCard |
      aCard triggerEvent: #flash; flip.
      view world doOneCycleNow]! !

!MemoryGame methodsFor: 'initialization' stamp: 'hlsf 5/24/2025 10:13:20'!
initialize
   model := MemoryGameModel new.
   cmdManager := CommandManager new :: presenter: self.
   view := MemoryGameWindow presenter: self.
   self startGame.
   view openInWorld.! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 5/24/2025 10:02:37'!
canRedo
   ^ cmdManager canRedo ! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 5/24/2025 10:02:28'!
canUndo
   ^ cmdManager canUndo ! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 3/22/2025 15:42:24'!
isPlayed
   ^ playing ! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 3/22/2025 15:42:35'!
isStopped
   ^ self isPlayed not! !

!MemoryGame methodsFor: 'accessing' stamp: 'hlsf 5/24/2025 10:07:05'!
cmdManager
   ^ cmdManager ! !

!MemoryGame methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 22:07:58'!
model
   ^model! !

!MemoryGameModel methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 22:25:40'!
initialize   
   size := 4 @ 3.
   tupleSize := 2! !

!MemoryGameModel methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 15:35:13'!
installCardModels
   | colours |
   cards := Array2D newSize: size.
   colours := self distributeColors.
   1 to: size y do: [:y |
      1 to: size x do: [:x | 
         cards 
            at: x@y 
            put: (MemoryCardModel new color: colours removeFirst) ] ]! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:55:08'!
cards
   ^ cards! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:09:23'!
distributeColors
   | colors |
   colors := OrderedCollection new.
   size x * size y / tupleSize timesRepeat: [colors add: Color random].
   tupleSize - 1 timesRepeat: [colors := colors, colors].
   ^ colors shuffled! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 4/10/2025 10:55:03'!
doneCards
   ^ cards elements select: #isDone! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 4/10/2025 10:55:14'!
flippedCards
   ^ cards elements select: [:aCard | aCard isDone not and: [aCard isFlipped] ]! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:55:16'!
size
   ^ size! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 19:23:33'!
tupleSize
   ^ tupleSize ! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:10:50'!
undoneCards
   ^ cards elements asOrderedCollection 
      removeAll: self doneCards;
      yourself.! !

!MemoryGameModel methodsFor: 'testing' stamp: 'hlsf 4/10/2025 10:54:49'!
isGameWon
   ^ (cards elements select: #isDone) size = (size x * size y)! !

!CommandStack methodsFor: 'private' stamp: 'hlsf 9/10/2024 21:00:31'!
truncate
   |oldReadLimit|
   oldReadLimit := readLimit.
   readLimit := position.
   oldReadLimit > readLimit ifTrue:
         [readLimit to: oldReadLimit do:
            [:index| collection at: index + 1 put: nil]]! !

!CommandStack methodsFor: 'accessing' stamp: 'hlsf 9/10/2024 21:00:20'!
nextPut: aCommand
   super nextPut: aCommand.
   self truncate.
   ^ aCommand ! !

!CommandStack methodsFor: 'accessing' stamp: 'hlsf 9/10/2024 21:00:26'!
previous
   self position = 0 ifTrue: [^nil].
   self position: self position - 1.
   ^self peek.! !

!CommandStack methodsFor: 'as yet unclassified' stamp: 'hlsf 10/26/2024 14:58:31'!
reset
   super reset.
   self truncate! !

!CommandStack class methodsFor: 'instance creation' stamp: 'hlsf 9/10/2024 21:01:01'!
new
   ^self on: Array new! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 18:52:39'!
adoptWidgetsColor: paneColor
" Does nothing, let the buttons have their own colors "! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/16/2025 17:16:57'!
message: aText
   statusBar contents: aText ;
      redrawNeeded ! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:38:00'!
presenter: aPresenter
   presenter := aPresenter.
   self model: presenter model! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 22:25:57'!
initialize
   super initialize.
   playground := LayoutMorph newColumn.
   self installToolbar.
   self addMorph: playground.
   self installStatusBar ! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 5/24/2025 10:08:12'!
installCards
   | row size |
   playground removeAllMorphs.
   size := model size.
   1 to: size y do: [:y |
      row := LayoutMorph newRow.
      1 to: size x do: [:x | | cardModel cardView |
         cardModel := model cards at: x@y.
         cardView := PluggableButtonMorph 
            model: presenter cmdManager action: #playCard: actionArgument: x@y.
         cardModel 
            when: #color send: #color: to: cardView;
            when: #lock send:#lock to: cardView;
            when: #unlock send: #unlock to: cardView;
            when: #flash send: #flash to: cardView.         
         cardView layoutSpec proportionalWidth: 1; proportionalHeight: 1.
         cardView color: cardModel backColor.
         row addMorph: cardView].
      playground addMorph: row ]! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/18/2025 23:14:00'!
installStatusBar
   statusBar := TextParagraphMorph new
         padding: 2;
         color: Color transparent;
         borderWidth: 1;
         borderColor: self borderColor twiceLighter ;
         setHeightOnContent.
   self addMorph: statusBar layoutSpec: LayoutSpec new useMorphHeight.
   self message: 'Welcome to ', 'Memory Game' bold! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 5/24/2025 10:32:50'!
installToolbar
   | toolbar button |
   toolbar := LayoutMorph newRow separation: 2.
   button := PluggableButtonMorph model: presenter action: #startGame :: 
      enableSelector: #isStopped;
      icon: Theme current playIcon;
      setBalloonText: 'Play the game';
      morphExtent: 32 asPoint.
   toolbar addMorph: button.
   button := PluggableButtonMorph model: presenter action: #stopGame :: 
      enableSelector: #isPlayed;
      icon: Theme current stopIcon;
      setBalloonText: 'Stop the game';
      morphExtent: 32 asPoint.
   toolbar addMorph: button.
   button := PluggableButtonMorph model: presenter cmdManager action: #undo :: 
      enableSelector: #canUndo;
      icon: Theme current undoIcon ;
      setBalloonText: 'Undo the last play';
      morphExtent: 32 asPoint.
   toolbar addMorph: button.
   button := PluggableButtonMorph model: presenter cmdManager action: #redo :: 
      enableSelector: #canRedo;
      icon: Theme current redoIcon ;
      setBalloonText: 'Redo the last play';
      morphExtent: 32 asPoint.
   toolbar addMorph: button.
   self addMorph: toolbar layoutSpec: LayoutSpec new useMorphHeight
! !

!MemoryGameWindow class methodsFor: 'instance creation' stamp: 'hlsf 3/22/2025 15:37:23'!
presenter: aPresenter
   ^ self basicNew
      presenter: aPresenter ;
      initialize ;
      yourself! !
