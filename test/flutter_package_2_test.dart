import 'dart:io';
import 'package:flutter/material.dart';

// main() 函数作为应用程序的入口
void main() {
  // 打印简单的问候语
  print('Hello, World!');

  // 用 var 来定义变量
  var name = 'Voyager I';
  var year = 1977;
  var antennaDiameter = 3.7;
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  var image = {
    'tags': ['saturn'],
    'url': '//path/to/saturn.jpg'
  };

  // 流程控制语句
  debugPrint(name);
  if (year >= 2001) {
    debugPrint('21st century');
  } else if (year >= 1901) {
    debugPrint('20th century');
  }
  for (final object in flybyObjects) {
    debugPrint(object);
  }
  for (int month = 1; month <= 12; month++) {
    print(month);
  }
  while (year < 2016) {
    year += 1;
  }

  // 调用函数
  var result = fibonacci(20);
  print('Fibonacci(20): $result');

  // 定义匿名函数
  flybyObjects.where((name) => name.contains('turn')).forEach(print);

  // 使用 Spacecraft 类
  var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
  voyager.describe();
  var voyager3 = Spacecraft.unlaunched('Voyager III');
  voyager3.describe();

  // 使用 Planet 枚举
  final yourPlanet = Planet.earth;
  if (!yourPlanet.isGiant) {
    print('Your planet is not a "giant planet".');
  }

  // 启动 Flutter 应用
  runApp(MyApp());
}

// 函数定义
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// 定义类
class Spacecraft {
  String name;
  DateTime? launchDate;

  // 只读非最终属性
  int? get launchYear => launchDate?.year;

  // 构造函数
  Spacecraft(this.name, this.launchDate);

  // 命名构造函数，转发到默认构造函数
  Spacecraft.unlaunched(String name) : this(name, null);

  // 方法
  void describe() {
    print('Spacecraft: $name');
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}

// 定义枚举类型 (Enum)
enum PlanetType { terrestrial, gas, ice }

/// 枚举，列举了太阳系中不同的行星及其属性
enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  earth(planetType: PlanetType.terrestrial, moons: 1, hasRings: false),
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  // 常量生成构造函数
  const Planet({required this.planetType, required this.moons, required this.hasRings});

  // 所有实例变量都是最终的
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  // 增强枚举支持 getters 和其他方法
  bool get isGiant => planetType == PlanetType.gas || planetType == PlanetType.ice;
}

// 扩展类（继承）
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(super.name, DateTime super.launchDate, this.altitude);
}

// 重用代码的方法
mixin Piloted {
  int astronauts = 1;
  void describeCrew() {
    // 异常
    if (astronauts == 0) {
      throw StateError('No astronauts.');
    }
    print('Number of astronauts: $astronauts');
  }
}

// 使用 Mixin 的方式继承
class PilotedCraft extends Spacecraft with Piloted {
  PilotedCraft(super.name, super.launchDate);
}

// 接口和抽象类
class MockSpaceship implements Spacecraft {
  @override
  DateTime? launchDate;

  @override
  String name = "Sun";

  @override
  void describe() {
    // 实现描述方法
    print('MockSpaceship: $name');
  }

  @override
  int? get launchYear => throw UnimplementedError();
}

// 异步函数创建描述文件
Future<void> createDescriptions(Iterable<String> objects) async {
  for (final object in objects) {
    try {
      var file = File('$object.txt');
      if (await file.exists()) {
        var modified = await file.lastModified();
        print('File for $object already exists. It was modified on $modified.');
        continue;
      }
      await file.create();
      await file.writeAsString('Start describing $object in this file.');
    } on IOException catch (e) {
      print('Cannot create description for $object: $e');
    }
  }
}

const oneSecond = Duration(seconds: 1);

// 异步生成器函数报告
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (final object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object';
  }
}

// 异步函数描述飞掠天体
Future<void> describeFlybyObjects(List<String> flybyObjects) async {
  try {
    for (final object in flybyObjects) {
      var description = await File('$object.txt').readAsString();
      print(description);
    }
  } on IOException catch (e) {
    print('Could not describe object: $e');
  } finally {
    flybyObjects.clear();
  }
}

// Flutter 应用的入口 Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart & Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = 'Running...';

  @override
  void initState() {
    super.initState();
    runExamples();
  }

  Future<void> runExamples() async {
    // 用 var 来定义变量
    var name = 'Voyager I';
    var year = 1977;
    var antennaDiameter = 3.7;
    var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
    var image = {
      'tags': ['saturn'],
      'url': '//path/to/saturn.jpg'
    };

    // 流程控制语句
    debugPrint(name);
    if (year >= 2001) {
      debugPrint('21st century');
    } else if (year >= 1901) {
      debugPrint('20th century');
    }
    for (final object in flybyObjects) {
      debugPrint(object);
    }
    for (int month = 1; month <= 12; month++) {
      debugPrint(month.toString());
    }
    while (year < 2016) {
      year += 1;
    }

    // 调用函数
    var result = fibonacci(20);
    debugPrint('Fibonacci(20): $result');

    // 定义匿名函数
    flybyObjects.where((name) => name.contains('turn')).forEach(debugPrint);

    // 使用 Spacecraft 类
    var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
    voyager.describe();
    var voyager3 = Spacecraft.unlaunched('Voyager III');
    voyager3.describe();

    // 使用 Planet 枚举
    final yourPlanet = Planet.earth;
    if (!yourPlanet.isGiant) {
      debugPrint('Your planet is not a "giant planet".');
    }

    // 异步文件操作示例
    await createDescriptions(flybyObjects);
    await describeFlybyObjects(flybyObjects);

    // 更新状态
    setState(() {
      _output = 'All examples finished.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dart & Flutter Demo'),
      ),
      body: Center(
        child: Text(_output),
      ),
    );
  }
}
