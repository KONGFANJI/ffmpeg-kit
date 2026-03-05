Pod::Spec.new do |spec|
  spec.name         = "ffmpeg-kit-macos"
  spec.version      = "6.0.3"
  spec.summary      = "FFmpeg Kit framework for macOS"
  spec.description  = <<-DESC
    FFmpeg Kit provides a flexible platform to cross-compile FFmpeg and FFmpeg dependencies.
    This podspec distributes the universal macOS xcframeworks containing arm64 and x86_64 architectures.
  DESC
  spec.homepage     = "https://github.com/KONGFANJI/ffmpeg-kit"
  spec.license      = { :type => "LGPL", :file => "LICENSE" }
  spec.author       = { "KONGFANJI" => "kongfanji@example.com" } # Adjust email if necessary
  
  # The source is where CocoaPods will download the zip file that was uploaded to the GitHub Release.
  spec.source       = { :http => "https://github.com/KONGFANJI/ffmpeg-kit/releases/download/v#{spec.version}/pod_release/ffmpeg-kit-macos-xcframeworks.zip" }

  spec.platform     = :osx, "10.15"

  # Include the xcframeworks from the downloaded zip
  spec.vendored_frameworks = [
    "ffmpegkit.xcframework",
    "libavcodec.xcframework",
    "libavdevice.xcframework",
    "libavfilter.xcframework",
    "libavformat.xcframework",
    "libavutil.xcframework",
    "libswresample.xcframework",
    "libswscale.xcframework"
  ]

  spec.requires_arc = true
end
