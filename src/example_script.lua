function onCustomCommand(message, user_id, is_admin, is_auth, command, ...)
	args = {...}

	if command == "?hello" then
		server.announce("[Welcome]", "Hello, " .. server.getPlayerName(user_id) .. "!", user_id)
		hello = true
	end

end