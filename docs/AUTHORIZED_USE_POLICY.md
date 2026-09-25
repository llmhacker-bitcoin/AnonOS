# AnonOS Authorized Use Policy

## 1. Purpose

AnonOS is a privacy-hardened live operating system designed to protect user identity and network traffic through Tor-enforced networking, MAC randomization, and time/clock hardening.

This policy governs what tools may be added to AnonOS and under what circumstances.

## 2. No Pentest Tools in the MVP

The Minimum Viable Product (MVP) of AnonOS contains **no penetration testing, exploitation, or offensive security tools**.

This is an intentional design decision:
- The privacy controls (Tor enforcement, firewall, MAC randomization, clock hardening) must be audited and tested first.
- Adding offensive tools before the privacy layer is hardened would create a false sense of security.
- Tooling decisions will be made only after the privacy layer passes testing.

## 3. Criteria for Future Tool Inclusion

Any future addition of security tools must meet ALL of the following criteria:

1. **Legal Compliance**: The tool is legal to possess and use in the jurisdictions where AnonOS is distributed.
2. **Authorized Use Only**: The tool is intended solely for:
   - Authorized penetration testing with written permission
   - Security research in controlled environments
   - Educational purposes in legal settings
   - Defensive security and hardening of your own systems
3. **Documentation**: Each tool must be accompanied by:
   - A clear description of its function
   - Explicit warnings about unauthorized use
   - References to applicable laws and ethical guidelines
4. **Community Review**: Tool additions require review and consensus from the AnonOS maintainers.

## 4. Prohibited Uses

AnonOS must not be used for:
- Unauthorized access to computer systems or networks
- Interception of communications without legal authority
- Distribution of malware or malicious software
- Any activity that violates applicable laws

## 5. Disclaimer

AnonOS is provided as-is for privacy protection and legitimate security research. The maintainers assume no liability for misuse. Users are solely responsible for ensuring their use of AnonOS complies with all applicable laws and regulations.

## 6. Reporting Misuse

If you discover AnonOS being used for illegal activities, report it to the appropriate legal authorities in your jurisdiction.

---

**Version**: MVP 0.1
**Last Updated**: 2026-09-25