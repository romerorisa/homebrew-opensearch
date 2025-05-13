class Opensearch < Formula
  desc "Open-source distributed and RESTful search engine"
  homepage "https://opensearch.org/"
  url "https://github.com/romerorisa/OpenSearch/archive/refs/heads/opensearch-2.19.1.tar.gz"
  sha256 "62c3eec747ca90ce180ac58caca6b75ae890818a67eb2ebb33f701d4b138b91c"
  license "Apache-2.0"

  depends_on "openjdk@21"
  depends_on "gradle" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "./gradlew", ":distribution:archives:darwin-arm64-tar:assemble"
    tarball = Dir["distribution/archives/darwin-arm64-tar/build/distributions/opensearch-*.tar.gz"].first
    odie "Could not find OpenSearch tarball!" unless tarball
    mkdir "stage"
    system "tar", "-xzf", tarball, "-C", "stage", "--strip-components=1"
    libexec.install Dir["stage/*"]
    (bin/"opensearch").write_env_script libexec/"bin/opensearch", :JAVA_HOME => Formula["openjdk@21"].opt_prefix
  end

  test do
    system "#{bin}/opensearch", "--version"
  end
end