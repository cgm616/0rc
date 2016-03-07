---------------------------------------------
0rc - 0net Relay Chat v0.55
---------------------------------------------

CONTRIBUTORS
- nofish@zeroid.bit (origin)
- meow@zeroid.bit
- cgm616@zeroid.bit
- hhes@zeroid.bit
- whowaswho@zeroid.bit

SEEKING NEW CONTRIBUTORS

---------------------------------------------

CURRENT FEATURES
- /me actions
- clickable urls/emails
- bolding your messages to stand out
- highlighting messages that mention you
- dark theme (rushjob)
- empty messages prevented
- visitor count

---------------------------------------------

TODO

NOTE
there's a hidden div called '#rhs' that is currently set to 'display: none',
it has a list inside that you can put text into, using these functions: 
ZeroChat.prototype.resetDebug() and ZeroChat.prototype.debugMsg(msg)

NEW FEATURES TO MAKE
- command '/r' to quickly reply to the last person who mentioned you
- updating the room name and description should update the title/desc in the header immediately
- press tab to autocomplete @mention names
- visitor count should be number of currently connected peers
- proper user list
- proper notifications when people connect/disconnect
- prevent repeated messages to stop spammers/flooders
- help command (like IRC)
- setting a topic (perhaps only the owner and special users)
- moderated users
- IMs?
- embedded images (scale them down to save space, hover over or click to expand)

LAYOUT/UI
- keep header and textbox at the top of the screen, when scrolling through the chat
- have all of your mentions collated in a mini inbox kind of thing (maybe)

IMPROVE DARKTHEME
- adjust colours for darktheme, I rushed it, all darktheme code is inlined in index.html
- adjust inline markup for highlighted messages and links so they aren't horrible to look at
- fix toggling of this rule: li:nth-child(odd) { background-color: #F9FAFD; }

USER PREFERENCES
- use localStorage for user prefs
- option to flip messages so new messages appear at the bottom and scroll up like in slack or IRC
- timestamp options
- textbox size
- layout
- theme

IMPROVE RESPONSIVENESS
- add new msg to '#messages' div immediately and do NOT reload ALL messages
- allow a cap on how many messages to load
- allow site owner to periodically purge messages

---------------------------------------------

BUGS
- Some messages get stuck at the top or get displayed out of order with 'Just now', this is a general ZeroChat bug

IF YOU GET CONTENT SIGNED FAILED: INVALID PRIVATE KEY
This is how I fix it
- I clone siteA to siteB
- I copy siteB's data into siteA
- I republish siteA
That seems to fix it, but the messages get cut off

