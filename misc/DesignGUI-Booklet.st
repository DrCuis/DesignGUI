!classDefinition: #TextEntryDemo category: #'DesignGUI-Booklet'!
Object subclass: #TextEntryDemo
	instanceVariableNames: 'value entry'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DesignGUI-Booklet'!

!TextEntryDemo methodsFor: 'as yet unclassified' stamp: 'hlsf 5/1/2025 18:32:57'!
accept
	value := entry contents.
	'I accepted the input ' print.
	('value = ', value) print! !

!TextEntryDemo methodsFor: 'as yet unclassified' stamp: 'hlsf 5/1/2025 18:37:24'!
cancel
	'I discarded the input' print.
	entry delete! !

!TextEntryDemo methodsFor: 'as yet unclassified' stamp: 'hlsf 5/1/2025 18:33:32'!
initialize
	value := '42'.
	entry := TextEntryMorph contents: value.
	entry acceptCancelReceiver: self.
	entry openInWorld! !


!classDefinition: #GreetingPanel category: #'DesignGUI-Booklet'!
DialogPanel subclass: #GreetingPanel
	instanceVariableNames: 'firstName lastName greetLabel myImage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'DesignGUI-Booklet'!

!GreetingPanel methodsFor: 'GUI building' stamp: 'hlsf 5/2/2025 18:44:08'!
dropDownIcons
	| morphs listModel | 
	morphs := #(addressBookIcon chatIcon clockIcon doItIcon findIcon) collect: [:anIcon | ImageMorph new ::
			image: ((Theme current perform: anIcon) magnifyTo: 32@32) ].
	listModel := ListModel with: morphs.
	listModel when: #listSelectionChanged send: #updateIcon: to: self.
	^ DropDownButtonMorph 
		withModel: listModel 
		listGetter: #list 
		indexGetter: #listIndex 
		indexSetter: #listIndex:! !

!GreetingPanel methodsFor: 'GUI building' stamp: 'hlsf 5/2/2025 11:04:26'!
newButtonArea
	^ PluggableButtonMorph model: self action: #greet label: 'Greet' ::
		color: self widgetsColor ! !

!GreetingPanel methodsFor: 'GUI building' stamp: 'hlsf 5/3/2025 09:38:31'!
newPane
	| column group radioColors decorator |
	column := LayoutMorph newColumn :: 
		color: Color transparent;
		gap: 10 .
	group := LabelGroup with: {
		'First Name: ' -> (firstName := TextEntryMorph contents: '') .
		'Last Name: ' -> (lastName := TextEntryMorph contents: '') .
		'Prefered icon: ' -> self dropDownIcons }.
	radioColors := RadioGroup fromList: #( Blue White Red).
	radioColors when: #informRadioSelection send: #setColor: to: self.
	greetLabel := LabelMorph contents: '' font: nil emphasis: 1 ::
		layoutSpec: (LayoutSpec 
			proportionalWidth: 0 
			fixedHeight: 20 
			offAxisEdgeWeight: #center).
	decorator := DecoratedPane 
		open: greetLabel 
		label: 'Decorated Label'  
		quickButtons: {
			PluggableButtonMorph 
				model: [greetLabel contents: 'Hello ', Utilities authorName] action: #value :: 
				icon: (Theme current fetch: #('16x16' 'actions' 'contact-new')) ; 
				setBalloonText: 'Say hello to the Smalltalk author of this running Cuis image.' .
			PluggableButtonMorph 
				model: [greetLabel contents: ''] action: #value :: 
				icon: (Theme current fetch: #('16x16' 'actions' 'edit-clear')); 
				setBalloonText: 'Take back my greeting.' }.
	column 
		addMorph: (myImage := ImageMorph new);
		addMorph: group layoutSpec: (LayoutSpec  fixedWidth: 300);
		addMorph: radioColors beRow;
		addMorph: decorator.
	^ column! !


!GreetingPanel methodsFor: 'initialization' stamp: 'hlsf 5/2/2025 11:05:11'!
defaultColor
	^ Color lightOrange ! !

!GreetingPanel methodsFor: 'initialization' stamp: 'hlsf 5/2/2025 10:48:01'!
initialize
	super initialize.
	self showButtonsNamed: #(close expand)! !


!GreetingPanel methodsFor: 'events' stamp: 'hlsf 5/2/2025 10:56:13'!
expandButtonClicked
	self fullScreen ! !

!GreetingPanel methodsFor: 'events' stamp: 'hlsf 5/2/2025 10:53:06'!
greet
	greetLabel contents: (
		'Hello {1} {2}!!' format: {firstName contents. lastName contents})! !

!GreetingPanel methodsFor: 'events' stamp: 'hlsf 5/2/2025 12:30:42'!
setColor: aColorSymbol 
	self color: (Color perform: aColorSymbol asLowercase asSymbol)! !

!GreetingPanel methodsFor: 'events' stamp: 'hlsf 5/2/2025 18:50:51'!
updateIcon: aListModel 
	myImage image: aListModel selectedItem form! !
