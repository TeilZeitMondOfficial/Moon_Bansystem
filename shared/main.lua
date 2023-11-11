Config = {
    CommandPerm = "tzmbans.command", -- Perm ( add_ace group.GROUPNAME tzmbans.command allow ) ( add_ace group.admin tzmbans.command allow )
    BanSystemCommand = "tzmban", -- Command name ( /tzmban ( /tzmban ban playerid reason ) ( /tzmban unban banid ) )
    BanSystemName = "MQ_BANSYS", -- Print Prefixes
    BansWebhook = "WebhookURL", -- Webhook for all bans
    ImagesWebhook = "WebhookURL", -- All ban images will get send in here ( Works as Image Storage )
    BansJSONName = "data/banlist.json" -- Means banlist.json in folder "data"
}