

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'pref_model.g.dart';

/// Model Utilisateur preference

@HiveType(typeId: 0)
class ProfilPreferenceModel extends HiveObject{

  @HiveField(0)
  bool walk = false;

  ProfilPreferenceModel({
    required this.walk,
  });

}



