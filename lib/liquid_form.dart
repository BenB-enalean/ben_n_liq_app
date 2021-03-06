import 'package:ben_n_liq_app/liquid.dart';
import 'package:flutter/material.dart';

class LiquidForm extends StatefulWidget {
  final Liquid _liquid;

  LiquidForm([this._liquid]);

  @override
  _LiquidFormState createState() => _LiquidFormState();
}

class _LiquidFormState extends State<LiquidForm> {
  TextEditingController _controllerName;
  TextEditingController _controllerBrand;
  TextEditingController _controllerQuantityPerBottle;
  TextEditingController _controllerBottle;
  TextEditingController _controllerPrice;

  bool _nameValidator = false;
  bool _quantityPerBottleValidator = false;
  bool _bottleValidator = false;
  bool _priceValidator = false;

  FocusNode _nameFocus = FocusNode();
  FocusNode _quantityPerBottleFocus = FocusNode();
  FocusNode _bottleFocus = FocusNode();
  FocusNode _brandFocus = FocusNode();
  FocusNode _priceFocus = FocusNode();

  @override
  initState() {
    super.initState();
    _controllerName = TextEditingController();
    _controllerBrand = TextEditingController();
    _controllerQuantityPerBottle = TextEditingController();
    _controllerBottle = TextEditingController();
    _controllerPrice = TextEditingController();
    if (widget._liquid != null) {
      print(widget._liquid.remainingQuantity);
      _controllerName.text = widget._liquid.name;
      _controllerBrand.text = widget._liquid.brand;
      _controllerQuantityPerBottle.text = widget._liquid.remainingQuantity.toString();
      _controllerBottle.text = widget._liquid.bottle.toString();
      _controllerPrice.text = widget._liquid.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        reverse: true,
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              _buildNameField(),
              _buildBrandField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: _buildQuantityPerBottleField()),
                  Expanded(child: _buildQuantityBottleField())
                ],
              ),
              _buildPriceField(),
              _buildButton(),
            ],
          ),
        ));
  }

  TextFormField _buildNameField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Nom :"),
      controller: _controllerName,
      autovalidate: true,
      focusNode: _nameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _nameFocus, _brandFocus);
      },
      validator: (String txt) {
        if (txt.isNotEmpty) {
          _nameValidator = true;
          return null;
        }
        return "Il faut un nom.";
      },
    );
  }

  TextFormField _buildBrandField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Marque :"),
      controller: _controllerBrand,
      autovalidate: true,
      focusNode: _brandFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _brandFocus, _quantityPerBottleFocus);
      },
      validator: (String txt) {
        if (txt.isNotEmpty) {
          return null;
        }
        return "Par défaut : A&L.";
      },
    );
  }

  TextFormField _buildQuantityPerBottleField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Quantité :"),
      controller: _controllerQuantityPerBottle,
      autovalidate: true,
      focusNode: _quantityPerBottleFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _quantityPerBottleFocus, _bottleFocus);
      },
      keyboardType: TextInputType.number,
      validator: (String txt) {
        if (int.tryParse(txt) != null) {
          _quantityPerBottleValidator = true;
          return null;
        }
        return "Il faut un nombre.";
      },
    );
  }

  TextFormField _buildQuantityBottleField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Flacon(s) :"),
      controller: _controllerBottle,
      autovalidate: true,
      focusNode: _bottleFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _bottleFocus, _priceFocus);
      },
      keyboardType: TextInputType.number,
      validator: (String txt) {
        if (txt != "" && int.tryParse(txt) != null) {
          _bottleValidator = true;
          return null;
        }
        if (txt == "") {
          _bottleValidator = true;
          return "Par défaut : 1.";
        }
        return "Il faut un nombre.";
      },
    );
  }

  TextFormField _buildPriceField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Prix d'un flacon :"),
      controller: _controllerPrice,
      autovalidate: true,
      focusNode: _priceFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        _priceFocus.unfocus();
        _onSubmittedForm();
      },
      keyboardType: TextInputType.number,
      validator: (String txt) {
        if (double.tryParse(txt) != null ||
            double.tryParse(txt.replaceAll(',', '.')) != null) {
          _priceValidator = true;
          return null;
        }
        return "Il faut un nombre.";
      },
    );
  }

  Container _buildButton() {
    return Container(
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        child: Text(
          widget._liquid != null ? 'Modifer' : "Créer un liquide",
          style: Theme.of(context).textTheme.button,
        ),
        padding: EdgeInsets.all(10),
        color: Theme.of(context).buttonColor,
        disabledColor: Colors.black,
        onPressed: () {
          _onSubmittedForm();
        },
      ),
    );
  }

  void _onSubmittedForm() {
    if (_nameValidator &&
        _quantityPerBottleValidator &&
        _priceValidator &&
        _bottleValidator) {
      int quantity = int.tryParse(_controllerQuantityPerBottle.text);
      double priceParse = double.tryParse(_controllerPrice.text);
      double goodPrice = priceParse != null
          ? priceParse
          : double.tryParse(_controllerPrice.text.replaceAll(',', '.'));
      if (_controllerBrand.text == "") _controllerBrand.text = "A&L";

      if (_controllerBottle.text == "") _controllerBottle.text = "1";

      int quantityBottle = int.tryParse(_controllerBottle.text);

      Liquid liquid = Liquid(_controllerName.text, _controllerBrand.text,
          quantity, 0, goodPrice, quantityBottle, quantity);

      setState(() {
        _controllerName.clear();
        _controllerBrand.clear();
        _controllerQuantityPerBottle.clear();
        _controllerBottle.clear();
        _controllerPrice.clear();
      });
      Navigator.pop(context, liquid);
    }
  }

  AppBar buildAppBar() {
    if (widget._liquid != null) {
      return AppBar(
        title: Text("Modifier un liquide",
            style: Theme.of(context).appBarTheme.textTheme.title),
      );
    }
    return AppBar(
      title: Text("Ajouter un liquide",
          style: Theme.of(context).appBarTheme.textTheme.title),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
