Class {
	#name : #GtWardleyMapAddProposition,
	#superclass : #Object,
	#traits : 'TGtWardleyMapDecoratorModel',
	#classTraits : 'TGtWardleyMapDecoratorModel classTrait',
	#instVars : [
		'acceptAction',
		'rejectAction',
		'parent',
		'isReadOnly'
	],
	#category : #'GToolkit-WardleyMap-! Models - Decorators'
}

{ #category : #'as yet unclassified' }
GtWardleyMapAddProposition >> beReadOnly [
	isReadOnly := true
]

{ #category : #'api - wardley map decorator model' }
GtWardleyMapAddProposition >> decorateEdgeElementInContext: anEdgeDecoratorContext [
	| anEdgeViewModel aCanvasElement aFromNodeElement aToNodeElement aPropositionElement |
	anEdgeViewModel := anEdgeDecoratorContext edgeElement wardleyMapEdgeViewModel.
	aCanvasElement := anEdgeDecoratorContext canvasElement.
	aFromNodeElement := anEdgeDecoratorContext fromNodeElement.
	aToNodeElement := anEdgeDecoratorContext toNodeElement.

	aPropositionElement := GtWardleyMapEdgePropositionElement new
			beAddProposition;
			wardleyMapEdgeViewModel: anEdgeViewModel;
			wardleyMapDecoratorViewModel: anEdgeDecoratorContext decoratorViewModel;
			edgeElement: anEdgeDecoratorContext edgeElement;
			fromAnchor: (BlNearestPositionEllipseAnchor
					referenceElement: aFromNodeElement
					relatedTo: aToNodeElement);
			toAnchor: (BlNearestPositionEllipseAnchor
					referenceElement: aToNodeElement
					relatedTo: aFromNodeElement).

	aCanvasElement addChild: aPropositionElement.

	isReadOnly
		ifFalse: [ acceptAction decorateEdgeElementInContext: anEdgeDecoratorContext.
			rejectAction decorateEdgeElementInContext: anEdgeDecoratorContext ]
]

{ #category : #accessing }
GtWardleyMapAddProposition >> decorateNodeElementInContext: aNodeDecoratorContext [
	| aHighlightElement |
	aHighlightElement := GtWardleyMapNodePropositionElement new
			beAddProposition;
			wardleyMapNodeViewModel: aNodeDecoratorContext nodeViewModel;
			wardleyMapDecoratorViewModel: aNodeDecoratorContext decoratorViewModel;
			nodeElement: aNodeDecoratorContext nodeElement.

	aNodeDecoratorContext canvasElement addChild: aHighlightElement.

	isReadOnly
		ifFalse: [ acceptAction decorateNodeElementInContext: aNodeDecoratorContext.
			rejectAction decorateNodeElementInContext: aNodeDecoratorContext ]
]

{ #category : #initialization }
GtWardleyMapAddProposition >> initialize [
	super initialize.

	acceptAction := GtWardleyMapAction new.
	acceptAction elementId: GtWardleyMapAddAcceptId.
	acceptAction icon: BrGlamorousVectorIcons accept.
	acceptAction tooltip: 'Keep'.
	acceptAction action: [ self onAcceptAction ].
	rejectAction := GtWardleyMapAction new.
	rejectAction elementId: GtWardleyMapAddRejectId.
	rejectAction icon: BrGlamorousVectorIcons cancel.
	rejectAction action: [ self onRejectAction ].
	rejectAction tooltip: 'Remove'.
	
	isReadOnly := false
]

{ #category : #testing }
GtWardleyMapAddProposition >> isActionableProposition [
	"Return true if it can be handled by GtWardleyMapAllProposition.
	Such decorator must implement #onAcceptAction and #onRejectAction methods.
	Return false in other cases."

	<return: #Boolean>
	^ true
]

{ #category : #'event handling' }
GtWardleyMapAddProposition >> onAcceptAction [
	parent ifNil: [ ^ self ].
	parent removeWardleyMapDecoratorModel: self.
]

{ #category : #'event handling' }
GtWardleyMapAddProposition >> onRejectAction [
	parent ifNil: [ ^ self ].
	parent removeFromMap.
]

{ #category : #initialization }
GtWardleyMapAddProposition >> parent: aParent [
	self assert: [ parent isNil ] description: [ 'Only one parent is allowed' ].

	parent := aParent
]

{ #category : #initialization }
GtWardleyMapAddProposition >> removeParent [
	parent := nil
]
