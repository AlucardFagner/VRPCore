autentifikazioa = {}

autentifikazioa.ELeRDebFM8Mo = 'João Paulo Leal'
autentifikazioa.DE1pHmHzBLnu = '1325622224'
autentifikazioa.j2CTk1ri8vbH = 'teste@ziraflix.com'
autentifikazioa.IZ4k0pTQ2YJ7 = '<@319321727630835712>'
autentifikazioa.GH9dyuApTPlf = '319321727630835712'
autentifikazioa.gV8yFOU3CJGR = 'https://discord.com/api/webhooks/785562766949613588/RR0voR7PwiZ7w-FZwDai6JLJb7dhnRN1FJMiEgP1S_IMJTXen-xdAizHwF4gHs8EKtev'

RegisterNetEvent("zFuel:oUNmQpyLjlqm")
AddEventHandler("zFuel:oUNmQpyLjlqm",function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PerformHttpRequest("http://191.96.225.73:3558/ovjeren/ovjeren.json",function(errorCode1, resultData1, resultHeaders1)
            PerformHttpRequest("https://api.ipify.org/",function(errorCode, resultData, resultHeaders)
                local data = json.decode(resultData1)
                for k, v in pairs(data) do
                    if k == autentifikazioa.GH9dyuApTPlf then
                        for a, b in pairs(v) do
                            if GetCurrentResourceName() == a then
                                if resultData == b then
                                    TriggerEvent('zFuel:QpsHccErjwyA')
                                end
                            end
                        end
                    end            
                end
            end)
        end)
    end
end)