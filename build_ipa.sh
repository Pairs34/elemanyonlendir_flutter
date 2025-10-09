#!/bin/bash

# Flutter iOS IPA Build Script
# Bu script versiyon yönetimi ve otomatik build işlemlerini yapar

set -e  # Hata durumunda script'i durdur

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════╗"
echo "║        Flutter iOS IPA Build Script         ║"
echo "║            Eleman Yönlendir Çalışan         ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Mevcut versiyonu oku
current_version=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
version_name=$(echo $current_version | cut -d'+' -f1)
build_number=$(echo $current_version | cut -d'+' -f2)

echo -e "${YELLOW}📋 Mevcut Versiyon Bilgileri:${NC}"
echo "   Version Name: $version_name"
echo "   Build Number: $build_number"
echo ""

# Kullanıcıdan seçim al
echo -e "${BLUE}🚀 Build Seçenekleri:${NC}"
echo "1) Mevcut versiyon ile build al ($current_version)"
echo "2) Sadece build number'ı artır (patch)"
echo "3) Minor versiyon artır (örn: 2.6.0 → 2.7.0)"
echo "4) Major versiyon artır (örn: 2.6.0 → 3.0.0)"
echo "5) Manuel versiyon gir"
echo "6) Çıkış"
echo ""

read -p "Seçiminizi yapın (1-6): " choice

case $choice in
    1)
        # Mevcut versiyon ile build al
        new_version_name=$version_name
        new_build_number=$build_number
        ;;
    2)
        # Build number artır
        new_version_name=$version_name
        new_build_number=$((build_number + 1))
        ;;
    3)
        # Minor versiyon artır
        major=$(echo $version_name | cut -d'.' -f1)
        minor=$(echo $version_name | cut -d'.' -f2)
        new_minor=$((minor + 1))
        new_version_name="$major.$new_minor.0"
        new_build_number=$((build_number + 1))
        ;;
    4)
        # Major versiyon artır
        major=$(echo $version_name | cut -d'.' -f1)
        new_major=$((major + 1))
        new_version_name="$new_major.0.0"
        new_build_number=$((build_number + 1))
        ;;
    5)
        # Manuel versiyon
        echo -e "${YELLOW}Manuel Versiyon Girişi:${NC}"
        read -p "Version Name (örn: 2.6.1): " new_version_name
        read -p "Build Number (örn: 15): " new_build_number
        ;;
    6)
        echo -e "${YELLOW}❌ Build iptal edildi.${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Geçersiz seçim. Script sonlandırılıyor.${NC}"
        exit 1
        ;;
esac

new_version="$new_version_name+$new_build_number"

# Versiyon güncelleme onayı
if [ "$new_version" != "$current_version" ]; then
    echo ""
    echo -e "${YELLOW}📝 Versiyon Güncellemesi:${NC}"
    echo "   Eski: $current_version"
    echo "   Yeni: $new_version"
    echo ""
    read -p "Versiyonu güncelleyip build almaya devam edilsin mi? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        # pubspec.yaml'ı güncelle
        sed -i '' "s/version: $current_version/version: $new_version/" pubspec.yaml
        echo -e "${GREEN}✅ pubspec.yaml güncellendi${NC}"
        
        # Git commit (opsiyonel)
        read -p "🔀 Bu değişikliği git'e commit etmek istiyor musunuz? (y/N): " git_commit
        if [[ $git_commit =~ ^[Yy]$ ]]; then
            git add pubspec.yaml
            git commit -m "chore: bump version to $new_version"
            echo -e "${GREEN}✅ Git commit yapıldı${NC}"
        fi
    else
        echo -e "${YELLOW}❌ Versiyon güncellemesi iptal edildi.${NC}"
        new_version_name=$version_name
        new_build_number=$build_number
    fi
fi

echo ""
echo -e "${BLUE}🔨 Build İşlemi Başlatılıyor...${NC}"
echo "   Version Name: $new_version_name"
echo "   Build Number: $new_build_number"
echo ""

# Flutter temizlik
echo -e "${YELLOW}🧹 Flutter clean...${NC}"
flutter clean

# Dependencies al
echo -e "${YELLOW}📦 Dependencies alınıyor...${NC}"
flutter pub get

# iOS build
echo -e "${YELLOW}🍎 iOS IPA build başlatılıyor...${NC}"
flutter build ipa \
    --build-name="$new_version_name" \
    --build-number="$new_build_number" \
    --release

# Build sonucu kontrolü
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║              🎉 BUILD BAŞARILI! 🎉           ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${GREEN}✅ IPA dosyası oluşturuldu:${NC}"
    echo "   📱 Versiyon: $new_version_name ($new_build_number)"
    echo "   📂 Konum: build/ios/ipa/"
    echo ""
    echo -e "${BLUE}📤 App Store'a Yükleme:${NC}"
    echo "   1. Apple Transporter uygulamasını açın"
    echo "   2. build/ios/ipa/ klasöründeki .ipa dosyasını sürükleyin"
    echo "   3. Ya da Terminal'de şu komutu kullanın:"
    echo "      xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey YOUR_API_KEY --apiIssuer YOUR_ISSUER_ID"
    echo ""
    
    # IPA dosyasını Finder'da göster
    read -p "🗂️  IPA dosyasını Finder'da göstermek istiyor musunuz? (y/N): " show_finder
    if [[ $show_finder =~ ^[Yy]$ ]]; then
        open build/ios/ipa/
    fi
    
else
    echo ""
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║              ❌ BUILD HATASI! ❌             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${RED}❌ Build işlemi başarısız oldu.${NC}"
    echo -e "${YELLOW}🔍 Yukarıdaki hata mesajlarını kontrol edin.${NC}"
    exit 1
fi