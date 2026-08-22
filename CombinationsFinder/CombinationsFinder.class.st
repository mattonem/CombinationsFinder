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

	
	html div class: 'container mt-5'; with: [
		html div class: 'row justify-content-center'; with: [
			html  heading
                    level: 1; 
					class: 'text-center mb-4'; 
					with: [ html text: 'Combinations Finder' ].
			html div class: 'col-md-6'; with: [
				html div class: 'card'; with: [
				
					
				].
				html div class: 'card'; with: [
					html div class: 'card-header'; with: [ html text: 'Possible combinations' ].
				
				].
			].
		].
	].
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
		
]
