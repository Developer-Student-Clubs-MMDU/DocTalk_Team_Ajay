import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../shared/RowWithIconText.dart';

class UserView extends GetView {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.notifications))
        ],
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              alignment: Alignment.center,
              child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Container(
                          height:25,
                          width: width*0.7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green,
                          ),
                          height:(height*0.20)-25,
                          width: width*0.7,
                          child: const Column(
                            children: [
                              SizedBox(height: 40,),
                              Text("Ajay Kumar",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w700),),
                              Text("Kumarajay.rs3322@gmail.com",style: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white,width: 3),
                      ),
                      child: CircleAvatar(radius: 50,),
                    ),
                  ]
              ),
            ),
            SizedBox(height: 40,),
            const ListTileWithIconText(data: "Settings", prefixIcon: Icons.settings),
            const ListTileWithIconText(data: "Logout", prefixIcon: Icons.logout),
          ],
        ),
      ),
    );
  }
}
