#!/usr/bin/env bash
# LICENSE: https://github.com/versenv/versenv/blob/HEAD/LICENSE
set -Eeu -o pipefail

# HOW TO USE
# $ curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/versenv/versenv/HEAD/download.sh | INSTALL_DIR=/tmp/versenv/bin bash

# LICENSE: https://github.com/hakadoriya/log.sh/blob/HEAD/LICENSE
# Common
if [ "${LOGSH_COLOR:-}" ] || [ -t 2 ]; then LOGSH_COLOR=true; else LOGSH_COLOR=''; fi
_logshRFC3339() { date "+%Y-%m-%dT%H:%M:%S%z" | sed "s/\(..\)$/:\1/"; }
_logshCmd() { for a in "$@"; do if echo "${a:-}" | grep -Eq "[[:blank:]]"; then printf "'%s' " "${a:-}"; else printf "%s " "${a:-}"; fi; done | sed "s/ $//"; }
# Color
LogshDefault() { test "  ${LOGSH_LEVEL:-0}" -gt 000 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;35m}  DEFAULT${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshDebug() { test "    ${LOGSH_LEVEL:-0}" -gt 100 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;34m}    DEBUG${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshInfo() { test "     ${LOGSH_LEVEL:-0}" -gt 200 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;32m}     INFO${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshNotice() { test "   ${LOGSH_LEVEL:-0}" -gt 300 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;36m}   NOTICE${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshWarn() { test "     ${LOGSH_LEVEL:-0}" -gt 400 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;33m}     WARN${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshWarning() { test "  ${LOGSH_LEVEL:-0}" -gt 400 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;33m}  WARNING${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshError() { test "    ${LOGSH_LEVEL:-0}" -gt 500 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;31m}    ERROR${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshCritical() { test " ${LOGSH_LEVEL:-0}" -gt 600 || echo "$*" | awk "{print \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;1;31m} CRITICAL${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshAlert() { test "    ${LOGSH_LEVEL:-0}" -gt 700 || echo "$*" | awk "{print   \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;41m}    ALERT${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshEmergency() { test "${LOGSH_LEVEL:-0}" -gt 800 || echo "$*" | awk "{print \"$(_logshRFC3339) [${LOGSH_COLOR:+\\033[0;1;41m}EMERGENCY${LOGSH_COLOR:+\\033[0m}] \"\$0\"\"}" 1>&2; }
LogshExec() { LogshInfo "$ $(_logshCmd "$@")" && "$@"; }
LogshRun() { _dlm="####R#E#C#D#E#L#I#M#I#T#E#R####" && _all=$({ _out=$("$@") && _rtn=$? || _rtn=$? && printf "\n%s" "${_dlm:?}${_out:-}" && return "${_rtn:-0}"; } 2>&1) && _rtn=$? || _rtn=$? && _dlmno=$(echo "${_all:-}" | sed -n "/${_dlm:?}/=") && _cmd=$(_logshCmd "$@") && _stdout=$(echo "${_all:-}" | tail -n +"${_dlmno:-1}" | sed "s/^${_dlm:?}//") && _stderr=$(echo "${_all:-}" | head -n "${_dlmno:-1}" | grep -v "^${_dlm:?}") && LogshInfo "$ ${_cmd:-}" && LogshInfo "${_stdout:-}" && { [ -z "${_stderr:-}" ] || LogshWarning "${_stderr:?}"; } && return "${_rtn:-0}"; }

DownloadURL() {
  local url="${1:?}"
  local file="${2:?}"
  if command -v curl >/dev/null; then
    LogshExec curl --tlsv1.2 --connect-timeout 2 --progress-bar -fLR "${url:?}" -o "${file:?}"
  elif command -v wget >/dev/null; then
    LogshExec wget --secure-protocol=TLSv1_2 --dns-timeout=2 --connect-timeout=2 -q "${url:?}" -O "${file:?}"
  else
    LogshError "command not found: curl or wget"
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
    scripts=(
      arcgen
      aws
      buf
      ddlctl
      direnv
      eksctl
      fzf
      ghq
      gitleaks
      golangci-lint
      goreleaser
      hammer
      helm
      kubectl
      migrate
      packer
      protoc
      sccache
      sops
      stern
      terraform
      tflint
      typos
    )
  fi
  # shellcheck disable=SC2001
  local install_dir && install_dir=$(echo "${VERSENV_PATH:-"${PWD:-.}"}" | sed "s|//*|/|g; s|/$||")
  # main
  LogshNotice "Start downloading versenv scripts (${scripts[*]}) to ${install_dir:?}"
  LogshRun mkdir -p "${install_dir:?}"
  for versenv_script_name in "${scripts[@]}"; do
    InstallVersenvScript "${versenv_script_name:?}" "${install_dir:?}"
  done
  LogshNotice "Complete!"
}

Main "$@"
