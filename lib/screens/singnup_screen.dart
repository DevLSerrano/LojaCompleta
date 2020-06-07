import 'package:app_loja/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SingnUpScreen extends StatefulWidget {
  @override
  _SingnUpScreenState createState() => _SingnUpScreenState();
}

class _SingnUpScreenState extends State<SingnUpScreen> {
  Map<String, dynamic> userData;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  validator: (text) {
                    if (text.isEmpty) return 'Nome invalido!';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nome',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (text) {
                    if (text.isEmpty || !text.contains('@')) return 'E-mail invalido!';
                    return null;
                    
                  },
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passController,
                  validator: (text) {
                    if (text.isEmpty || text.length < 2)
                      return 'Senha invalida, minimo 6';
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Senha',
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _addressController,
                  validator: (text) {
                    if (text.isEmpty) return 'Endereco invalido';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Endereço',
                  ),
                ),



                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        userData = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'address': _addressController.text,
                        };
                        model.signUp(
                          userData: userData,
                          pass: _passController.text,
                          onSuccesses: _onSuccess,
                          onFail: _onFail,
                        );
                      }
                    },
                    child: Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
   _scaffoldKey.currentState.showSnackBar(
     SnackBar(
       content: Text('User criado com sucesso!'),
       backgroundColor: Theme.of(context).primaryColor,
       duration: Duration(seconds: 2),

     )
   );
   Future.delayed(Duration(seconds:2)).then((_){
     Navigator.of(context).pop();
   });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
     SnackBar(
       content: Text('Erro ao criar user!'),
       backgroundColor: Colors.redAccent,
       duration: Duration(seconds: 2),

     )
   );
  }
}
