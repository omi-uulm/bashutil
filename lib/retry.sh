#######################################
# Runs a command for several times and gives up with
# an error message after max retries.
#
# Arguments:
#   maxretries      number of retries before giving up
#   timeout         seconds untill retry
#   errormessage    error message for each failed try
#   command         command to be executed
#
# Returns:
#   1 on failure. 0 on success
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function retry(){
    maxretries=$1; shift
    timeout=$1; shift
    errormessage=$1; shift
    command="$@"

    tries=0
    while (( $tries >= 0 )); do
        $command
        if [[ $? != 0 ]]; then
            let tries+=1
            if (( $tries < $maxretries )); then
                echo "$errormessage"
                echo "$tries retries. retry in ${timeout}s." >&2
                sleep $timeout
            else
                echo "$errormessage"
                echo "$tries retries. Will give up." >&2
                return 1
            fi
        else
            tries=-1 # try success
            return 0
        fi
    done   
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f retry
else
  retry "${@}"
  exit $?
fi