class DartSdk < Formula
  desc "Dart SDK, VM, and core libraries"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.0.5.tar.gz"
  sha256 "f5d75042e7b3081816b19dcee196885769420e0bcbdf0ff3c32e5bb4896ff9a6"
  license "GPL-2.0-or-later"
  head "https://github.com/dart-lang/sdk.git", branch: "main"

  depends_on xcode: :build
  uses_from_macos "python@3.11" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git", branch: "main"
  end

  def install
    resource("depot-tools").stage do |context|
      context.retain!
      ENV["PATH"] = PATH.new(ENV.fetch("PATH")).prepend(context.staging.tmpdir)
    end

    system "gclient", "config", "https://github.com/dart-lang/sdk/"
    if build.head?
      system "gclient", "sync"
    else
      system "gclient", "sync", "-r", version
    end

    Dir.chdir("sdk") do
      system "./tools/build.py", "--no-goma", "--mode", "release", "create_sdk"

      # adapted from dart-sdk/sdk/sdk/bin/dart script
      out_dir = if OS.mac?
                  File.absolute_path("#{Dir.pwd}/xcodebuild/")
                else
                  File.absolute_path("#{Dir.pwd}/out/")
                end

      dirs = Dir["#{out_dir}/*"]
      configs = ["ReleaseX64", "ReleaseARM64", "ReleaseIA32", "DebugX64", "DebugIA32", "ReleaseARM"]

      dart_configuration = nil
      configs.each do |config|
        catch :found do
          dirs.map(&File.method(:basename)).each do |dir|
            if config == dir
              dart_configuration = config
              throw :found
            end
          end
        end
      end

      if dart_configuration.nil?
        odie "couldn't find a valid dart build. if you see this, please file a bug report to charitybell/homebrew-charitybell"
      end

      libexec.install Dir["#{out_dir}/#{dart_configuration}/dart-sdk/*"]

      bin.install_symlink "#{libexec}/bin/dart"
      bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
    end

  end

  test do
    output = shell_output "#{bin}/dart --version"
    unless output.include? version
      odie "wrong version was built! wanted #{version}, but found `#{output}`"
    end
  end
end
