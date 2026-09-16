EV=/Users/jrad/.no-mistakes/evidence/01M2KW29MTSTRRHEYR563AVDB2
WT=/Users/jrad/.no-mistakes/worktrees/728acd5903fe/01M2KW29MTSTRRHEYR563AVDB2
LAB=fm-lab-sidtest-71976-9084
LABEL=dev.firstmate.herdr-lab.fm-lab-sidtest-71976-9084
STATE=${TMPDIR:-/tmp}/fm-herdr-lab-501
T=/Users/jrad/.no-mistakes/evidence/01M2KW29MTSTRRHEYR563AVDB2/launchd-lab-transcript.log
LAB_SH=/Users/jrad/.no-mistakes/worktrees/728acd5903fe/01M2KW29MTSTRRHEYR563AVDB2/bin/fm-herdr-lab.sh
step() { printf '\n===== %s [%s] =====\n' "$*" "$(date +%H:%M:%S)" | tee -a "$T"; }
say() { printf '%s\n' "$*" | tee -a "$T"; }
run() { printf '$ %s\n' "$*" | tee -a "$T"; "$@" 2>&1 | tee -a "$T"; return ${PIPESTATUS[0]}; }
procs() { ps -A -o pid=,ppid=,pgid=,sess=,stat=,command= | grep -E -- "--session $LAB( |$)|fm-remote-herdr-guard.sh .* $LAB|fm-remote-herdr-supervisor" | grep -v grep || true; }
jobpid() { launchctl print gui/501/$LABEL 2>/dev/null | awk '$1=="pid" && $2=="=" {print $3; exit}'; }
serverpid() { HERDR_SESSION=$LAB herdr status --json --session $LAB 2>/dev/null | jq -r '.server.pid // empty'; }
cap() { HERDR_SESSION=$LAB herdr status --json --session $LAB 2>/dev/null | jq -c '{running: .server.running, pid: .server.pid, detached_server_daemon: .server.capabilities.detached_server_daemon}'; }
PROBE_SVC=fm-lab-keychain-probe-79273
BASE_ROOT=/var/folders/r_/clp1b7jd0l32szknvsvw8b2m0000gn/T//fm-base-root.w9ND4j
# zsh-safe redefinition: capture the command's own exit status, not tee's
run() { local out rc; printf '$ %s\n' "$*" | tee -a "$T"; out=$("$@" 2>&1); rc=$?; [ -z "$out" ] || printf '%s\n' "$out" | tee -a "$T"; printf 'exit status: %s\n' "$rc" | tee -a "$T"; return $rc; }
OLD=fm-lab-oldshape-13181-18339
