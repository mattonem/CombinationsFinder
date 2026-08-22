Class {
	#name : 'CombinationsFinder',
	#superclass : 'PjFileBasedWebApp',
	#traits : 'StaticComponentHolder',
	#classTraits : 'StaticComponentHolder classTrait',
	#category : 'CombinationsFinder-Core',
	#package : 'CombinationsFinder',
	#tag : 'Core'
}

{ #category : 'accessing' }
CombinationsFinder class >> bridgeClass [
	<pharoJsSkip>
	^ PjBridge
]

{ #category : 'accessing' }
CombinationsFinder class >> bridgeClientClass [
	<pharoJsSkip>
	
	^ PjZnHostedBrowserBridgeClient
]

{ #category : 'accessing' }
CombinationsFinder class >> exporterClass [

	<pharoJsSkip>
	^ PjFileExporterWithIndexHtml
]

{ #category : 'accessing' }
CombinationsFinder class >> generateHtmlUsing: html [

	<pharoJsSkip>
	html div
		class: 'container mt-5';
		with: [
			html div
				class: 'row justify-content-center';
				with: [
					html heading
						level: 1;
						class: 'text-center mb-4';
						with: [ html text: 'Combinations Finder' ].
					html div
						class: 'col-md-6';
						with: [
							html div
								class: 'card';
								with: [
									html div
										class: 'card-header';
										with: [ html text: 'Input' ].
									html div
										class: 'card-body';
										with: [
											html form with: [
													html div
														class: 'mb-3';
														with: [
															html label
																class: 'form-label';
																for: 'values';
																with: [ html text: 'Values (seperated by ; and decimal should . character)' ].
															html textInput
																class: 'form-control';
																id: 'values';
																placeholder: '10.45;20.11' ].
													html div
														class: 'mb-3';
														with: [
															html label
																class: 'form-label';
																for: 'total';
																with: [ html text: 'Total' ].
															html textInput
																class: 'form-control';
																id: 'total' ].
													html submitButton
														class: 'btn btn-primary';
														value: 'Find combinaisons' ] ] ].
							html div
								class: 'card';
								with: [
									html div
										class: 'card-header';
										with: [ html text: 'Possible combinations' ].
									html div
										class: 'card-body';
										with: [ html preformatted id: 'result' ] ] ] ] ]
]

{ #category : 'accessing' }
CombinationsFinder class >> staticComponentsSerialized [

	<jsLiteralGenerator>
	^ self _staticComponents asPhxJsonString
]

{ #category : 'accessing' }
CombinationsFinder class >> updateHtmlRoot: root [

	<pharoJsSkip>
	root language: 'en'.
	root stylesheet url:
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'.
	root stylesheet url:
		'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css'.
	root link
		relationship: 'icon';
		type: WCMimeType imageXIcon;
		url: 'https://mattonem.github.io/assets/combinations_finder.svg'.
		
]

{ #category : 'as yet unclassified' }
CombinationsFinder >> findCombinaitionsValues: valuesArray total: total [

	| result current |
	result := OrderedCollection new.
	current := OrderedCollection new.
	self
		findCombinaitionsValues: valuesArray
		total: total
		current: current
		result: result.
	^ result
]

{ #category : 'as yet unclassified' }
CombinationsFinder >> findCombinaitionsValues: valuesArray total: total current: current result: result [

	| sum first remaining |
	sum := current
		       inject: 0
		       into: [ :totalSoFar :aValue | totalSoFar + aValue ].

	sum = total ifTrue: [
		result add: current copy.
		^ self ].
	(sum > total or: [ valuesArray isEmpty ]) ifTrue: [ ^ self ].

	first := valuesArray first.
	remaining := valuesArray allButFirst.
	self
		findCombinaitionsValues: remaining
		total: total
		current: (current copy
				 add: first;
				 yourself)
		result: result.
	self
		findCombinaitionsValues: remaining
		total: total
		current: current
		result: result
]

{ #category : 'initialize-release' }
CombinationsFinder >> start [

	super start.

	(document querySelector: 'form')
		addEventListener: 'submit'
		do: [ :event |
			| valuesString valuesStringArray valuesArray total result resultString |
			event preventDefault.
			valuesString := (document getElementById: #values) value.
			valuesStringArray := $; split: valuesString.
			valuesArray := valuesStringArray collect: #asNumber.

			total := (document getElementById: #total) value asNumber.

			result := self findCombinaitionsValues: valuesArray total: total.
			resultString := ''.
			result do: [ :aComb |
				aComb do: [ :aValue |
					resultString := resultString , aValue asString , ' - ' ].
				resultString := resultString , String cr ].
			(document getElementById: #result) innerText: resultString ]
]
