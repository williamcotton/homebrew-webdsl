class Webdsl < Formula
  desc "Domain-specific language and server for building web applications"
  homepage "https://github.com/williamcotton/webdsl"
  head "https://github.com/williamcotton/webdsl.git", branch: "main"

  depends_on "llvm"
  depends_on "postgresql@14"
  depends_on "libmicrohttpd"
  depends_on "jansson"
  depends_on "jq"
  depends_on "lua"
  depends_on "uthash"
  depends_on "libbsd"
  depends_on "openssl"
  depends_on "curl"

  def install
    ENV.llvm_clang
    system "make"
    bin.install "build/webdsl"
  end

  test do
    (testpath/"test.webdsl").write <<~EOS
      website {
        port 3123
        name "Test Site"
      }
    EOS
    
    system "#{bin}/webdsl", "test.webdsl"
  end
end
