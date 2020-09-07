import 'package:flutter/material.dart';
import 'package:shoppingApp/models/products.dart';

class AddEditUserProductsScreen extends StatefulWidget {
  static const routeName = "/add-edit-product";

  @override
  _AddEditUserProductsScreenState createState() =>
      _AddEditUserProductsScreenState();
}

class _AddEditUserProductsScreenState extends State<AddEditUserProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _imageURLcontroller = TextEditingController();
  // 'TextEditingController()' is not necessary in 'Form()'
  // It is used here, because, the 'Container' needs to access the image url before the form is submitted,
  // to show preview

  final _form = GlobalKey<FormState>();
  // 'GlobalKey<>()' is used only when we want to interact with any Widget.
  // Here, we want to interact with 'Form' widget to submit the data filled in the form.
  // It is of generic type.
  // Always slides into the state of the Widget.
  // Interacts with the state behind the 'Form' widget.

  Product _editProduct = Product(
    id: null,
    title: null,
    description: null,
    imageURL: null,
    price: null,
  );

  @override
  void initState() {
    _imageURLFocusNode.addListener(_imagePreview);
    super.initState();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_imagePreview);
    // All created listeners must be removed to avoid memory leak.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLcontroller.dispose();
    // 'FocusNode', 'TextEditingController' must be disposed once used to avoid memory leaks
    super.dispose();
  }

  void _imagePreview() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Title",
                  errorStyle: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1.toString(),
                  ),
                ),
                textInputAction: TextInputAction.next,
                // Shows 'next' icon on the bottom-right of the keyboard
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a title.";
                    // Any text is interpreted as error.
                  }
                  return null;
                  // 'null' is interpreted as no error.
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                  // When the button on the bottom-right corner of the keyboard('->|') is pressed,
                  // the focus changes to the field where the 'focusNode' is '_priceFocusNode'
                  // Here, to the 'Price' field.
                },
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: value,
                    description: _editProduct.description,
                    imageURL: _editProduct.imageURL,
                    price: _editProduct.price,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                textInputAction: TextInputAction.next,
                // Shows 'next' icon on the bottom-right of the keyboard
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: _editProduct.title,
                    description: _editProduct.description,
                    imageURL: _editProduct.imageURL,
                    price: double.parse(value),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                // textInputAction: TextInputAction.next,
                // Shows 'next' icon on the bottom-right of the keyboard
                keyboardType: TextInputType.multiline,
                // Since, the keyboard is of type 'multiline', focus can't be changed to the next field.
                // Keyboard will have new line button, instead of next button.
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editProduct = Product(
                    id: null,
                    title: _editProduct.title,
                    description: value,
                    imageURL: _editProduct.imageURL,
                    price: _editProduct.price,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    child: _imageURLcontroller.text.isEmpty
                        ? Center(
                            child: Text(
                              "No image",
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _imageURLcontroller.text,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // 'TextFormField()' takes as much width as it can and might causes error
                      // (when inside a 'Row()'/'Widgets with no height/width handlers') if not handled.
                      // Here, 'Expanded()' does the job.
                      decoration: InputDecoration(
                        labelText: "Image URL",
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageURLcontroller,
                      focusNode: _imageURLFocusNode,
                      onFieldSubmitted: (value) => _saveForm,
                      onSaved: (value) {
                        _editProduct = Product(
                          id: null,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          imageURL: value,
                          price: _editProduct.price,
                        );
                      },
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
