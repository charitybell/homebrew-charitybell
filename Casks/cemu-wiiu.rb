cask "cemu-wiiu" do
  version "2.0-42"
  sha256 "d177771b189efdafe269a81f79f334027188a9e66a9e84fe6251aa731cf69249"

  url "https://github.com/cemu-project/Cemu/releases/download/v#{version}/cemu-#{version}-macos-12-x64.dmg"
  name "Cemu"
  desc "Wii U emulator"
  homepage "https://github.com/cemu-project/Cemu"

  app "Cemu.app"
end
