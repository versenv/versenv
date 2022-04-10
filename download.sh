#!/usr/bin/env bash

# HOW TO USE
# $ curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/newtstat/versenv/HEAD/download.sh | DOWNLOAD_DIR=/tmp/versenv/bin bash

# MIT License Copyright (c) 2021 newtstat https://github.com/rec-logger/rec.sh
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
RecRun() { _dlm='####R#E#C#D#E#L#I#M#I#T#E#R####' _all=$({ _out=$("$@") && _rtn=$? || _rtn=$? && printf "\n%s" "${_dlm:?}${_out:-}" && return ${_rtn:-0}; } 2>&1) && _rtn=$? || _rtn=$? && _dlmno=$(echo "${_all:-}" | sed -n "/${_dlm:?}/=") && _cmd=$(_recCmd "$@") && _stdout=$(echo "${_all:-}" | tail -n +"${_dlmno:-1}" | sed "s/^${_dlm:?}//") && _stderr=$(echo "${_all:-}" | head -n "${_dlmno:-1}" | grep -v "^${_dlm:?}") && RecInfo "$ ${_cmd:-}" && RecInfo "${_stdout:-}" && { [ -z "${_stderr:-}" ] || RecWarning "${_stderr:-}"; } && return ${_rtn:-0}; }

DownloadURL() {
  local url="${1:?}"
  local file="${2:?}"
  if command -v curl >/dev/null; then
    RecExec curl --tlsv1.2 --progress-bar -fLR "${url:?}" -o "${file:?}"
  elif command -v wget >/dev/null; then
    RecExec wget --secure-protocol=TLSv1_2 --show-progress -q "${url:?}" -O "${file:?}"
  else
    RecCritical "command not found: curl or wget"
    exit 127
  fi
}

DownloadVersenvScript() {
  # args
  local versenv_script_name=${1:?"DownloadVersenvScript: versenv_script_name is empty"}
  local download_dir=${2:?"DownloadVersenvScript: download_dir is empty"}
  # vars
  local download_path="${download_dir:?}/${versenv_script_name:?}"
  # main
  DownloadURL "https://github.com/newtstat/versenv/releases/latest/download/${versenv_script_name:?}" "${download_path:?}"
  chmod +x "${download_path:?}"
}

Main() {
  # vars
  # shellcheck disable=SC2001
  local scripts=(kubectl packer stern terraform)
  local download_dir && download_dir=$(echo "${DOWNLOAD_DIR:-"${PWD:-.}"}" | sed "s@//*@/@g")
  # main
  RecNotice "Start downloading versenv scripts to ${download_dir:?}"
  mkdir -p "${download_dir:?}"
  for versenv_script_name in "${scripts[@]}"; do
    DownloadVersenvScript "${versenv_script_name:?}" "${download_dir:?}"
  done
  RecNotice "Complete!"
}

Main "$@"
