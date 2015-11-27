Adblock Plus Server
===================

Centralized adblock plus for your home / office. So all kind of advertisement blocked in one place. No need to install extensions in your Desktop, Laptop, Tablet, Smartphone etc.,

Run the below docker in any one of machine in your network.

    docker run -d --restart=always --cap-add=NET_ADMIN \
    -p 8118:8118 \
    --name adblock arulrajnet/adblockplus-server:latest

Then add this as proxy server in all other system. For ex `192.168.0.10:8118`

## Guide to Setup Proxy

### Forward Proxy

In that way you have to manually configure proxy in each every client. For examble to set up proxy in below browser.

* [firefox][firefox_proxy]
* [chrome][chrome_proxy]
* [android][android_proxy]
* [ubuntu][ubuntu_proxy]

In this method client must know proxy details. 

![Alt](images/adblock-server-forward.png "Forward Proxy")

Note: There is no gureentee App in your smartphone also follow the proxy which is set in your browser. Refer this [Stackoverflow thread][so-thread]

### Transparent Proxy

In this client does not aware of proxy is there in between. So you no need to configure proxy in all client.

![Alt](images/adblock-server-reverse.png "Transparent Proxy")

In this you have to route traffic from WiFi router to proxy server then reach the internet.

Note : HTTPS traffic can't be routed via proxy. Refer [Man in the Middle Attack][man-in-middle]

#### How I have used in my Home

In my home I used transparent proxy.

Here is my setup

* Ubuntu 14.04
* Internet on Eth0 port (My ISP giving direct fibre connection)
* WiFi Hotspot in wlan0. Refer setup [wifi hotspot ubuntu][wifi-hotspot-ubuntu]

![Alt](images/adblock-server-home.png "My Home Setup")

Install Docker

```
curl -sSL https://get.docker.com/ | sh
```

Then run privoxy adblock as container

```
docker run -d --restart=always --cap-add=NET_ADMIN \
    -p 8118:8118 \
    --name adblock arulrajnet/adblockplus-server:latest
```

Copy the below text and save as file `/etc/network/if-up.d/adblockplus-privoxy`

```
#! /bin/bash
# Add iptables rule to NAT port 80 traffic to docker0:8118(Privoxy port). 

set -e

DOCKER0_IP=$(ifconfig docker0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

# IPtables rule
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to $DOCKER0_IP:8118
```

Make that as executable

```
sudo chmod +x /etc/network/if-up.d/adblockplus-privoxy
```

* Now restart your machine. 
* Connect to wifi hotspot from your smartphone. 
* all your HTTP ads are blocked without any app / extra settings in your phone.

### Using DNS

#### Iptable rule to forward DNS lookup request to dnsmasq docker

```
iptables -t nat -A OUTPUT -i wlan0 -p udp --dport 53 -j DNAT --to $DOCKER0_IP:53
iptables -t nat -A OUTPUT -i wlan0 -p tcp --dport 53 -j DNAT --to $DOCKER0_IP:53
```

#### Validate

```
dig ads.yahoo.com +short @172.17.42.1
```

If the response is `0.0.0.0` then its working.

### Roadmap

* block HTTPS ads
    - DNS lookup
* PixelServ for blocked pages
* evaluate squid-cache

### Misc

To build this container.

    docker build -t $USER/adblockplus-server:latest .

IP Tables

    iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j DNAT --to 172.17.0.1:8118

http://serverfault.com/questions/167233/iptables-https-transparent-proxy-with-privoxy

you can't just forward 443 traffic. Because its the MAN IN THE MIDDLE attack. Better use DHCP with auto-detect proxy.


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
[man-in-middle]: https://en.wikipedia.org/wiki/Man-in-the-middle_attack
[wifi-hotspot-ubuntu]: http://ubuntuhandbook.org/index.php/2014/09/3-ways-create-wifi-hotspot-ubuntu/
[so-thread]: http://stackoverflow.com/questions/24417242/do-android-proxy-settings-apply-to-all-apps-on-the-device
