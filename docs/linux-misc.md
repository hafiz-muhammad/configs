## Install & Setup Oh My Posh

[Official Oh My Posh Linux instructions](https://ohmyposh.dev/docs/installation/linux)

1. Make bin folder in your home directory:
    ```console
    mkdir ~/bin
    ```

2. Installation:
    ```console
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/bin
    ```

3. Copy the [`oh-my-posh.bashrc`](https://github.com/hafiz-muhammad/configs/blob/main/linux/home/.bashrc.d/oh-my-posh.bashrc) file in this repository, and add it to `~/.bashrc.d`.

4. Reload profile for changes to take effect:
    ```console
    exec bash
    ```

## Create ~/.local/bin directory if it doesn't exist
```console
mkdir ~/.local/bin
```