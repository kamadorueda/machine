#! /usr/bin/env bash

function indent {
  sed -E 's/^/  /g'
}

function create {
  local ssid="${1}"
  local psk"${2}"

  echo Checking if "${ssid}" already exists \
    && if nmcli connection show "${ssid}" |& indent; then
      echo Deleting "${ssid}" \
        && nmcli connection delete "${ssid}" |& indent
    fi \
    && echo Adding "${ssid}" \
    && nmcli connection add \
      autoconnect 'no' \
      con-name "${ssid}" \
      ifname '*' \
      save 'no' \
      type 'wifi' \
      -- \
      +connection.permissions '' \
      +ipv4.dns '1.1.1.1,8.8.8.8,8.8.4.4' \
      +ipv4.dns-search '' \
      +ipv4.ignore-auto-dns 'true' \
      +ipv4.method 'auto' \
      +ipv6.addr-gen-mode 'stable-privacy' \
      +ipv6.dns '2001:4860:4860::8888,2001:4860:4860::8844' \
      +ipv6.dns-search '' \
      +ipv6.ignore-auto-dns 'true' \
      +ipv6.method 'auto' \
      +wifi.mac-address-blacklist '' \
      +wifi.mode 'infrastructure' \
      +wifi-sec.key-mgmt 'wpa-psk' \
      +wifi.ssid "${ssid}" \
    |& indent
}

function main {
  local _24_sid=24f42fdc30
  local _24_pass=da4854ddc5eb

  local _50_sid=503b89add5
  local _50_pass=947bd77afe97

  true \
    && create "${_24_sid}" \
    && create "${_50_sid}" \
    && echo "${_24_pass}" | nmcli connection up --ask "${_24_sid}" \
    && echo "${_50_pass}" | nmcli connection up --ask "${_50_sid}" \
    && true
}

main "${@}"
