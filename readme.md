# Certificate Generation Script

## Usage

`cgen.sh [-d] [-e] [-h] domain`

## Flags

```bash
#   -d : Generate dhpram2 pem file
#   -e : Generate certificates for different environments (INT, QA, Prod)
#   -h : Display this help message
#
# Example Usage:
#   ./csrgen.sh sample.site.com               # Generate CSR and KEY for sample.site.com
#   ./csrgen.sh -d sample.site.com            # Generate CSR, KEY, and DH pem file
#   ./csrgen.sh -e sample.site.com            # Generate CSR and KEY for INT, QA, and Prod environments
```

## Setting up script as a terminal command

run the following command from the project's directory to add the script to your path variable. This wil enable tthe use the command `csrgen`

```bash
mkdir -p ~/scripts
cp csrgen.sh ~/scripts/
mv ~/scripts/csrgen.sh ~/scripts/csrgen
chmod a+x ~/scripts/csrgen
echo 'export PATH=~/scripts/csrgen:$PATH' >> ~/.zshrc
echo 'alias csrgen="source ~/scripts/csrgen"' >> ~/.zshrc
exec zsh

```
