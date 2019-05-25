import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int pagina=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _callPage( pagina ),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
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