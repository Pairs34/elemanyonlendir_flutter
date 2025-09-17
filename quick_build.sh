#!/bin/bash

# Hızlı Build Script - Sadece build number artırır
# Kullanım: ./quick_build.sh

set -e

echo "🚀 Hızlı IPA Build Başlatılıyor..."

# Mevcut versiyonu oku
current_version=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

# Build number'ı artır
new_build_number=$((build_number + 1))
new_version="$version_name+$new_build_number"

echo "📝 Versiyon güncelleniyor: $current_version → $new_version"

# pubspec.yaml'ı güncelle
sed -i '' "s/version: $current_version/version: $new_version/" pubspec.yaml

echo "🧹 Flutter clean..."
flutter clean

echo "📦 Dependencies..."
flutter pub get

echo "🍎 IPA build..."
flutter build ipa --build-name="$version_name" --build-number="$new_build_number" --release

if [ $? -eq 0 ]; then
    echo "✅ Build başarılı! Versiyon: $new_version"
    echo "📂 IPA dosyası: build/ios/ipa/"
else
    echo "❌ Build başarısız!"
    exit 1
fi