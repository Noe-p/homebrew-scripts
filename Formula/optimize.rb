class Optimize < Formula
  desc "Optimizes and resizes images and videos"
  homepage "https://github.com/Noe-p/optimize-script"
  url "https://github.com/Noe-p/optimize-script/archive/v1.0.0.tar.gz"
  sha256 "28e4f219edaf3ee86fbbd8ad3833f41dd5c4a4a20868c27cf8a1d335bae2cd7f"
  license "MIT"

  depends_on "imagemagick"

  def install
    bin.install "optimize.sh" => "optimize"
  end

  test do
    system "#{bin}/optimize", "--help"
  end
end
