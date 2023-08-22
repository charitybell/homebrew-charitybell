cask "playdate-sdk" do
  version "2.0.1"
  sha256 "04c53f03f6b01da0b5bfcf902649225136f04d838693ad4f219dcb041eb2d1c1"

  url "https://download-keycdn.panic.com/playdate_sdk/PlaydateSDK-#{version}.zip",
      verified: "download-keycdn.panic.com/playdate_sdk"
  name "PlaydateSDK"
  desc "SDK and developer documentation for the Playdate"
  homepage "https://play.date/dev"

  livecheck do
    url "https://download-keycdn.panic.com/playdate_sdk/"
    strategy :page_match
    regex(%r{href=.*?/playdate_sdk/PlaydateSDK-(\d+(?:\.\d+)*)\.zip}i)
  end

  pkg "PlaydateSDK.pkg"

  uninstall pkgutil: "play.date.sdk"
  uninstall delete: "~/Developer/PlaydateSDK/"
end
