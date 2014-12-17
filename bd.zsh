bd () {
  # No-arg case. jump to project root
  if [[ -z "$1" ]]; then
    cd $(git rev-parse --show-toplevel)
    return 0
  fi

  # Get parents (in reverse order)
  local parents
  local num=${#${(ps:/:)${PWD}}}
  local i
  for i in {$((num+1))..2}
  do
    parents=($parents "$(echo $PWD | cut -d'/' -f$i)")
  done
  parents=($parents "/")
  # Build dest and 'cd' to it
  local dest="./"
  local parent
  foreach parent (${parents})
  do
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
    dest+="../"
  done
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}
_bd () {
  # Get parents (in reverse order)
  local num=${#${(ps:/:)${PWD}}}
  local i
  for i in {$((num+1))..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}
compctl -V directories -K _bd bd
alias u="bd"
