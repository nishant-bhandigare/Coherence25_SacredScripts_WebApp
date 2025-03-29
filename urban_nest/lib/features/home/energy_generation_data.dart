Map<String, Map<String, double>> processData() {
  final jsonData = [
    {
      "ID": "270",
      "Month": "Oct-2024",
      "fy": "2024-2025",
      "mode": "HYDRO",
      "Region_State": "All India",
      "bus": "14.45588"
    },
    {
      "ID": "269",
      "Month": "Oct-2024",
      "fy": "2024-2025",
      "mode": "NUCLEAR",
      "Region_State": "All India",
      "bus": "4.76892"
    },
    {
      "ID": "268",
      "Month": "Oct-2024",
      "fy": "2024-2025",
      "mode": "THERMAL",
      "Region_State": "All India",
      "bus": "114.10172"
    },
    {
      "ID": "272",
      "Month": "Nov-2024",
      "fy": "2024-2025",
      "mode": "THERMAL",
      "Region_State": "All India",
      "bus": "104.23142"
    },
    {
      "ID": "273",
      "Month": "Nov-2024",
      "fy": "2024-2025",
      "mode": "NUCLEAR",
      "Region_State": "All India",
      "bus": "4.80977"
    },
    {
      "ID": "274",
      "Month": "Nov-2024",
      "fy": "2024-2025",
      "mode": "HYDRO",
      "Region_State": "All India",
      "bus": "8.630889999999999"
    },
    {
      "ID": "275",
      "Month": "Nov-2024",
      "fy": "2024-2025",
      "mode": "BHUTAN IMP",
      "Region_State": "All India",
      "bus": "0.1284"
    },
    {
      "ID": "279",
      "Month": "Dec-2024",
      "fy": "2024-2025",
      "mode": "BHUTAN IMP",
      "Region_State": "All India",
      "bus": "0.0246"
    },
    {
      "ID": "278",
      "Month": "Dec-2024",
      "fy": "2024-2025",
      "mode": "HYDRO",
      "Region_State": "All India",
      "bus": "7.753430000000001"
    },
    {
      "ID": "277",
      "Month": "Dec-2024",
      "fy": "2024-2025",
      "mode": "NUCLEAR",
      "Region_State": "All India",
      "bus": "5.1247"
    },
    {
      "ID": "276",
      "Month": "Dec-2024",
      "fy": "2024-2025",
      "mode": "THERMAL",
      "Region_State": "All India",
      "bus": "108.24152"
    },
    {
      "ID": "283",
      "Month": "Jan-2025",
      "fy": "2024-2025",
      "mode": "BHUTAN IMP",
      "Region_State": "All India",
      "bus": "0.05795"
    },
    {
      "ID": "282",
      "Month": "Jan-2025",
      "fy": "2024-2025",
      "mode": "HYDRO",
      "Region_State": "All India",
      "bus": "7.38805"
    },
    {
      "ID": "281",
      "Month": "Jan-2025",
      "fy": "2024-2025",
      "mode": "NUCLEAR",
      "Region_State": "All India",
      "bus": "4.77841"
    },
    {
      "ID": "280",
      "Month": "Jan-2025",
      "fy": "2024-2025",
      "mode": "THERMAL",
      "Region_State": "All India",
      "bus": "114.11224"
    },
    {
      "ID": "284",
      "Month": "Feb-2025",
      "fy": "2024-2025",
      "mode": "THERMAL",
      "Region_State": "All India",
      "bus": "110.40015"
    },
    {
      "ID": "285",
      "Month": "Feb-2025",
      "fy": "2024-2025",
      "mode": "NUCLEAR",
      "Region_State": "All India",
      "bus": "4.15334"
    },
    {
      "ID": "286",
      "Month": "Feb-2025",
      "fy": "2024-2025",
      "mode": "HYDRO",
      "Region_State": "All India",
      "bus": "6.970890000000001"
    },
    {
      "ID": "287",
      "Month": "Feb-2025",
      "fy": "2024-2025",
      "mode": "BHUTAN IMP",
      "Region_State": "All India",
      "bus": "0.07063"
    }
  ];

  // Initialize result structure
  Map<String, Map<String, double>> result = {
    'THERMAL': {},
    'HYDRO': {},
    'NUCLEAR': {},
    'BHUTAN IMP': {},
  };

  // Process data
  for (var item in jsonData) {
    final month = item['Month'] as String;
    final mode = item['mode'] as String;
    final busValue = double.parse(item['bus'] as String);

    if (result.containsKey(mode)) {
      result[mode]![month] = busValue;
    }
  }

  return result;
}