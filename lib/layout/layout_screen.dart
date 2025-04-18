import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _navBarAnimation;
  late int _currentIndex = 0;
  bool _showAllProducts = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Product data with all required fields
  final List<Map<String, dynamic>> allFruits = [
    {
      "name": "Strawberry",
      "price": 2.5,
      "unit": "kg",
      "color": Colors.red[100],
      "image": "assets/icons/strawberry.png",
      "rating": 4.8,
      "description": "Fresh organic strawberries",
      "isFavorite": false,
    },
    {
      "name": "Watermelon",
      "price": 1.8,
      "unit": "kg",
      "color": Colors.green[100],
      "image": "assets/icons/watermelon.png",
      "rating": 4.5,
      "description": "Juicy seedless watermelon",
      "isFavorite": true,
    },
    {
      "name": "Mango",
      "price": 3.5,
      "unit": "kg",
      "color": Colors.orange[100],
      "image": "assets/icons/mango.png",
      "rating": 4.9,
      "description": "Sweet Alphonso mangoes",
      "isFavorite": false,
    },
    {
      "name": "Pineapple",
      "price": 2.9,
      "unit": "kg",
      "color": Colors.yellow[100],
      "image": "assets/icons/pineapple.png",
      "rating": 4.3,
      "description": "Tropical golden pineapples",
      "isFavorite": false,
    },
    {
      "name": "Apple",
      "price": 1.5,
      "unit": "kg",
      "color": Colors.red[200],
      "image": "assets/icons/apple.png",
      "rating": 4.7,
      "description": "Crisp red apples",
      "isFavorite": true,
    },
    {
      "name": "Banana",
      "price": 0.8,
      "unit": "kg",
      "color": Colors.yellow[200],
      "image": "assets/icons/banana.png",
      "rating": 4.2,
      "description": "Ripe organic bananas",
      "isFavorite": false,
    },
    {
      "name": "Grapes",
      "price": 3.2,
      "unit": "kg",
      "color": Colors.purple[100],
      "image": "assets/icons/grapes.png",
      "rating": 4.6,
      "description": "Sweet black grapes",
      "isFavorite": false,
    },
    {
      "name": "Orange",
      "price": 1.2,
      "unit": "kg",
      "color": Colors.orange[200],
      "image": "assets/icons/orange.png",
      "rating": 4.4,
      "description": "Juicy Valencia oranges",
      "isFavorite": false,
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutQuad),
      ),
    );

    _navBarAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: [Colors.green[400]!, Colors.green[600]!],
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      const SizedBox(height: kToolbarHeight),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Morning",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Ahmed Mostafa",
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/300',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: const Badge(
                    smallSize: 8,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.notifications_none, color: Colors.black),
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildSearchBar(theme),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildPromoBanner(screenWidth),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Best Sellers',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.sort, color: Colors.grey[600]),
                            onSelected: (value) {
                              _sortProducts(value);
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: 'price_low',
                                  child: Text('Price: Low to High'),
                                ),
                                const PopupMenuItem(
                                  value: 'price_high',
                                  child: Text('Price: High to Low'),
                                ),
                                const PopupMenuItem(
                                  value: 'rating',
                                  child: Text('Top Rated'),
                                ),
                                const PopupMenuItem(
                                  value: 'name',
                                  child: Text('Alphabetical'),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ]),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _showAllProducts && screenWidth > 600 ? 3 : 2,
                  mainAxisExtent: 250,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildAnimatedProductCard(index),
                  childCount: _showAllProducts ? allFruits.length : 4,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                child:
                    _showAllProducts
                        ? const SizedBox()
                        : Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _showAllProducts = true;
                              });
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Text(
                              'View All Products',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green[600],
          elevation: 4,
          child: const Icon(Icons.shopping_basket, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: AnimatedBuilder(
        animation: _navBarAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * _navBarAnimation.value),
            child: Opacity(opacity: 1 - _navBarAnimation.value, child: child),
          );
        },
        child: _buildBottomNavBar(),
      ),
    );
  }

  void _sortProducts(String value) {
    setState(() {
      switch (value) {
        case 'price_low':
          allFruits.sort(
            (a, b) => (a['price'] as double).compareTo(b['price'] as double),
          );
          break;
        case 'price_high':
          allFruits.sort(
            (a, b) => (b['price'] as double).compareTo(a['price'] as double),
          );
          break;
        case 'rating':
          allFruits.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
          );
          break;
        case 'name':
          allFruits.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String),
          );
          break;
      }
    });
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search for fruits...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[500],
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
      onChanged: (value) {},
    );
  }

  Widget _buildPromoBanner(double screenWidth) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[400]!, Colors.orange[600]!],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summer Special',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const Text(
                    '25% OFF',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'On all tropical fruits',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () {},
                child: const Text('Shop Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProductCard(int index) {
    final fruit = allFruits[index];
    final totalItems = _showAllProducts ? allFruits.length : 4;
    final start =
        0.4 + (0.5 * index / totalItems); // Distribute animations evenly

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0.5 + (0.1 * index)),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                start.clamp(0.0, 0.9), // Ensure begin is <= end
                (start + 0.1).clamp(0.1, 1.0), // Ensure end is <= 1.0
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  start.clamp(0.0, 0.9),
                  (start + 0.1).clamp(0.1, 1.0),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            child: child,
          ),
        );
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showProductDetails(context, fruit);
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: fruit['color'] as Color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'fruit-${fruit['name']}',
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Center(child: Text('Image')),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  fruit['isFavorite'] =
                                      !(fruit['isFavorite'] as bool);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  fruit['isFavorite'] as bool
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      fruit['isFavorite'] as bool
                                          ? Colors.red
                                          : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fruit['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (fruit['rating'] as double).toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${fruit['price']}/${fruit['unit']}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ScaleTransition(
                                scale: Tween<double>(begin: 0, end: 1).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Interval(
                                      0.6 + (0.1 * index),
                                      1.0,
                                      curve: Curves.elasticOut,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    _addToCartAnimation(context, index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addToCartAnimation(BuildContext context, int index) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx + renderBox.size.width - 30,
            top: position.dy + renderBox.size.height - 30,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animationController,
                  curve: Curves.fastOutSlowIn,
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 500), () {
      overlayEntry.remove();
      animationController.dispose();
    });
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Hero(
                tag: 'fruit-${product['name']}',
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: product['color'] as Color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(child: Text('Product Image')),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['name'] as String,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              product['isFavorite'] as bool
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  product['isFavorite'] as bool
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                product['isFavorite'] =
                                    !(product['isFavorite'] as bool);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            (product['rating'] as double).toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${product['price']}/${product['unit']}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product['description'] as String,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 1
                          ? Colors.green.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite_border),
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 2
                          ? Colors.green.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Badge(
                  label: Text('3'),
                  backgroundColor: Colors.red,
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      _currentIndex == 3
                          ? Colors.green.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
