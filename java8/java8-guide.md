## Java8简明指南

> 欢迎来到Java8简明指南。本教程将一步一步指导你通过所有新语言特性。由短而简单的代码示例,带你了解如何使用默认接口方法,lambda表达式,方法引用和可重复注解。本文的最后你会熟悉最新的API的变化如Stream,Fcuntional,Map API扩展和新的日期API。


<!--more-->


### 接口的默认方法
在Java8中，利用`default`关键字使我们能够添加非抽象方法实现的接口。此功能也被称为扩展方法，这里是我们的第一个例子：

```java
interface Formula {
    double calculate(int a);

    default double sqrt(int a) {
        return Math.sqrt(a);
    }
}
```
除了接口抽象方法`calculate`，还定义了默认方法`sqrt`的返回值。具体类实现抽象方法`calculate`。默认的方法`sqrt`可以开箱即用。
```java
Formula formula = new Formula() {
    @Override
    public double calculate(int a) {
        return sqrt(a * 100);
    }
};

formula.calculate(100);     // 100.0
formula.sqrt(16);           // 4.0
```

该公式被实现为匿名对象。这段代码是相当长的：非常详细的一个计算：6行代码完成这样一个简单的计算。正如我们将在下一节中看到的，Java8有一个更好的方法来实现单方法对象。

### Lambda表达式

让我们以一个简单的例子来开始，在以前的版本中对字符串进行排序：
```java
List<String> names = Arrays.asList("peter", "anna", "mike", "xenia");

Collections.sort(names, new Comparator<String>() {
    @Override
    public int compare(String a, String b) {
        return b.compareTo(a);
    }
});
```
静态的集合类方法`Collections.sort`，为比较器的给定列表中的元素排序。你会发现自己经常创建匿名比较器并将它们传递给方法。
Java8支持更短的语法而不总是创建匿名对象，
**Lambda表达式：**
```java
Collections.sort(names, (String a, String b) -> {
    return b.compareTo(a);
});
```
正如你可以看到的代码更容易阅读。但它甚至更短：
```java
Collections.sort(names, (String a, String b) -> b.compareTo(a));
```
一行方法的方法体可以跳过`{}`和参数类型，使它变得更短：
```java
Collections.sort(names, (a, b) -> b.compareTo(a));
```
Java编译器知道参数类型，所以你可以跳过它们，接下来让我们深入了解lambda表达式。

### 函数式接口(Functional Interfaces)
如何适应Java lambda表达式类型系统？每个`lambda`由一个指定的接口对应于一个给定的类型。所谓的函数式接口必须包含一个确切的**一个抽象方法声明**。该类型将匹配这个抽象方法每个lambda表达式。因为默认的方法是不抽象的，你可以自由添加默认的方法到你的函数式接口。

我们可以使用任意的接口为lambda表达式，只要接口只包含一个抽象方法。确保你的接口满足要求，你应该添加`@FunctionalInterface`注解。当你尝试在接口上添加第二个抽象方法声明时，编译器会注意到这个注释并抛出一个编译器错误。

举例：
```java
@FunctionalInterface
interface Converter<F, T> {
    T convert(F from);
}
```

```java
Converter<String, Integer> converter = (from) -> Integer.valueOf(from);
Integer converted = converter.convert("123");
System.out.println(converted);    // 123
```
记住，有`@FunctionalInterface`注解的也是有效的代码。

### 方法和构造函数引用
上面的例子代码可以进一步简化，利用静态方法引用：
```java
Converter<String, Integer> converter = Integer::valueOf;
Integer converted = converter.convert("123");
System.out.println(converted);   // 123
```
Java使您可以通过`::`关键字调用引用的方法或构造函数。上面的示例演示了如何引用静态方法。但我们也可以参考对象方法：
```java
class Something {
    String startsWith(String s) {
        return String.valueOf(s.charAt(0));
    }
}
```

