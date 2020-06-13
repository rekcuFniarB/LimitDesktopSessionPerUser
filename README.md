Limit Deskop Sessions Per User
==============================

This simple util allows only one Linux desktop session per user.

When user attempts to start new desktop session instead of logging in already existing one, it will activate existing session of this user.

This is a workaround of [such issue](https://github.com/sddm/sddm/issues/447). There is a [suggested patch](https://github.com/sddm/sddm/pull/730) but it's not merged to the master yet.

Installing
----------

Run `./install` script. Restart your display manager (e.g. `sudo systemctl restart sddm`) and select session **Limit Session Per User** on the login screen instead of default one.

To uninstall run `./install --uninstall`.

Configuring
-----------

By default it will use **Plasma Desktop**. You can override it in `/etc/limitsessionperuser.conf`:

    SESSION='/usr/share/xsessions/plasma.desktop'

Other config options:

* `TERMINATESESSION=Y` terminates session to avoid session hang on exiting. (see bug https://bugs.kde.org/show_bug.cgi?id=417038 )
* `ACTION='KILL'` terminates old sessions and starts new one instead of reusing existing session. Disabled by default, this doesn't work properly for some reason.
