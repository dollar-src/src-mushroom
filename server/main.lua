local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('src-mushroom:serveritem', function(test)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	    if 	Player then
		TriggerClientEvent("QBCore:Notify", src, "U found mushroom but looks weird.", "Success", 1000)
		  Player.Functions.AddItem(test, 1)
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[test], "add", 1)
	    end
end)


RegisterServerEvent('src-mushroom:syrup', function(arg)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local item1 = Player.Functions.GetItemByName(Config.Items.Level_1_Item)
	local item2 = Player.Functions.GetItemByName(Config.Items.Level_2_Item)
	local item3 = Player.Functions.GetItemByName(Config.Items.Level_3_Item)
		 if tonumber(arg.level) == 1 then
			
		

			if item1 ~= nil then
				
				
				if item1.amount >= 25 then
					Player.Functions.RemoveItem(Config.Items.Level_1_Item, 25)
					TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_1_Item], "remove", 25)
					Player.Functions.AddItem(Config.Items.StamineSyrup, 1)
					TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.StamineSyrup], "add", 1)

				else
					need = 25 - item1.amount
					TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
				
				end
			
			end

		 elseif arg.level == 2 then
			if item2 ~= nil then
			if item2.amount >= 25 then
				Player.Functions.RemoveItem(Config.Items.Level_2_Item, 25)
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_2_Item], "remove", 25)

				Player.Functions.AddItem(Config.Items.HealSyrup, 1)
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.HealSyrup], "add", 1)
				
			else
				need = 25 - item2.amount
				TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
			
			end
		end

		 elseif arg.level == 3 then
			if item3 ~= nil then
			if item3.amount >= 25 then
				Player.Functions.RemoveItem(Config.Items.Level_3_Item, 25)
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_3_Item], "remove", 25)
			

				Player.Functions.AddItem(Config.Items.ArmorSyrup, 1)
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.ArmorSyrup], "add", 1)
			else
				need = 25 - item3.amount
				TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
			
			end
		end
		
	elseif arg.level == 4 then
		if item3 ~= nil then
		if item3.amount >= 25 then
			Player.Functions.RemoveItem(Config.Items.Level_3_Item, 25)
			TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_3_Item], "remove", 25)
		

			Player.Functions.AddItem(Config.Items.HealSyrup, 1)
			TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.HealSyrup], "add", 1)
		else
			need = 25 - item3.amount
			TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
		
		end
	end

elseif arg.level == 5 then
	if item3 ~= nil then
	if item3.amount >= 25 then
		Player.Functions.RemoveItem(Config.Items.Level_3_Item, 25)
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_3_Item], "remove", 25)
	

		Player.Functions.AddItem(Config.Items.StamineSyrup, 1)
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.StamineSyrup], "add", 1)
	else
		need = 25 - item3.amount
		TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
	
	end
end
elseif arg.level == 6 then
	if item2 ~= nil then
	if item2.amount >= 25 then
		Player.Functions.RemoveItem(Config.Items.Level_2_Item, 25)
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.Level_2_Item], "remove", 25)

		Player.Functions.AddItem(Config.Items.StamineSyrup, 1)
		TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.Items.StamineSyrup], "add", 1)
		
	else
		need = 25 - item2.amount
		TriggerClientEvent('QBCore:Notify', src, "Bunu yapmak için"..' '..need.. 'x İhtiyacın var', "error")
	
	end
end
end
        
end)
RegisterServerEvent('src-mushroom:sell', function(arg)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local item1 = Player.Functions.GetItemByName(Config.Items.Level_1_Item)
	local item2 = Player.Functions.GetItemByName(Config.Items.Level_2_Item)
	local item3 = Player.Functions.GetItemByName(Config.Items.Level_3_Item)
		 if tonumber(arg.level) == 1 then
			
		

			if item1 ~= nil then
				Player.Functions.RemoveItem(Config.Items.Level_1_Item, item1.amount)
				Player.Functions.AddItem('markedbills' ,item1.amount * Config.PriceList.Level1)
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['markedbills'], "add", item1.amount * Config.PriceList.Level1)

				TriggerClientEvent('QBCore:Notify', src, "Üzerinde Satabileceğin Birşey yok", "error")
			
			end

		 elseif arg.level == 2 then
			if item2 ~= nil then
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['markedbills'], "add", item2.amount * Config.PriceList.Level2)
				Player.Functions.RemoveItem(Config.Items.Level_2_Item, item2.amount)
				Player.Functions.AddItem('markedbills' ,item2.amount * Config.PriceList.Level2)
			else
				TriggerClientEvent('QBCore:Notify', src, "Üzerinde Satabileceğin Birşey yok", "error")
			
			end
		 elseif arg.level == 3 then
			if item3 ~= nil then
				TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['markedbills'], "add", item3.amount * Config.PriceList.Level3)
				Player.Functions.RemoveItem(Config.Items.Level_3_Item, item3.amount)
				Player.Functions.AddItem('markedbills' ,item3.amount * Config.PriceList.Level3)
			else
				TriggerClientEvent('QBCore:Notify', src, "Üzerinde Satabileceğin Birşey yok", "error")
			
			end

	
         end
		 
end)


QBCore.Functions.CreateUseableItem(Config.Items.StamineSyrup, function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)

   Player.Functions.RemoveItem(item.name, 1)
   TriggerClientEvent('stamina-src', source)
end)

QBCore.Functions.CreateUseableItem(Config.Items.HealSyrup, function(source, item)

	local Player = QBCore.Functions.GetPlayer(source)

   Player.Functions.RemoveItem(item.name, 1)

    TriggerClientEvent('heal-src', source)
end)

QBCore.Functions.CreateUseableItem(Config.Items.ArmorSyrup, function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)

	Player.Functions.RemoveItem(item.name, 1)

    TriggerClientEvent('arm-src', source)
end)



QBCore.Functions.CreateUseableItem('mush_1', function(source, item)
	local Player = QBCore.Functions.GetPlayer(source)

	Player.Functions.RemoveItem(item.name, 1)
	TriggerClientEvent("consumables:client:uselsd", source)
    TriggerClientEvent('acid-src', source)
end)
