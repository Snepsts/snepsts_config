# Setting up Github stuffs

## SSH key

### Setup

Install some needed packages:

`pacman -S openssh xclip`

### Generate SSH key

Run the key generator:

`ssh-keygen -t rsa -b 4096 -C "replace_your@email.here"`

It will prompt you for the file to save it to, enter this:

`/home/your_user_name_here/.ssh/id_rsa_github`

It will prompt you for a passphrase. Up to you if you want to enter one.

After that, open `~/.ssh/config`:

`nano ~/.ssh/config`

and enter the following lines somewhere in the file:

```
AddKeysToAgent yes

Host github.com
	User git
	IdentityFile /path/to/your/ssh/key
```

You're good to go from your computer's side.

### Add it to your github account

Run this command to copy your public key to your clipboard thing:

`xclip -sel clip < ~/.ssh/id_rsa_github.pub`

Go to Github. Navigate to Settings > SSH and GPG keys. Click on the New SSH key button, should be self explanatory from there.

## GPG key

### Setup

Install gpg:

`pacman -S gnupg`

### Generate GPG key

Start key generation:

`gpg --full-generate-key`

When prompted for key type, enter 1 (RSA and RSA)

Key size should be 4096 bits long

Key should be valid for 0 (indefinite)

Enter your information as prompted

When prompted for a passphrase, give one you are comfortable with.

### Add to Github

Find your key:

`gpg --list-secret-keys --keyid-format LONG`

Your key will be after sec, in an output like this:

```
sec rsa4096/abcdefg 2019-10-01 [SC]
    zxcvbn
uid blah blah blah
ssb rsa4096/asdfghjkl
```

Your key is `abcdefg`

To get your full key, type `gpg --armor --export abcdefg | xclip -selection clipboard` substituting `abcdefg` with your actual key id. This command copies the key to your clipboard.

Go to Github. Navigate to Settings > SSH and GPG keys. Click on the New GPG key button. Should be self-explanatory from there.

### Configuring git to use your new GPG key

Remember `abcdefg` from earlier? Cool. We're gonna use it to tell git about our signing process:

`git config --global user.signingkey abcdefg`

Also, let's tell git to always sign it:

`git config --global commit.gpgsign true`

Finally, we need to make sure gpg knows where to prompt for info:

`export GPG_TTY=$(tty)`

Add it to your `.zshrc` or something similar to that.
