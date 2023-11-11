RegisterNetEvent(GetCurrentResourceName() .. ':ClientBanStart')
AddEventHandler(GetCurrentResourceName() .. ':ClientBanStart', function(adminSource, reason)
    exports['screenshot-basic']:requestScreenshotUpload(Config.ImagesWebhook, 'files[]', function(data)
        local resp = json.decode(data)
        local screenshotUrl = resp.attachments and resp.attachments[1] and resp.attachments[1].proxy_url
        TriggerServerEvent(GetCurrentResourceName() .. ':ServerBanNow', adminSource, screenshotUrl or "NoScreenshot", reason)
    end)
end)