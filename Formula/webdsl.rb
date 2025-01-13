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
    llvm = Formula["llvm"]
    
    # Set environment variables for compilation
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["LDFLAGS"] = "-L#{llvm.opt_lib}"
    ENV["CPPFLAGS"] = "-I#{llvm.opt_include}"
    
    # Ensure pkg-config can find the Homebrew-installed libraries
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["postgresql@14"].opt_lib/"pkgconfig"
    
    # Override the make command to use the correct compiler
    system "make", "build/webdsl", "CC=#{llvm.opt_bin}/clang"
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
