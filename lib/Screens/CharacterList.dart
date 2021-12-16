import 'dart:convert';
import 'package:flutter_assignment/Model/getCharacterModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";


class CharacterListWidget extends StatefulWidget {
  const CharacterListWidget({
    Key? key,
  }) : super(key: key);

  @override
  _CharacterListWidgetState createState() =>
      _CharacterListWidgetState();
}

class _CharacterListWidgetState
    extends State<CharacterListWidget> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isError = ValueNotifier(false);
  List<Results> _characterLists=[];


  @override
  void initState() {
    super.initState();
    getCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) => isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : child!,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isError,
        builder: (context, hasError, child) => hasError
            ? const Center(
          child: Text(
            'Something went Wrong..!!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterDetailsWidget(
                    RickNMortyCharacter: _characterLists[index],
                  ),
                )),
            child: SingleChildScrollView(

              child: Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        _characterLists[index].image!,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_characterLists[index].name!,style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),),
                          Row(
                            children: [
                              Text(
                                'Location :  ',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                width:MediaQuery.of(context).size.width*0.5,
                                child: Text(_characterLists[index].origin!.name!,
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),


                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Species : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _characterLists[index].species!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          itemCount: _characterLists.length,
        ),
      ),
    );
  }

  Future<void> getCharacter() async
  {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var url = Uri.parse('https://rickandmortyapi.com/api/character/?page=1');
    var response = await http.get(url,headers: headers);
    var jsonResponse = json.decode(response.body);
    getCharacterModel getCharacter = new getCharacterModel.fromJson(jsonResponse);
    if (response.statusCode == 200) {
      print("jsonResponse" + jsonResponse.toString());
      setState(() {
        _characterLists=getCharacter.results!;

      });

    } else {

    }
  }
}

class CharacterDetailsWidget extends StatelessWidget {

  final Results RickNMortyCharacter;
  const CharacterDetailsWidget({
    Key? key,
    required this.RickNMortyCharacter,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RickNMortyCharacter.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(RickNMortyCharacter.image!),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Status ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  RickNMortyCharacter.status!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  'Gender ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  RickNMortyCharacter.gender!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  'Species ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  RickNMortyCharacter.species!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  'location ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  RickNMortyCharacter.location!.name!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Divider(),
            // Row(
            //   children: [
            //     const Text(
            //       'Dimension ',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text(
            //       RickNMortyCharacter.dimension,
            //       style: const TextStyle(
            //         fontSize: 16,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }



}