```java
Something something = new Something();
Converter<String, String> converter = something::startsWith;
String converted = converter.convert("Java");
System.out.println(converted);    // "J"
```

让我们来看看如何使用`::`关键字调用构造函数。首先，我们定义一个`Person`类并且提供不同的构造函数：
```java
class Person {
    String firstName;
    String lastName;

    Person() {}

    Person(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }
}
```

接下来，我们指定一个`Person`的工厂接口，用于创建`Person`：
```java
interface PersonFactory<P extends Person> {
    P create(String firstName, String lastName);
}
```
然后我们通过构造函数引用来把所有东西拼到一起，而不是手动实现工厂：
```java
PersonFactory<Person> personFactory = Person::new;
Person person = personFactory.create("Peter", "Parker");
```
我们通过`Person::new`创建一个人的引用，Java编译器会自动选择正确的构造函数匹配`PersonFactory.create`的返回。

### Lambda作用域

从lambda表达式访问外部变量的作用域是匿名对象非常相似。您可以从本地外部范围以及实例字段和静态变量中访问`final`变量。

#### 访问局部变量
我们可以从lambda表达式的外部范围读取`final`变量：
```java
final int num = 1;
Converter<Integer, String> stringConverter = (from) -> String.valueOf(from + num);
stringConverter.convert(2);     // 3
```
但不同的匿名对象变量`num`没有被声明为`final`，下面的代码也有效：
```java
int num = 1;
Converter<Integer, String> stringConverter = (from) -> String.valueOf(from + num);
stringConverter.convert(2);     // 3
```
然而`num`必须是隐含的`final`常量。以下代码不编译：
```java
int num = 1;
Converter<Integer, String> stringConverter = (from) -> String.valueOf(from + num);
num = 3;
```
在lambda表达式里修改`num`也是不允许的。

#### 访问字段和静态变量
与局部变量不同，我们在lambda表达式的内部能获取到对成员变量或静态变量的读写权。这种访问行为在匿名对象里是非常典型的。
```java
class Lambda4 {
    static int outerStaticNum;
    int outerNum;

    void testScopes() {
        Converter<Integer, String> stringConverter1 = (from) -> {
            outerNum = 23;
            return String.valueOf(from);
        };

        Converter<Integer, String> stringConverter2 = (from) -> {
            outerStaticNum = 72;
            return String.valueOf(from);
        };
    }
}
```

#### 访问默认接口方法
记得第一节的`formula`例子吗？接口`Formula`定义了一个默认的方法可以从每个公式实例访问包括匿名对象，
这并没有Lambda表达式的工作。
默认方法**不能**在lambda表达式访问。以下代码不编译：
```java
Formula formula = (a) -> sqrt( a * 100);
```

### 内置函数式接口(Built-in Functional Interfaces)

JDK1.8的API包含许多内置的函数式接口。其中有些是众所周知的，从旧版本中而来，如`Comparator`或者`Runnable`。使现有的接口通过`@FunctionalInterface`注解支持Lambda。

