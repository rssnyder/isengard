#
# Command-line "tools" pulled from my .zshrc file
#


# Ansible
alias run="ansible-playbook --vault-password .vault_password -i hosts.yml -i secrets.yml"
alias dst="ansible-playbook --vault-password .vault_password -i hosts.yml playbooks/discord-stock-ticker.yml --limit"
alias tf="tofu -chdir=infra"

function ansible-encrypt () {
  echo "enter var name: "
  read name
  echo "enter var secret: "
  read secret
  ansible-vault encrypt_string --vault-password-file .vault_password "$secret" --name "$name"
}

# DST
function addbot () {
  ###
  # addbot <id> <token>
  ###

  curl -X PUT -s "discord-bot-manager.r.ss/bot/free?bot_id=$1"  | jq -e '.id' || curl -X POST -s "discord-bot-manager.r.ss/bot/store?bot_id=$1&bot_token=$2" | jq -e '.id'
}

function newbots () {
  curl -setting "discord-bot-manager.r.ss/bot/unclaimed" | jq .
}

function popnewbot () {
  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $newbot | jq .
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newcrypto () {
  ###
  # newcrypto <ip>:<port> <id>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/ticker --data "
  {
    \"name\": \"$2\",
    \"crypto\": true,
    \"color\": true,
    \"frequency\": 10,
    \"decimals\": 8,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  "  | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
  curl -X PUT -s "discord-bot-manager.r.ss/bot/photo?bot_id=$id&photo_url=$(curl -s https://api.coingecko.com/api/v3/coins/$2 | jq -r .image.large | cut -d'?' -f1)"
}

# \"currency\": \"BRL\",
# \"currencySymbol\": \"R$\",

# \"currency\": \"PHP\",
# \"currencySymbol\": \"₱\",

function newstock () {
  ###
  # newstock <ip>:<port> <id> <name>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/ticker --data "
  {
    \"ticker\": \"$2\",
    \"name\": \"$3\",
    \"color\": true,
    \"frequency\": 10,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newgas () {
  ###
  # newgas <ip>:<port> <network>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/gas --data "
  {
    \"network\": \"$2\",
    \"frequency\": 10,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newmarketcap () {
  ###
  # newmarketcap <ip>:<port> <id>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/marketcap --data "
  {
    \"name\": \"$2\",
    \"color\": true,
    \"frequency\": 10,
    \"ticker\": \" \",
    \"decorator\": \" \",
    \"decimals\": 0,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
  curl -X PUT -s "discord-bot-manager.r.ss/bot/photo?bot_id=$id&photo_url=$(curl -s https://api.coingecko.com/api/v3/coins/$2 | jq -r .image.large | cut -d'?' -f1)"
}

function newcirculating () {
  ###
  # newcirculating <ip>:<port> <id>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/circulating --data "
  {
    \"name\": \"$2\",
    \"frequency\": 10,
    \"activity\": \"Circulating Supply\",
    \"ticker\": \" \",
    \"decimals\": 0,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newtotalvaluelocked () {
  ###
  # newtotalvaluelocked <ip>:<port> <id>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/valuelocked --data "
  {
    \"name\": \"$2\",
    \"frequency\": 10,
    \"activity\": \"Sperax TVL\",
    \"currency\": \"USD\",
    \"currency_symbol\": \"$\",
    \"nickname\": true,
    \"source\": \"llama\",
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newfloor () {
  ###
  # newfloor <ip>:<port> <marketplace> <collection>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/floor --data "
  {
    \"marketplace\": \"$2\",
    \"name\": \"$3\",
    \"frequency\": 10,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newtoken () {
  ###
  # newtoken <ip>:<port> <network> <address> <name> <source>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/token --data "
  {
    \"network\": \"$2\",
    \"contract\": \"$3\",
    \"source\": \"$5\",
    \"name\": \"$4\",
    \"frequency\": 10,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function newholders () {
  ###
  # newholders <ip>:<port> <network> <address> <activity>
  ###

  newbot=$(curl -s 'discord-bot-manager.r.ss/bot/get' | jq -c .)
  id=$(echo $newbot | jq -r .id)
  token=$(echo $newbot | jq -r .token)
  echo $id
  curl -s -X POST $1/holders --data "
  {
    \"network\": \"$2\",
    \"address\": \"$3\",
    \"activity\": \"$4\",
    \"frequency\": 10,
    \"nickname\": true,
    \"discord_bot_token\": \"$token\",
    \"client_id\": \"$id\"
  }
  " | jq -r '.client_id' | read id && echo "<https://discord.com/api/oauth2/authorize?permissions=335544320&scope=bot&client_id=$id>"
  curl -X PUT -s "discord-bot-manager.r.ss/bot/claim?bot_id=$id" | jq -c .
}

function botimage () {
  ###
  # botimage <id> <url>
  ###

  curl -X PUT "discord-bot-manager.r.ss/bot/photo?bot_id=$1&photo_url=$2"
}

function tokentest () {
  ###
  # tokentest <address>
  ###

  echo "DexLab:"
  curl "https://api.dexlab.space/v1/trades/$1/24h"
  echo
  echo "Pancakeswap:"
  curl "https://api.pancakeswap.info/api/v2/tokens/$1"
  echo
  echo "1inch ETH:"
  curl "https://api.1inch.exchange/v3.0/1/quote?fromTokenAddress=$1&toTokenAddress=0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48&amount=10000000000000000000"
  echo
  echo "1inch BSC:"
  curl "https://api.1inch.exchange/v3.0/56/quote?fromTokenAddress=$1&toTokenAddress=0x55d398326f99059ff775485246999027b3197955&amount=10000000"
  echo
  echo "1inch MATIC"
  curl "https://api.1inch.exchange/v3.0/137/quote?fromTokenAddress=$1&toTokenAddress=0x2791bca1f2de4661ed88a30c99a7a9449aa84174&amount=10000000000000000000"
  echo
}

function price () {
  ###
  # price <coin id>
  ###

  curl -s "https://api.coingecko.com/api/v3/coins/$1" | jq .market_data.current_price.usd
}

function restartclient () {
  ###
  # restartclient <client>
  ###

  ansible-playbook -i $HOME/isengard/hosts.yml $HOME/isengard/playbooks/restart-service.yml --limit oc -e "{\"service\":\"$1\"}"
}

function updateclient () {
  ###
  # updateclient <client>
  ###

  ansible-playbook -i $HOME/isengard/hosts.yml $HOME/isengard/playbooks/discord-stock-ticker-update.yml --limit oracle_arm_dst -e "{\"client\":\"$1\"}"
}

function dbpull() {
  rclone copy s3:discord-stock-ticker/database/$1.state ./
}

function claim () {
  dbpull $1 && reclaim -db $1.state
}

alias getenv='export $(cat ../.env | xargs); export AWS_ACCESS_KEY_ID=$MINIO_USER; export AWS_SECRET_ACCESS_KEY=$MINIO_PASSWORD'

function signal () {
  message=$@
  curl -X POST http://signal-api.r.ss/v2/send --data "
  {
    \"message\": \"$message\",
    \"number\": \"+14808407117\",
    \"recipients\": [
      \"+15159792049\"
    ]
  }"
}

function signal_survivor () {
  message=$@
  curl -X POST http://signal-api.r.ss/v2/send --data "
  {
    \"message\": \"$message\",
    \"number\": \"+14808407117\",
    \"recipients\": [
      \"group.ZTVTUzdvNjZSbGFsYTlrR1p0M21KbTQ3eFZNa2ZRWHMzZm1acFlnd1c1Yz0=\"
    ]
  }"
}

function signal_nicole () {
  message=$@
  curl -X POST http://signal-api.r.ss/v2/send --data "
  {
    \"message\": \"$message\",
    \"number\": \"+14808407117\",
    \"recipients\": [
      \"+15155097579\"
    ]
  }"
}

function rm-ns-force () {
  kubectl get namespace "$1" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/$1/finalize -f -

}

function frigate-deploy () {
  curl -X POST -H 'content-type: application/json' --url 'https://app.harness.io/gateway/pipeline/api/webhook/custom/v2?accountIdentifier=wlgELJ0TTre5aZhzpt8gVA&orgIdentifier=default&projectIdentifier=home_lab&pipelineIdentifier=deploy&triggerIdentifier=frigate_http'
}