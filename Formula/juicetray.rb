# Installs the prebuilt universal Juicetray.app from the GitHub release. Homebrew downloads it
# with curl, so it carries no quarantine flag and Gatekeeper does not block the ad-hoc signed app.
class Juicetray < Formula
  desc "Battery levels of wireless mice, headsets and Bluetooth devices in the menu bar"
  homepage "https://github.com/ittmchien/juicetray"
  url "https://github.com/ittmchien/juicetray/releases/download/v0.4.3/juicetray-macos-universal.app.zip",
      using: :nounzip
  sha256 "a32d80c0bf5b347cc65ff054da0007a3952661ceef253f938450e7ea5c8fa23f"
  license "GPL-3.0-or-later"

  depends_on macos: :ventura

  def install
    # ditto keeps the bundle's code signature and resources intact.
    system "ditto", "-x", "-k", "juicetray-macos-universal.app.zip", prefix
  end

  def caveats
    <<~EOS
      Open it once and choose Move to put it in Applications:
        open "#{opt_prefix}/Juicetray.app"
      Later updates: Check for updates… → Update now in the app.
    EOS
  end

  test do
    app = prefix/"Juicetray.app"
    assert_path_exists app/"Contents/MacOS/juicetray"
    system "codesign", "--verify", app
  end
end
