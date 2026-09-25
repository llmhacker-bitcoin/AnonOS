# AnonOS MVP

A privacy-hardened, live-bootable Debian-based operating system with Tor-enforced networking.

## What is AnonOS?

AnonOS is a minimal, live Debian image designed to:
- Route all network traffic through Tor (Whonix-style gateway pattern)
- Block all direct internet connections via a deny-all nftables firewall
- Randomize MAC addresses on every network interface bring-up
- Harden clock and timezone settings to prevent information leakage

## Architecture

```
+------------------+
|   Applications   |
|  (Firefox, etc.) |
+--------+---------+
         |
         v
+--------+---------+
|   Tor SOCKS/Trans|
|   Port (9050/9040)|
+--------+---------+
         |
         v
+--------+---------+
|   Tor Daemon     |
| (debian-tor user)|
+--------+---------+
         |
         v
+--------+---------+
|  nftables Filter |
| (deny-all except |
|  Tor egress)     |
+--------+---------+
         |
         v
+--------+---------+
|  Network Interface|
|  (MAC randomized) |
+------------------+
```

## Quick Start

### Prerequisites

- Debian 12 (bookworm) or compatible
- `live-build` package installed
- At least 10 GB free disk space
- Internet connection for package downloads

### Build

```bash
sudo apt update
sudo apt install live-build

cd anonos-mvp
sudo lb clean
sudo lb config
sudo lb build
```

The resulting ISO will be `live-image-amd64.hybrid.iso`.

### Run in a VM

```bash
qemu-system-x86_64 -cdrom live-image-amd64.hybrid.iso -m 2048 -enable-kvm
```

### Flash to USB

```bash
sudo dd if=live-image-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress
sync
```

Replace `/dev/sdX` with your USB device (use `lsblk` to identify).

## Privacy Features

### 1. Tor-Enforced Networking

All outbound traffic is forced through Tor:
- Applications must use SOCKS5 proxy at `127.0.0.1:9050`
- Transparent proxying on port `9040` for non-Tor-aware apps
- DNS queries routed through Tor DNSPort at `127.0.0.1:5353`
- Direct internet connections are blocked by nftables

### 2. Deny-All Firewall

nftables configuration:
- Default policy: DROP on input, forward, and output
- Only Tor daemon (running as `debian-tor`) can initiate external TCP connections
- Local loopback and Tor ports are allowed
- ICMP is rate-limited for basic connectivity health

### 3. MAC Randomization

On every network interface up event:
- Interface is brought down
- `macchanger -r` assigns a random MAC address
- Interface is brought back up

This happens automatically for all physical interfaces (`eth*`, `wlan*`, `en*`, `wl*`).

### 4. Clock / Timezone Hardening

- Timezone forced to UTC to prevent local timezone leakage
- Hardware clock uses UTC (no local time storage)
- NTP is blocked by firewall to prevent cleartext time leaks
- Future versions will use Tor-based time synchronization

## Verification

After booting AnonOS, open a terminal and run:

```bash
anonos-status
```

This will show:
- Tor service status
- Active nftables rules
- External IP (via Tor)
- Current MAC addresses
- Timezone setting

You can also reapply the firewall manually:

```bash
sudo anonos-apply-firewall
```

## Building in GitHub Codespaces

AnonOS includes a devcontainer configuration for building in GitHub Codespaces using VS Code (browser or desktop). No local git CLI is required.

### Setup

1. Create a codespace on the repository
2. The container auto-installs `live-build` and dependencies
3. Run:

```bash
make all
```

4. Download the ISO via the forwarded port (port 8080) or via GitHub Actions artifacts.

See `docs/CODESPACES_BUILD.md` for detailed instructions.

## Pentest Tools Policy

**The MVP contains no penetration testing tools.**

See `docs/AUTHORIZED_USE_POLICY.md` for:
- Why tools are excluded from the MVP
- Criteria for future inclusion
- Prohibited uses and legal compliance requirements

No tools will be added until the privacy layer passes testing and the policy is finalized.

## Project Structure

```
anonos-mvp/
├── auto/config                          # live-build configuration
├── config/
│   ├── package-lists/anonos.list.chroot # Package manifest
│   ├── hooks/normal/anonos.hook.chroot  # Post-install hardening hook
│   └── includes.chroot/
│       ├── etc/tor/torrc                # Tor configuration
│       ├── etc/nftables/anonos.conf     # Firewall rules
│       ├── etc/network/if-up.d/         # MAC randomization
│       ├── etc/anonymization/           # Clock hardening scripts
│       └── usr/local/bin/               # Helper scripts
└── docs/
    └── AUTHORIZED_USE_POLICY.md         # Tooling policy
```

## Roadmap

### MVP (Current)
- [x] Debian live-build base
- [x] Tor gateway pattern
- [x] Deny-all nftables firewall
- [x] MAC randomization
- [x] Clock/timezone hardening
- [x] Authorized use policy

### Next Steps
- [ ] Audit: verify no traffic leaks around Tor
- [ ] Replace NTP with Tor-based time sync (sdwdate)
- [ ] Add AppArmor profiles for critical services
- [ ] Implement stream isolation for different applications
- [ ] Consider pentest tools only after privacy layer passes audit

## License

See LICENSE file for details.

## Disclaimer

AnonOS is provided for privacy protection and legitimate security research. Users are responsible for complying with all applicable laws. See `docs/AUTHORIZED_USE_POLICY.md`.
