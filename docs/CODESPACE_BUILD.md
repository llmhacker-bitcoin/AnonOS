# Building AnonOS in GitHub Codespaces (VS Code Only, No Git CLI)

## Environment

- **Instance**: GitHub Codespaces (4 vCPU, 16 GB RAM)
- **Base Image**: Debian (via Dev Container)
- **Privileges**: Required (`--privileged` for loop device access)
- **Workflow**: All development happens inside VS Code (browser or desktop). No local git CLI is used.

## Quick Start

### 1. Create the Codespace from GitHub

1. Go to your `anonos` repository on GitHub.
2. Click the green **Code** button.
3. Select the **Codespaces** tab.
4. Click the dropdown arrow on **Create codespace on main**.
5. Choose **Open in browser** (or **Open in Visual Studio Code** if using desktop).

The container will auto-install `live-build` and all dependencies.

### 2. Build AnonOS

Open the integrated terminal in VS Code (`` Ctrl+` `` or Terminal -> New Terminal) and run:

VVVbash
cd /workspaces/anonos
make all
VVV

Or manually:

VVVbash
cd /workspaces/anonos
sudo lb clean
sudo lb config
sudo lb build
VVV

### 3. Download the ISO

Codespaces runs in the cloud. After building, serve the ISO via Python HTTP server:

VVVbash
make serve
VVV

Codespaces will auto-forward port 8080. Click the URL in the **Ports** tab and download `live-image-amd64.hybrid.iso`.

Alternatively, push to `main` and use the GitHub Actions workflow to download the ISO as a build artifact.

## Codespaces-Specific Notes

### Privileged Mode

live-build requires loop devices and mount privileges. The `.devcontainer/devcontainer.json` specifies `"runArgs": ["--privileged"]`. If your Codespace does not start with privileged mode, rebuild the container via the VS Code command palette: **Codespaces: Rebuild Container**.

### Disk Space

A Debian live-build can consume 5-8 GB during the build. The default Codespaces disk (32 GB) is sufficient. Monitor with:

VVVbash
df -h
VVV

### Loop Devices

If you get loop device errors, run:

VVVbash
sudo losetup -f
sudo mknod -m 660 /dev/loop0 b 7 0 2>/dev/null || true
VVV

### QEMU Testing in Codespaces

Codespaces is headless. Test with:

VVVbash
make test
VVV

This runs QEMU with `-nographic` and serial output only. Use `Ctrl+A then X` to quit QEMU.

## Committing Changes (No Git CLI)

All git operations are done through VS Code's Source Control panel:

1. Click the **Source Control** icon (branch symbol) in the left sidebar.
2. Stage changes by clicking the **+** next to each file.
3. Type a commit message in the box at the top.
4. Click **Commit** -> **Commit & Push**.

No terminal commands needed.

## Alternative: GitHub Actions CI Build

Push to `main` and the workflow in `.github/workflows/build.yml` will:
1. Install dependencies
2. Build the ISO
3. Upload it as a downloadable artifact

This is useful if you want to build without keeping a Codespace running.