Limit Deskop Sessions Per User
==============================

This simple util allows only one Linux desktop session per user.

When user attempts to start new desktop session instead of logging in already existing one, it will throw it back to the login screen.

This is a workaround of [such issue](https://github.com/sddm/sddm/issues/447). There is a [suggested patch](https://github.com/sddm/sddm/pull/730) but it's not merged to the master yet.

Installing
----------

Run `./install` script. Restart your display manager (e.g. `sudo systemctl restart sddm`) and select session **Limit Session Per User** on the login screen instead of default one.

To uninstall run `./install --uninstall`.
