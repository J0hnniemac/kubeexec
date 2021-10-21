on run argv
    tell application "Terminal"
        do script "/usr/local/bin/kubectl exec --namespace="& item 2 of argv & " --stdin --tty " & item 1 of argv & " -- /bin/bash"
    end tell
end run
