import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/core/color.dart';
import 'package:shop_app/providers/Product.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Products_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/teanslations/locale_Keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class EditeProductsScreen extends StatefulWidget {
  static const routename = "/Edite-products-Screen";

  @override
  State<EditeProductsScreen> createState() => _EditeProductsScreenState();
}

class _EditeProductsScreenState extends State<EditeProductsScreen> {
  final _pricefocusnode = FocusNode();
  final _Ddescrirptionfocusnode = FocusNode();
  final _Conditionfocusnode = FocusNode();

  String? _Catigory;

  int? categoryid = 0;
  bool edting = false;

  final _form = GlobalKey<FormState>();

  bool _isinit = true;
  bool _isloading = false;
  bool hasimage = false;

  File? _storedImage;
  final ImagePicker picker = ImagePicker();

  var _initvalue = {
    "title": '',
    'Description': '',
    'condition': '',
    "categoryid": '',
    'Price': '',
    'imageUrl': ''
  };

  var _editedPropduct = Product(
      id: "",
      title: "",
      description: "",
      imageUrl: "",
      condition: '',
      categoryId: '',
      price: 0);

  Future<void> _takePicture() async {
    final imgeFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    print("tototo1");

    if (imgeFile == null) {
      print("no image");
      return;
    }
    setState(() {
      _storedImage = File(imgeFile.path);
      hasimage = false ;
    });
    _editedPropduct = Product(
      id: _editedPropduct.id,
      isFavorite: _editedPropduct.isFavorite,
      title: _editedPropduct.title,
      description: _editedPropduct.description,
      condition: _editedPropduct.condition,
      categoryId: _editedPropduct.categoryId.toString(),
      imageUrl: _storedImage!.path,
      price: _editedPropduct.price,
    );
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final prodId = ModalRoute.of(context)!.settings.arguments as String?;
      if (prodId != null) {
        _editedPropduct = Provider.of<Products>(context).FindById(prodId);
        setState(() {
          edting = true;
          categoryid =int.parse(_editedPropduct.categoryId.toString());
        });
        if (_editedPropduct.categoryId == "1") {
          _Catigory = "Clothes";
        }
        if (_editedPropduct.categoryId == "2") {
          _Catigory = "Tool";
        }
        if (_editedPropduct.categoryId == "3") {
          _Catigory = 'Kitchen Utility';
        }
        if (_editedPropduct.categoryId == "4") {
          _Catigory = "Furniture";
        }



        print(_editedPropduct.categoryId);
        print(_editedPropduct.condition);
        print(_editedPropduct.description);
        print(_editedPropduct.price);
        print(_editedPropduct.title);
        print(_editedPropduct.imageUrl);
        print(_editedPropduct.id);
        if (_editedPropduct.imageUrl != null) {
          setState(() {
            hasimage = true;
          });
          _initvalue = {
            "title": _editedPropduct.title,
            'Description': _editedPropduct.description,
            'Price': _editedPropduct.price.toString(),
            'condition': _editedPropduct.condition.toString(),
            "categoryid": _editedPropduct.categoryId.toString(),
            'imageUrl': _editedPropduct.imageUrl,
          };
        }
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    _pricefocusnode.dispose();
    _Ddescrirptionfocusnode.dispose();
    _Conditionfocusnode.dispose();

    super.dispose();
  }



  Future<void> _saveForm() async {
    print("pressed");
    setState(() {
      _isloading = true;
    });
    final isValid = _form.currentState!.validate();

    if (!isValid||
        _editedPropduct.categoryId == "" ||
        _editedPropduct.imageUrl == "") {
      setState(() {
        _isloading = false;
      });
      return;
    }
    _form.currentState?.save();
    print(_editedPropduct.categoryId);
    print(_editedPropduct.condition);
    print(_editedPropduct.description);
    print(_editedPropduct.price);
    print(_editedPropduct.title);
    print(_editedPropduct.imageUrl);
    print(_editedPropduct.id);
    if (_editedPropduct.id != '') {
      print("edit");

      await Provider.of<Products>(context, listen: false)
           .Updateprdocut(_editedPropduct.id, _editedPropduct , !hasimage);

    } else {
      try {
        print("Add");
        await Provider.of<Products>(context, listen: false)
            .AddProduct(_editedPropduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(LocaleKeys.anerroraccured.tr()),
                  content: Text('Somthing went wrong. '),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(LocaleKeys.ok.tr())),
                  ],
                ));
      }
      // finally{
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.editeproducttitle.tr()),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save_alt_outlined))
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: _initvalue['title'],
                      decoration: InputDecoration(
                        labelText: LocaleKeys.title.tr(),

                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocusnode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.tilterror.tr();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPropduct = Product(
                            id: _editedPropduct.id,
                            isFavorite: _editedPropduct.isFavorite,
                            title: value.toString(),
                            description: _editedPropduct.description,
                            condition: _editedPropduct.condition,
                            categoryId: _editedPropduct.categoryId,
                            imageUrl: _editedPropduct.imageUrl,
                            price: _editedPropduct.price);
                      },
                      style: TextStyle(
                        color: whiteText,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: whiteText,
                      ),
                      initialValue: _initvalue['Price'],
                      decoration: InputDecoration(
                        labelText: LocaleKeys.price.tr(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_Conditionfocusnode);
                      },
                      focusNode: _pricefocusnode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.priceerror1.tr();
                        }
                        if (double.tryParse(value) == null) {
                          return LocaleKeys.priceerror2.tr();
                        }
                        if (double.parse(value) <= 0) {
                          return LocaleKeys.priceerror3.tr();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPropduct = Product(
                            id: _editedPropduct.id,
                            isFavorite: _editedPropduct.isFavorite,
                            title: _editedPropduct.title,
                            condition: _editedPropduct.condition,
                            categoryId: _editedPropduct.categoryId,
                            description: _editedPropduct.description,
                            imageUrl: _editedPropduct.imageUrl,
                            price: double.parse(value.toString()));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: whiteText,
                      ),
                      initialValue: _initvalue['condition'],
                      decoration: InputDecoration(
                        labelText: LocaleKeys.condition.tr(),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_Ddescrirptionfocusnode);
                      },
                      focusNode: _Conditionfocusnode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.conerror.tr();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPropduct = Product(
                            id: _editedPropduct.id,
                            isFavorite: _editedPropduct.isFavorite,
                            title: _editedPropduct.title,
                            description: _editedPropduct.description,
                            condition: value.toString(),
                            categoryId: _editedPropduct.categoryId,
                            imageUrl: _editedPropduct.imageUrl,
                            price: _editedPropduct.price);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: whiteText,
                      ),
                      initialValue: _initvalue['Description'],
                      decoration: InputDecoration(
                        labelText: LocaleKeys.description.tr(),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _Ddescrirptionfocusnode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return LocaleKeys.descerror1.tr();
                        }
                        if (value.length <= 10) {
                          return LocaleKeys.descerror2.tr();
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedPropduct = Product(
                            id: _editedPropduct.id,
                            isFavorite: _editedPropduct.isFavorite,
                            title: _editedPropduct.title,
                            description: value.toString(),
                            condition: _editedPropduct.condition,
                            categoryId: _editedPropduct.categoryId,
                            imageUrl: _editedPropduct.imageUrl,
                            price: _editedPropduct.price);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          color: Theme.of(context).accentColor.withOpacity(0.2),
                          child: Text(
                            LocaleKeys.categorytitle.tr(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        DropdownButton(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 10,
                          iconSize: 30,
                          value: _Catigory,
                          hint: Text(LocaleKeys.categoryhint.tr()),
                          items: [
                            DropdownMenuItem(
                              child: Text(LocaleKeys.clothes.tr()),
                              value: "Clothes",
                            ),
                            DropdownMenuItem(
                              child: Text(LocaleKeys.kitchenUtilities.tr()),
                              value: 'Kitchen Utility',
                            ),
                            DropdownMenuItem(
                              child: Text(LocaleKeys.furniture.tr()),
                              value: 'Furniture',
                            ),
                            DropdownMenuItem(
                              child: Text(LocaleKeys.tools.tr()),
                              value: 'Tool',
                            ),
                          ],
                          onChanged: (value) {
                            print(value.toString());
                            setState(() {
                              _Catigory = value.toString();
                              if (_Catigory == "Clothes") {
                                categoryid = 1;
                              }
                              if (_Catigory == 'Kitchen Utility') {
                                categoryid = 3;
                              }
                              if (_Catigory == "Furniture") {
                                categoryid = 4;
                              }
                              if (_Catigory == "Tool") {
                                categoryid = 2;
                              }
                            });
                            _editedPropduct = Product(
                                id: _editedPropduct.id,
                                isFavorite: _editedPropduct.isFavorite,
                                title: _editedPropduct.title,
                                description: _editedPropduct.description,
                                condition: _editedPropduct.condition,
                                categoryId: categoryid.toString()=="0"?_editedPropduct.categoryId : categoryid.toString(),
                                imageUrl: _editedPropduct.imageUrl,
                                price: _editedPropduct.price);
                          },
                          isExpanded: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                   Row(
                            children: [
                              Container(
                                height: 150,
                                width: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5, color: Colors.grey)),
                                child: hasimage
                                    ? Image.network(
                                        _editedPropduct.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : _storedImage != null
                                        ? Image.file(
                                            _storedImage!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Center(
                                            child: Text(
                                            LocaleKeys.noimage.tr(),
                                            textAlign: TextAlign.center,
                                          )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: _takePicture,
                                  label: Text(
                                    LocaleKeys.takeimage.tr(),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  icon: Icon(Icons.camera_alt_outlined),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
