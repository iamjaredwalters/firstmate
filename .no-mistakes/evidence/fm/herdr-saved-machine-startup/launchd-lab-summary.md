# Live launchd lab run: session-leader fm-remote Herdr server (target 4286daf, base bdcacb9)

Host: macOS 15.7.3 (Darwin 24.6.0), Herdr 0.9.0, /usr/bin/perl 5.34.1, driver shell in the Aqua login session (asid 100016).
Lab: `bin/fm-herdr-lab.sh launchagent provision <fm-lab-*> <code root>` under real launchd in `gui/501`, isolated lab labels only.
Full transcript: `launchd-lab-transcript.log`; launch agent logs: `lab-launch-agent.log` (new shape), `lab-launch-agent-oldshape.log` (base commit).

| # | Scenario | Observed |
|---|----------|----------|
| 1 | Server leads its own session under launchd | job = `/usr/bin/perl fm-remote-herdr-supervisor.pl` pid 77810 (ppid 1, STAT S); server pid 77832 ppid 77810 pgid 77832 STAT `Ss`; watcher 77833 in the server's group |
| 1c | Herdr capability | `detached_server_daemon: true` for the supervised server; `false` for a foreign shell-born server (step 9) and for the base-commit shape (step 13) |
| 2 | Aqua session + login keychain from a pane | pane shell child of the server: `launchctl managername` Aqua, asid 100016 (same as the driver shell), `security find-generic-password -w` exit 0 and the value matched the temporary probe item |
| 3 | Viewer attach/detach | job pid 77810 and server pid 77832 unchanged, capability still true |
| 4 | Ownership/birth checks | owner-lib: socket owner 77832, birth `launchd` (job is the owner's parent), aqua yes, leads_session yes; server env carries `XPC_SERVICE_NAME=<lab label>` |
| 4a/14 | Guard adopts an Aqua-born supervised server | `nothing to do`, exit status 0, job/server pids unchanged |
| 5 | `launchctl kickstart -k` restart | supervisor forwarded SIGTERM, server exited 0, `last exit code = 0`, new generation 87935/87955 (`Ss`) |
| 6 | SIGKILL of the server | supervisor `ended by signal 9`, `last exit code = 137`, launchd respawned; old watcher gone |
| 7 | SIGKILL of the job (with an open pane) | watcher `killing that group`; pane shell 89363 gone; `last terminating signal = Killed: 9`; respawn; no orphan |
| 8 | Clean stop (`herdr session stop`) | `state = not running`, `last exit code = 0`, no respawn through 17s, no processes of the session |
| 9 | Foreign server takeover | shell-born server pid 1645 (birth `unknown`, capability false) stopped by the guard on the next launch, replaced by supervised pid 2184 (birth `launchd`, leads session) |
| 10 | Teardown / bootout | forwarded SIGTERM, exit 0, label unloaded, no processes, session deleted, default server pid 47119 unchanged, Firstmate agents still absent |
| 11 | Perl prerequisite (guard, direct) | no perl / broken perl on PATH: exit status 1, names the prerequisite, no session created, no server started |
| 12 | Doctor read-only on this Mac | `check herdr-server=fixable: ... not running` with `action: rerun this command with --fix` because `/bin/zsh -l -c perl -c <supervisor>` succeeded |
| 13 | Base-commit guard (pre-change shape) | job = `herdr server` itself pid 13265 STAT `S`, capability false, owner-lib leads_session no, birth `launchd`; new guard run against it: `nothing to do`, exit 0, job untouched |
