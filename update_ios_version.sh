#!/bin/bash

# iOS Xcode Versiyon Güncelleme Script
# Bu script iOS projesindeki versiyon numaralarını Flutter'a bağlar

set -e

echo "🔧 iOS Xcode Versiyon Güncelleme Script"
echo "========================================"

# Mevcut versiyonu oku
current_version=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

echo "📋 pubspec.yaml'dan versiyon bilgileri:"
echo "   Version Name: $version_name"
echo "   Build Number: $build_number"
echo ""

# iOS project.pbxproj dosyasını güncelle
project_file="ios/Runner.xcodeproj/project.pbxproj"

if [ ! -f "$project_file" ]; then
    echo "❌ $project_file bulunamadı!"
    exit 1
fi

echo "🔧 iOS projesini güncelleniyor..."

# Backup oluştur
cp "$project_file" "$project_file.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Backup oluşturuldu: $project_file.backup.$(date +%Y%m%d_%H%M%S)"

# Option 1: Sabit versiyonları güncelle
echo ""
echo "Seçenekler:"
echo "1) Sabit versiyon numaralarını güncelle (Basit)"
echo "2) Flutter bağımlılığı ekle (Gelişmiş - otomatik)"
echo ""
read -p "Seçiminizi yapın (1-2): " option

case $option in
    1)
        # Sabit versiyonları güncelle
        echo "🔄 Sabit versiyon numaraları güncelleniyor..."
        
        # MARKETING_VERSION güncelle
        sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = $version_name/g" "$project_file"
        
        # CURRENT_PROJECT_VERSION güncelle
        sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = $build_number/g" "$project_file"
        
        echo "✅ iOS projesi güncellendi!"
        echo "   Marketing Version: $version_name"
        echo "   Current Project Version: $build_number"
        ;;
        
    2)
        # Flutter bağımlılığı ekle
        echo "🔗 Flutter bağımlılığı ekleniyor..."
        
        # MARKETING_VERSION'ı Flutter'a bağla
        sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = \$(FLUTTER_BUILD_NAME)/g" "$project_file"
        
        # CURRENT_PROJECT_VERSION'ı Flutter'a bağla
        sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = \$(FLUTTER_BUILD_NUMBER)/g" "$project_file"
        
        echo "✅ iOS projesi Flutter'a bağlandı!"
        echo "   Marketing Version: \$(FLUTTER_BUILD_NAME)"
        echo "   Current Project Version: \$(FLUTTER_BUILD_NUMBER)"
        echo ""
        echo "ℹ️  Artık flutter build ipa komutları otomatik olarak"
        echo "   pubspec.yaml'daki versiyonu kullanacak."
        ;;
        
    *)
        echo "❌ Geçersiz seçim!"
        exit 1
        ;;
esac

echo ""
echo "🧪 Değişiklikleri test edelim..."

# Test build (sadece doğrulama için)
cd ios
if xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -destination 'generic/platform=iOS' clean > /dev/null 2>&1; then
    echo "✅ iOS projesi syntax kontrolü başarılı"
else
    echo "❌ iOS projesi syntax hatası! Backup geri yükleniyor..."
    cp "$project_file.backup.$(date +%Y%m%d_%H%M%S)" "$project_file"
    exit 1
fi

cd ..

echo ""
echo "🎉 İşlem tamamlandı!"
echo ""
echo "📝 Sonraki adımlar:"
echo "   1. ./build_ipa.sh veya ./quick_build.sh ile build alın"
echo "   2. Veya flutter build ipa komutunu kullanın"
echo ""
echo "💡 İpucu: Artık her build'de versiyon otomatik olarak güncellenecek!"