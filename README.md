Adblock Plus Server
===================

Centralized adblock plus for your home / office. So all kind of advertisement blocked in one place. No need to install extensions in your Desktop, Laptop, Tablet, Smartphone etc.,

Run the below docker in any one of machine in your network.

    docker run -d --cap-add=NET_ADMIN \
    -p 8118:8118 \
    --name adblock arulrajnet/adblockplus-server:latest

Then add this as proxy server in all other system. For ex `192.168.0.10:8118`

Guide to Setup Proxy in

* [firefox][firefox_proxy]
* [chrome][chrome_proxy]
* [android][android_proxy]
* [ubuntu][ubuntu_proxy]

### For Geek 

These steps for advanced yours 

    docker build -t arulrajnet/adblockplus-server:latest .

Suppose you want to redirect all your router traffic to privoxy. you have touch into the iptables. 

TODO: To be done. Not yet completed.

iptables -t nat -A PREROUTING --source 10.42.0.1/24 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8118

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8118
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8118

above 2 not working

    iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to 172.17.0.1:8118

iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 443 -j DNAT --to 172.17.0.1:8118

Reference
---------

https://github.com/RMerl/asuswrt-merlin/wiki/How-to-use-Adblock-Plus-filter-subscriptions-to-provide-advertisement-filtering-to-devices

https://github.com/evaryont/bin/blob/master/adblock-to-privoxy

https://github.com/StevenBlack/hosts/blob/master/updateHostsFile.py


License
-------

[MIT License][mit_license]. 


**Author**

| [![follow][avatar]][twitterhandle] |
|---|
| [@arulrajnet][twitterhandle] |

[twitterhandle]: https://twitter.com/arulrajnet "Follow @arulrajnet on Twitter"
[avatar]: https://avatars0.githubusercontent.com/u/834529?s=70
[mit_license]: https://raw.githubusercontent.com/arulrajnet/adblockplus-server/master/LICENSE
[firefox_proxy]: http://www.wikihow.com/Enter-Proxy-Settings-in-Firefox
[chrome_proxy]: https://support.google.com/chrome/answer/96815?hl=en
[android_proxy]: https://adblockplus.org/android-config-samsung-galaxy-s3
[ubuntu_proxy]: http://www.ubuntugeek.com/how-to-configure-ubuntu-desktop-to-use-your-proxy-server.html