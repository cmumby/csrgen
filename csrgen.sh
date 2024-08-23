if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [-d] [-e] [-h] domain"
  exit 1
fi

DOMAIN=""
GENERATE_DHPARAM=false
ENVIRONMENTAL=false
BASE_DIR="$HOME/certs"

display_help() {
  echo "Usage: csrgen.sh [-d] [-e] [-h] domain"
  echo "Flags:"
  echo "  -d : dhpram2 pem file"
  echo "  -e : Generate certificates for different environments (INT, QA, Prod)"
  echo "  -h : Display help message"
  echo ""
  echo "Example Usage:"
  echo "  ./csrgen.sh sample.site.com               # Generate CSR and KEY for sample.site.com"
  echo "  ./csrgen.sh -d sample.site.com            # Generate CSR, KEY, and dhpram2 pem file"
  echo "  ./csrgen.sh -e sample.site.com            # Generate CSR and KEY for INT, QA, and Prod environments"
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -d*)
      GENERATE_DHPARAM=true
      if [[ "$1" == *e* ]]; then
        ENVIRONMENTAL=true
      fi
      shift
      ;;
    -e*)
      ENVIRONMENTAL=true
      if [[ "$1" == *d* ]]; then
        GENERATE_DHPARAM=true
      fi
      shift
      ;;
    -h)
      display_help
      exit 0
      ;;
    *)
      DOMAIN="$1"
      shift
      ;;
  esac
done

if [ -z "$DOMAIN" ]; then
  echo "Error: No domain provided."
  display_help
  exit 1
fi

MAIN_DIR="${BASE_DIR}/${DOMAIN}"
if [ ! -d "$MAIN_DIR" ]; then
  mkdir -p "$MAIN_DIR"
else
  echo "Directory $MAIN_DIR already exists. Regenerating certificates..."
fi

generate_certs() {
  local domain_name="$1"
  local dir_name="$2"

  # Want to make sure the correct directories exist 
  if [ ! -d "$dir_name" ]; then
    mkdir -p "$dir_name"
  fi

  cd "$dir_name" || exit

  local formatted_domain=$(echo "$domain_name" | tr '.' '_')

  # Main Command
  openssl req -new -newkey rsa:2048 -nodes -out "${formatted_domain}.csr" -keyout "${formatted_domain}.key" -subj "/C=US/ST=WI/L=Milwaukee/O=Northwestern Mutual/OU=NMXP/CN=${domain_name}"

 # dparam2 pem file command if needed
  if $GENERATE_DHPARAM; then
    openssl dhparam -dsaparam -out dhparam2.pem 4096
  fi

  echo "Files generated in $dir_name for $domain_name"
}

# Creates INT QA AND PROD versions if needed
if $ENVIRONMENTAL; then
  INT_DIR="${MAIN_DIR}/INT"
  QA_DIR="${MAIN_DIR}/QA"
  PROD_DIR="${MAIN_DIR}/PROD"

  generate_certs "sample-int.${DOMAIN}" "$INT_DIR"
  generate_certs "sample-qa.${DOMAIN}" "$QA_DIR"
  generate_certs "${DOMAIN}" "$PROD_DIR"

else
  # NO INT QA and PROD directories if -e is ommited
  generate_certs "$DOMAIN" "$MAIN_DIR"
fi
