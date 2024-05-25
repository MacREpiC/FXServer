local golpesHabilt = false

RegisterCommand('activar_punetazos', function()
    golpesHabilt = not golpesHabilt
    if golpesHabilt then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {'SERVER', 'Puñetazos deshabilitados.'}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'SERVER', 'Puñetazos habilitados.'}
        })
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if golpesHabilt then
            DisableControlAction(0, 140, true) -- puñetazo fuerte
            DisableControlAction(0, 141, true) -- puñetazo leve
            DisableControlAction(0, 142, true) -- golpe con el pie
        end

        if IsControlJustReleased(0, 166) then -- 166 es el código de la tecla F5
            ExecuteCommand('activar_punetazos')
        end
    end
end)