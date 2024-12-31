# gatsby

install nvm
```bash
rm -rf ~/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.bashrc
```
Then install node
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
source ~/.bashrc 
nvm install --lts # Install the latest LTS version of Node.js
nvm use 22.12.0 # Use the installed Node.js version (replace with the desired version)

```

install gatsby
```bash
sudo npm install -g gatsby-cli
```

ok this was hard and i ran out of space on my vm.

but at the end i managed to get it running with the following commands:

```bash
 docker build -t gat .
 docker run --rm -it -p 8001:8001 -v ~/data/gatsby-data:/usr/src/app gat
 ```
 in any case i got the error that i had to update to node 18 at least and then I ran out of space. Also it doesnt work on a shared virtual machine volume, so this approach is not valid, I then decided to use something else.