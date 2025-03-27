'From Cuis7.3 [latest update: #7066] on 27 March 2025 at 6:00:44 pm'!
'Description '!
!provides: 'MemoryGameV2' 1 7!
SystemOrganization addCategory: 'MemoryGameV2'!


!classDefinition: #MemoryCardModel category: 'MemoryGameV2'!
Object subclass: #MemoryCardModel
	instanceVariableNames: 'flipped done color'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV2'!
!classDefinition: 'MemoryCardModel class' category: 'MemoryGameV2'!
MemoryCardModel class
	instanceVariableNames: ''!

!classDefinition: #MemoryGame category: 'MemoryGameV2'!
Object subclass: #MemoryGame
	instanceVariableNames: 'model view playing'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV2'!
!classDefinition: 'MemoryGame class' category: 'MemoryGameV2'!
MemoryGame class
	instanceVariableNames: ''!

!classDefinition: #MemoryGameModel category: 'MemoryGameV2'!
Object subclass: #MemoryGameModel
	instanceVariableNames: 'size tupleSize cards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV2'!
!classDefinition: 'MemoryGameModel class' category: 'MemoryGameV2'!
MemoryGameModel class
	instanceVariableNames: ''!

!classDefinition: #MemoryGameWindow category: 'MemoryGameV2'!
SystemWindow subclass: #MemoryGameWindow
	instanceVariableNames: 'presenter statusBar playground'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV2'!
!classDefinition: 'MemoryGameWindow class' category: 'MemoryGameV2'!
MemoryGameWindow class
	instanceVariableNames: ''!


!MemoryGame commentStamp: '<historical>' prior: 0!
I am the presenter of the Memory Game. I create the model of the game and I handle the user interaction.!

!MemoryGameWindow commentStamp: '<historical>' prior: 0!
A memory game based on finding identical squares of the same color.!

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:14:16'!
backColor
	^ Color white! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:31:11'!
color
	^ color! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:31:11'!
color: anObject
	color := anObject! !

!MemoryCardModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 13:30:03'!
setDone
	done := true! !

!MemoryCardModel methodsFor: 'testing' stamp: 'hlsf 3/22/2025 13:30:12'!
isDone
	^ done! !

!MemoryCardModel methodsFor: 'testing' stamp: 'hlsf 3/22/2025 13:15:39'!
isFlipped
	^ flipped! !

!MemoryCardModel methodsFor: 'updating' stamp: 'hlsf 3/22/2025 19:40:34'!
flip
	| newColor |
	flipped := flipped not.
	newColor := flipped ifTrue: [color ] ifFalse: [self backColor].
	self triggerEvent: #color with: newColor! !

!MemoryCardModel methodsFor: 'updating' stamp: 'hlsf 3/22/2025 15:53:33'!
flipFlash
	self flip.
	self triggerEvent: #flash! !

!MemoryCardModel methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 13:28:57'!
initialize
	super initialize.
	done := flipped := false! !

!MemoryGame methodsFor: 'callback ui' stamp: 'hlsf 3/22/2025 22:41:36'!
flip: position
	| flippedCards |
	(model cards at: position) 
		flip;
		triggerEvent: #lock.	
	
	" Do the flipped cards share the same color? "
	flippedCards := model flippedCards.
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
		flippedCards do: [:aCard | aCard triggerEvent: #flash].
		flippedCards do: #setDone.
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

!MemoryGame methodsFor: 'callback ui' stamp: 'hlsf 3/22/2025 22:27:53'!
stopGame
	playing := false.
	view message: 'Game over'.
	view setLabel: 'G A M E   S T O P P E D'.
	model undoneCards do: [:aCard |
		aCard triggerEvent: #flash; flip.
		view world doOneCycleNow]! !

!MemoryGame methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 22:25:51'!
initialize
	model := MemoryGameModel new.
	view := MemoryGameWindow presenter: self.
	self startGame.
	view openInWorld.! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 3/22/2025 15:42:24'!
isPlayed
	^ playing ! !

!MemoryGame methodsFor: 'testing' stamp: 'hlsf 3/22/2025 15:42:35'!
isStopped
	^ self isPlayed not! !

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

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:09:49'!
doneCards
	| doneCards |
	doneCards := OrderedCollection new.	
	cards do: [:aCard | 
		aCard isDone ifTrue: [doneCards add: aCard] ].
	^ doneCards ! !

!MemoryGameModel methodsFor: 'accessing' stamp: 'hlsf 3/22/2025 15:10:37'!
flippedCards
	| flippedCards |
	flippedCards := OrderedCollection new.	
	cards do: [:aCard | 
		(aCard isDone not and: [aCard isFlipped]) ifTrue: [flippedCards add: aCard] ].
	^ flippedCards ! !

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

!MemoryGameModel methodsFor: 'testing' stamp: 'hlsf 3/22/2025 15:13:27'!
isGameWon
	| doneCards |
	doneCards := OrderedCollection new.	
	cards do: [:aCard | 
		aCard isDone ifTrue: [doneCards add: aCard] ].
	^ doneCards size = (size x * size y)! !

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

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 22:18:57'!
installCards
	| row size |
	playground removeAllMorphs.
	size := model size.
	1 to: size y do: [:y |
		row := LayoutMorph newRow.
		1 to: size x do: [:x | | cardModel cardView |
			cardModel := model cards at: x@y.
			cardView := PluggableButtonMorph model: presenter action: #flip: actionArgument: x@y.
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

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/22/2025 15:40:23'!
installToolbar
	| toolbar button |
	toolbar := LayoutMorph newRow separation: 2.
	button := PluggableButtonMorph model: presenter action: #startGame :: 
		enableSelector: #isStopped;
		icon: Theme current playIcon;
		borderWidth: 2;
		borderColor: Color black;
		setBalloonText: 'Play the game';
		morphExtent: 32 asPoint.
	toolbar addMorph: button.
	button := PluggableButtonMorph model: presenter action: #stopGame :: 
		enableSelector: #isPlayed;
		icon: Theme current stopIcon;
		setBalloonText: 'Stop the game';
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
