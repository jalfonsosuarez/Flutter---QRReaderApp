import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int pagina=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 'QR Scanner' ),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever ),
            onPressed: scansBloc.borrarScans,
          )
        ],
      ),
      body: _callPage( pagina ),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: _scanQR,
        backgroundColor: Theme.of( context ).primaryColor,
      ),

    );
  }

  _scanQR() async {

    // https://fernando-herrera.com
    // geo: 37.402549896017995, -5.957479177321261

    // String futureString = '';
    String futureString = 'https://fernando-herrera.com';

    // try {

    //   futureString = await new QRCodeReader().scan();

    // } catch (e) {

    //   futureString = e.toString();

    // }

    if (futureString != null ) {
        final scan = ScanModel( valor: futureString );
        scansBloc.agregarScan(scan);

        // final scan2 = ScanModel( valor: 'geo: 37.402549896017995,-5.957479177321261' );
        // scansBloc.agregarScan(scan2);

        if ( Platform.isIOS ) {
          Future.delayed(Duration(milliseconds: 750), () {
            utils.abrirScan(scan);
          });
        } else {
          utils.abrirScan(scan);
        }
    }

  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: pagina,
      onTap: (index) {
        setState(() {
          pagina = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text( 'Mapas' ),
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text( 'Direcciones' ),
        ),
      ]
    );

  }

  Widget _callPage( int pagina ) {

    switch( pagina ){
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }

  }
}