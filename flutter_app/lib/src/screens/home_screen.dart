import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';
import '../providers/shops_provider.dart';
import '../widgets/shop_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  Position? _position;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final has = await Geolocator.isLocationServiceEnabled();
    if (!has) {
      setState(() => _permissionDenied = true);
      return;
    }
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      final req = await Geolocator.requestPermission();
      if (req == LocationPermission.denied || req == LocationPermission.deniedForever) {
        setState(() => _permissionDenied = true);
        return;
      }
    }
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() => _position = pos);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Good morning', style: Theme.of(context).textTheme.bodySmall),
          Text(auth.user?.firstName ?? 'Guest', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        ]),
        actions: [
          IconButton(onPressed: () => ref.read(authProvider.notifier).logout(), icon: const Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _initLocation(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    // TODO: open search page
                  },
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search for barbershop or service', filled: true, fillColor: Theme.of(context).cardColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [const Icon(Icons.location_on), const SizedBox(width: 8), Text(_position != null ? '${_position!.latitude.toStringAsFixed(4)}, ${_position!.longitude.toStringAsFixed(4)}' : (_permissionDenied ? 'Location disabled' : 'Detecting location...'))]),
                  TextButton.icon(onPressed: _initLocation, icon: const Icon(Icons.my_location), label: const Text('Use my location'))
                ]),
              ),
              const SizedBox(height: 8),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Text('Nearby', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
              const SizedBox(height: 8),
              if (_position == null && !_permissionDenied)
                const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
              else if (_permissionDenied)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Location access required', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        const Text('To show nearby barbershops we need access to your location. Please allow location permission.'),
                        const SizedBox(height: 12),
                        Row(children: [
                          ElevatedButton(onPressed: () => Geolocator.openLocationSettings(), child: const Text('Open Settings')),
                          const SizedBox(width: 8),
                          OutlinedButton(onPressed: _initLocation, child: const Text('Retry'))
                        ])
                      ]),
                    ),
                  ),
                )
              else
                Consumer(builder: (context, ref2, _) {
                  final async = ref2.watch(nearbyShopsProvider({'lat': _position!.latitude, 'lng': _position!.longitude, 'radius': 10.0}));
                  return async.when(
                    data: (shops) {
                      if (shops.isEmpty) return const Padding(padding: EdgeInsets.all(16.0), child: Text('No barbershops found in this area.'));
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shops.length,
                        itemBuilder: (context, i) => ShopCard(shop: shops[i], onTap: () {
                          // TODO: navigate to shop details with hero
                        }),
                      );
                    },
                    loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                    error: (e, s) => Padding(padding: const EdgeInsets.all(16.0), child: Text('Failed to load nearby shops: $e')),
                  );
                })
            ],
          ),
        ),
      ),
    );
  }
}

