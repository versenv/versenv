#!/usr/bin/env bash
set -Eeu -o pipefail

# HOW TO USE
# $ curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/versenv/versenv/HEAD/download.sh | INSTALL_DIR=/tmp/versenv/bin bash

# MIT License Copyright (c) 2021 ginokent https://github.com/rec-logger/rec.sh
# Common
_recRFC3339() { date "+%Y-%m-%dT%H:%M:%S%z" | sed "s/\(..\)$/:\1/"; }
_recCmd() { for a in "$@"; do if echo "${a:-}" | grep -Eq "[[:blank:]]"; then printf "'%s' " "${a:-}"; else printf "%s " "${a:-}"; fi; done | sed "s/ $//"; }
# Color
RecDefault() { test "  ${REC_SEVERITY:-0}" -gt 000 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;35m  DEFAULT\\033[0m] \"\$0\"\"}" 1>&2; }
RecDebug() { test "    ${REC_SEVERITY:-0}" -gt 100 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;34m    DEBUG\\033[0m] \"\$0\"\"}" 1>&2; }
RecInfo() { test "     ${REC_SEVERITY:-0}" -gt 200 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;32m     INFO\\033[0m] \"\$0\"\"}" 1>&2; }
RecNotice() { test "   ${REC_SEVERITY:-0}" -gt 300 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;36m   NOTICE\\033[0m] \"\$0\"\"}" 1>&2; }
RecWarning() { test "  ${REC_SEVERITY:-0}" -gt 400 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;33m  WARNING\\033[0m] \"\$0\"\"}" 1>&2; }
RecError() { test "    ${REC_SEVERITY:-0}" -gt 500 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;31m    ERROR\\033[0m] \"\$0\"\"}" 1>&2; }
RecCritical() { test " ${REC_SEVERITY:-0}" -gt 600 2>/dev/null || echo "$*" | awk "{print \"$(_recRFC3339) [\\033[0;1;31m CRITICAL\\033[0m] \"\$0\"\"}" 1>&2; }
RecAlert() { test "    ${REC_SEVERITY:-0}" -gt 700 2>/dev/null || echo "$*" | awk "{print   \"$(_recRFC3339) [\\033[0;41m    ALERT\\033[0m] \"\$0\"\"}" 1>&2; }
RecEmergency() { test "${REC_SEVERITY:-0}" -gt 800 2>/dev/null || echo "$*" | awk "{print \"$(_recRFC3339) [\\033[0;1;41mEMERGENCY\\033[0m] \"\$0\"\"}" 1>&2; }
RecExec() { RecInfo "$ $(_recCmd "$@")" && "$@"; }
RecRun() { _dlm="####R#E#C#D#E#L#I#M#I#T#E#R####" _all=$({ _out=$("$@") && _rtn=$? || _rtn=$? && printf "\n%s" "${_dlm:?}${_out:-}" && return ${_rtn:-0}; } 2>&1) && _rtn=$? || _rtn=$? && _dlmno=$(echo "${_all:-}" | sed -n "/${_dlm:?}/=") && _cmd=$(_recCmd "$@") && _stdout=$(echo "${_all:-}" | tail -n +"${_dlmno:-1}" | sed "s/^${_dlm:?}//") && _stderr=$(echo "${_all:-}" | head -n "${_dlmno:-1}" | grep -v "^${_dlm:?}") && RecInfo "$ ${_cmd:-}" && { [ -z "${_stdout:-}" ] || RecInfo "${_stdout:?}"; } && { [ -z "${_stderr:-}" ] || RecWarning "${_stderr:?}"; } && return ${_rtn:-0}; }

DownloadURL() {
  local url="${1:?}"
  local file="${2:?}"
  if command -v wget >/dev/null; then
    RecExec wget --secure-protocol=TLSv1_2 --dns-timeout=2 --connect-timeout=2 --show-progress -q "${url:?}" -O "${file:?}"
  elif command -v curl >/dev/null; then
    RecExec curl --tlsv1.2 --connect-timeout 2 --progress-bar -fLR "${url:?}" -o "${file:?}"
  else
    RecCritical "command not found: curl or wget"
    exit 127
  fi
}

InstallVersenvScript() {
  # args
  local versenv_script_name=${1:?"InstallVersenvScript: versenv_script_name is empty"}
  local install_dir=${2:?"InstallVersenvScript: install_dir is empty"}
  # vars
  local download_path="${install_dir:?}/${versenv_script_name:?}"
  # main
  DownloadURL "https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/${versenv_script_name:?}" "${download_path:?}"
  chmod +x "${download_path:?}"
}

Main() {
  # vars
  # shellcheck disable=SC2207
  local -a scripts=($(echo "${VERSENV_SCRIPTS:-}" | sed "s/ *//g; s/,/ /g"))
  if [[ ${#scripts[@]} -eq 0 ]]; then
    scripts=(kubectl terraform packer helm eksctl direnv stern ghq fzf)
  fi
  # shellcheck disable=SC2001
  local install_dir && install_dir=$(echo "${VERSENV_PATH:-"${PWD:-.}"}" | sed "s|//*|/|g; s|/$||")
  # main
  RecNotice "Start downloading versenv scripts (${scripts[*]}) to ${install_dir:?}"
  RecRun mkdir -p "${install_dir:?}"
  for versenv_script_name in "${scripts[@]}"; do
    InstallVersenvScript "${versenv_script_name:?}" "${install_dir:?}"
  done
  RecNotice "Complete!"
}

Main "$@"
