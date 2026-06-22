import { PrismaClient, Role, OwnerStatus } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Owner User'ları oluştur
  await prisma.user.createMany({
    data: [
      {
        id: 'owner-1',
        email: 'elite@test.com',
        password: 'demo',
        role: Role.OWNER,
      },
      {
        id: 'owner-2',
        email: 'studio@test.com',
        password: 'demo',
        role: Role.OWNER,
      },
      {
        id: 'owner-3',
        email: 'royal@test.com',
        password: 'demo',
        role: Role.OWNER,
      },
    ],
    skipDuplicates: true,
  });

  // Owner profilleri
  await prisma.owner.createMany({
    data: [
      {
        userId: 'owner-1',
        fullName: 'Elite Owner',
        phone: '05000000001',
        status: OwnerStatus.APPROVED,
      },
      {
        userId: 'owner-2',
        fullName: 'Studio Owner',
        phone: '05000000002',
        status: OwnerStatus.APPROVED,
      },
      {
        userId: 'owner-3',
        fullName: 'Royal Owner',
        phone: '05000000003',
        status: OwnerStatus.APPROVED,
      },
    ],
    skipDuplicates: true,
  });

  // Dükkanlar
  await prisma.shop.createMany({
    data: [
      {
        id: 'shop-1',
        name: 'Elite Kuaför',
        description: 'Profesyonel saç ve bakım hizmetleri.',
        city: 'İstanbul',
        district: 'Kadıköy',
        address: 'Moda Caddesi No:12',
        latitude: 40.987,
        longitude: 29.027,
        ownerId: 'owner-1',
      },
      {
        id: 'shop-2',
        name: 'Studio 34',
        description: 'Modern erkek bakım merkezi.',
        city: 'İstanbul',
        district: 'Beşiktaş',
        address: 'Barbaros Bulvarı No:45',
        latitude: 41.043,
        longitude: 29.009,
        ownerId: 'owner-2',
      },
      {
        id: 'shop-3',
        name: 'Royal Hair',
        description: 'Randevulu premium hizmet.',
        city: 'İstanbul',
        district: 'Şişli',
        address: 'Halaskargazi Cd.',
        latitude: 41.061,
        longitude: 28.987,
        ownerId: 'owner-3',
      },
    ],
    skipDuplicates: true,
  });

  // Uzmanlar
  await prisma.chair.createMany({
    data: [
      {
        shopId: 'shop-1',
        name: 'Ahmet Usta',
        bio: '10 yıllık deneyim',
      },
      {
        shopId: 'shop-1',
        name: 'Mehmet',
        bio: 'Fade uzmanı',
      },
      {
        shopId: 'shop-2',
        name: 'Can',
        bio: 'Sakal tasarımı',
      },
      {
        shopId: 'shop-3',
        name: 'Emre',
        bio: 'Klasik kesim',
      },
    ],
    skipDuplicates: true,
  });

  // Görseller
  await prisma.shopImage.createMany({
    data: [
      {
        shopId: 'shop-1',
        url: 'https://picsum.photos/600/400?random=1',
      },
      {
        shopId: 'shop-2',
        url: 'https://picsum.photos/600/400?random=2',
      },
      {
        shopId: 'shop-3',
        url: 'https://picsum.photos/600/400?random=3',
      },
    ],
    skipDuplicates: true,
  });

  console.log('✅ Demo veriler oluşturuldu.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });