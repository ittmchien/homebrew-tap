# Builds Juicetray.app from source, so the app carries no quarantine flag and Gatekeeper
# does not block it even though it is only ad-hoc signed.
class Juicetray < Formula
  desc "Battery levels of wireless mice, headsets and Bluetooth devices in the menu bar"
  homepage "https://github.com/ittmchien/juicetray"
  url "https://github.com/ittmchien/juicetray/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9ac7fb2e19e251b1d4ab10ac42f7e83d22481afe2e10cb81e61393d5cc8dbc57"
  license "GPL-3.0-or-later"
  head "https://github.com/ittmchien/juicetray.git", branch: "dev"

  depends_on "rust" => :build
  depends_on macos: :ventura

  def install
    system "cargo", "install", *std_cargo_args(path: "app")

    # The binary lives inside the app bundle only; a bare `juicetray` on PATH is not needed.
    contents = prefix/"Juicetray.app/Contents"
    (contents/"MacOS").install bin/"juicetray"
    rm_r bin
    (contents/"Resources").install "packaging/macos/AppIcon.icns"
    plist = File.read("packaging/macos/Info.plist").gsub("__VERSION__", version.to_s)
    (contents/"Info.plist").write plist
    # Same licence files as the release bundle (app, Material Symbols icons, Inter font).
    licenses = contents/"Resources/licenses"
    licenses.install "LICENSE"
    licenses.install "crates/strip-render/assets/icons/LICENSE" => "Material-Symbols-LICENSE"
    licenses.install "crates/strip-render/assets/OFL.txt" => "Inter-OFL.txt"
    # Signing the bundle binds Info.plist (Bluetooth usage text) to the binary.
    system "codesign", "--force", "-s", "-", prefix/"Juicetray.app"
  end

  def caveats
    <<~EOS
      Copy the app into Applications (again after each upgrade), then open it from there:
        rm -rf /Applications/Juicetray.app && cp -R #{opt_prefix}/Juicetray.app /Applications/
    EOS
  end

  test do
    assert_path_exists prefix/"Juicetray.app/Contents/MacOS/juicetray"
    assert_match "Bluetooth", shell_output("#{prefix}/Juicetray.app/Contents/MacOS/juicetray scan")
  end
end
