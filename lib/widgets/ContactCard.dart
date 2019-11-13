import 'dart:io';

import 'package:agenda/model/Contact.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final List<Contact> contacts;
  final int index;
  final VoidCallback click;

  ContactCard({@required this.contacts, @required this.index, this.click});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].image != null
                          ? FileImage(
                              File(contacts[index].image),
                            )
                          : AssetImage('assets/profile.jpg'),
                          fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 220,
                        child: Text(
                          contacts[index].name ?? "",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: 220,
                        child: Text(
                          contacts[index].email ?? "",
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        )),
                    Container(
                        child: Text(
                      contacts[index].phone ?? "",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: click,
    );
  }
}
