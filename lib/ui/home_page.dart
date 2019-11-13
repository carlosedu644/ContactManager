import 'package:agenda/helpers/contact_helper.dart';
import 'package:agenda/model/Contact.dart';
import 'package:agenda/ui/contact_page.dart';
import 'package:agenda/widgets/ContactCard.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  List<Contact> listContact = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (_) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordernar de AZ'),
                value: OrderOptions.orderAZ,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordernar de ZA'),
                value: OrderOptions.orderZA,
              )
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: listContact == null ? 0 : listContact.length,
        itemBuilder: (context, index) {
          return ContactCard(
            contacts: listContact,
            index: index,
            click: () {
              _showOptions(context, index);
            },
          );
        },
      ),
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        listContact.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        listContact.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
        
    }
    setState(() {
          
        });
  }

  void _showOptions(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return BottomSheet(
            onClosing: () {},
            builder: (_) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                      onPressed: () {
                        Navigator.pop(_);
                        launch('tel:${listContact[index].phone}');
                      },
                    ),
                    FlatButton(
                      child: Text('Editar',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                      onPressed: () {
                        Navigator.pop(_);
                        _showContactPage(contact: listContact[index]);
                      },
                    ),
                    FlatButton(
                      child: Text('Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                      onPressed: () {
                        helper.deleteContact(listContact[index].id);
                        setState(() {
                          listContact.removeAt(index);
                          Navigator.pop(_);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactPage(
            contact: contact,
          ),
        ));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }

      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        listContact = list;
      });
    });
  }
}
