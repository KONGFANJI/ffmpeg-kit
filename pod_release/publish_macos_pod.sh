#!/bin/bash

# FFmpeg Kit macOS Automated Publisher
# This script zips frameworks, pushes a tag, and uploads to GitHub Releases.

# Change to the project root directory before executing
cd "$(dirname "$0")/.." || exit 1

VERSION="6.0.3"
ZIP_NAME="pod_release/ffmpeg-kit-macos-xcframeworks.zip"
FRAMEWORKS_DIR="prebuilt/bundle-apple-xcframework-macos"
TAG_NAME="v$VERSION"

echo "--- Starting Automation for version $VERSION ---"

# 1. Zip frameworks
if [ -d "$FRAMEWORKS_DIR" ]; then
    echo "Zipping frameworks..."
    cd "$FRAMEWORKS_DIR" || exit 1
    zip -y -q -r "../../$ZIP_NAME" *.xcframework
    cd ../../ || exit 1
    echo "Zip created: $ZIP_NAME"
else
    echo "Error: Frameworks directory not found at $FRAMEWORKS_DIR"
    exit 1
fi

# 2. Git Tag
echo "Ensuring git tag $TAG_NAME exists..."
if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    echo "Tag $TAG_NAME already exists locally."
else
    git tag "$TAG_NAME"
fi
git push origin "$TAG_NAME"

# 3. GitHub Release and Upload
echo "Uploading to GitHub Release..."
# Check if release already exists
if gh release view "$TAG_NAME" >/dev/null 2>&1; then
    echo "Release $TAG_NAME already exists. Uploading asset..."
    gh release upload "$TAG_NAME" "$ZIP_NAME" --clobber
else
    echo "Creating new release $TAG_NAME and uploading asset..."
    gh release create "$TAG_NAME" "$ZIP_NAME" --title "$TAG_NAME" --notes "Automated release for macOS xcframeworks"
fi

echo "--- Done! ---"
echo "Podspec download link: https://github.com/KONGFANJI/ffmpeg-kit/releases/download/$TAG_NAME/$ZIP_NAME"
