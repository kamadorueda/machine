_: with _; {
  a = "git add -p";
  bashrc = "code $MACHINE/src/config/programs/bash/bashrc.sh";
  bat = "bat --show-all --theme=ansi";
  c = "git commit --allow-empty";
  csv = "column -s, -t";
  cm = "git log -n 1 --format=%s%n%n%b";
  cr = "git commit -m \"$(cm)\"";
  f = "git fetch --all";
  graph = "TZ=UTC git rev-list --date=iso-local --pretty='!%H!!%ad!!%cd!!%aN!!%P!' --graph HEAD";
  l = "git log --show-signature";
  m = "git commit --amend --no-edit --allow-empty";
  melts = "CI=true CI_COMMIT_REF_NAME=master melts";
  nix3 = "${packages.nixpkgs.nixUnstable}/bin/nix --experimental-features 'ca-references flakes nix-command '";
  now = "date --iso-8601=seconds --utc";
  p = "git push -f";
  r = "git pull --autostash --progress --rebase --stat origin master";
  ru = "git pull --autostash --progress --rebase --stat upstream master";
  rp = "r && p";
  s = "git status";
  today = "git log --format=%aI --author ${abs.emailAtWork} | sed -E 's/T.*$//g' | uniq -c | head -n 7 | tac";
}
