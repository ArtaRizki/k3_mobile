import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/http_request_client.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_shared_preference_key.dart';
import 'package:k3_mobile/const/app_snackbar.dart';
import 'package:k3_mobile/src/login/model/login_model.dart';
import 'package:k3_mobile/src/register/model/agency_select_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  var req = HttpRequestClient();
  var loginModel = LoginModel().obs;
  var loading = false.obs;
  var isValidated = false.obs;

  final nidC = TextEditingController().obs,
      nameC = TextEditingController().obs,
      occupationC = TextEditingController().obs,
      agencyC = TextEditingController().obs,
      emailC = TextEditingController().obs,
      passwordC = TextEditingController().obs,
      confirmationPasswordC = TextEditingController().obs,
      searchAgencyC = TextEditingController().obs;

  final passwordVisible = false.obs, confirmationNewPassVisible = false.obs;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    getData();
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppSharedPreferenceKey.kSetPrefLoginModel);
    if (data != null) {
      loginModel.value = LoginModel.fromJson(jsonDecode(data));
      final user = loginModel.value.data;
      update();
    }
  }

  bool validate() {
    if (nidC.value.text.isEmpty) return false;
    if (nameC.value.text.isEmpty) return false;
    if (occupationC.value.text.isEmpty) return false;
    if (agencyC.value.text.isEmpty) return false;
    if (emailC.value.text.isEmpty) return false;
    if (passwordC.value.text.isEmpty) return false;
    if (confirmationPasswordC.value.text.isEmpty) return false;
    if (passwordC.value.text != confirmationPasswordC.value.text) return false;
    return true;
  }

  validateForm() {
    isValidated.value = validate();
    log("IS VALIDATED : ${isValidated.value}");
    update();
  }

  var filteredAgencySelectList = <AgencySelectModelData?>[].obs;
  var agencySelectList = <AgencySelectModelData?>[].obs;
  var selectedAgency = Rx<AgencySelectModelData?>(null);

  void clearSearchAgencyField() {
    searchAgencyC.value.clear();
    update();
  }

  void _onSearchAgencyChanged() {
    String query = searchAgencyC.value.text.toLowerCase();
    log("QUERY : $query");
    if (query.isEmpty) {
      filteredAgencySelectList.assignAll(agencySelectList);
    } else {
      filteredAgencySelectList.assignAll(
        agencySelectList.where((agency) {
          return (agency?.name ?? '').toLowerCase().contains(query) ||
              (agency?.code ?? '').toLowerCase().contains(query) ||
              (agency?.address ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }
    update();
    refresh();
  }

  Future<void> getData() async {
    if (!loading.value) {
      loading(true);
      final response = await req.get('/get-data-instansi');
      if (response.statusCode == 200) {
        final agencies = AgencySelectModel.fromJson(jsonDecode(response.body));
        loading(false);
        final list = agencies.data ?? [];
        agencySelectList.value = list;
        filteredAgencySelectList.assignAll(agencies.data ?? []);
        searchAgencyC.value.addListener(_onSearchAgencyChanged);
        update();
      } else {
        final msg = jsonDecode(response.body)['message'];
        if (msg == '') AppSnackbar.showSnackBar(Get.context!, msg, true);
      }
    }
  }

  Future<void> sendRegister() async {
    loading(true);
    final response = await req.post(
      '/register-user',
      body: {
        'nid': nidC.value.text,
        'name': nameC.value.text,
        'jabatan': occupationC.value.text,
        'instansi': selectedAgency.value?.id ?? '',
        'email': emailC.value.text,
        'password': passwordC.value.text,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      update();
      loading(false);
      Get.back();
      final map = jsonDecode(response.body);
      Utils.showSuccess(msg: map["message"]);
    } else {
      final mapError = jsonDecode(response.body);
      final message = mapError["message"] + '' + mapError["error"];
      AppSnackbar.showSnackBar(Get.context!, message, true);
      loading(false);
      throw Exception(message);
    }
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
