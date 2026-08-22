Class {
	#name : 'BaselineOfCombinationsFinder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCombinationsFinder',
	#package : 'BaselineOfCombinationsFinder'
}

{ #category : 'baselines' }
BaselineOfCombinationsFinder >> baseline: spec [

	<baseline>
	spec for: #common do: [

		spec
			baseline: 'Camping'
			with: [ spec repository: 'github://mattonem/WildCamping' ].

		spec package: #CombinationsFinder with: [ spec requires: #( Camping ) ] ]
]
