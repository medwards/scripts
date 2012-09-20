# My Scripts #
* `cleanup-git.sh`  
  Loops through your remote branches and will attempt to delete local branches
  of the same name. This may throw errors if your local branch does not exist.
  You can ask it for info and receive commits that do not exist in
  upstream. You must change the script to change the default upstream
  (upstream/master) and remote (origin).
