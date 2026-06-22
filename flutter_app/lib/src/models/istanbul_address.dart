class IstanbulDistrict {
  final String name;
  final List<IstanbulNeighborhood> neighborhoods;

  IstanbulDistrict({
    required this.name,
    required this.neighborhoods,
  });
}

class IstanbulNeighborhood {
  final String name;
  final List<String> streets;

  IstanbulNeighborhood({
    required this.name,
    required this.streets,
  });
}

class AddressSelection {
  final String city;
  final String district;
  final String neighborhood;
  final String street;
  final String? buildingNumber;

  AddressSelection({
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.street,
    this.buildingNumber,
  });

  String get fullAddress {
    final parts = [buildingNumber, street, neighborhood, district, city]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

// İstanbul adres verileri
final istanbulData = [
  IstanbulDistrict(
    name: 'Adalar',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Burgazadası',
        streets: [
          'Orman Sokak',
          'Deniz Caddesi',
          'Cumhuriyet Sokak',
          'Yüksek Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Heybeliada',
        streets: [
          'İskelesi Caddesi',
          'Manastır Sokak',
          'Yalı Sokak',
          'Mezarlık Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kınalıada',
        streets: [
          'Deniz Yolu Caddesi',
          'Şirin Sokak',
          'Ağa Caddesi',
          'Kaya Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Sedef Adası',
        streets: [
          'Sahil Caddesi',
          'Park Sokak',
          'Yalı Sokak',
          'Orman Yolu',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Avcılar',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Avcılar',
        streets: [
          'Halkalı Caddesi',
          'Beşyüzevler Sokak',
          'Cumhuriyet Caddesi',
          'Merkez Sokak',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Beşyüzevler',
        streets: [
          'Beşyüzevler Sokak',
          'Çam Yolu',
          'Orman Sokak',
          'Yol Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Halkalı',
        streets: [
          'Halkalı Caddesi',
          'Istasyon Sokak',
          'Merkez Sokak',
          'Yeni Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Bakırköy',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Bakırköy',
        streets: [
          'Adnan Menderes Caddesi',
          'Sahil Yolu',
          'Cumhuriyet Caddesi',
          'Merkez Sokak',
          'Barbaros Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Bahçelievler',
        streets: [
          'Bahçelievler Caddesi',
          'Park Sokak',
          'Yeşil Yol',
          'Bahçe Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'İnşirah',
        streets: [
          'İnşirah Caddesi',
          'Sahil Sokak',
          'Merkez Yolu',
          'Çiçek Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Yeşilbağ',
        streets: [
          'Yeşilbağ Caddesi',
          'Orman Sokak',
          'Bahçe Yolu',
          'Çınar Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Başakşehir',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Başakşehir',
        streets: [
          'Başakşehir Caddesi',
          'Cumhuriyet Yolu',
          'Merkez Sokak',
          'Park Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Elmalı',
        streets: [
          'Elmalı Caddesi',
          'Orman Sokak',
          'Bahçe Yolu',
          'Çiçek Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kaynarca',
        streets: [
          'Kaynarca Caddesi',
          'Yeni Yol',
          'Merkez Sokak',
          'Sahil Caddesi',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Bayrampaşa',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Bayrampaşa',
        streets: [
          'Bayrampaşa Caddesi',
          'Gümrük Sokak',
          'Merkez Yolu',
          'Cumhuriyet Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Edirnekapı',
        streets: [
          'Edirnekapı Caddesi',
          'Surlar Sokak',
          'Osmanlı Yolu',
          'Kale Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Topkapı',
        streets: [
          'Topkapı Caddesi',
          'Saray Sokak',
          'Bahçe Yolu',
          'Tarihi Yol',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Beşiktaş',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Beşiktaş',
        streets: [
          'Barbaros Caddesi',
          'Vişnezade Sokak',
          'Defterdar Yokuşu',
          'Sahil Yolu',
          'Çırağan Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Arnavutköy',
        streets: [
          'Arnavutköy Caddesi',
          'Sahil Sokak',
          'Merkez Yolu',
          'Yalı Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Bebek',
        streets: [
          'Cevdetpaşa Caddesi',
          'Sahil Yolu',
          'Bebek Park Sokak',
          'Dereboyu Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Levent',
        streets: [
          'Levent Caddesi',
          'Nispetiye Sokak',
          'Barbaros Caddesi',
          'Merkez Yolu',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Ortaköy',
        streets: [
          'Ortaköy Caddesi',
          'Sahil Sokak',
          'Mecidiye Sokak',
          'Dereboyu Yolu',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Beylikdüzü',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Beylikdüzü',
        streets: [
          'Beylikdüzü Caddesi',
          'Cumhuriyet Yolu',
          'Merkez Sokak',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Güzeltepe',
        streets: [
          'Güzeltepe Caddesi',
          'Orman Sokak',
          'Bahçe Yolu',
          'Çiçek Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Sarıyer',
        streets: [
          'Sarıyer Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Yeni Yol',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Beyoğlu',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Beyoğlu',
        streets: [
          'İstiklal Caddesi',
          'Galata Sokak',
          'Taksim Meydanı',
          'Şişli Caddesi',
          'Yeşilçam Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Cihangir',
        streets: [
          'Cihangir Caddesi',
          'Ayvansaray Sokak',
          'Sahil Yolu',
          'Dereboyu Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Dolapdere',
        streets: [
          'Dolapdere Caddesi',
          'İş Hanı Sokak',
          'Merkez Yolu',
          'Cumhuriyet Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Galata',
        streets: [
          'Galata Kulesi Caddesi',
          'Bankacılar Sokak',
          'Voyvoda Caddesi',
          'Sahil Yolu',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Pera',
        streets: [
          'Pera Sokak',
          'Taksim Caddesi',
          'İstiklal Yolu',
          'Merkez Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Çatalay',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Çatalay',
        streets: [
          'Çatalay Caddesi',
          'Merkez Sokak',
          'Sahil Yolu',
          'Orman Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kaya',
        streets: [
          'Kaya Caddesi',
          'Park Sokak',
          'Yeşil Yol',
          'Bahçe Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Çekmeköy',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Çekmeköy',
        streets: [
          'Çekmeköy Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'İçerenköy',
        streets: [
          'İçerenköy Caddesi',
          'Orman Sokak',
          'Merkez Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Eminönü',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Eminönü',
        streets: [
          'Rıhtım Caddesi',
          'Gümrük Sokak',
          'Eminönü Meydanı',
          'Spice Bazaar Yolu',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Fatih',
        streets: [
          'Fatih Caddesi',
          'Mosque Sokak',
          'Merkez Yolu',
          'Tarihi Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Eyüp',
        streets: [
          'Eyüp Caddesi',
          'Camii Sokak',
          'Bahçe Yolu',
          'Pierre Loti Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Esenler',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Esenler',
        streets: [
          'Esenler Caddesi',
          'Otogar Sokak',
          'Merkez Yolu',
          'Cumhuriyet Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Saraçhane',
        streets: [
          'Saraçhane Caddesi',
          'Sanayi Sokak',
          'Ticaret Yolu',
          'Gümrük Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Esenyurt',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Esenyurt',
        streets: [
          'Esenyurt Caddesi',
          'Cumhuriyet Yolu',
          'Merkez Sokak',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Arnavutköy',
        streets: [
          'Arnavutköy Caddesi',
          'Merkez Sokak',
          'Sahil Yolu',
          'Yalı Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Fatih',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Fatih',
        streets: [
          'Fatih Caddesi',
          'Sulukule Sokak',
          'Saraç Sokak',
          'Şehzade Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Balat',
        streets: [
          'Balat Caddesi',
          'Ayvansaray Sokak',
          'Merkez Yolu',
          'Dereboyu Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Fener',
        streets: [
          'Fener Caddesi',
          'Camii Sokak',
          'Sahil Yolu',
          'İskele Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Gaziosmanpaşa',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Gaziosmanpaşa',
        streets: [
          'Gaziosmanpaşa Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Park Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Şirinevler',
        streets: [
          'Şirinevler Caddesi',
          'Siteler Sokak',
          'Merkez Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Güngören',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Güngören',
        streets: [
          'Güngören Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Sahil Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Yeşiltepe',
        streets: [
          'Yeşiltepe Caddesi',
          'Bahçe Sokak',
          'Orman Yolu',
          'Çiçek Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Kadıköy',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Kadıköy',
        streets: [
          'Barış Manço Caddesi',
          'Sahil Yolu',
          'Söğütlü Sokak',
          'Cumhuriyet Caddesi',
          'İskele Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Acibadem',
        streets: [
          'Acibadem Caddesi',
          'Merkez Sokak',
          'Bahçe Yolu',
          'Orman Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Caddebostan',
        streets: [
          'Caddebostan Caddesi',
          'Sahil Yolu',
          'Plaj Sokak',
          'Deniz Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Erenköy',
        streets: [
          'Erenköy Caddesi',
          'Sahil Yolu',
          'Park Sokak',
          'Yalı Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Fikirtepe',
        streets: [
          'Fikirtepe Caddesi',
          'Ticaret Sokak',
          'Sanayi Yolu',
          'Merkez Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Kağıthane',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Kağıthane',
        streets: [
          'Kağıthane Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Park Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Turnaçiçek',
        streets: [
          'Turnaçiçek Caddesi',
          'Orman Sokak',
          'Bahçe Yolu',
          'Çiçek Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Kartal',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Kartal',
        streets: [
          'Kartal Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'İskele Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Cevizli',
        streets: [
          'Cevizli Caddesi',
          'Bahçe Sokak',
          'Merkez Yolu',
          'Yeşil Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Pendik',
        streets: [
          'Pendik Caddesi',
          'Sahil Yolu',
          'Park Sokak',
          'Deniz Caddesi',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Küçükçekmece',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Küçükçekmece',
        streets: [
          'Küçükçekmece Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Göl Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Florya',
        streets: [
          'Florya Caddesi',
          'Sahil Yolu',
          'Park Sokak',
          'Deniz Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Yeşilköy',
        streets: [
          'Yeşilköy Caddesi',
          'Orman Sokak',
          'Merkez Yolu',
          'Bahçe Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Maltepe',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Maltepe',
        streets: [
          'Maltepe Caddesi',
          'Sahil Yolu',
          'Plaj Sokak',
          'Deniz Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Altayçeşme',
        streets: [
          'Altayçeşme Caddesi',
          'Merkez Sokak',
          'Bahçe Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Pendik',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Pendik',
        streets: [
          'Pendik Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'İskele Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Çayırova',
        streets: [
          'Çayırova Caddesi',
          'Orman Sokak',
          'Merkez Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Sarıyer',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Sarıyer',
        streets: [
          'Sarıyer Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Boğaz Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kilyos',
        streets: [
          'Kilyos Caddesi',
          'Sahil Yolu',
          'Plaj Sokak',
          'Deniz Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Rumelihisarı',
        streets: [
          'Rumelihisarı Caddesi',
          'Boğaz Yolu',
          'Kale Sokak',
          'Dereboyu Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Şileli',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Şileli',
        streets: [
          'Şileli Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Deniz Caddesi',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Şimşeköy',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Şimşeköy',
        streets: [
          'Şimşeköy Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Bahçe Caddesi',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Silivri',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Silivri',
        streets: [
          'Silivri Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'İskele Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Gümüşyaka',
        streets: [
          'Gümüşyaka Caddesi',
          'Orman Sokak',
          'Merkez Yolu',
          'Bahçe Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Şişli',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Şişli',
        streets: [
          'Abide-i Hürriyet Caddesi',
          'Halaskargazi Caddesi',
          'İstiklal Caddesi',
          'Meşrutiyet Caddesi',
          'Nisantaşı Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Bomontiada',
        streets: [
          'Bomontiada Caddesi',
          'Sanayi Sokak',
          'Merkez Yolu',
          'Ticaret Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Osmanbey',
        streets: [
          'Osmanbey Caddesi',
          'Meşrutiyet Sokak',
          'Merkez Yolu',
          'Bahçe Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Teşvikiye',
        streets: [
          'Teşvikiye Caddesi',
          'Gümüş Sokak',
          'Park Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Taksim',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Taksim',
        streets: [
          'Taksim Meydanı',
          'İstiklal Caddesi',
          'Cumhuriyet Caddesi',
          'Gümrük Sokak',
          'Merkez Yolu',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Tuzla',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Tuzla',
        streets: [
          'Tuzla Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'İskele Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Orhantepe',
        streets: [
          'Orhantepe Caddesi',
          'Bahçe Sokak',
          'Merkez Yolu',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Ümraniye',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Ümraniye',
        streets: [
          'Ümraniye Caddesi',
          'Merkez Sokak',
          'Cumhuriyet Yolu',
          'Park Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Ataşehir',
        streets: [
          'Ataşehir Caddesi',
          'Bahçelievler Sokak',
          'Merkez Yolu',
          'Yeşilbağ Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Üsküdar',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Üsküdar',
        streets: [
          'Iskele Caddesi',
          'Sahil Yolu',
          'Rumeli Caddesi',
          'Merkez Sokak',
          'Camii Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Beylerbeyi',
        streets: [
          'Beylerbeyi Caddesi',
          'Boğaz Yolu',
          'Saray Sokak',
          'Dereboyu Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Çengelköy',
        streets: [
          'Çengelköy Caddesi',
          'Sahil Yolu',
          'Boğaz Sokak',
          'Deniz Caddesi',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kuzguncuk',
        streets: [
          'Kuzguncuk Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Yeşil Sokak',
        ],
      ),
    ],
  ),
  IstanbulDistrict(
    name: 'Zeytinburnu',
    neighborhoods: [
      IstanbulNeighborhood(
        name: 'Zeytinburnu',
        streets: [
          'Zeytinburnu Caddesi',
          'Sahil Yolu',
          'Merkez Sokak',
          'Kumbaracı Sokak',
        ],
      ),
      IstanbulNeighborhood(
        name: 'Kazlıçeşme',
        streets: [
          'Kazlıçeşme Caddesi',
          'Orman Sokak',
          'Merkez Yolu',
          'Bahçe Sokak',
        ],
      ),
    ],
  ),
];
