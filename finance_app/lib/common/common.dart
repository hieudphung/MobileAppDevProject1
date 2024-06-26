//This is just for sharing common functions.
//

import 'package:flutter/material.dart';

String getMonth(int month) {
    switch (month){
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
        //Only really adding up until June, to replicate as if goes by current month
    }

  return 'None';
}

String getSpendType(int spendType) {
  switch (spendType) {
    case 1:
      return 'Type A';
    case 2:
      return 'Type B';
    case 3:
      return 'Type C';
    case 4:
      return 'Goal Spend';
  }

  return 'None';
}

Icon getSpendIcon(int spendType) {
  switch (spendType) {
    case 1:
      return const Icon(Icons.abc);
    case 2:
      return const Icon(Icons.ac_unit);
    case 3:
      return const Icon(Icons.access_alarm);
    case 4:
      return const Icon(Icons.account_box);
  }

  return const Icon(Icons.skateboarding_outlined);
}