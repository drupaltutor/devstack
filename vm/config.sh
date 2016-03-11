#!/usr/bin/env bash


function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

function get_var {
    if [ -f /vagrant-config/config.default.yml ]; then
        eval $(parse_yaml /vagrant-config/config.default.yml "CONF_DEFAULT_")
    fi

    if [ -f /vagrant-config/config.yml ]; then
        eval $(parse_yaml /vagrant-config/config.yml "CONF_")
    fi

    local VAR=`echo CONF_$1`;
    if [ -z $(echo ${!VAR}) ]; then
        local VAR=`echo CONF_DEFAULT_$1`;
    fi
    echo ${!VAR};
}

