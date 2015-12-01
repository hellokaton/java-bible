# java8 foreach

在这篇文章中我将向你演示如何使用Java8中的`foreach`操作`List`和`Map`

### 1. Foreach操作Map
1.1 正常方式遍历Map
```java
Map<String, Integer> items = new HashMap<>();
items.put("A", 10);
items.put("B", 20);
items.put("C", 30);
items.put("D", 40);
items.put("E", 50);
items.put("F", 60);

for (Map.Entry<String, Integer> entry : items.entrySet()) {
	System.out.println("Item : " + entry.getKey() + " Count : " + entry.getValue());
}
```

<!--more-->

1.2 使用Java8的`foreach`+`lambda`表达式遍历Map
```java
Map<String, Integer> items = new HashMap<>();
items.put("A", 10);
items.put("B", 20);
items.put("C", 30);
items.put("D", 40);
items.put("E", 50);
items.put("F", 60);

items.forEach((k,v)->System.out.println("Item : " + k + " Count : " + v));

items.forEach((k,v)->{
	System.out.println("Item : " + k + " Count : " + v);
	if("E".equals(k)){
		System.out.println("Hello E");
	}
});
```

###2. Foreach操作List
2.1 普通方式循环List
```java
List<String> items = new ArrayList<>();
items.add("A");
items.add("B");
items.add("C");
items.add("D");
items.add("E");

for(String item : items){
	System.out.println(item);
}
```
2.2 在Java8中使用`foreach`+`lambda`表达式遍历List
```java
List<String> items = new ArrayList<>();
items.add("A");
items.add("B");
items.add("C");
items.add("D");
items.add("E");

//lambda
//Output : A,B,C,D,E
items.forEach(item->System.out.println(item));
	
//Output : C
items.forEach(item->{
	if("C".equals(item)){
		System.out.println(item);
	}
});
	
//method reference
//Output : A,B,C,D,E
items.forEach(System.out::println);

//Steam and filter
//Output : B
items.stream()
	.filter(s->s.contains("B"))
	.forEach(System.out::println);
```

参考资料：
1. [Java 8 Iterable forEach JavaDoc](https://docs.oracle.com/javase/8/docs/api/java/lang/Iterable.html#forEach-java.util.function.Consumer-)
2. [Java 8 forEach JavaDoc](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#forEach-java.util.function.BiConsumer-)

欢迎star开源web框架Blade：[http://github.com/biezhi/blade](http://github.com/biezhi/blade)