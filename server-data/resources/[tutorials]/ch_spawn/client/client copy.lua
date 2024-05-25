local vehiculosJugador = {}

RegisterCommand('coche', function(source, args)
    local nombreVehiculo = args[1] or 'adder'
    local idJugador = PlayerPedId()
    local pos = GetEntityCoords(idJugador)
    local nombre = GetEntityHeading(idJugador)
    local antiguoCoche = vehiculosJugador[source]

    if not IsModelInCdimage(nombreVehiculo) or not IsModelAVehicle(nombreVehiculo) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'El vehículo "' .. nombreVehiculo .. '" no existe.'}
        })
        return
    elseif IsPedInAnyVehicle(idJugador) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'No puedes spawnear un vehículo si estás dentro de otro.'}
        })
    else
        DeleteVehicle(antiguoCoche)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'Spawneado: "' .. nombreVehiculo .. '"....'}
        })
        RequestModel(nombreVehiculo)

        while not HasModelLoaded(nombreVehiculo) do
            Wait(10)
        end

        local vehiculo = CreateVehicle(
            nombreVehiculo,
            pos,
            nombre,
            true
        )
        
        SetPedIntoVehicle(idJugador, vehiculo, -1)
        vehiculosJugador[source] = vehiculo
    end
end)

RegisterCommand('arma', function(source, args)
    local nombreArma = args[1] or 'adder'
    local idJugador = PlayerPedId()
    GiveWeaponToPed(PlayerPedId(), GetHashKey(nombreArma), 100, false, true)
end, false)

RegisterCommand('clean', function(source, args)
    TriggerEvent('chat:clear')
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        args = {'SERVER', 'Se ha limpiado el chat.'}
    })
end, false)

RegisterCommand('borrar_coche', function(source, args)
    local antiguoCoche = vehiculosJugador[source]
    if(antiguoCoche == nil) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'El usuario no tiene ningún coche.'}
        })
    else
        DeleteVehicle(antiguoCoche)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'Se ha borrado el último coche del usuario.'}
        })
        vehiculosJugador[source] = nil
    end
end, false)

RegisterCommand('mis_coords', function(source, args)
    local pos = GetEntityCoords(PlayerPedId())
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        args = {'SERVER',pos.x .. ', ' .. pos.y .. ', ' .. pos.z}
    })
end, false)

RegisterCommand('tp', function(source, args)
    local idJugador = PlayerPedId()
    if #args < 3 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'Uso: /teleportar [x] [y] [z]'}
        })
        return
    end
    
    local x = tonumber(args[1])
    local y = tonumber(args[2])
    local z = tonumber(args[3])
    
    if x and y and z then
        SetEntityCoords(idJugador, x, y, z, false, false, false, true)
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'SERVER', 'Te has teletransportado a: ' .. x .. ', ' .. y .. ', ' .. z}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'Las coordenadas deben ser números válidos.'}
        })
    end
end, false)

TriggerEvent('chat:addSuggestion', '/coche', 'Spawnea un coche.', {
    {name = 'nombre'}
})

TriggerEvent('chat:addSuggestion', '/clean', 'Limpia el chat')

TriggerEvent('chat:addSuggestion', '/tp', 'Te teletransporta a unas determinadas coordenadas.x ', {
    {name = 'x'},
    {name = 'y'},
    {name = 'z'}
})

TriggerEvent('chat:addSuggestion', '/mis_coords', 'Te dice tus coordenadas actuales.')

TriggerEvent('chat:addSuggestion', '/borrar_coche', 'Borra el último coche.')
