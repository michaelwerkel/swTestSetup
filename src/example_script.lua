
-- Tick function that will be executed every logic tick
function onTick(game_ticks)
	async.httpGet(80, "/auth");
end

function httpReply(port, request, response)
	screen.drawText(0, 0, response);
end

function onPlayerJoin(steam_id, name, peer_id, admin, auth)
	server.announce("[Server]", name .. " joined the game")
end

function onPlayerLeave(steam_id, name, peer_id, admin, auth)
	server.announce("[Server]", name .. " left the game")
end

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, command, one, two, three, four, five)

	if command == "?cleanup" then
		
		server.cleanVehicles();
		
	end

end

function onChatMessage(sender_name, message)

	server.notify(-1, sender_name, message, 1);

end