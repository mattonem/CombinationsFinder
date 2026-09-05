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
											html form
												class: 'row row-cols-lg-auto g-3 align-items-center ';
												with: [
													html div
														class: 'mb-6 ';
														with: [
															html div
																class: 'form-floating';
																with: [
																	html textInput
																		class: 'form-control';
																		id: 'newValues';
																		placeholder: ''.
																	html label
																		for: 'newValues';
																		with:
																			'Values (seperated by ;)' ] ].
													html div
														class: 'mb-3';
														with: [
															html submitButton
																class: 'btn btn-primary';
																value: 'Add values' ] ].
											html div
												class: 'mb-3';
												with: [
													html div id: #visibleValues.
													html select
														class: 'form-control';
														disabled;
														hidden: true;
														multiple;
														id: 'values';
														with: [  ] ].
											html form with: [
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
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css'.
		root javascript url:
		'https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js'.
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
CombinationsFinder >> setSelectedValues: valuesArray [

	(document getElementById: #values) innerHTML: ''.
	valuesArray do: [ :aValue |
		| frag |
		frag := document createElement: 'template'.
		frag innerHTML: (WCHtmlCanvas builder
				 fullDocument: false;
				 render: [ :html |
					 html option selected
						 value: aValue;
						 with: aValue ]).
		(document getElementById: #values) appendChild: frag content ]
]

{ #category : 'initialize-release' }
CombinationsFinder >> start [

	| observer |
	super start.
	observer := MutationObserver new: [ :aMutation |
		            | frag |
		            (document getElementById: #visibleValues) innerHTML: ''.
		            frag := document createElement: 'template'.
		            frag innerHTML: (WCHtmlCanvas builder
				             fullDocument: false;
				             render: [ :html |
					             | valuesArray |
					             valuesArray := ((document getElementById: #values)
						                             options collect: #value) collect:
							                            #asNumber.
					             valuesArray do: [ :aVal |
							             html span
								             class: 'badge rounded-pill text-bg-secondary';
								             with: [
									             html text: aVal.
									             html button
										             id: 'removeValue';
										             class: 'btn-close' ] ] ]).
		            (document getElementById: #visibleValues) appendChild:
			            frag content.

		            (document querySelectorAll: '#removeValue') do: [
			            :aButton |
			            aButton addEventListener: #click block: [
				            | valuesArray |
				            valuesArray := (((document getElementById: #values)
					                             options collect: #value) collect:
						                            #asNumber)
					                           remove:
						                           aButton parentNode textContent
							                           asNumber;
					                           yourself.
				            self setSelectedValues: valuesArray ] ] ].
	observer observe: (document getElementById: #values) config: {
			(#childList -> true).
			(#subtree -> true) } asJsObject.
	(document querySelectorAll: 'form') do: [ :aForm |
		aForm addEventListener: 'submit' do: [ :event |
			| valuesString valuesStringArray valuesArray total result resultString |
			event preventDefault.
			valuesString := (document getElementById: #newValues) value.
			(document getElementById: #newValues) value: ''.
			valuesString := valuesString replaceAll: $, with: $..
			valuesStringArray := $; split: valuesString.
			valuesStringArray := valuesStringArray copyWithout: ''.

			valuesArray := (((document getElementById: #values) options
				                 collect: #value) collect: #asNumber)
				               addAll: (valuesStringArray collect: #asNumber);
				               yourself.
			valuesArray := valuesArray select: [ :e | (Number isNaN: e) not ].

			self setSelectedValues: valuesArray.
			valuesArray := ((document getElementById: #values) options
				                collect: #value) collect: #asNumber.
			total := (document getElementById: #total) value.
			total := total replaceAll: $, with: $..
			total := total asNumber.

			result := self findCombinaitionsValues: valuesArray total: total.
			resultString := ''.
			result
				do: [ :aComb |
					aComb
						do: [ :aVal | resultString := resultString , aVal ]
						separatedBy: [ resultString := resultString , ' - ' ] ]
				separatedBy: [ :aComb | resultString := resultString , String cr ].

			(document getElementById: #result) innerText: resultString ] ]
]
