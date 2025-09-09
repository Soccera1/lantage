# Lantage

Lantage (LAN + Portage) is a client/server system to offload Gentoo package compilation to a remote, more powerful machine.

It is licensed under the **AGPL v3**. See the `LICENSE` file for more details.

## Features

- **Correct Builds**: The client sends its local `/etc/portage` configuration to the server, ensuring that all packages are compiled with the correct `USE` flags, `CFLAGS`, and other settings for the client machine.
- **Simple**: The system consists of two standalone Python scripts with no external dependencies.
- **Pretend First**: Uses `emerge --pretend` to safely calculate the dependency tree before sending it to the builder.

## How It Works

1.  The `lantage` client script is run on the client machine (e.g., a low-powered laptop).
2.  It runs `emerge --pretend` to get a list of packages to be built.
3.  It creates a tarball of the client's `/etc/portage` directory.
4.  It sends the package list and the configuration tarball to the `lantaged` server.
5.  The `lantaged` server receives the job, unpacks the client's configuration into a temporary directory, and runs `emerge --buildpkgonly` for each package using the client's configuration.
6.  The server then creates a tarball of the resulting binary packages and sends it back to the client.
7.  The client saves the binary package tarball and provides the user with the commands to install the packages.

## Installation

There are two ways to install Lantage.

### 1. Using the Ebuilds (Recommended for Gentoo)

This is the standard Gentoo way. You will need to create a local overlay.

1.  **Create the overlay directory:**
    ```bash
    # mkdir -p /var/db/repos/local
    # chown portage:portage /var/db/repos/local
    ```

2.  **Configure the overlay in `/etc/portage/repos.conf/`:**
    Create a file named `/etc/portage/repos.conf/local.conf` with the following content:
    ```ini
    [local]
    location = /var/db/repos/local
    ```

3.  **Copy the ebuilds to your overlay:**
    From the lantage project directory:
    ```bash
    # cp -r portage/* /var/db/repos/local/
    ```

4.  **Generate the manifest:**
    ```bash
    # ebuild /var/db/repos/local/app-admin/lantage/lantage-0.1.ebuild manifest
    # ebuild /var/db/repos/local/app-admin/lantaged/lantaged-0.1.ebuild manifest
    ```

5.  **Install the packages:**
    - On the client machine: `# emerge lantage`
    - On the server machine: `# emerge lantaged`

### 2. Using the Makefile

For a simpler installation that doesn't use the Portage package manager directly, you can use `make`.

- To install both scripts: `# make install`
- To uninstall: `# make uninstall`

## Usage

### Server Machine

On your powerful build machine, run the `lantaged` daemon. It requires root to run `emerge`.

```bash
# lantaged
Starting lantaged on 0.0.0.0:8473...
```

### Client Machine

1.  **Set the server's IP address:**
    ```bash
    export LANTAGE_HOST=192.168.1.100
    ```

2.  **Run `lantage` as a wrapper around `emerge`:**
    ```bash
    $ lantage emerge -auvDN @world
    ```

3.  **Install the received packages:**
    The script will download the binaries and print the final commands for you. You will need to run them as root.

    ```bash
    # tar -xvf /tmp/tmpXXXX.tar.gz -C /var/cache/binpkgs/
    # emerge --usepkg --binpkg-respect-use=y -k [args]
    ```
