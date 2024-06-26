#!/bin/sh
set -e -u

# LICENSE: https://github.com/kunitsucom/log.sh/blob/HEAD/LICENSE
# Common
if [ "${LOGSH_COLOR:-}" ] || [ -t 2 ] ; then LOGSH_COLOR=true; else LOGSH_COLOR=''; fi
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

cd "$(dirname "$0")"

err=0

# begin log
LogshRun uname -a
LogshInfo "RUN: $0"
# end log
trap 'if [ ${err:-0} -gt 0 ]; then
  LogshError "FAIL: $0"
  exit ${err:-1}
else
  LogshInfo "PASS: $0"
  exit 0
fi
' EXIT

PATH="$(pwd -P)/bin:${PATH:-}"
export PATH


LogshExec kubectl version --client || err=$((err+$?))
LogshExec terraform version || err=$((err+$?))
LogshExec packer version || err=$((err+$?))
LogshExec helm version || err=$((err+$?))
LogshExec eksctl version || err=$((err+$?))
LogshExec protoc --version || err=$((err+$?))
LogshExec buf --version || err=$((err+$?))
#LogshExec aws --version  # Comment out because it takes too long.

LogshExec direnv version || err=$((err+$?))
LogshExec golangci-lint --version || err=$((err+$?))
LogshExec stern --version || err=$((err+$?))
LogshExec ghq --version || err=$((err+$?))
LogshExec fzf --version || err=$((err+$?))
LogshExec migrate --version || err=$((err+$?))
LogshExec hammer version || err=$((err+$?))
LogshExec typos --version || err=$((err+$?))
LogshExec arcgen --version || err=$((err+$?))
LogshExec ddlctl version || err=$((err+$?))
