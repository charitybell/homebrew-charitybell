cask "rpcs3" do
  version "0.0.28"
  sha256 "8d58d2690bd3c0e7613b155a4ab5dd9741d0ed83a12dbad87d167ed529be424e"

  url "https://github.com/RPCS3/rpcs3-binaries-mac/releases/download/build-fcfca6efda24839fe2cb9b49f148e7d6c664a80f/rpcs3-v#{version}-15156-fcfca6ef_macos.dmg", verified: "github.com/RPCS3/"
  name "RPCS3"
  desc "Open-source PlayStation 3 Emulator"
  homepage "https://rpcs3.net/"

  livecheck do
    url "https://github.com/RPCS3/rpcs3-binaries-mac/releases"
    strategy :github_latest
  end

  app "RPCS3.app"
end
