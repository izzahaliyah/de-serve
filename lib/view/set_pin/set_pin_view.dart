import 'package:flutter/material.dart';
import 'set_pin_presenter.dart';

class SetPinView extends StatefulWidget {
  @override
  _SetPinViewState createState() => _SetPinViewState();
}

class _SetPinViewState extends State<SetPinView> implements SetPinViewContract {
  final TextEditingController _pinController = TextEditingController();
  late SetPinPresenter _presenter;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _presenter = SetPinPresenter(this);
  }

  void _onSubmitPin() {
    final pin = _pinController.text.trim();
    if (pin.length > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a 6 digit PIN')),
      );
      return;
    }

    setState(() => _isSaving = true);
    _presenter.savePin(pin);
  }

  @override
  void onPinSaved() {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PIN saved successfully!')),
    );
    // Navigate to home or dashboard
    Navigator.pushReplacementNamed(context, '/profileCompletion');
  }

  @override
  void onError(String message) {
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Your PIN')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Enter a 6 digit PIN',
                counterText: '',
              ),
            ),
            SizedBox(height: 20),
            _isSaving
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _onSubmitPin,
                    child: Text('Save PIN'),
                  ),
          ],
        ),
      ),
    );
  }
}
