plugin helper dbgame_Entity
	name: "DBGame Entity"
    classID: #(0x48274019, 0x54f2d7dc)
	extends: point
	replaceUI: true
	invisible: false
(
	parameters pblock rollout:params
	(
		test type:#float animatable:false ui:amount default:30.0
	)
	rollout params "Entity Parameters"
	(
		Spinner amount "Size:" range:[0, 1e9, 40]
	)
	tool create
	(
		on mousePoint click do
		(
			nodeTM.translation = gridPoint;#stop
		)
	)
)