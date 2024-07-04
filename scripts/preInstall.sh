#set env vars
set -o allexport; source .env; set +o allexport;

MEILI_MASTER_KEY=${MEILI_MASTER_KEY:-`openssl rand -hex 32`}
JWT_SECRET=${JWT_SECRET:-`openssl rand -hex 32`}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET:-`openssl rand -hex 32`}
CREDS_KEY=${CREDS_KEY:-`openssl rand -hex 32`}
CREDS_IV=${CREDS_IV:-`openssl rand -hex 32`}

cat /opt/elestio/startPostfix.sh > post.txt
filename="./post.txt"

SMTP_LOGIN=""
SMTP_PASSWORD=""

# Read the file line by line
while IFS= read -r line; do
  # Extract the values after the flags (-e)
  values=$(echo "$line" | grep -o '\-e [^ ]*' | sed 's/-e //')

  # Loop through each value and store in respective variables
  while IFS= read -r value; do
    if [[ $value == RELAYHOST_USERNAME=* ]]; then
      SMTP_LOGIN=${value#*=}
    elif [[ $value == RELAYHOST_PASSWORD=* ]]; then
      SMTP_PASSWORD=${value#*=}
    fi
  done <<< "$values"

done < "$filename"

rm post.txt

cat << EOT >> ./.env

MEILI_MASTER_KEY=${MEILI_MASTER_KEY}
JWT_SECRET=${JWT_SECRET}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
CREDS_KEY=${CREDS_KEY}
CREDS_IV=${CREDS_IV}
EMAIL_HOST=tuesday.mxrouting.net
EMAIL_PORT=465
EMAIL_FROM_NAME=LibreChat
EMAIL_ENCRYPTION=tls
EMAIL_FROM=${SMTP_LOGIN}
EMAIL_USERNAME=${SMTP_LOGIN}
EMAIL_PASSWORD=${SMTP_PASSWORD}

EOT