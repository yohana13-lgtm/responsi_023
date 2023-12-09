class _MealPageState extends State<MealPage> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['categories'] != null) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(responseData['categories']);
          });
        } else {
          print('Error: No categories found');
        }
      } else {
        print('Error: Failed to fetch data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff80deea),
        title: Text('Meal Categories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Center(
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.cream, // Ganti dengan warna krem yang diinginkan
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(
                  category['strCategory'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  category['strCategoryDescription'] ?? '',
                  textAlign: TextAlign.center,
                ),
                leading: category['strCategoryThumb'] != null
                    ? SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image.network(
                    category['strCategoryThumb'],
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  width: 80.0,
                  height: 80.0,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MealCategoryPage(category: category['strCategory']),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
