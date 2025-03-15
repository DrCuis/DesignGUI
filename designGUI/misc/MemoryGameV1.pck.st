'From Cuis7.3 [latest update: #7066] on 15 March 2025 at 3:44:24 pm'!
'Description '!
!provides: 'MemoryGameV1' 1 0!
SystemOrganization addCategory: 'MemoryGameV1'!


!classDefinition: #MemoryCard category: 'MemoryGameV1'!
PluggableButtonMorph subclass: #MemoryCard
	instanceVariableNames: 'cardColor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV1'!
!classDefinition: 'MemoryCard class' category: 'MemoryGameV1'!
MemoryCard class
	instanceVariableNames: ''!

!classDefinition: #MemoryGameWindow category: 'MemoryGameV1'!
SystemWindow subclass: #MemoryGameWindow
	instanceVariableNames: 'size flipped'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MemoryGameV1'!
!classDefinition: 'MemoryGameWindow class' category: 'MemoryGameV1'!
MemoryGameWindow class
	instanceVariableNames: ''!


!MemoryGameWindow commentStamp: '<historical>' prior: 0!
A memory game based on finding identical squares of the same color.!

!MemoryCard methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 14:47:47'!
defaultBorderColor
	^ self defaultColor ! !

!MemoryCard methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 14:44:10'!
defaultBorderWidth
	^ 5! !

!MemoryCard methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 15:39:10'!
defaultColor
	^ Color white! !

!MemoryCard methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 14:48:44'!
cardColor
	"Answer the value of cardColor"

	^ cardColor! !

!MemoryCard methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 14:48:44'!
cardColor: anObject
	"Set the value of cardColor"

	cardColor := anObject! !

!MemoryCard methodsFor: 'testing' stamp: 'hlsf 3/15/2025 14:56:29'!
isReturned
	^ color = cardColor ! !

!MemoryCard methodsFor: 'action' stamp: 'hlsf 3/15/2025 14:58:18'!
flip
	color := self isReturned ifTrue:  [self defaultColor] ifFalse: [cardColor ]! !

!MemoryCard methodsFor: 'dependency mechanism' stamp: 'hlsf 3/15/2025 15:41:30'!
update: position
	super update: position.
	position = actionArgument 
		ifTrue: [actionArgument print]! !

!MemoryGameWindow methodsFor: 'accessing' stamp: 'hlsf 3/15/2025 15:32:04'!
adoptWidgetsColor: paneColor! !

!MemoryGameWindow methodsFor: 'initialization' stamp: 'hlsf 3/15/2025 15:34:49'!
initialize
	| row |
	super initialize.
	size := 3 @ 3.
	flipped := Array2D  newSize: size.
	1 to: size y do: [:y |
		row := LayoutMorph newRow.
		1 to: size x do: [:x | | card |
			card := MemoryCard model: self action: #flip: actionArgument: x@y.
			card layoutSpec proportionalWidth: 1; proportionalHeight: 1.
			row addMorph: card.
			flipped at: x@y put: false ].
		self addMorph: row ]! !

!MemoryGameWindow methodsFor: 'updating' stamp: 'hlsf 3/15/2025 15:37:42'!
flip: position
	flipped at: position put: (flipped at: position) not.
	self changed: position! !
