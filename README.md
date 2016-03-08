0rc - 0net Relay Chat
===================


An IRC-like internet chatroom hosted on [ZeroNet](https://github.com/hellozeronet/zeronet), a distributed network. 0rc is a fully distributed website, and messages are shared through peers using the ZeroNet stack. In addition, making a new chatroom website is a simple as downloading the files and cloning the site.

----------


Installing / Hosting 0rc
-------------
In order to start hosting 0rc, you must install ZeroNet. Instructions for doing that are available on its repository. However, once hosting the site once and getting enough peers, the site should forever be available through ZeroNet regardless of whether or not your node is running.

There are two ways to start hosting 0rc. The first is visiting the 0rc dev chatroom (must have ZeroNet running) and cloning it directly through the ZeroHello homepage UI. The second includes downloading the files from GitHub and creating a new site through the ZeroNet command line.

### Using ZeroHello
Make sure that ZeroNet is running and your client is able to contact other peers and visit sites.

Visit the [0rc dev chatroom](http://127.0.0.1:43110/dev.0rc.bit) to cause ZeroNet to download the latest version of 0rc. This will download all of the needed files.

Once the site is downloaded, head back to the ZeroNet homepage and scroll down on the site list until you find dev.0rc.bit, the site you just visited. Click on the ellipses on the right hand side of the site's entry, then click 'Clone'. This will create a new version of the chatroom entirely for you.

All of the files for this site will be in `zeronet/data/[site address]/`, and you can edit them to change the site. However, after every edit, you must resign the site and publish it. More information is available on the [ZeroNet documentation](https://zeronet.readthedocs.org/en/latest/using_zeronet/create_new_site/#2-buildmodify-site).

Editing the `content.json` file and changing the name, domain name, and description is recommended.

### Using git and a new, custom site
This way is more complicated, but also allows easy integration with the latest versions of 0rc. In addition, it gives you more complete control over the site from the get go.

Same as the previous method, make sure that ZeroNet is running and your client is able to contact other peers and visit sites.

Follow the instructions on the ZeroNet documentation on how to [create a new site](https://zeronet.readthedocs.org/en/latest/using_zeronet/create_new_site/).

> **Note:**
>
> - Make sure to save your private key, and also keep it safe.
>  - With this, anyone can sign a new version of your site and put it in place of yours.
>  - Without this, you will not be able to sign your site or make any changes to it.

Next, download the files from this repository, either by using the [zip link](https://github.com/cgm616/0rc/archive/master.zip), or cloning it with git. Find the site folder, which will be in `zeronet/data/[site address]/`, and copy all of the files just downloaded or cloned into that directory.

Next, edit the `content.json` file to have a personalized description and name of the site, and add a few lines to make 0rc work properly and not seed things it doesn't have to. Directly beneath:
```
"files": {
    "index.html": {
        "sha512": "f8557901b15e...e7d038f86c7b57",
        "size": 87836
    },
    ...
},
```
add a new section with the following:
```
"ignore": ".git/|data/.*",
"includes": {
    "data/users/content.json": {
        "signers": [],
        "signers_required": 1
    }
},
```
This will clean up the site and reduce the number of unneeded files seeded.

Next, we have to establish a `data/` directory for user data. Rename `data-default/` to `data/`. Then, rename `data/content-default.json` to `data/content.json`.

At this point, you should be all done. All that's left is to [sign and publish](https://zeronet.readthedocs.org/en/latest/using_zeronet/create_new_site/#2-buildmodify-site) your site, and then everyone on ZeroNet who has the address will be able to visit it.


License for 0rc
-------------
Due to the unique nature of ZeroNet and how it so tightly couples sharing site source code, and due to how this codebase evolved from the work of both nofish and meow, we chose to use the Unlicense for our work. Any contributions after tag v0.55 are under this license.

The complete license can be found in the file `UNLICENSE` at the root of the repository.


Contributors
-------------
All of the contributors in this list with an @zeroid.bit name are referenced by their ZeroNet usernames.

- nofish@zeroid.bit
- meow@zeroid.bit
- cgm616@zeroid.bit
- hhes@zeroid.bit
- whowaswho@zeroid.bit
