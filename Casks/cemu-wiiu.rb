cask "cemu-wiiu" do
  version "2.0-39"
  sha256 "353bfa8508b6362063d9d6fe898b558bb739efd20ae7f4a50853eb6ec2fdf89a"
  homepage "https://github.com/cemu-project/Cemu"
  url "https://github.com/cemu-project/Cemu/releases/download/v#{version}/cemu-#{version}-macos-12-x64.dmg"
  name "Cemu"
  desc "Wii U emulator"

  app "Cemu.app"
end
