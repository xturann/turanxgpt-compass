local nuiVisible = true -- NUI'nin başlangıçta açık olup olmadığını takip eden değişken
local isPusulaToggled = true -- Komut ile pusulanın açılıp kapalı olduğunu hatırlamak için bir değişken

-- Fonksiyon: Oyuncunun yönünü hesapla
local directions = {"N", "NE", "E", "SE", "S", "SW", "W", "NW"}

function getDirectionFromHeading(heading)
    local index = math.floor((heading + 22.5) / 45.0) % 8 + 1
    return directions[index]
end

-- Pusula bilgisini HTML'ye gönder
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)

        if playerVehicle ~= 0 then -- Oyuncu araç içindeyse
            local playerPos = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local streetHash, crossingHash = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
            local streetName = GetStreetNameFromHashKey(streetHash)
            local zoneName = GetLabelText(GetNameOfZone(playerPos.x, playerPos.y, playerPos.z))
            local direction = getDirectionFromHeading(heading)

            -- HTML'ye gönderilecek veri
            if nuiVisible then
                SendNUIMessage({
                    show = true,
                    direction = direction,
                    street = streetName,
                    zone = zoneName
                })
            end
        else
            -- Araç dışındaysa pusulayı gizle
            if nuiVisible then
                SendNUIMessage({ show = false })
            end
        end

        Wait(500) -- Yarım saniyede bir güncelle
    end
end)

-- Komut: /pusula
RegisterCommand('pusula', function()
    nuiVisible = not nuiVisible -- NUI açık/kapalı durumunu değiştir
    isPusulaToggled = not nuiVisible -- Durumun değiştiğini hatırlamak için isPusulaToggled değişkenini güncelle
    SendNUIMessage({ show = nuiVisible }) -- NUI'yi aç/kapat
end, false)

-- Oyuncu girişte önceki durumu kontrol et
AddEventHandler('playerSpawned', function()
    nuiVisible = isPusulaToggled -- Oyuna her girişte NUI durumunu eski duruma getir
    SendNUIMessage({ show = nuiVisible })
end)
