# Developing in DevContainers

## Use This Kit

- create a git repo that has the base files and start tweaking

## Getting Windows Git Credentials into WSL2

```bash
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
```

[source](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup)

## Getting a .devcontainer.json into a repo

### Using  _Github Gist_

**This process is easier with _git submodules_.**

```sh
curl --output .devcontainer.json -L  https://gist.github.com/waltiam/c94e2d042cac1e7976ebac9e683f2287/raw 
```

The example here uses the `.devcontainer.json` for the go lang container.

### Using _git submodules_

This is intended to be used as a git sub-module. 

To use in an existing repo first delete the existing `.devcontainer` folder and commit this change.

```bash
git rm -rf .devcontainer\
```

Then clone and update the .devcontainer submodule.

```bash
cd {root project}
git submodule add https://github.com/waltiam/submodule-golang.git .devcontainer
git submodule init
git submodule update
```

If you make change to the .devcontainer that you want to commit back to the repo.

```bash
cd {project root}/.devcontainer
git add {changes to add}
git commit -m"{commit mesage}"
git push
cd ..
git submodule update
```

## General WSL

- [Configuring WSL](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)

Sone extensions (_GitGraph_) require `socat` to communicate with the host this can be installed with:

```sh
sudo apt-get install socat
```

Executed from the WSL shell.

## SSH and Commit Signing

[Microsoft has this to say about it.](https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container)

The short of this is that there are three options:

1. SSH without a passphrase - relying on the public/private key pair.
1. HTTPS using the Windows Credential Manager
1. Use the VSCode terminal and not the UI

I opted to go with SSH and no passphrase; the UI tools within VSCode allow for the PR into branches to be and using HHTPS potentially exposes the github credential to attack.

THe GPG and GPG/SM processes below could also be set to use password free, again relying on the public/private keys.

### SSH

The general idea is that I do not want tokens, credentials or passwords in the repo.  This means there will be inevitably some manual steps happening.  To start with we share the ~/.ssh folder with the docker image as ${user}/.ssh, as long as the ssh token have been properly configured in github this should work.

```json
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached",
```

### Commit Signing

A little more complex because there are actual manual steps to create the and sign the token.

> Taking the steps to create a gpg cert from [Signing your GitHub commits using GPG keys on Windows](https://kolappan.dev/blog/2021/signing-your-commits/).

Configure a gpg commit signing key on the WSL instance.

```sh
gpg --full-key-gen --pinentry-mode loopback
... etc
```

- The important thing here is the `--pinentry-mode loopback` and be sure that `export GPG_TTY=$(tty)` has been added to the shell rc file.

Again though, let's start with sharing the folder where the gpg token is stored.  Mount e `~/.gnupg` folder with the dev container:

```json
    "source=${localEnv:HOME}/.gnupg,target=/home/vscode/.gnupg,type=bind,consistency=cached",
```

Run the git configuration steps on the docker image, this will require the public key.

The final piece of the puzzle, the GPG commit signing requires a encryption key. Once the PGP key is generated in the WSL environment this "should just work" &trade; .  Almost, the key turned out to be that for some reason the docker dev container doesn't take the default recipient, fixed that by adding the following line into the `~/.gnupg/gpg.conf` file:

```
recipient {your email accosicated with the token}
```

### Sectigo x.506 - s/mime

Run through the setup in as per the [Sectigo Documentation](https://confluence.comodoca.net/pages/viewpage.action?pageId=115377205).  When it comes to the part about configuring git the commands should be executed in the .devcontainer, only the following are really needed and could be scripted out per user and stored outside the container:

```sh
git config --global gpg.program $(which gpgsm)
git config --global gpg.format x509
git config --global user.signingkey 0xDDDDDDDD
git config --global user.email 'walt.speelman@sectigo.com'
```

Somewhere, I cannot find the original post anywhere, it was said that the command `export GPG_TTY=$(tty)` also needed to be executed.

Other things that I still need to explore to help stablize the signing environment:

- `gpgconf --kill gpg-agent`
- `echo UPDATESTARTUPTTY | gpg-connect-agent`

### Password Prompting ...

- Installing the [Gpg4win](https://gpg4win.org/index.html) tool.  
- Update the `~/.gnupg/gpg-agent.conf` file with the addition of:

```txt
pinentry-program "/mnt/c/Program Files (x86)/GnuPG/bin/pinentry-basic.exe"
default-cache-ttl 34560000
max-cache-ttl 34560000
```

Execute a `gpgconf --kill gpg-agent` for good luck (gI feel this is sort of like a goat sacrifice at this point).

### Resources that Got Us Here

- [Started with this](https://kolappan.dev/blog/2021/signing-your-commits/)
- [creating subkeys](https://oguya.ch/posts/2016-04-01-gpg-subkeys/)
- [Git - the horses mouth](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
- [The hint that said we needed an encryption key](http://www.verycomputer.com/92_d9ba28a257565c3a_1.htm)
- [Parsing the GPG output with **awk**](https://www.tutorialspoint.com/awk/awk_basic_examples.htm)
- [GPG - though the actual `man gpg` was more useful](https://www.tutorialspoint.com/unix_commands/gpg.htm)
- [Git - starting page of the set up for Github](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/about-commit-signature-verification)
- [Some interesting stuff, can't remember if this actually told me anything new though](https://medium.com/@rwbutler/signing-commits-using-gpg-on-macos-7210362d15#:~:text=%20Signing%20Commits%20Using%20GPG%20on%20macOS%20,Alternatively%20when%20committing%2C%20supply%20the%20-S...%20More%20)
- [Where you're gonna store these things on GitHub](https://github.com/settings/keys)
- [The online manpage for `gpgsm`](https://linux.die.net/man/1/gpgsm)
- [Configuring `GPG_TTY`](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html#Agent-Examples)

## More information:

- [Atlassian Intro](https://www.atlassian.com/git/tutorials/git-submodule)
- [Git Details](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

The _template-golang_ has this sub-module already inserted.

If you make changes to this submodule remember to add and commit from the `.devcontainer` folder.

Licensed under the MIT License.

//! TODO: add license file

## Deprecation Notice of Folders

There is a far better repository by Microsoft [here](https://github.com/microsoft/vscode-dev-containers/tree/master/containers).

## Setup and Initial Configuration

This is a quick walk through of setting up a development environment in VS Code using docker images. I don't claim great knowledge on this, I've got them running and they seem to be ok.

* [Visual Sutdio Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)
* [64-Dev-Docker/dev-env (github.com)](https://github.com/64-Dev-Docker/dev-env)
* [Docker Hub](https://hub.docker.com/)
* [go lang docker container configuration (github.com)](https://ygist.github.com/waltiam/c94e2d042cac1e7976ebac9e683f2287)

> To the best of my knowledge this technology does not apply to Visual Studio.

## Issues

If you've run into issues with file ownership:

### Linux Error

If this is your error:

```bash
> git commit -m"clever commit message"
$ fatal: could not open '.git/COMMIT_EDITMSG': Permission denied
```

This should resolve the immediate challenge
```bash
chown -R $(whoami) .
```

A better, and longer term solution would be to review the users in the local and remote docker container.
