Class {
	#name : 'BaselineOfCombinaisonFinder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCombinaisonFinder',
	#package : 'BaselineOfCombinaisonFinder'
}

{ #category : 'baselines' }
BaselineOfCombinaisonFinder >> baseline: spec [

	<baseline>
	spec for: #common do: [

		spec
			baseline: 'Camping'
			with: [ spec repository: 'github://mattonem/WildCamping' ].

		spec package: #CombinaisonFinder with: [ spec requires: #( Camping ) ] ]
]
