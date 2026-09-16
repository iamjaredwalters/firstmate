import ctypes, ctypes.util, os, subprocess, sys
libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
class AuditinfoAddr(ctypes.Structure):
    _fields_ = [("ai_auid", ctypes.c_uint32), ("ai_mask", ctypes.c_uint32 * 2),
                ("ai_termid", ctypes.c_uint32 * 6), ("ai_asid", ctypes.c_uint32), ("ai_flags", ctypes.c_uint64)]
info = AuditinfoAddr()
libc.getaudit_addr(ctypes.byref(info), ctypes.sizeof(info))
mn = subprocess.run(["launchctl", "managername"], capture_output=True, text=True).stdout.strip()
probe = sys.argv[1] if len(sys.argv) > 1 else ""
kc = subprocess.run(["security", "find-generic-password", "-s", probe, "-w"], capture_output=True, text=True) if probe else None
print("PROBE pid=%d ppid=%d sid=%d managername=%s asid=%d asflags=%s XPC_SERVICE_NAME=%s keychain_read_exit=%s keychain_value=%s" % (
    os.getpid(), os.getppid(), os.getsid(0), mn, info.ai_asid, hex(info.ai_flags), os.environ.get("XPC_SERVICE_NAME", "<unset>"),
    kc.returncode if kc else "n/a", (kc.stdout.strip() if kc and kc.returncode == 0 else (kc.stderr.strip()[:80] if kc else "n/a"))))
