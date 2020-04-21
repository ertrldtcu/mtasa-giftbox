addEvent("secretBox:replaceBox",true)
addEventHandler("secretBox:replaceBox",root,function(id)
	txd = engineLoadTXD("box/box.txd")
	engineImportTXD(txd,id)
	dff = engineLoadDFF("box/box.dff")
	engineReplaceModel(dff,id)
end)

addEvent("secretBox:addRender",true)
addEventHandler("secretBox:addRender",root,function(box)
	fx = false
	rot = 0
	secretBox = box
	removeEventHandler("onClientRender",root,render)
	addEventHandler("onClientRender",root,render)
end)

addEvent("secretBox:stopRender",true)
addEventHandler("secretBox:stopRender",root,function(finded)
	fx = finded
end)

function render()
	if secretBox and isElement(secretBox) then
		setElementRotation(secretBox,0,0,rot)
		rot = rot + 1
		if fx then
			local x,y,z = getElementPosition(secretBox)
			fxAddDebris(x,y,z,math.random(255),math.random(255),math.random(255),180,0.1)
		end
	else
		removeEventHandler("onClientRender",root,render)
	end
end

triggerServerEvent("secretBox:clientSideOkey",localPlayer)