但是Java8 API也添加了新功能接口,使你的开发更简单。其中一些接口是众所周知的[Google Guava](https://code.google.com/p/guava-libraries/)库。即使你熟悉这个库也应该密切关注这些接口是如何延长一些有用的扩展方法。

#### Predicates(谓词)
Predicates是一个返回布尔类型的函数。这就是谓词函数，输入一个对象，返回true或者false。
在Google Guava中，定义了Predicate接口，该接口包含一个带有泛型参数的方法：
```java
apply(T input): boolean
```
```java
Predicate<String> predicate = (s) -> s.length() > 0;
 
predicate.test("foo");              // true
predicate.negate().test("foo");     // false
 
Predicate<Boolean> nonNull = Objects::nonNull;
Predicate<Boolean> isNull = Objects::isNull;
 
Predicate<String> isEmpty = String::isEmpty;
Predicate<String> isNotEmpty = isEmpty.negate();
```
#### Functions(函数)
Functions接受一个参数，并产生一个结果。默认方法可以将多个函数串在一起（compse, andThen）
```java
Function<String, Integer> toInteger = Integer::valueOf;
Function<String, String> backToString = toInteger.andThen(String::valueOf);

backToString.apply("123");     // "123"
```
#### Suppliers(生产者)
Suppliers产生一个给定的泛型类型的结果。与Functional不同的是Suppliers不接受输入参数。
```java
Supplier<Person> personSupplier = Person::new;
personSupplier.get();   // new Person
```
#### Consumers(消费者)
Consumers代表在一个单一的输入参数上执行操作。
```java
Consumer<Person> greeter = (p) -> System.out.println("Hello, " + p.firstName);
greeter.accept(new Person("Luke", "Skywalker"));
```
#### Comparators(比较器)
Comparators在旧版本Java中是众所周知的。Java8增加了各种默认方法的接口。
```java
Comparator<Person> comparator = (p1, p2) -> p1.firstName.compareTo(p2.firstName);

Person p1 = new Person("John", "Doe");
Person p2 = new Person("Alice", "Wonderland");

comparator.compare(p1, p2);             // > 0
comparator.reversed().compare(p1, p2);  // < 0
```
#### Optionals(可选项)
Optionals是没有函数的接口，取而代之的是防止`NullPointerException`异常。这是下一节的一个重要概念，所以让我们看看如何结合Optionals工作。

Optional is a simple container for a value which may be null or non-null. Think of a method which may return a non-null result but sometimes return nothing. Instead of returning null you return an Optional in Java 8.

Optional是一个简单的容器，这个值可能是空的或者非空的。考虑到一个方法可能会返回一个non-null的值，也可能返回一个空值。为了不直接返回null，我们在Java 8中就返回一个Optional。
```java
Optional<String> optional = Optional.of("bam");

optional.isPresent();           // true
optional.get();                 // "bam"
optional.orElse("fallback");    // "bam"

optional.ifPresent((s) -> System.out.println(s.charAt(0)));     // "b"
```

#### Streams(管道)
一个`java.util.Stream`代表一个序列的元素在其中的一个或多个可以执行的操作。流操作是中间或终端。当终端操作返回某一类型的结果时，中间操作返回流，这样就可以将多个方法调用在一行中。流是一个源产生的，例如`java.util.Collection`像列表或设置（不支持map）。流操作可以被执行的顺序或并行。

让我们先看一下数据流如何工作。首先，我们创建一个字符串列表的数据：
```java
List<String> stringCollection = new ArrayList<>();
stringCollection.add("ddd2");
stringCollection.add("aaa2");
stringCollection.add("bbb1");
stringCollection.add("aaa1");
stringCollection.add("bbb3");
stringCollection.add("ccc");
stringCollection.add("bbb2");
stringCollection.add("ddd1");
```
在Java8中Collections类的功能已经有所增强，你可用调用`Collection.stream()`或`Collection.parallelStream()`。
下面的章节解释最常见的流操作。

#### Filter
Filter接受一个predicate来过滤流的所有元素。这个中间操作能够调用另一个流的操作（Foreach）的结果。ForEach接受一个消费者为每个元素执行过滤流。它是`void`，所以我们不能称之为另一个流操作。
```java
stringCollection
    .stream()
    .filter((s) -> s.startsWith("a"))
    .forEach(System.out::println);

// "aaa2", "aaa1"
```
#### Sorted
Sorted是一个中间操作，能够返回一个排过序的流对象的视图。这些元素按自然顺序排序，除非你经过一个自定义比较器（实现Comparator接口）。
```java
stringCollection
    .stream()
    .sorted()
    .filter((s) -> s.startsWith("a"))
    .forEach(System.out::println);

// "aaa1", "aaa2"
```
要记住，排序只会创建一个流的排序视图，而不处理支持集合的排序。原来string集合中的元素顺序是没有改变的。
```java
System.out.println(stringCollection);
// ddd2, aaa2, bbb1, aaa1, bbb3, ccc, bbb2, ddd1
```
#### Map
`map`是一个对于流对象的中间操作，通过给定的方法，它能够把流对象中的每一个元素对应到另外一个对象上。下面的例子将每个字符串转换成一个大写字符串，但也可以使用`map`将每个对象转换为另一种类型。所得到的流的泛型类型取决于您传递给`map`方法的泛型类型。
```java
stringCollection
    .stream()
    .map(String::toUpperCase)
    .sorted((a, b) -> b.compareTo(a))
    .forEach(System.out::println);

// "DDD2", "DDD1", "CCC", "BBB3", "BBB2", "AAA2", "AAA1"
```
#### Match
可以使用各种匹配操作来检查某个谓词是否匹配流。所有这些操作都是终止操作，返回一个布尔结果。
```java
boolean anyStartsWithA =
    stringCollection
        .stream()
        .anyMatch((s) -> s.startsWith("a"));

System.out.println(anyStartsWithA);      // true

boolean allStartsWithA =
    stringCollection
        .stream()
        .allMatch((s) -> s.startsWith("a"));

System.out.println(allStartsWithA);      // false

boolean noneStartsWithZ =
    stringCollection
        .stream()
        .noneMatch((s) -> s.startsWith("z"));

System.out.println(noneStartsWithZ);      // true
```
#### Count
Count是一个终止操作返回流中的元素的数目，返回`long`类型。
```java
long startsWithB =
    stringCollection
        .stream()
        .filter((s) -> s.startsWith("b"))
        .count();

System.out.println(startsWithB);    // 3
```
#### Reduce
该终止操作能够通过某一个方法，对元素进行削减操作。该操作的结果会放在一个Optional变量里返回。
```java
Optional<String> reduced =
    stringCollection
        .stream()
        .sorted()
        .reduce((s1, s2) -> s1 + "#" + s2);

reduced.ifPresent(System.out::println);
// "aaa1#aaa2#bbb1#bbb2#bbb3#ccc#ddd1#ddd2"
```

### Parallel Streams

如上所述的数据流可以是连续的或平行的。在一个单独的线程上进行操作，同时在多个线程上执行并行操作。

下面的例子演示了如何使用并行流很容易的提高性能。

首先，我们创建一个大的元素列表：
```java
int max = 1000000;
List<String> values = new ArrayList<>(max);
for (int i = 0; i < max; i++) {
    UUID uuid = UUID.randomUUID();
    values.add(uuid.toString());
}
```
现在我们测量一下流对这个集合进行排序消耗的时间。
#### Sequential Sort
```java
long t0 = System.nanoTime();

long count = values.stream().sorted().count();
System.out.println(count);

long t1 = System.nanoTime();

long millis = TimeUnit.NANOSECONDS.toMillis(t1 - t0);
System.out.println(String.format("sequential sort took: %d ms", millis));

// sequential sort took: 899 ms
```
#### Parallel Sort
```java
long t0 = System.nanoTime();

long count = values.parallelStream().sorted().count();
System.out.println(count);

long t1 = System.nanoTime();

long millis = TimeUnit.NANOSECONDS.toMillis(t1 - t0);
System.out.println(String.format("parallel sort took: %d ms", millis));

// parallel sort took: 472 ms
```

你可以看到这两段代码片段几乎是相同的，但并行排序大致是50%的差距。唯一的不同就是把`stream()`改成了`parallelStream()`。

### Map
正如前面所说的Map不支持流操作，现在的Map支持各种新的实用的方法和常见的任务。

```java
Map<Integer, String> map = new HashMap<>();

for (int i = 0; i < 10; i++) {
    map.putIfAbsent(i, "val" + i);
}

map.forEach((id, val) -> System.out.println(val));
```

上面的代码应该是不解自明的：putIfAbsent避免我们将null写入；forEach接受一个消费者对象，从而将操作实施到每一个map中的值上。

这个例子演示了如何利用函数判断或获取Map中的数据：
```java
map.computeIfPresent(3, (num, val) -> val + num);
map.get(3);             // val33

map.computeIfPresent(9, (num, val) -> null);
map.containsKey(9);     // false

map.computeIfAbsent(23, num -> "val" + num);
map.containsKey(23);    // true

map.computeIfAbsent(3, num -> "bam");
map.get(3);             // val33
```
接下来，我们将学习如何删除一一个给定的键的条目，只有当它当前映射到给定值：
```java
map.remove(3, "val3");
map.get(3);             // val33

map.remove(3, "val33");
map.get(3);             // null
```
另一种实用的方法：
```java
map.getOrDefault(42, "not found");  // not found
```
Map合并条目是非常容易的：
```java
map.merge(9, "val9", (value, newValue) -> value.concat(newValue));
map.get(9);             // val9

map.merge(9, "concat", (value, newValue) -> value.concat(newValue));
map.get(9);             // val9concat
```
合并操作先看map中是否没有特定的key/value存在，如果是，则把key/value存入map，否则merging函数就会被调用，对现有的数值进行修改。

### Date API
Java8 包含一个新的日期和时间API，在`java.time`包下。新的日期API与[Joda Time](http://www.joda.org/joda-time/)库可以媲美，但它们是不一样的。下面的例子涵盖了这个新的API最重要的部分。

#### Clock
Clock提供访问当前日期和时间。Clock是对当前时区敏感的，可以用来代替`System.currentTimeMillis()`来获取当前的毫秒值。当前时间线上的时刻可以用Instance类来表示。Instance可以用来创建`java.util.Date`格式的对象。
```java
Clock clock = Clock.systemDefaultZone();
long millis = clock.millis();

Instant instant = clock.instant();
Date legacyDate = Date.from(instant);   // legacy java.util.Date
```

#### Timezones
时区是由`ZoneId`表示，通过静态工厂方法可以很容易地访问。时区还定义了一个偏移量，用来转换当前时刻与目标时刻。
```java
System.out.println(ZoneId.getAvailableZoneIds());
// prints all available timezone ids

ZoneId zone1 = ZoneId.of("Europe/Berlin");
ZoneId zone2 = ZoneId.of("Brazil/East");
System.out.println(zone1.getRules());
System.out.println(zone2.getRules());

// ZoneRules[currentStandardOffset=+01:00]
// ZoneRules[currentStandardOffset=-03:00]
```

#### LocalTime
LocalTime代表没有时区的时间，例如晚上10点或17:30:15。下面的例子会用上面的例子定义的时区创建两个本地时间对象。然后我们比较两个时间并计算小时和分钟的差异。
```java
LocalTime now1 = LocalTime.now(zone1);
LocalTime now2 = LocalTime.now(zone2);

System.out.println(now1.isBefore(now2));  // false

long hoursBetween = ChronoUnit.HOURS.between(now1, now2);
long minutesBetween = ChronoUnit.MINUTES.between(now1, now2);

System.out.println(hoursBetween);       // -3
System.out.println(minutesBetween);     // -239
```

#### LocalDate
LocalDate代表一个唯一的日期，如2014-03-11。它是不可变的,完全模拟本地时间工作。此示例演示如何通过添加或减去天数,月数，年来计算新的日期。记住每一个操作都会返回一个新的实例。
```java
LocalDate today = LocalDate.now();
LocalDate tomorrow = today.plus(1, ChronoUnit.DAYS);
LocalDate yesterday = tomorrow.minusDays(2);

LocalDate independenceDay = LocalDate.of(2014, Month.JULY, 4);
DayOfWeek dayOfWeek = independenceDay.getDayOfWeek();
System.out.println(dayOfWeek);    // FRIDAY
```
将字符串解析为LocalDate:
```java
DateTimeFormatter germanFormatter =
    DateTimeFormatter
        .ofLocalizedDate(FormatStyle.MEDIUM)
        .withLocale(Locale.GERMAN);

LocalDate xmas = LocalDate.parse("24.12.2014", germanFormatter);
System.out.println(xmas);   // 2014-12-24
```

#### LocalDateTime
LocalDateTime代表日期时间。它结合了日期和时间见上面的部分为一个实例。`LocalDateTime`是不可变的,类似于本地时间和LocalDate工作。我们可以从一个日期时间获取某些字段的方法:
```java
LocalDateTime sylvester = LocalDateTime.of(2014, Month.DECEMBER, 31, 23, 59, 59);

DayOfWeek dayOfWeek = sylvester.getDayOfWeek();
System.out.println(dayOfWeek);      // WEDNESDAY

Month month = sylvester.getMonth();
System.out.println(month);          // DECEMBER

long minuteOfDay = sylvester.getLong(ChronoField.MINUTE_OF_DAY);
System.out.println(minuteOfDay);    // 1439
```
随着一个时区可以转换为一个即时的附加信息。Instance可以被转换为日期型转化为指定格式的` java.util.Date`。
```java
Instant instant = sylvester
        .atZone(ZoneId.systemDefault())
        .toInstant();

Date legacyDate = Date.from(instant);
System.out.println(legacyDate);     // Wed Dec 31 23:59:59 CET 2014
```
格式日期时间对象就像格式化日期对象或者格式化时间对象，除了使用预定义的格式以外，我们还可以创建自定义的格式化对象，然后匹配我们自定义的格式。
```java
DateTimeFormatter formatter =
    DateTimeFormatter
        .ofPattern("MMM dd, yyyy - HH:mm");

LocalDateTime parsed = LocalDateTime.parse("Nov 03, 2014 - 07:13", formatter);
String string = formatter.format(parsed);
System.out.println(string);     // Nov 03, 2014 - 07:13
```
不像`java.text.NumberFormat`，新的`DateTimeFormatter`是不可变的，线程安全的。

### Annotations(注解)

在Java8中注解是可以重复的，让我们深入到一个示例中。

首先，我们定义了一个包装的注解，它拥有一个返回值为数组类型的方法Hint：
```java
@interface Hints {
    Hint[] value();
}

@Repeatable(Hints.class)
@interface Hint {
    String value();
}
```
Java8使我们能够使用相同类型的多个注解，通过`@Repeatable`声明注解。

##### 变体1：使用注解容器（老方法）
```java
@Hints({@Hint("hint1"), @Hint("hint2")})
class Person {}
```

##### 变体2：使用可重复注解（新方法）
```java
@Hint("hint1")
@Hint("hint2")
class Person {}
```

使用变体2隐式编译器隐式地设置了`@Hints`注解。这对于通过反射来读取注解信息是非常重要的。

```java
Hint hint = Person.class.getAnnotation(Hint.class);
System.out.println(hint);                   // null

Hints hints1 = Person.class.getAnnotation(Hints.class);
System.out.println(hints1.value().length);  // 2

Hint[] hints2 = Person.class.getAnnotationsByType(Hint.class);
System.out.println(hints2.length);          // 2
```

虽然在`Person`中从未定义`@Hints`注解，它仍然可读通过`getAnnotation(Hints.class)`读取。并且，getAnnotationsByType方法会更方便，因为它赋予了所有@Hints注解标注的方法直接的访问权限。

```java
@Target({ElementType.TYPE_PARAMETER, ElementType.TYPE_USE})
@interface MyAnnotation {}
```

欢迎Star我的开源Web框架Blade：[http://github.com/biezhi/blade](http://github.com/biezhi/blade)