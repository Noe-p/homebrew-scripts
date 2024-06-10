class Optimize < Formula
  desc "Optimizes and resizes images and videos"
  homepage "https://github.com/Noe-p/optimize-script"
  url "https://github.com/Noe-p/optimize-script.git", :tag => "v1.0.2"
  license "MIT"

  depends_on "imagemagick"

  def install
    bin.install "optimize.sh" => "optimize"
  end

  test do
    system "#{bin}/optimize", "--help"
  end
end
