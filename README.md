# ittmchien/tap

Homebrew formulae for [Juicetray](https://github.com/ittmchien/juicetray).

```sh
brew tap ittmchien/tap
brew trust ittmchien/tap
brew install juicetray
cp -R "$(brew --prefix)/opt/juicetray/Juicetray.app" /Applications/
```

The formula installs the prebuilt universal app from the GitHub release (about 3 MB). Homebrew
downloads it with curl, so it carries no quarantine flag and Gatekeeper does not block it.
