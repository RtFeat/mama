import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'profile_view.g.dart';

class ProfileViewStore extends _ProfileViewStore with _$ProfileViewStore {
  ProfileViewStore({
    required super.model,
    required super.restClient,
  });
}

abstract class _ProfileViewStore with Store {
  final AccountModel model;
  final RestClient restClient;

  _ProfileViewStore({
    required this.model,
    required this.restClient,
  });

  late final FormGroup formGroup;

  void init() {
    formGroup = FormGroup({
      'name': FormControl<String>(
        value: '${model.firstName} ${model.secondName}',
        validators: [Validators.required],
      ),
      'phone': FormControl<String>(
        value: model.phone,
        validators: [Validators.required],
      ),
      'profession': FormControl<String>(
        value: model.profession,
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        value: model.email,
        validators: [Validators.required],
      ),
      'about': FormControl<String>(
        value: model.info,
      ),
    });
  }

  AbstractControl get name => formGroup.control('name');

  bool get isNameValid => name.valid;

  AbstractControl get profession => formGroup.control('profession');

  bool get isProfessionValid => profession.valid;

  AbstractControl get phone => formGroup.control('phone');

  bool get isPhoneValid => phone.valid;

  AbstractControl get email => formGroup.control('email');

  bool get isEmailValid => email.valid;

  AbstractControl get about => formGroup.control('about');

  bool get isAboutValid => about.valid;

  void updateData() {
    if (isNameValid && name.value != '${model.firstName} ${model.secondName}') {
      final List<String> nameValue = (name.value as String).split(' ');

      model.setFirstName(nameValue[0]);
      model.setSecondName(nameValue[1]);
    }

    if (isProfessionValid && profession.value != model.profession) {
      model.setProfession(profession.value);
    }

    if (isPhoneValid && phone.value != model.phone) {
      model.setPhone(phone.value);
    }

    if (isEmailValid && email.value != model.email) {
      model.setEmail(email.value);
    }

    if (isAboutValid && about.value != model.info) {
      model.setInfo(about.value);
    }
  }

  void dispose() {
    formGroup.dispose();
  }

  Future sendFeedback(String text) async {
    restClient
        .post('${Endpoint.feedback}/', body: {
          'text': text,
        })
        .then((value) {})
        .catchError((error) {});
  }
}
