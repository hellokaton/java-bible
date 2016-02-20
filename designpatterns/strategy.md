# 什么是策略模式

- [策略模式](#策略模式)
	- [一、策略模式的定义](#策略模式的定义)
	- [二、策略模式的实际应用](#策略模式的实际应用)
	- [三、策略模式中的设计原则](#策略模式中的设计原则)

## 策略模式

### 策略模式的定义

**策略模式**，顾名思义就是指对象具有某个行为，但是在不同的业务场景下，这个行为应该有不同的表现形式，也就是有了不同的策略。让对象能再不同的场景下对同一行为有不同的实现，这就是策略模式。

下面是策略模式的类图： 

![](http://i.imgur.com/PE99rte.jpg)

1. 首先定义一个策略接口：
```java
public interface Strategy {
    public void algorithmStartegy() ;
}
```
2. 定义两个具体的策略类：
```java
public class ConcentrateStrategy_1 implements Strategy{
    @Override
    public void algorithmStartegy() {
        System.out.println("I am algorithm strategy 1");
    }
}
public class ConcentrateStrategy_2 implements Strategy{
    @Override
    public void algorithmStartegy() {
        System.out.println("I am algorithm strategy 2");
    }
}
```
3. 定义一个算法使用场景
```java
public class Situation {
    Strategy strategy;
    public Situation(Strategy strategy) {
        this.strategy = strategy;
    }
    public void handleAlgorithm() {
        strategy.algorithmStartegy();
    }
}
```
4. 客户端调用
```java
Situation situation = new Situation(new ConcentrateStrategy_1());
situation.handleAlgorithm();
    ...
```

从策略模式的描述以及类图来看真的是非常简单，总结起来就是策略模式定义了一组算法，它们有一个共同的**策略行为接口**，并且这些算法之间可以**互相替换**，使算法可以根据场景的不同而改变。

### 策略模式的实际应用

策略模式的应用有很多， 比如说JDK中`FilenameFilter`的使用过程， 比如场景`java.util.Collections.sort(List<T>list, Comparator<? super T>c)`与策略`java.util.Comparator`的使用等等。
下面我以一个实际的业务场景来具体实现以下策略模式：

1. 背景： 中国银行的便民服务包括中国移动手机充值， 中国联通，中国电信。用户选择某个便民服务时， 服务器后台会向银行发送不同的业务XML报文， 已达到通信目的。
2. 实现
	1. 定义策略接口 : 包含一个生成报文的方法
```java
public interface IProduct {
    public String generateXML() ;
}
```
	2. 定义一组具体策略类：
```java
@XMLType("Default")
class DefaultHead implements IProduct {
    public String generateXML() {
        return "Defalut XML";
    }
}
@XMLType("ChinaMobile")
class ChinaMobile implements IProduct{
    public String generateXML() {
        return "China Mobile XML";
    }
}
@XMLType("ChinaUnicom")
class ChinaUnicom implements IProduct {
    public String generateXML() {
        return "Chinal Unicom XML";
    }
}
```
	3. 定义一个场景类用于生成XML报文
```java
public class XMLGenerator {
    private IProduct product = new DefaultHead();
    //根据用户缴费类型，生成不同的通信报文
    public String generate(String type) {
        //注意此处
        product = ProductFactory.getInstance().createProduct(type);
    return product.generateXML();
    }
}
```
	4. 创建具体的策略类， 本来是可以用一系列的`if else`判断， 然后new相应的策略类。这里为了避免`if else`我们定义一个策略工厂，来生产具体的策略类。
**策略类工厂**：这个工厂创建策略类的思路就是，载入一些列策略类，根据不同策略类的**自定义注解**和用户的传入参数来生成具体的策略类。 
```java
public class ProductFactory {
    // singleton
    private ProductFactory() {}

    public static ProductFactory getInstance() {
        return ProductFactoryInstance.instance;
    }

    private static class ProductFactoryInstance {
        static final ProductFactory instance = new ProductFactory();
    }

    //创建一个具体的策略类
    public IProduct createProduct(String productType) throws URISyntaxException {
        // load all startegys
        List<Class<? extends IProduct>> startegyList = loadAllStrategy("com.su.startegy");
        //遍历所有策略类， 根据条件找出需要用到的
        for(Class<? extends IProduct> clazz : startegyList) {
            //解析策略类的注解
            XMLType xmlType = praseAnnotation(clazz);
            if(xmlType.value().equals(productType))
            	try {
                	return clazz.newInstance();
                } catch (InstantiationException | IllegalAccessException e)  {
                	e.printStackTrace();
    			}
			}
		}
		//create IProduct Object failed
    	return null;
    }

	//载入策略类方法
	private List<Class<? extends IProduct>> loadAllStrategy(String packageName) throws URISyntaxException {
        //定义一个策略类的列表
        List<Class<? extends IProduct>> strategyList = new ArrayList<Class<? extends IProduct>>();
        URI filePath = getClass().getClassLoader().getResource(packageName.replace(".", "/")).toURI();
        //获取filepath
        File[] files = new File(filePath).listFiles(new FilenameFilter() {
	        @Override
	        public boolean accept(File dir, String name) {
	            if (name.endsWith(".class"))
	                return true;
	            return false;
	        }
	    });
        // load class
        for (File file : files) {
            try {
                Class clazz = getClass().getClassLoader().loadClass(packageName + "." + file.getName().replace(".class", ""));
	            if (clazz != IProduct.class && IProduct.class.isAssignableFrom(clazz)) {
	                strategyList.add(clazz);
	            }
	        } catch (ClassNotFoundException e) {
	            e.printStackTrace();
	        }
	    }
    	return strategyList;
	}

	//解析注解方法
	private XMLType praseAnnotation(Class<? extends IProduct> clazz) {
		XMLType xmlType = clazz.getAnnotation(XMLType.class);
		if (xmlType == null) {
			return null;
		}
	    return xmlType;
	}

}
```

此处我使用**注解**的原因是为了简单， 跟代码的耦合紧一点。

**自定义的注解类： **

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface XMLType {
    public String value() default "defalut";
}
```

以上就是此处的策略模式的设计过程，如果需要多种策略的叠加， 也就要相应的使用注解的嵌套了， 这里就不在发挥了。

### 策略模式中的设计原则

学习策略模式， 不要记住代码是怎么实现的，更重要的是记住其设计原则。根据原则写代码， 而不是生搬硬套。其实设计模式都是设计原则的体现， 如果理解了设计原则， 那么你写的代码也可以变成一种模式。

1. **开闭原则（Open-Closed Principle，缩写为OCP）**
一个软件实体应当对扩展(例如对抽象层的扩展)开放，对修改(例如对抽象层的修改)关闭。即在设计一个模块的时候，应当使这个模块可以在不被修改的前提下被扩展。
开闭原则的关键，在于抽象。策略模式，是开闭原则的一个极好的应用范例。

2. **里氏替换原则（Liskov Substitution Principle，缩写为LSP）**
一个软件实体如果使用的是一个基类的话，那么一定适用于其子类，而且它根本不能察觉到基类对象和子类对象的区别。比如，假设有两个类，一个是Base类，一个是Derived类，并且Derived类是Base类的子类。那么一个方法如果可以接受一个基类对象b的话：method1(Base b)，那么它必然可以接受一个子类对象d，也即可以有method1(d)。反之，则不一定成立
里氏替换原则讲的是基类与子类的关系。只有当这种关系存在时，里氏替换关系才存在，反之则不存在。

策略模式之所以可行的基础便是里氏替换原则：策略模式要求所有的策略对象都是可以互换的，因此它们都必须是一个抽象策略角色的子类。在客户端则仅知道抽象策略角色类型，虽然变量的真实类型可以是任何一个具体策略角色的实例

## 参考文献 

[策略模式设计原则](http://blog.csdn.net/caihaijiang/article/details/8764226)