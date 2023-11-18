# Moon_Bansystem


EN :

The FiveM ban system is a powerful and effective solution to keep unwanted players away from your server. It is based on a comprehensive client-server model, enabling quick identification and punishment of cheaters or other rule violations.

How it works:

Client-Side:

The ban system is activated on the client-side through a custom event (ClientBanStart). This event triggers when an administrator wants to ban a player.
It utilizes the screenshot-basic resource to capture screenshots and then uploads them to a specified webhook.
After the screenshot is uploaded, a server event (ServerBanNow) is triggered to perform the ban on the server-side.
Server-Side:

The server stores bans in a JSON file (banlist.json), containing identifiers of banned players, the reason, and the screenshot of the ban.
A custom command (tzmban) allows administrators to ban or unban players, requiring the appropriate permission (tzmbans.command).
Another event (ServerBanNow) is triggered when a player is banned. This event creates a unique ban ID, collects player identifiers, and informs the server about the ban.
Banned players receive a notification about the ban with details such as the reason, ban ID, and a screenshot of the rule violation.
Configuration:

The configuration file (config.lua) allows easy customization of settings such as permissions, command names, and webhooks for bans and screenshots.

DE :

Das FiveM Bansystem ist eine leistungsstarke und effektive Lösung, um unerwünschte Spieler von deinem Server fernzuhalten. Es basiert auf einem umfassenden Client-Server-Modell und ermöglicht die schnelle Identifizierung und Bestrafung von Cheatern oder anderen Regelverstößen.

Funktionsweise:

Client-Seite:

Das Bansystem wird über ein benutzerdefiniertes Event (ClientBanStart) auf der Client-Seite aktiviert. Dieses Event wird ausgelöst, wenn ein Administrator einen Spieler bannen möchte.
Es verwendet die screenshot-basic Ressource, um Screenshots zu erstellen und sie dann an einen spezifizierten Webhook hochzuladen.
Nachdem der Screenshot hochgeladen wurde, wird ein Server-Event (ServerBanNow) ausgelöst, um den Ban auf der Server-Seite durchzuführen.
Server-Seite:

Der Server speichert die Bans in einer JSON-Datei (banlist.json), die Identifikatoren der gebannten Spieler sowie den Grund und den Screenshot des Bans enthält.
Ein benutzerdefinierter Befehl (tzmban) ermöglicht es Administratoren, Spieler zu bannen oder zu entbannen. Der Befehl erfordert die entsprechende Berechtigung (tzmbans.command).
Ein weiteres Event (ServerBanNow) wird ausgelöst, wenn ein Spieler gebannt wird. Dieses Event erstellt eine eindeutige Ban-ID, sammelt die Spieleridentifikatoren und informiert den Server über den Ban.
Gebannte Spieler erhalten eine Benachrichtigung über den Ban mit Details wie Grund, Ban-ID und einem Screenshot des Regelverstoßes.
Konfiguration:

Die Konfigurationsdatei (config.lua) ermöglicht die einfache Anpassung von Einstellungen wie Berechtigungen, Befehlsnamen und Webhooks für Bans und Screenshots.
