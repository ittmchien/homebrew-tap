# ittmchien/tap

Homebrew formulae for [Juicetray](https://github.com/ittmchien/juicetray).

```sh
brew tap ittmchien/tap
brew trust ittmchien/tap
brew install juicetray
cp -R "$(brew --prefix)/opt/juicetray/Juicetray.app" /Applications/
```

The formula builds the app from source on your Mac, so Gatekeeper does not block it.
