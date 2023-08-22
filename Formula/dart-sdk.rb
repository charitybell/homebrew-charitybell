class DartSdk < Formula
  desc "SDK, VM, and core libraries for the Dart programming language"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.0.6.tar.gz"
  sha256 "7df8264f03c19ba87453061c93edb6a0420784af130f15b421237d16c725aaf4"
  license "BSD-3-Clause"
  head "https://github.com/dart-lang/sdk.git", branch: "main"

  bottle do
    root_url "https://github.com/charitybell/homebrew-charitybell/releases/download/dart-sdk/{{XXX_FORMULA_VERSION}}"
    sha256 cellar: :any_skip_relocation, ventura:      "a27bdc658522f07d8b9499a7957aae98342bc9bdb6f462c149f5ff48f5d7c8f7"
    sha256 cellar: :any_skip_relocation, monterey:     "7110d5f88b6ff03e1112961cff0f3cc7fd66504a9928fd288c4e7ba62d9b49bf"
    sha256 cellar: :any_skip_relocation, big_sur:      "3e22ef293ca832eb59f8619d459c965b4daf645cc99924266848359a188a5f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8267e1b501ba31d65b1ade693867936f8b4f05e821f2df051f9b53620a379e69"
  end

  depends_on xcode: :build
  depends_on "python@3.11" => :build

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
      configs = %w[ReleaseX64 ReleaseARM64 ReleaseIA32 DebugX64 DebugIA32 ReleaseARM]

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
        odie "couldn't find a valid dart build. please file a bug report to charitybell/homebrew-charitybell"
      end

      libexec.install Dir["#{out_dir}/#{dart_configuration}/dart-sdk/*"]

      bin.install_symlink "#{libexec}/bin/dart"
      bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
    end
  end

  test do
    output = shell_output "#{bin}/dart --version"
    odie "wrong version was built! wanted #{version}, but found `#{output}`" unless output.include? version
  end
end
