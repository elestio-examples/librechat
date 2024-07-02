#set env vars
set -o allexport; source .env; set +o allexport;


mkdir -p ./storage
chown -R 1000:1000 ./storage






MEILI_MASTER_KEY=${MEILI_MASTER_KEY:-`openssl rand -hex 32`}
JWT_SECRET=${JWT_SECRET:-`openssl rand -hex 32`}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET:-`openssl rand -hex 32`}
CREDS_KEY=${CREDS_KEY:-`openssl rand -hex 32`}
CREDS_IV=${CREDS_IV:-`openssl rand -hex 32`}



cat << EOT >> ./scripts/config.sh

MEILI_MASTER_KEY=${MEILI_MASTER_KEY}
JWT_SECRET=${JWT_SECRET}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
CREDS_KEY=${CREDS_KEY}
CREDS_IV=${CREDS_IV}


OPENAI_API_KEY=

EOT

cat << EOT >> ./.env
