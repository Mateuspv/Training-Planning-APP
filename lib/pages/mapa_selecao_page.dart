import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaSelecaoPage extends StatefulWidget {
  @override
  _MapaSelecaoPageState createState() => _MapaSelecaoPageState();
}

class _MapaSelecaoPageState extends State<MapaSelecaoPage> {
  LatLng? _localSelecionado;
  GoogleMapController? _controller;
  LatLng? _localAtual;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _obterLocalAtual();
  }

  Future<void> _obterLocalAtual() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final posicao = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _localAtual = LatLng(posicao.latitude, posicao.longitude);
        _carregando = false;
      });
    } else {
      // fallback para SP se permissão negada
      setState(() {
        _localAtual = LatLng(-23.5505, -46.6333);
        _carregando = false;
      });
    }
  }

  void _onMapTap(LatLng pos) {
    setState(() {
      _localSelecionado = pos;
    });
  }

  void _confirmarLocal() {
    if (_localSelecionado != null) {
      Navigator.of(context).pop(_localSelecionado);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando || _localAtual == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Local')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _localAtual!,
          zoom: 16,
        ),
        onMapCreated: (controller) => _controller = controller,
        onTap: _onMapTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _localSelecionado != null
            ? {
          Marker(
            markerId: const MarkerId('selecionado'),
            position: _localSelecionado!,
          )
        }
            : {},
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmarLocal,
        icon: const Icon(Icons.check),
        label: const Text('Confirmar'),
      ),
    );
  }
}
