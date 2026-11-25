# Installs the prebuilt universal Juicetray.app from the GitHub release. Homebrew downloads it
# with curl, so it carries no quarantine flag and Gatekeeper does not block the ad-hoc signed app.
class Juicetray < Formula
  desc "Battery levels of wireless mice, headsets and Bluetooth devices in the menu bar"
  homepage "https://github.com/ittmchien/juicetray"
  url "https://github.com/ittmchien/juicetray/releases/download/v0.4.1/juicetray-macos-universal.app.zip",
      using: :nounzip
  sha256 "bd82b73c4eec7817613fdecf303b3dc775f921233d4531c3614b7fac6401027d"
  license "GPL-3.0-or-later"

  depends_on macos: :ventura

  def install
    # ditto keeps the bundle's code signature and resources intact.
    system "ditto", "-x", "-k", "juicetray-macos-universal.app.zip", prefix
  end

  def caveats
    <<~EOS
      Copy the app into Applications (again after each upgrade), then open it from there:
        rm -rf /Applications/Juicetray.app && cp -R #{opt_prefix}/Juicetray.app /Applications/
    EOS
  end

  test do
    app = prefix/"Juicetray.app"
    assert_path_exists app/"Contents/MacOS/juicetray"
    system "codesign", "--verify", app
  end
end
