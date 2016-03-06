class ZeroChat extends ZeroFrame
    init: ->
        @addLine "inited!"


    selectUser: =>
        Page.cmd "certSelect", [["zeroid.bit"]]
        return false


    route: (cmd, message) ->
        if cmd == "setSiteInfo"
            if message.params.cert_user_id
                document.getElementById("select_user").innerHTML = message.params.cert_user_id
            else
                document.getElementById("select_user").innerHTML = "Select user"
            @site_info = message.params  # Save site info data to allow access it later

            # Reload messages if new file arrives
            if message.params.event[0] == "file_done"
                @loadMessages()

    resetDebug: ->
        document.getElementById("list").innerHTML = ""

    debugMsg: (msg) ->
        newElement = document.createElement('li')
        newElement.innerHTML = msg
        document.getElementById("list").appendChild(newElement)

    resetInputField: =>
        document.getElementById("message").disabled = false
        document.getElementById("message").value = ""  # Reset the message input
        document.getElementById("message").focus()

    sendMessage: =>
        if not Page.site_info.cert_user_id  # No account selected, display error
            Page.cmd "wrapperNotification", ["info", "Please, select your account."]
            return false

        document.getElementById("message").disabled = true
        inner_path = "data/users/#{@site_info.auth_address}/data.json"  # This is our data file

        # Load our current messages
        @cmd "fileGet", {"inner_path": inner_path, "required": false}, (data) =>
            if data  # Parse if already exits
                data = JSON.parse(data)
            else  # Not exits yet, use default data
                data = { "message": [] }

            # // EMPTY MESSAGES
            msg = document.getElementById("message").value
            if msg == "" or msg == "/me" or msg == "/me "
                @debugMsg('empty message')
                @resetInputField()
                return false
            # Add the message to data
            data.message.push({
                "body": document.getElementById("message").value,
                "date_added": (+new Date)
            })

            # Encode data array to utf8 json text
            json_raw = unescape(encodeURIComponent(JSON.stringify(data, undefined, '\t')))

            # Write file to disk
            @cmd "fileWrite", [inner_path, btoa(json_raw)], (res) =>
                if res == "ok"
                    # Publish the file to other users
                    @cmd "sitePublish", {"inner_path": inner_path}, (res) =>
                        @resetInputField()
                        @loadMessages()
                else
                    @cmd "wrapperNotification", ["error", "File write error: #{res}"]
                    document.getElementById("message").disabled = false

        return false


    replaceURLs: (body) ->
        # // REGEXES
        replacePattern0 = /(http:\/\/127.0.0.1:43110\/)/gi
        replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim
        replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim
        replacePattern3 = /(([a-zA-Z0-9\-\_\.])+@[a-zA-Z\_]+?(\.[a-zA-Z]{2,6})+)/gim
        replacePattern4 = /0net:\/\/([-a-zA-Z0-9+&.,:+_\/=?]*)/g
        replacePattern5 = /(([a-zA-Z0-9\-\_\.])+)\/\/0mail/gim;
        
        # // url rewriting 127.0.0.1:43110 to 0net:// so other replacements don't break
        replacedText = body.replace(replacePattern0, '0net://')
        replacedText = replacedText.replace('@zeroid.bit', '//0mail')

        # // URLs starting with http://, https://, or ftp://
        replacedText = replacedText.replace(replacePattern1, '<a href="$1" target="_blank" style="color: red; font-weight: bold;">$1</a>');

        # // URLs starting with "www." (without // before it, or it'd re-link the ones done above).
        replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank" style="color: red; font-weight: bold;">$2</a>')

        # // Change email addresses to mailto:: links.
        replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1" style="color: red; font-weight: bold;">$1</a>')

        # // replace 0net:// URL href back to http://127.0.0.1:43110
        replacedText = replacedText.replace(replacePattern4, '<a href="http://127.0.0.1:43110/$1" target="_blank" style="color: green; font-weight: bold;">0net://$1</a>')

        # // rewrite link href and replace //0mail with @zeroid.bit
        replacedText = replacedText.replace(replacePattern5, '<a href="http://127.0.0.1:43110/Mail.ZeroNetwork.bit/?to=$1" target="_blank" style="color: green; font-weight: bold;">$1@zeroid.bit</a>')

        return replacedText

    loadMessages: ->
        query = """
            SELECT message.*, keyvalue.value AS cert_user_id FROM message
            LEFT JOIN json AS data_json USING (json_id)
            LEFT JOIN json AS content_json ON (
                data_json.directory = content_json.directory AND content_json.file_name = 'content.json'
            )
            LEFT JOIN keyvalue ON (keyvalue.key = 'cert_user_id' AND keyvalue.json_id = content_json.json_id)
            ORDER BY date_added
        """
        @cmd "dbQuery", [query], (messages) =>
            document.getElementById("messages").innerHTML = ""  # Always start with empty messages
            message_lines = []

            # // remove later
            @resetDebug()

            for message in messages
                body = message.body.replace(/</g, "&lt;").replace(/>/g, "&gt;")  # Escape html tags in body
                added = new Date(message.date_added)

                # // OUR ADDITIONS
                time = Time.since(message.date_added / 1000)
                userid = message.cert_user_id
                useridcolor = Text.toColor(userid)
                username = message.cert_user_id.replace('@zeroid.bit', '')
                msgseparator = ":"

                # // REPLACE URLS
                body = @replaceURLs(body)

                # // REPLACE IRC
                if body.substr(0,3) == "/me"
                    action = body.replace("/me","")
                    username = username+' '+action
                    body = ''
                    msgseparator = ''

                # // STYLE OUR MESSAGES AND MENTIONS
                prestyle=""
                poststyle=""
                # our messages
                if userid == Page.site_info.cert_user_id
                    prestyle = '<span style="color:black; font-weight:bold;">'
                    poststyle = '</span>'
                # our mentions
                if Page.site_info.cert_user_id and body.indexOf(Page.site_info.cert_user_id.replace('@zeroid.bit', '')) > -1
                    prestyle = '<span style="color:blue; font-weight:bold;">'
                    poststyle = '</span>'
                body = prestyle + body + poststyle

                message_lines.push "<li><small title='#{added}'>#{time}</small> <b style='color: #{useridcolor}'>#{username}</b>#{msgseparator} #{body}</li>"
            message_lines.reverse()
            document.getElementById("messages").innerHTML = message_lines.join("\n")


    addLine: (line) ->
        messages = document.getElementById("messages")
        messages.innerHTML = "<li>#{line}</li>"+messages.innerHTML


    # Wrapper websocket connection ready
    onOpenWebsocket: (e) =>
        @cmd "siteInfo", {}, (site_info) =>
            document.getElementById("bigTitle").innerHTML = site_info.content.title + ' - ' + site_info.content.description
            document.getElementById("peerCount").innerHTML = site_info.peers + ' Visitors'

            # Update currently selected username
            if site_info.cert_user_id
                document.getElementById("select_user").innerHTML = site_info.cert_user_id
            @site_info = site_info  # Save site info data to allow access it later
        @loadMessages()


window.Page = new ZeroChat()
