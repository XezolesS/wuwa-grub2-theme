#!/usr/bin/env bash

# ---- colors ----
COLOR_DEF="\033[0m"         # default color
COLOR_INF="\033[0;36m"      # info color
COLOR_SUC="\033[0;32m"      # success color
COLOR_ERR="\033[0;31m"      # error color
COLOR_WAR="\033[0;33m"      # waring color
COLOR_BOLD_DEF="\033[1;37m" # bold default color
COLOR_BOLD_INF="\033[1;36m" # bold info color
COLOR_BOLD_SUC="\033[1;32m" # bold success color
COLOR_BOLD_ERR="\033[1;31m" # bold error color
COLOR_BOLD_WAR="\033[1;33m" # bold warning color

# ---- functions ----

print_msg() {
  printf "${COLOR_DEF}%s\n" "$1"
}

info_msg() {
  printf "${COLOR_BOLD_INF}INFO: ${COLOR_DEF}%s\n" "$1"
}

success_msg() {
  printf "${COLOR_BOLD_SUC}SUCCESS: ${COLOR_DEF}%s\n" "$1"
}

warning_msg() {
  printf "${COLOR_BOLD_WAR}WARNING: ${COLOR_DEF}%s\n" "$1"
}

error_msg() {
  printf "${COLOR_BOLD_ERR}ERROR: ${COLOR_DEF}%s\n" "$1"
}

has_command() {
  command -v "$1" &>/dev/null
}
