-- CREATE GIFTBOX FUNCTION
function createSecretBox(pl,cmdName,...)
	local tip,x,y,z
	if pl and isElement(pl) and getElementType(pl) == "player" then
		if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(pl)),aclGetGroup("Admin")) then -- oyuncu yetkili mi?
			if not searchTimer then
				x,y,z = getElementPosition(pl)
				arg = {...}
				tip = ""
				for i,st in pairs(arg) do
					tip = tip..st.." "
				end
				outputChatBox("#FFFFFFGizli kutu "..getPlayerName(pl).." #FFFFFFadlı yetkili tarafından oluşturuldu! Bulmak için #FF0000"..settings.searchTime.." #FFFFFFdakikan var. Ödüller seni bekliyor.",root,0,0,0,true)
			--	outputChatBox("#FFFFFFGift box created by "..getPlayerName(pl).."#FFFFFF. You have #00FF00"..settings.searchTime.." #FFFFFFminute for find it.",root,0,0,0,true)
				if createTimer and isTimer(createTimer) then killTimer(createTimer);createTimer = nil end
			else
				outputChatBox("Zaten bir gizli kutu var, o bulunmadan yenisini oluşturamazsın!",pl,255,0,0,true) return
			--	outputChatBox("Gift box already created, you have to wait for him to be found!",pl,255,0,0,true) return
			end
		else return end
	else
		local rand = math.random(#positions)
		tip,x,y,z = unpack(positions[rand])
		outputChatBox("#FFFFFFGizli kutu ortaya çıktı! Bulmak için #FF0000"..settings.searchTime.." #FFFFFFdakikan var. Ödüller seni bekliyor.",root,0,0,0,true)
	--	outputChatBox("#FFFFFFGift box created! You have #00FF00"..settings.searchTime.." #FFFFFFminute for find it.",root,0,0,0,true)
	end
	secretBox = createObject(settings.objectID,x,y,z)
	setObjectScale(secretBox,0.4)
	setElementCollisionsEnabled(secretBox,false)
	col = createColCuboid(x-0.5,y-0.5,z-1,1,1,2)
	addEventHandler("onColShapeHit",col,stopSearch)
	outputChatBox("İpucu: "..tip,root,0,255,0,true)
--	outputChatBox("Tip: "..tip,root,0,255,0,true)
	triggerClientEvent("secretBox:addRender",resourceRoot,secretBox)
	searchTimer = setTimer(stopSearch,settings.searchTime*60000,1)
end

function stopSearch(hit)
	if secretBox and isElement(secretBox) then
		if searchTimer and isTimer(searchTimer) then
			killTimer(searchTimer)
			searchTimer = nil
		end
		if hit and getElementType(hit) == "player" then
			local reward = math.random(100)
			if reward >= settings.possibility[1] then
				local weapon,ammo = settings.weaponIDs[math.random(#settings.weaponIDs)],math.random(settings.ammoCount[1],settings.ammoCount[2])
				giveWeapon(hit,weapon,ammo) -- oyuncuya silah ver
				outputChatBox(getPlayerName(hit).." #FFFFFFadlı oyuncu gizli kutuyu buldu ve #FF0000"..getWeaponNameFromID(weapon).." ("..ammo.." mermi) #FFFFFF$ kazandı!",root,255,255,255,true)
			--	outputChatBox(getPlayerName(hit).." #FFFFFFfound the gift box and won #00FF00"..getWeaponNameFromID(weapon).." ("..ammo.." ammo)",root,255,255,255,true)
			else
				local money = math.random(settings.cashCount[1],settings.cashCount[2])
				givePlayerMoney(hit,money) -- oyuncuya para ver
				outputChatBox(getPlayerName(hit).." #FFFFFFadlı oyuncu gizli kutuyu buldu ve #FF0000"..money.."#FFFFFF$ kazandı!",root,255,255,255,true)
			--	outputChatBox(getPlayerName(hit).." #FFFFFFfound the gift box and won #00FF00"..money.."#FFFFFF$",root,255,255,255,true)
			end
			if settings.health_armor then
				setElementHealth(hit,100) -- oyuncunun canını doldur (renew the player's health)
				setPedArmor(hit,100) -- oyuncunun zırhını yenile (renew the player's armor)
			end
		else
			outputChatBox("Gizli kutu bulunamadı :(",root,255,0,0,true)
		--	outputChatBox("No hidden gift box found :(",root,255,0,0,true)
		end
		setTimer(destroyElement,1500,1,secretBox)
		removeEventHandler("onColShapeHit",col,stopSearch)
		destroyElement(col)
		secretBox = nil
		col = nil
		triggerClientEvent("secretBox:stopRender",resourceRoot,hit)
		outputChatBox("Sonraki gizli kutu "..settings.createTime.." dakika sonra ortaya çıkacak.",root,0,255,0,true)
	--	outputChatBox("The next gift box will be create in "..settings.createTime.." minute.",root,0,255,0,true)
		createTimer = setTimer(createSecretBox,settings.createTime*60000,1)
	end
end

addEvent("secretBox:clientSideOkey",true)
addEventHandler("secretBox:clientSideOkey",root,function()
	triggerClientEvent(source,"secretBox:replaceBox",source,settings.objectID)
end)

kontrol = setTimer(function()
	if kontrol and positions then
		addCommandHandler(settings.command,createSecretBox)
		outputChatBox("İlk gizli kutu "..settings.createTime.." dakika sonra ortaya çıkacak!",root,0,255,0,true)
	--	outputChatBox("First gift box will be create in "..settings.createTime.." minute!",root,0,255,0,true)
		createTimer = setTimer(createSecretBox,settings.createTime*60000,1)
		killTimer(kontrol)
		kontrol = nil
	end
end,50,0)