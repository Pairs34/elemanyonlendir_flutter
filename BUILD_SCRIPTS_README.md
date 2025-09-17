# 🚀 Flutter iOS Build Scripts

Bu klasörde iOS IPA build işlemlerini kolaylaştıran scriptler bulunmaktadır.

## 📋 Scriptler

### 1. `build_ipa.sh` - Ana Build Script ⭐
**En kapsamlı script - Önerilen**

```bash
./build_ipa.sh
```

**Özellikler:**
- ✅ İnteraktif menü
- ✅ Versiyon seçenekleri (patch, minor, major)
- ✅ Manuel versiyon girme
- ✅ Git commit desteği
- ✅ Renkli çıktı
- ✅ IPA dosyasını Finder'da gösterme
- ✅ App Store yükleme talimatları

### 2. `quick_build.sh` - Hızlı Build
**Sadece build number artırır ve build alır**

```bash
./quick_build.sh
```

**Özellikler:**
- ✅ Tek komutla build
- ✅ Otomatik build number artırma
- ✅ Hızlı ve basit

### 3. `update_ios_version.sh` - iOS Xcode Güncelleme
**iOS projesindeki versiyon numaralarını Flutter'a bağlar**

```bash
./update_ios_version.sh
```

**Özellikler:**
- ✅ iOS project.pbxproj güncelleme
- ✅ Flutter bağımlılığı ekleme
- ✅ Otomatik backup
- ✅ Syntax kontrolü

## 🎯 Kullanım Senaryoları

### Senaryo 1: İlk Kurulum
```bash
# 1. iOS projesini Flutter'a bağla
./update_ios_version.sh

# 2. Build al
./build_ipa.sh
```

### Senaryo 2: Rutin Build
```bash
# Hızlı build (build number +1)
./quick_build.sh

# Veya detaylı build seçenekleri
./build_ipa.sh
```

### Senaryo 3: Versiyon Yönetimi
```bash
# Ana script ile versiyon kontrolü
./build_ipa.sh
# Menüden istediğiniz versiyon türünü seçin:
# - Patch: 2.6.0 → 2.6.1
# - Minor: 2.6.0 → 2.7.0  
# - Major: 2.6.0 → 3.0.0
```

## 📱 Versiyon Formatı

```
version: 2.6.0+13
         ↑     ↑
    Version   Build
    Name      Number
```

- **Version Name**: App Store'da görünen versiyon (2.6.0)
- **Build Number**: Dahili build numarası (13)

## 🔧 Sorun Giderme

### Script çalışmıyor
```bash
chmod +x *.sh
```

### iOS build hatası
```bash
# Clean ve retry
flutter clean
flutter pub get
./build_ipa.sh
```

### Versiyon güncellenmiyor
```bash
# iOS projesini Flutter'a bağla
./update_ios_version.sh
```

## 📤 App Store'a Yükleme

Build başarılı olduktan sonra:

1. **Apple Transporter** kullanın (Önerilen)
   - App Store'dan Apple Transporter'ı indirin
   - `build/ios/ipa/` klasöründeki .ipa dosyasını sürükleyin

2. **Terminal** ile:
   ```bash
   xcrun altool --upload-app --type ios \
     -f build/ios/ipa/*.ipa \
     --apiKey YOUR_API_KEY \
     --apiIssuer YOUR_ISSUER_ID
   ```

## 🎨 Script Özellikleri

- 🎨 Renkli terminal çıktısı
- 🛡️ Hata kontrolü ve güvenli çıkış
- 📁 Otomatik backup oluşturma
- 🔍 Build doğrulama
- 📊 Detaylı durum raporları
- 🎯 Kullanıcı dostu menüler

## 💡 İpuçları

1. **İlk kullanımda** `update_ios_version.sh` çalıştırın
2. **Rutin buildler** için `quick_build.sh` kullanın
3. **Release buildleri** için `build_ipa.sh` kullanın
4. **Git commit** seçeneğini kullanarak versiyon değişikliklerini takip edin

---

**Hazırlayan:** GitHub Copilot  
**Proje:** Eleman Yönlendir Çalışan  
**Tarih:** Eylül 2025