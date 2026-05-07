# Java Complete Exam Answers (Q1 – Q34)

---

## Q1. Differentiate between `throw` and `throws` with examples.

### Concept:
In Java, exceptions are handled using a robust mechanism. Two important keywords used in this context are `throw` and `throws`. Though they sound similar, they serve completely different purposes.

### `throw`:
- `throw` is a **statement** used inside a method body to **explicitly throw an exception**.
- It is followed by an **object** of a Throwable class (or its subclass).
- Only **one** exception can be thrown at a time using `throw`.
- Used to throw both **checked and unchecked** exceptions.

### `throws`:
- `throws` is a **clause** used in the **method signature/declaration**.
- It tells the caller of the method that the method **might throw** one or more exceptions.
- Multiple exceptions can be listed with `throws`, separated by commas.
- Used for **checked exceptions** mainly.

### Differences (Table):

| Feature       | `throw`                              | `throws`                                  |
|---------------|--------------------------------------|-------------------------------------------|
| Purpose       | Actually throws an exception          | Declares that a method may throw exceptions|
| Location      | Inside method body                    | In method signature                        |
| Followed by   | An exception object                   | Exception class name(s)                   |
| Number        | One exception at a time              | Multiple exceptions can be declared        |
| Type          | Both checked & unchecked             | Mainly checked exceptions                  |

### Example:

```java
import java.io.*;

class ThrowVsThrows {

    // 'throws' declares that this method may throw IOException
    static void readFile(String name) throws IOException {
        if (name == null) {
            // 'throw' actually throws the exception object
            throw new IOException("File name cannot be null");
        }
        System.out.println("Reading file: " + name);
    }

    public static void main(String[] args) {
        try {
            readFile(null);   // This will trigger the throw
        } catch (IOException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        try {
            readFile("data.txt");  // Normal execution
        } catch (IOException e) {
            System.out.println("Caught: " + e.getMessage());
        }
    }
}
```

**Output:**
```
Caught: File name cannot be null
Reading file: data.txt
```

---

## Q2. What is dynamic binding? Why is it called so? Explain with example.

### Concept:
**Binding** refers to the connection between a method call and the method body (implementation).

- **Static Binding (Early Binding):** The method call is resolved **at compile time**. Happens with `static`, `private`, and `final` methods.
- **Dynamic Binding (Late Binding):** The method call is resolved **at runtime** based on the actual object type, not the reference type.

### Why is it called "Dynamic"?
It is called **dynamic** because the decision of which method to call is made **dynamically (at runtime)**, not at compile time. The JVM looks at the actual runtime object to decide which method to invoke.

### When does it occur?
Dynamic binding occurs when:
- A **parent class reference** holds a **child class object**.
- The method is **overridden** in the child class.

### Example:

```java
class Animal {
    void sound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("Dog barks");
    }
}

class Cat extends Animal {
    @Override
    void sound() {
        System.out.println("Cat meows");
    }
}

class DynamicBindingDemo {
    public static void main(String[] args) {
        Animal a;  // Reference of parent class

        a = new Dog();   // Parent ref holds Dog object
        a.sound();       // Calls Dog's sound() at runtime --> Dynamic Binding

        a = new Cat();   // Parent ref holds Cat object
        a.sound();       // Calls Cat's sound() at runtime --> Dynamic Binding
    }
}
```

**Output:**
```
Dog barks
Cat meows
```

At compile time, the compiler only sees `Animal`'s `sound()`. But at runtime, the JVM checks the actual object (`Dog` or `Cat`) and calls the appropriate overridden method. This resolution at runtime is **dynamic binding**.

---

## Q3. Differentiate between method overloading and method overriding with suitable Java examples.

### Concept:
Both are forms of **polymorphism** in Java but apply at different stages.

### Method Overloading (Compile-time Polymorphism):
- Same method name, **different parameter list** (type, number, or order).
- Occurs within the **same class**.
- Return type may or may not be different.
- Resolved at **compile time**.

### Method Overriding (Runtime Polymorphism):
- Same method name, **same parameter list**, same return type.
- Occurs between **parent and child class**.
- The child class provides a **new implementation** of the parent's method.
- Resolved at **runtime**.

### Differences (Table):

| Feature              | Overloading                        | Overriding                              |
|----------------------|------------------------------------|-----------------------------------------|
| Class                | Same class                         | Parent and child class                  |
| Parameters           | Must differ                        | Must be same                            |
| Return type          | Can differ                         | Must be same (or covariant)             |
| Binding              | Compile-time (Static)              | Runtime (Dynamic)                       |
| `@Override`          | Not used                           | Should be used                          |
| Access modifier      | Can be anything                    | Cannot reduce visibility                |

### Example:

```java
// Overloading Example
class Calculator {
    int add(int a, int b) {
        return a + b;
    }

    double add(double a, double b) {  // Same name, different parameter types
        return a + b;
    }

    int add(int a, int b, int c) {   // Same name, different number of parameters
        return a + b + c;
    }
}

// Overriding Example
class Vehicle {
    void start() {
        System.out.println("Vehicle is starting...");
    }
}

class Car extends Vehicle {
    @Override
    void start() {                   // Same signature as parent
        System.out.println("Car engine starts with a key");
    }
}

class OverloadOverrideDemo {
    public static void main(String[] args) {
        // Overloading
        Calculator calc = new Calculator();
        System.out.println(calc.add(2, 3));
        System.out.println(calc.add(2.5, 3.5));
        System.out.println(calc.add(1, 2, 3));

        // Overriding
        Vehicle v = new Car();  // Parent ref, child object
        v.start();              // Calls Car's start() - dynamic binding
    }
}
```

**Output:**
```
5
6.0
6
Car engine starts with a key
```

---

## Q4. Explain runtime polymorphism using dynamic method dispatch with Java code.

### Concept:
**Runtime Polymorphism** is the ability of Java to resolve method calls at **runtime**, not compile time. It is achieved through **method overriding** and **dynamic method dispatch**.

**Dynamic Method Dispatch** is the mechanism by which Java determines which overridden method to call at runtime based on the **actual type of the object** (not the reference type).

### Key Rules:
1. A **superclass reference** can point to a **subclass object**.
2. When an overridden method is called through a superclass reference, Java determines at **runtime** which version (subclass or superclass) to execute.
3. This enables **one interface, multiple implementations**.

### Example:

```java
class Shape {
    void draw() {
        System.out.println("Drawing a generic shape");
    }

    double area() {
        return 0;
    }
}

class Circle extends Shape {
    double radius;

    Circle(double r) {
        this.radius = r;
    }

    @Override
    void draw() {
        System.out.println("Drawing a Circle");
    }

    @Override
    double area() {
        return Math.PI * radius * radius;
    }
}

class Rectangle extends Shape {
    double length, width;

    Rectangle(double l, double w) {
        this.length = l;
        this.width = w;
    }

    @Override
    void draw() {
        System.out.println("Drawing a Rectangle");
    }

    @Override
    double area() {
        return length * width;
    }
}

class Triangle extends Shape {
    double base, height;

    Triangle(double b, double h) {
        this.base = b;
        this.height = h;
    }

    @Override
    void draw() {
        System.out.println("Drawing a Triangle");
    }

    @Override
    double area() {
        return 0.5 * base * height;
    }
}

class RuntimePolymorphismDemo {
    public static void main(String[] args) {
        Shape s;  // Superclass reference

        s = new Circle(5);           // Points to Circle object
        s.draw();                    // Calls Circle's draw() at runtime
        System.out.println("Area: " + s.area());

        s = new Rectangle(4, 6);    // Points to Rectangle object
        s.draw();                    // Calls Rectangle's draw() at runtime
        System.out.println("Area: " + s.area());

        s = new Triangle(3, 8);     // Points to Triangle object
        s.draw();                    // Calls Triangle's draw() at runtime
        System.out.println("Area: " + s.area());
    }
}
```

**Output:**
```
Drawing a Circle
Area: 78.53981633974483
Drawing a Rectangle
Area: 24.0
Drawing a Triangle
Area: 12.0
```

At runtime, the JVM uses the actual object type (Circle, Rectangle, Triangle) to dispatch the correct method. This is **dynamic method dispatch**, the backbone of runtime polymorphism.

---

## Q5. Explain static variable, static method, and static block with a Java program.

### Concept:
The `static` keyword in Java means that the member **belongs to the class** rather than to any individual object. Static members are shared across all instances of a class.

### Static Variable:
- Declared with the `static` keyword.
- **Shared** among all objects of the class (only one copy in memory).
- Initialized when the class is loaded.
- Also called **class variable**.

### Static Method:
- Declared with `static` keyword.
- Can be called **without creating an object**: `ClassName.method()`.
- Can **only access static** members directly.
- Cannot use `this` or `super`.

### Static Block:
- A block of code declared as `static { ... }`.
- Executed **only once** when the class is loaded into memory.
- Used for **static initialization** (e.g., setting up static variables).
- Runs **before** the constructor and `main()`.

### Example:

```java
class Counter {
    static int count = 0;   // Static variable - shared by all objects
    int id;

    // Static block - runs once when class is loaded
    static {
        System.out.println("Static block executed. Initializing...");
        count = 100;  // Initialize static variable
    }

    // Constructor
    Counter() {
        count++;
        id = count;
        System.out.println("Object created with id = " + id);
    }

    // Static method - can be called without object
    static void showCount() {
        System.out.println("Total objects created: " + count);
    }

    // Instance method
    void showId() {
        System.out.println("My id is: " + id);
    }
}

class StaticDemo {
    public static void main(String[] args) {
        System.out.println("main() started");

        Counter.showCount();   // Calling static method without object

        Counter c1 = new Counter();
        Counter c2 = new Counter();
        Counter c3 = new Counter();

        Counter.showCount();   // Static method called on class

        c1.showId();
        c2.showId();
        c3.showId();
    }
}
```

**Output:**
```
Static block executed. Initializing...
main() started
Total objects created: 100
Object created with id = 101
Object created with id = 102
Object created with id = 103
Total objects created: 103
My id is: 101
My id is: 102
My id is: 103
```

Note: The static block executes **before** `main()` because it runs when the class is loaded.

---

## Q6. Explain different types of access specifiers in Java packages with examples.

### Concept:
**Access specifiers (access modifiers)** in Java control the **visibility** of classes, methods, and variables. There are four types:

| Modifier    | Same Class | Same Package | Subclass (diff pkg) | Anywhere |
|-------------|------------|--------------|---------------------|----------|
| `private`   | ✅          | ❌            | ❌                   | ❌        |
| (default)   | ✅          | ✅            | ❌                   | ❌        |
| `protected` | ✅          | ✅            | ✅                   | ❌        |
| `public`    | ✅          | ✅            | ✅                   | ✅        |

### 1. `private`:
- Accessible only within the **same class**.
- Used for **encapsulation** (hiding internal data).

### 2. Default (No modifier):
- Accessible within the **same package** only.
- Also called **package-private**.

### 3. `protected`:
- Accessible within the **same package** AND in **subclasses** (even in different packages).

### 4. `public`:
- Accessible from **anywhere** in the program.

### Example:

```java
// File: package1/AccessDemo.java
package package1;

public class AccessDemo {
    private   int privateVar   = 1;   // Only in this class
              int defaultVar   = 2;   // Same package only
    protected int protectedVar = 3;   // Same package + subclasses
    public    int publicVar    = 4;   // Everywhere

    public void show() {
        System.out.println("private:   " + privateVar);
        System.out.println("default:   " + defaultVar);
        System.out.println("protected: " + protectedVar);
        System.out.println("public:    " + publicVar);
    }
}

// File: package2/SubClass.java
package package2;
import package1.AccessDemo;

public class SubClass extends AccessDemo {
    public void display() {
        // privateVar   - NOT accessible (compile error)
        // defaultVar   - NOT accessible (different package)
        System.out.println("protected: " + protectedVar);  // OK (subclass)
        System.out.println("public:    " + publicVar);     // OK
    }
}

// File: package2/OtherClass.java
package package2;
import package1.AccessDemo;

public class OtherClass {
    public static void main(String[] args) {
        AccessDemo obj = new AccessDemo();
        // obj.privateVar   - NOT accessible
        // obj.defaultVar   - NOT accessible
        // obj.protectedVar - NOT accessible (not a subclass)
        System.out.println("public: " + obj.publicVar);  // OK

        SubClass s = new SubClass();
        s.display();
    }
}
```

---

## Q7. Differentiate between String and StringBuilder in Java.

### Concept:
Both `String` and `StringBuilder` are used to work with text (sequences of characters) in Java, but they differ fundamentally in how they handle data in memory.

### String:
- **Immutable** — once created, its content cannot be changed.
- Every modification creates a **new String object** in the heap.
- Stored in the **String Constant Pool**.
- Thread-safe (because immutable).
- Use when the string value **won't change frequently**.

### StringBuilder:
- **Mutable** — content can be changed **in place** without creating new objects.
- All modifications happen on the **same object**.
- **Not thread-safe** (use `StringBuffer` for thread safety).
- More **efficient for frequent modifications** (loops, concatenations).

### Differences (Table):

| Feature         | String                        | StringBuilder                    |
|-----------------|-------------------------------|----------------------------------|
| Mutability      | Immutable                     | Mutable                          |
| Memory          | New object per modification   | Same object modified             |
| Thread Safety   | Thread-safe                   | Not thread-safe                  |
| Performance     | Slow for repeated changes     | Fast for repeated changes        |
| Storage         | String Constant Pool          | Heap                             |

### Example:

```java
class StringVsStringBuilder {
    public static void main(String[] args) {
        // String - Immutable
        String s = "Hello";
        System.out.println("Before: " + System.identityHashCode(s));
        s = s + " World";  // New object created
        System.out.println("After:  " + System.identityHashCode(s));
        // Different hash codes - different objects!

        System.out.println("String result: " + s);

        // StringBuilder - Mutable
        StringBuilder sb = new StringBuilder("Hello");
        System.out.println("\nBefore: " + System.identityHashCode(sb));
        sb.append(" World");   // Modifies the SAME object
        System.out.println("After:  " + System.identityHashCode(sb));
        // Same hash code - same object!

        System.out.println("StringBuilder result: " + sb);

        // Performance comparison
        long start, end;

        // String concatenation in loop (slow)
        String str = "";
        start = System.nanoTime();
        for (int i = 0; i < 1000; i++) {
            str += i;  // Creates 1000 new String objects!
        }
        end = System.nanoTime();
        System.out.println("\nString time: " + (end - start) + " ns");

        // StringBuilder in loop (fast)
        StringBuilder sb2 = new StringBuilder();
        start = System.nanoTime();
        for (int i = 0; i < 1000; i++) {
            sb2.append(i);  // Modifies same object
        }
        end = System.nanoTime();
        System.out.println("StringBuilder time: " + (end - start) + " ns");
    }
}
```

---

## Q8. Write a program to check if marks exceed a threshold, and throw custom exceptions accordingly.

### Concept:
Custom exceptions allow us to create application-specific exception types by extending `Exception` or `RuntimeException`. Here we create exceptions for marks that are too high or too low.

```java
// Custom exception for marks below minimum
class MarksToLowException extends Exception {
    MarksToLowException(String msg) {
        super(msg);
    }
}

// Custom exception for marks above maximum
class MarksToHighException extends Exception {
    MarksToHighException(String msg) {
        super(msg);
    }
}

class MarksValidator {
    static final int MIN_MARKS = 0;
    static final int MAX_MARKS = 100;
    static final int PASS_THRESHOLD = 35;

    static void validateMarks(int marks) throws MarksToLowException, MarksToHighException {
        if (marks < MIN_MARKS) {
            throw new MarksToLowException("Marks cannot be negative! Entered: " + marks);
        }
        if (marks > MAX_MARKS) {
            throw new MarksToHighException("Marks cannot exceed 100! Entered: " + marks);
        }
        if (marks < PASS_THRESHOLD) {
            System.out.println("Marks = " + marks + " | Result: FAIL (below threshold of " + PASS_THRESHOLD + ")");
        } else {
            System.out.println("Marks = " + marks + " | Result: PASS");
        }
    }

    public static void main(String[] args) {
        int[] testMarks = {85, 30, -5, 110, 35};

        for (int m : testMarks) {
            try {
                validateMarks(m);
            } catch (MarksToLowException e) {
                System.out.println("MarksToLowException: " + e.getMessage());
            } catch (MarksToHighException e) {
                System.out.println("MarksToHighException: " + e.getMessage());
            }
        }
    }
}
```

**Output:**
```
Marks = 85 | Result: PASS
Marks = 30 | Result: FAIL (below threshold of 35)
MarksToLowException: Marks cannot be negative! Entered: -5
MarksToHighException: Marks cannot exceed 100! Entered: 110
Marks = 35 | Result: PASS
```

---

## Q9. Create a user-defined exception `InvalidValueException` triggered when a number is not equal to 10.

### Concept:
A **user-defined (custom) exception** is created by extending the `Exception` class. It allows meaningful, domain-specific exception messages.

```java
// Step 1: Create custom exception
class InvalidValueException extends Exception {
    int value;

    InvalidValueException(int val) {
        super("Invalid value: " + val + ". Expected value is 10.");
        this.value = val;
    }
}

// Step 2: Class that uses the custom exception
class ValueChecker {
    static void checkValue(int num) throws InvalidValueException {
        if (num != 10) {
            throw new InvalidValueException(num);  // Trigger custom exception
        }
        System.out.println("Value is valid: " + num);
    }

    public static void main(String[] args) {
        int[] numbers = {10, 5, 10, 99, 7};

        for (int n : numbers) {
            try {
                checkValue(n);
            } catch (InvalidValueException e) {
                System.out.println("Caught InvalidValueException: " + e.getMessage());
            }
        }
    }
}
```

**Output:**
```
Value is valid: 10
Caught InvalidValueException: Invalid value: 5. Expected value is 10.
Value is valid: 10
Caught InvalidValueException: Invalid value: 99. Expected value is 10.
Caught InvalidValueException: Invalid value: 7. Expected value is 10.
```

---

## Q10. Consider the code and determine output for each command line:

### The Code (Repeated for Reference):
```java
class Test {
    public static void main(String ar[]) {
        int a = 0;
        try {
            a = convert(ar[1]) / ar.length;
        }
        catch (ArithmeticException e) {
            System.out.println("Division by zero");
        }
        catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Improper Argument");
        }
        catch (Exception e) {
            System.out.println("Something Else");
        }
        finally {
            System.out.println("a=" + a);
        }
    }

    static int convert(String str) {
        return Integer.parseInt(str);
    }
}
```

### Analysis:

#### (i) `java Test`
- `ar[]` is empty (no arguments). `ar.length = 0`.
- `ar[1]` → throws `ArrayIndexOutOfBoundsException` (index 1 doesn't exist).
- `a` remains `0`.

**Output:**
```
Improper Argument
a=0
```

#### (ii) `java Test 25`
- `ar[] = {"25"}`. `ar.length = 1`. `ar[1]` doesn't exist.
- `ar[1]` → throws `ArrayIndexOutOfBoundsException`.
- `a` remains `0`.

**Output:**
```
Improper Argument
a=0
```

#### (iii) `java Test 25 10`
- `ar[] = {"25", "10"}`. `ar.length = 2`.
- `ar[1] = "10"`. `convert("10") = 10`.
- `a = 10 / 2 = 5`. No exception.
- `finally` runs.

**Output:**
```
a=5
```

#### (iv) `java Test 25 a`
- `ar[] = {"25", "a"}`. `ar.length = 2`.
- `ar[1] = "a"`. `convert("a")` → `Integer.parseInt("a")` → throws `NumberFormatException`.
- `NumberFormatException` is a subclass of `RuntimeException` which is a subclass of `Exception`.
- Caught by `catch(Exception e)`.
- `a` remains `0`.

**Output:**
```
Something Else
a=0
```

---

## Q11. Explain the purpose and usage of the `final` keyword in Java.

### Concept:
The `final` keyword in Java is a **non-access modifier** that restricts further modification. It can be applied to **variables**, **methods**, and **classes**.

### 1. `final` Variable:
- Value cannot be changed once assigned (**constant**).
- Must be initialized at declaration or in the constructor.
- By convention, named in UPPERCASE.

### 2. `final` Method:
- Cannot be **overridden** by subclasses.
- Used to prevent unintended changes to behavior.

### 3. `final` Class:
- Cannot be **extended/inherited**.
- Example: `String`, `Integer`, `Math` are all `final` classes in Java.

### Example:

```java
final class MathConstants {   // final class - cannot be inherited
    final double PI = 3.14159;   // final variable - constant value

    final double circleArea(double r) {   // final method - cannot be overridden
        return PI * r * r;
    }
}

// This would cause a compile error:
// class ExtendedMath extends MathConstants {}  // ERROR: cannot inherit from final class

class FinalDemo {
    public static void main(String[] args) {
        MathConstants mc = new MathConstants();
        System.out.println("PI = " + mc.PI);
        System.out.println("Area = " + mc.circleArea(5));

        // mc.PI = 3.14;  // ERROR: cannot assign a value to final variable PI
    }
}
```

**Output:**
```
PI = 3.14159
Area = 78.53975
```

---

## Q12. Differentiate between handled, unhandled, checked, and unchecked exceptions with examples.

### Concept:
Java exceptions are classified in multiple ways:

### Checked vs Unchecked:

| Feature         | Checked Exception                          | Unchecked Exception                     |
|-----------------|--------------------------------------------|-----------------------------------------|
| Detection       | Detected at **compile time**               | Detected at **runtime**                 |
| Handling        | **Must** be handled or declared with throws| Handling is optional                    |
| Superclass      | Extends `Exception` (not RuntimeException) | Extends `RuntimeException`              |
| Examples        | `IOException`, `SQLException`              | `NullPointerException`, `ArithmeticException` |

### Handled vs Unhandled:

- **Handled Exception:** The exception is caught and dealt with in a try-catch block. Program continues normally.
- **Unhandled Exception:** No try-catch is present; the exception propagates up, and if not caught anywhere, the **JVM terminates the program** with an error message.

### Example:

```java
import java.io.*;

class ExceptionTypes {
    public static void main(String[] args) {
        // 1. Checked Exception - HANDLED
        try {
            FileReader fr = new FileReader("test.txt");  // IOException (checked)
        } catch (IOException e) {
            System.out.println("Handled checked exception: " + e.getMessage());
        }

        // 2. Unchecked Exception - HANDLED
        try {
            int result = 10 / 0;   // ArithmeticException (unchecked)
        } catch (ArithmeticException e) {
            System.out.println("Handled unchecked exception: " + e.getMessage());
        }

        // 3. Unchecked Exception - UNHANDLED (would crash the program)
        // String s = null;
        // s.length();   // NullPointerException - if not in try-catch, program crashes

        System.out.println("Program continues after handled exceptions.");
    }
}
```

**Output:**
```
Handled checked exception: test.txt (No such file or directory)
Handled unchecked exception: / by zero
Program continues after handled exceptions.
```

---

## Q13. What is an error? How is it different from an exception?

### Concept:
In Java, the `Throwable` class is the parent of all error and exception classes.

```
Throwable
├── Error          (serious system-level problems)
└── Exception      (application-level problems)
    ├── RuntimeException   (unchecked)
    └── Others             (checked)
```

### Error:
- Represents **serious system-level problems** that are beyond the control of the application.
- Usually indicates a problem with the **JVM environment**, hardware, or system resources.
- **Cannot and should not be caught** in normal programs.
- Examples: `OutOfMemoryError`, `StackOverflowError`, `VirtualMachineError`.

### Exception:
- Represents **application-level problems** that can be anticipated and handled.
- Can (and often should) be caught and recovered from.
- Examples: `IOException`, `NullPointerException`, `ArithmeticException`.

### Differences (Table):

| Feature         | Error                              | Exception                           |
|-----------------|------------------------------------|-------------------------------------|
| Severity        | Very serious (system failure)      | Less serious (application fault)    |
| Recoverable?    | Generally NOT recoverable          | Generally recoverable               |
| Should catch?   | No                                 | Yes                                 |
| Cause           | JVM/system resource problems       | Programming logic or I/O issues     |
| Examples        | `OutOfMemoryError`, `StackOverflowError` | `IOException`, `ArithmeticException` |

### Example:

```java
class ErrorVsException {
    // Causes StackOverflowError (infinite recursion)
    static void infiniteRecursion() {
        infiniteRecursion();
    }

    public static void main(String[] args) {
        // Catching Exception - normal practice
        try {
            int[] arr = new int[5];
            arr[10] = 1;  // ArrayIndexOutOfBoundsException
        } catch (Exception e) {
            System.out.println("Exception caught: " + e.getMessage());
        }

        // Catching Error - generally not recommended
        try {
            infiniteRecursion();
        } catch (StackOverflowError e) {
            System.out.println("Error caught: StackOverflowError - " + e);
        }
    }
}
```

**Output:**
```
Exception caught: Index 10 out of bounds for length 5
Error caught: StackOverflowError - java.lang.StackOverflowError
```

---

## Q14. Justify: String is immutable but StringBuilder is mutable, with example.

### Concept:
- **Immutable** means the state of the object **cannot be changed** after it is created.
- **Mutable** means the state of the object **can be changed** after it is created.

### Why String is Immutable:
1. Strings are stored in the **String Constant Pool**. Multiple references can point to the same string. If strings were mutable, changing one reference would affect all others.
2. Immutability makes strings **thread-safe** without synchronization.
3. Strings are used as **keys in HashMap**, hash codes must remain consistent.
4. Java designers explicitly made `String` immutable for **security and caching** benefits.

When you "modify" a String (e.g., `s = s + "World"`), Java actually:
- Creates a **new String object** with the new value.
- Makes `s` reference the new object.
- The old object remains unchanged in the pool.

### Why StringBuilder is Mutable:
`StringBuilder` stores characters in an internal `char[]` array that can grow and be modified. All `append()`, `insert()`, `delete()` etc. operations modify the **same internal array**, not create new objects.

### Example:

```java
class MutabilityDemo {
    public static void main(String[] args) {
        // --- String Immutability ---
        String s1 = "Hello";
        String s2 = s1;  // Both s1 and s2 point to same object

        System.out.println("Before modification:");
        System.out.println("s1: " + s1 + " | hashCode: " + System.identityHashCode(s1));
        System.out.println("s2: " + s2 + " | hashCode: " + System.identityHashCode(s2));

        s1 = s1 + " World";  // New String object created; s1 now points to new object
        System.out.println("\nAfter s1 = s1 + \" World\":");
        System.out.println("s1: " + s1 + " | hashCode: " + System.identityHashCode(s1)); // DIFFERENT
        System.out.println("s2: " + s2 + " | hashCode: " + System.identityHashCode(s2)); // UNCHANGED

        // --- StringBuilder Mutability ---
        StringBuilder sb1 = new StringBuilder("Hello");
        StringBuilder sb2 = sb1;  // Both point to same object

        System.out.println("\nBefore modification:");
        System.out.println("sb1: " + sb1 + " | hashCode: " + System.identityHashCode(sb1));
        System.out.println("sb2: " + sb2 + " | hashCode: " + System.identityHashCode(sb2));

        sb1.append(" World");  // SAME object modified
        System.out.println("\nAfter sb1.append(\" World\"):");
        System.out.println("sb1: " + sb1 + " | hashCode: " + System.identityHashCode(sb1)); // SAME
        System.out.println("sb2: " + sb2 + " | hashCode: " + System.identityHashCode(sb2)); // ALSO CHANGED (same object!)
    }
}
```

**Output (hash codes may vary):**
```
Before modification:
s1: Hello | hashCode: 366712642
s2: Hello | hashCode: 366712642

After s1 = s1 + " World":
s1: Hello World | hashCode: 1829164700   ← NEW object
s2: Hello       | hashCode: 366712642   ← OLD object unchanged

Before modification:
sb1: Hello | hashCode: 2018699554
sb2: Hello | hashCode: 2018699554

After sb1.append(" World"):
sb1: Hello World | hashCode: 2018699554  ← SAME object
sb2: Hello World | hashCode: 2018699554  ← SAME object, value changed
```

This conclusively proves String is immutable and StringBuilder is mutable.

---

## Q15. Explain how to create and use a custom exception class in Java.

### Concept:
A **custom exception** (user-defined exception) is a new exception class created to represent domain-specific error conditions. It is created by **extending** `Exception` (for checked) or `RuntimeException` (for unchecked).

### Steps to Create a Custom Exception:
1. Create a class that **extends** `Exception` or `RuntimeException`.
2. Add a **constructor** that calls `super(message)` to set the error message.
3. Optionally, add extra fields for more context.
4. Use `throw` to raise it in your code.
5. Use `throws` in the method signature (for checked exceptions).
6. Use `try-catch` to handle it.

### Example:

```java
// Step 1 & 2: Create custom exception
class InsufficientFundsException extends Exception {
    double amount;  // Extra context: how much was short

    InsufficientFundsException(double amount) {
        super("Insufficient funds! Short by: Rs." + amount);
        this.amount = amount;
    }
}

// Step 3: Class using the custom exception
class BankAccount {
    private String owner;
    private double balance;

    BankAccount(String owner, double balance) {
        this.owner = owner;
        this.balance = balance;
    }

    // Step 4 & 5: throw and throws
    void withdraw(double amount) throws InsufficientFundsException {
        if (amount > balance) {
            double shortfall = amount - balance;
            throw new InsufficientFundsException(shortfall);
        }
        balance -= amount;
        System.out.println("Withdrew: Rs." + amount + " | Remaining: Rs." + balance);
    }

    void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: Rs." + amount + " | Balance: Rs." + balance);
    }
}

class CustomExceptionDemo {
    public static void main(String[] args) {
        BankAccount acc = new BankAccount("Alice", 5000);

        try {
            acc.withdraw(3000);   // Valid
            acc.withdraw(3000);   // Insufficient funds
        } catch (InsufficientFundsException e) {
            // Step 6: Handle it
            System.out.println("Caught: " + e.getMessage());
            System.out.println("Short by: Rs." + e.amount);
        }
    }
}
```

**Output:**
```
Withdrew: Rs.3000.0 | Remaining: Rs.2000.0
Caught: Insufficient funds! Short by: Rs.1000.0
Short by: Rs.1000.0
```

---

## Q16. What will be the output of the following code?

### Code:
```java
class Demo {
    void show() {}
}

class Demo2 extends Demo {
    void show() throws IllegalAccessException, ArithmeticException {
        System.out.println("In Demo1 Show");
    }

    public static void main(String args[]) {
        try {
            Demo2 d = new Demo2();
            d.show();
        } catch (Exception e) {
        }
    }
}
```

### Analysis:

**Key Concept – Exception in Overriding:**
> When overriding a method, the overriding method cannot declare **new or broader checked exceptions** than those declared by the parent method. However, it **can** declare unchecked (runtime) exceptions freely.

- `Demo.show()` declares **no exceptions**.
- `Demo2.show()` tries to declare `throws IllegalAccessException, ArithmeticException`.
  - `ArithmeticException` → **Unchecked** (extends RuntimeException) → **ALLOWED** ✅
  - `IllegalAccessException` → **Checked** → **NOT ALLOWED** ❌ (parent doesn't declare it)

**This code will result in a COMPILE-TIME ERROR:**
```
Demo2.java: show() in Demo2 cannot override show() in Demo;
overridden method does not throw IllegalAccessException
```

**If we assume** the code compiles (i.e., remove `IllegalAccessException`), the output would be:
```
In Demo1 Show
```

---

## Q17. Explain the concept of nested classes in Java with example.

### Concept:
A **nested class** is a class defined **inside another class**. Java supports four types:

1. **Static Nested Class** – Declared `static` inside outer class. Does not need outer class object.
2. **Inner Class (Non-static)** – Non-static class inside outer class. Needs outer class object.
3. **Local Class** – Defined inside a method. Scope limited to that method.
4. **Anonymous Class** – A class without a name, defined and instantiated in one expression.

### Why use nested classes?
- Logically groups classes that are used together.
- Increases encapsulation.
- Can make code more readable.

### Example:

```java
class Outer {
    private int outerData = 100;

    // 1. Static Nested Class
    static class StaticNested {
        void display() {
            System.out.println("Static Nested Class");
            // Cannot access outerData directly (no outer instance)
        }
    }

    // 2. Inner Class (Non-static)
    class Inner {
        void display() {
            System.out.println("Inner Class. Outer data: " + outerData);  // Can access outer members
        }
    }

    void outerMethod() {
        // 3. Local Class
        class LocalClass {
            void display() {
                System.out.println("Local Class inside outerMethod. Data: " + outerData);
            }
        }
        LocalClass lc = new LocalClass();
        lc.display();
    }
}

interface Greeting {
    void greet();
}

class NestedClassDemo {
    public static void main(String[] args) {
        // Static Nested Class - no outer object needed
        Outer.StaticNested sn = new Outer.StaticNested();
        sn.display();

        // Inner Class - outer object needed
        Outer outerObj = new Outer();
        Outer.Inner inner = outerObj.new Inner();
        inner.display();

        // Local Class - accessed via method call
        outerObj.outerMethod();

        // 4. Anonymous Class
        Greeting g = new Greeting() {
            @Override
            public void greet() {
                System.out.println("Hello from Anonymous Class!");
            }
        };
        g.greet();
    }
}
```

**Output:**
```
Static Nested Class
Inner Class. Outer data: 100
Local Class inside outerMethod. Data: 100
Hello from Anonymous Class!
```

---

## Q18. Write a program to validate command-line arguments count, throwing exception if less than a given number.

### Concept:
We create a custom exception `InsufficientArgumentsException` that is thrown when the number of command-line arguments provided is less than the required count.

```java
// Custom exception for insufficient arguments
class InsufficientArgumentsException extends Exception {
    InsufficientArgumentsException(int required, int provided) {
        super("Insufficient arguments! Required: " + required + ", Provided: " + provided);
    }
}

class ArgValidator {
    // Method that validates argument count
    static void validateArgs(String[] args, int required) throws InsufficientArgumentsException {
        if (args.length < required) {
            throw new InsufficientArgumentsException(required, args.length);
        }
    }

    public static void main(String[] args) {
        int REQUIRED_ARGS = 3;  // Minimum required arguments

        try {
            validateArgs(args, REQUIRED_ARGS);
            System.out.println("Argument count valid! Processing arguments:");
            for (int i = 0; i < args.length; i++) {
                System.out.println("  Arg[" + i + "] = " + args[i]);
            }
        } catch (InsufficientArgumentsException e) {
            System.out.println("Error: " + e.getMessage());
            System.out.println("Usage: java ArgValidator <arg1> <arg2> <arg3> ...");
        }
    }
}
```

**Running:**
- `java ArgValidator` → `Error: Insufficient arguments! Required: 3, Provided: 0`
- `java ArgValidator a b` → `Error: Insufficient arguments! Required: 3, Provided: 2`
- `java ArgValidator a b c` → `Argument count valid! Processing...`

---

## Q19. Explain the role of the `finally` block with Java code.

### Concept:
The `finally` block is a special block in Java's exception handling that **always executes**, regardless of whether an exception occurred or was caught. It is used for **cleanup operations** like closing files, releasing database connections, or freeing resources.

### Key Points:
- Executes **after** try and catch blocks.
- Executes whether exception is thrown or not.
- Executes even if `return` is used in try or catch.
- Only exception: it won't execute if `System.exit()` is called or JVM crashes.

### Example:

```java
import java.io.*;

class FinallyDemo {
    // Case 1: No exception
    static void case1() {
        System.out.println("\n--- Case 1: No Exception ---");
        try {
            System.out.println("try: Normal execution");
        } catch (Exception e) {
            System.out.println("catch: " + e.getMessage());
        } finally {
            System.out.println("finally: Always executes (cleanup here)");
        }
    }

    // Case 2: Exception is caught
    static void case2() {
        System.out.println("\n--- Case 2: Exception Caught ---");
        try {
            System.out.println("try: Before exception");
            int x = 10 / 0;  // ArithmeticException
            System.out.println("try: After exception (never runs)");
        } catch (ArithmeticException e) {
            System.out.println("catch: Caught ArithmeticException");
        } finally {
            System.out.println("finally: Runs after catch block too");
        }
    }

    // Case 3: Exception not caught (propagates), finally still runs
    static void case3() {
        System.out.println("\n--- Case 3: Exception Not Caught ---");
        try {
            System.out.println("try: Before exception");
            throw new RuntimeException("Uncaught!");
        } finally {
            System.out.println("finally: Runs even when exception is not caught!");
        }
    }

    // Case 4: finally with return in try
    static int case4() {
        System.out.println("\n--- Case 4: return in try ---");
        try {
            return 1;  // finally still runs before actual return!
        } finally {
            System.out.println("finally: Runs even before return!");
        }
    }

    public static void main(String[] args) {
        case1();
        case2();
        try {
            case3();  // Wrap in try since it throws
        } catch (Exception e) {
            System.out.println("main caught: " + e.getMessage());
        }
        int val = case4();
        System.out.println("Return value: " + val);
    }
}
```

**Output:**
```
--- Case 1: No Exception ---
try: Normal execution
finally: Always executes (cleanup here)

--- Case 2: Exception Caught ---
try: Before exception
catch: Caught ArithmeticException
finally: Runs after catch block too

--- Case 3: Exception Not Caught ---
try: Before exception
finally: Runs even when exception is not caught!
main caught: Uncaught!

--- Case 4: return in try ---
finally: Runs even before return!
Return value: 1
```

---

## Q20. Justify the statement: Java is both compiled and interpreted language.

### Concept:
Java uses a **two-stage execution model** that makes it both compiled and interpreted:

### Stage 1 – Compilation (Compiled):
- The Java source code (`.java` file) is **compiled** by the Java Compiler (`javac`) into **bytecode** (`.class` file).
- Bytecode is **not machine code** – it is an intermediate, platform-neutral representation.
- This compilation detects **syntax and type errors** at compile time.

### Stage 2 – Interpretation / JIT (Interpreted):
- The JVM (**Java Virtual Machine**) **interprets** the bytecode at runtime.
- Modern JVMs use **JIT (Just-In-Time) Compiler** which compiles frequently-used bytecode into native machine code for better performance.
- The JVM acts as a virtual interpreter between bytecode and the actual hardware.

### Diagram:
```
Source Code (.java)
       ↓   [javac - Compiler]
Bytecode (.class)
       ↓   [JVM - Interpreter / JIT]
Machine Code (Platform-specific)
```

### Why this makes Java Platform Independent:
- The **same bytecode** can run on any machine that has a JVM.
- "Write Once, Run Anywhere" (WORA) principle.

### Justification Summary:
- **Compiled**: Source → Bytecode (by javac)
- **Interpreted**: Bytecode → Machine Code (by JVM/JIT at runtime)
- Hence, Java is **both compiled AND interpreted**.

---

## Q21. Differentiate between an abstract class and an interface with proper examples.

### Concept:
Both are used to achieve **abstraction** in Java, but they differ in their purpose and capabilities.

### Differences (Table):

| Feature               | Abstract Class                          | Interface                               |
|-----------------------|-----------------------------------------|-----------------------------------------|
| Keyword               | `abstract class`                        | `interface`                             |
| Methods               | Can have abstract + concrete methods    | Only abstract methods (Java 7), can have `default` and `static` methods (Java 8+) |
| Variables             | Can have instance variables             | Only `public static final` (constants)  |
| Constructors          | Can have constructors                   | Cannot have constructors                |
| Inheritance           | `extends` (single)                      | `implements` (multiple allowed)         |
| Access modifiers      | Any                                     | `public` by default                     |
| Usage                 | "IS-A" relationship + shared code      | "CAN-DO" / capability contract          |

### Example:

```java
// Abstract Class Example
abstract class Animal {
    String name;  // Instance variable

    Animal(String name) {  // Constructor
        this.name = name;
    }

    abstract void sound();  // Abstract method

    void breathe() {        // Concrete method
        System.out.println(name + " breathes oxygen");
    }
}

// Interface Example
interface Swimmable {
    int MAX_DEPTH = 100;  // public static final by default
    void swim();          // public abstract by default
    default void float_() {  // default method (Java 8+)
        System.out.println("Floating on water");
    }
}

interface Flyable {
    void fly();
}

// Class using both abstract class and interface
class Duck extends Animal implements Swimmable, Flyable {
    Duck(String name) {
        super(name);
    }

    @Override
    public void sound() {
        System.out.println(name + " says: Quack!");
    }

    @Override
    public void swim() {
        System.out.println(name + " is swimming");
    }

    @Override
    public void fly() {
        System.out.println(name + " is flying low");
    }
}

class AbstractInterfaceDemo {
    public static void main(String[] args) {
        Duck d = new Duck("Donald");
        d.sound();
        d.breathe();
        d.swim();
        d.float_();
        d.fly();
    }
}
```

**Output:**
```
Donald says: Quack!
Donald breathes oxygen
Donald is swimming
Floating on water
Donald is flying low
```

---

## Q22. Create `Shape` class with `getDim()` and `showDim()`, subclass `Rectangle` with overriding `showDim()`.

### Concept:
**Method Overriding** allows a subclass to provide its own implementation of a method defined in the parent class. The `@Override` annotation helps ensure correctness.

```java
import java.util.Scanner;

class Shape {
    double dim1, dim2;

    // Accept dimensions
    void getDim() {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter dimension 1: ");
        dim1 = sc.nextDouble();
        System.out.print("Enter dimension 2: ");
        dim2 = sc.nextDouble();
    }

    // Display dimensions (parent version)
    void showDim() {
        System.out.println("Dimension 1: " + dim1);
        System.out.println("Dimension 2: " + dim2);
    }
}

class Rectangle extends Shape {
    // Overrides parent's showDim()
    @Override
    void showDim() {
        System.out.println("Rectangle Dimensions:");
        System.out.println("  Length = " + dim1);
        System.out.println("  Breadth = " + dim2);
        System.out.println("  Area = " + (dim1 * dim2));
        System.out.println("  Perimeter = " + 2 * (dim1 + dim2));
    }
}

// Driver class
class ShapeDriver {
    public static void main(String[] args) {
        System.out.println("=== Shape (Parent) ===");
        Shape s = new Shape();
        s.getDim();
        s.showDim();   // Calls Shape's showDim()

        System.out.println("\n=== Rectangle (Child) ===");
        Rectangle r = new Rectangle();
        r.getDim();    // Inherited from Shape
        r.showDim();   // Calls Rectangle's overridden showDim()

        System.out.println("\n=== Dynamic Dispatch ===");
        Shape shapeRef = new Rectangle();  // Parent ref, child object
        shapeRef.getDim();
        shapeRef.showDim();  // Calls Rectangle's showDim() at runtime
    }
}
```

**Sample Output:**
```
=== Shape (Parent) ===
Enter dimension 1: 5
Enter dimension 2: 3
Dimension 1: 5.0
Dimension 2: 3.0

=== Rectangle (Child) ===
Enter dimension 1: 8
Enter dimension 2: 4
Rectangle Dimensions:
  Length = 8.0
  Breadth = 4.0
  Area = 32.0
  Perimeter = 24.0
```

---

## Q23. Justify why an abstract method cannot be declared as `final`.

### Concept:
The `abstract` and `final` keywords are **mutually contradictory** and cannot be used together. Here's why:

### `abstract` method:
- An abstract method has **no body/implementation**.
- It **must be overridden** by subclasses to provide implementation.
- The entire purpose of `abstract` is to **force subclasses to override** it.

### `final` method:
- A final method **cannot be overridden** by any subclass.
- It is used to **prevent modification** of the method's behavior.

### Contradiction:
- `abstract` says: "You **must** override this method."
- `final` says: "You **cannot** override this method."
- Both cannot be true at the same time — they are logically opposite.
- If a method is both `abstract` and `final`, no subclass could override it, yet it has no body. The method would be **useless and unimplementable**.

### Example (Demonstrating the Error):

```java
abstract class Vehicle {
    // ERROR: Illegal combination of modifiers: abstract and final
    // abstract final void start();  // COMPILE ERROR!

    abstract void start();   // Valid: must be overridden
    final void stop() {      // Valid: cannot be overridden
        System.out.println("Vehicle stopped.");
    }
}

class Car extends Vehicle {
    @Override
    void start() {   // MUST override abstract method
        System.out.println("Car started with key");
    }
    // Cannot override stop() - it's final
}

class AbstractFinalDemo {
    public static void main(String[] args) {
        Car c = new Car();
        c.start();
        c.stop();
    }
}
```

**Output:**
```
Car started with key
Vehicle stopped.
```

**Justification:** An abstract method is a **contract for overriding**, while final is a **restriction on overriding**. They are semantically opposite. Java enforces this at compile time by flagging `abstract final` as an **illegal combination of modifiers**.

---

## Q24. Justify: Reassigning a String variable creates a new object instead of modifying the old one.

### Concept:
Java maintains a **String Constant Pool** (part of the heap), which is a special memory area where String literals are stored. When a String is created with a literal, Java first checks the pool. If the value exists, it reuses it; otherwise, it adds it.

### Why String is Immutable:
The internal `char[]` array of a `String` object is declared as `final` and is never changed. Any "modification" operation returns a **new String object**.

### Justification with Example:

```java
class StringReassignDemo {
    public static void main(String[] args) {
        // Step 1: "Hello" is created in String Pool
        String s = "Hello";
        System.out.println("s = " + s);
        System.out.println("Hash before: " + System.identityHashCode(s));

        // Step 2: s is "reassigned"
        // Java does NOT modify "Hello"
        // Instead: creates NEW String "Hello World" and makes s point to it
        s = s + " World";
        System.out.println("\ns = " + s);
        System.out.println("Hash after: " + System.identityHashCode(s));
        // Hash is DIFFERENT --> new object was created

        // Step 3: Original "Hello" still exists in pool (GC may collect later)
        String original = "Hello";   // Reuses the same "Hello" from pool
        System.out.println("\noriginal = " + original);

        // Step 4: concat() also creates a new object
        String s2 = "Java";
        String s3 = s2.concat(" Language");
        System.out.println("\ns2 = " + s2 + " | Hash: " + System.identityHashCode(s2));
        System.out.println("s3 = " + s3 + " | Hash: " + System.identityHashCode(s3));
        // s2 is unchanged ("Java"), s3 is new object ("Java Language")
    }
}
```

**Output (hash codes vary):**
```
s = Hello
Hash before: 366712642

s = Hello World
Hash after: 1829164700   ← Different hash = new object

original = Hello

s2 = Java     | Hash: 2018699554
s3 = Java Language | Hash: 1311053135  ← Different hash = new object
```

**Conclusion:** Every time a String variable is reassigned, the JVM creates a **new String object**. The original object in the pool remains unchanged. This confirms that String is **immutable** and reassignment does **not modify** the old object but creates a new one.

---

## Q25. Define an interface `Queue` with operations enqueue, dequeue, and isEmpty. Implement it using arrays.

### Concept:
A **Queue** is a **FIFO (First In, First Out)** data structure. An interface defines the contract; the implementation class provides the actual logic.

```java
// Interface defining Queue operations
interface Queue {
    void enqueue(int element);   // Add to rear
    int dequeue();               // Remove from front
    boolean isEmpty();           // Check if empty
    void display();              // Show all elements
}

// Array-based implementation
class ArrayQueue implements Queue {
    private int[] arr;
    private int front, rear, size, capacity;

    ArrayQueue(int capacity) {
        this.capacity = capacity;
        arr = new int[capacity];
        front = 0;
        rear = -1;
        size = 0;
    }

    @Override
    public void enqueue(int element) {
        if (size == capacity) {
            System.out.println("Queue Overflow! Cannot enqueue " + element);
            return;
        }
        rear = (rear + 1) % capacity;  // Circular array
        arr[rear] = element;
        size++;
        System.out.println("Enqueued: " + element);
    }

    @Override
    public int dequeue() {
        if (isEmpty()) {
            System.out.println("Queue Underflow! Cannot dequeue.");
            return -1;
        }
        int element = arr[front];
        front = (front + 1) % capacity;
        size--;
        System.out.println("Dequeued: " + element);
        return element;
    }

    @Override
    public boolean isEmpty() {
        return size == 0;
    }

    @Override
    public void display() {
        if (isEmpty()) {
            System.out.println("Queue is empty.");
            return;
        }
        System.out.print("Queue (front to rear): ");
        for (int i = 0; i < size; i++) {
            System.out.print(arr[(front + i) % capacity] + " ");
        }
        System.out.println();
    }
}

class QueueDemo {
    public static void main(String[] args) {
        Queue q = new ArrayQueue(5);

        q.enqueue(10);
        q.enqueue(20);
        q.enqueue(30);
        q.display();

        q.dequeue();
        q.display();

        q.enqueue(40);
        q.enqueue(50);
        q.enqueue(60);
        q.enqueue(70);  // Overflow

        q.display();

        System.out.println("Is empty? " + q.isEmpty());
    }
}
```

**Output:**
```
Enqueued: 10
Enqueued: 20
Enqueued: 30
Queue (front to rear): 10 20 30
Dequeued: 10
Queue (front to rear): 20 30
Enqueued: 40
Enqueued: 50
Enqueued: 60
Queue Overflow! Cannot enqueue 70
Queue (front to rear): 20 30 40 50 60
Is empty? false
```

---

## Q26. Demonstrate that a try block can have multiple catch blocks with example.

### Concept:
A single `try` block can be followed by **multiple catch blocks**, each handling a different type of exception. Java evaluates catch blocks **in order from top to bottom** and executes the **first matching** catch block.

### Rules:
1. More **specific** (subclass) exceptions must come **before** more general (superclass) ones.
2. Only **one** catch block executes per exception.
3. If no catch matches, the exception propagates up.

```java
class MultipleCatchDemo {
    public static void main(String[] args) {
        String[] names = {"Alice", null, "Bob"};
        int[] divisors = {2, 0, 1};

        System.out.println("Test 1: Normal execution");
        testMultipleCatch(names, divisors, 0, 1);  // valid index, divisor=2

        System.out.println("\nTest 2: Division by zero");
        testMultipleCatch(names, divisors, 0, 1);  // divisor=0 -> ArithmeticException (via idx 1)
        testMultipleCatch(names, divisors, 1, 1);

        System.out.println("\nTest 3: Null string");
        testMultipleCatch(names, divisors, 1, 2);  // null name -> NullPointerException

        System.out.println("\nTest 4: Array index out of bounds");
        testMultipleCatch(names, divisors, 5, 0);  // invalid index
    }

    static void testMultipleCatch(String[] names, int[] divisors, int nameIdx, int divIdx) {
        try {
            String name = names[nameIdx];       // Might throw ArrayIndexOutOfBoundsException
            int len = name.length();            // Might throw NullPointerException
            int result = len / divisors[divIdx]; // Might throw ArithmeticException
            System.out.println("Name: " + name + " | Length: " + len + " | Result: " + result);
        }
        catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("ArrayIndexOutOfBoundsException: " + e.getMessage());
        }
        catch (NullPointerException e) {
            System.out.println("NullPointerException: name is null!");
        }
        catch (ArithmeticException e) {
            System.out.println("ArithmeticException: " + e.getMessage());
        }
        catch (Exception e) {  // Generic catch - must be last
            System.out.println("General Exception: " + e.getMessage());
        }
    }
}
```

**Output:**
```
Test 1: Normal execution
Name: Alice | Length: 5 | Result: 2

Test 2: Division by zero
Name: Alice | Length: 5 | Result: 2
ArithmeticException: / by zero

Test 3: Null string
NullPointerException: name is null!

Test 4: Array index out of bounds
ArrayIndexOutOfBoundsException: Index 5 out of bounds for length 3
```

---

## Q27. Explain why multiple inheritance is not supported in Java classes, with a program example.

### Concept:
**Multiple inheritance** means a class inheriting from **more than one parent class**. Java **does not support** multiple inheritance through classes because of the **Diamond Problem**.

### The Diamond Problem:
```
        A
       / \
      B   C
       \ /
        D
```
If both `B` and `C` override a method from `A`, and `D` inherits from both `B` and `C`, which version does `D` get? This creates **ambiguity**. The JVM cannot resolve it automatically.

### Java's Solution:
- Java **does not allow** `class D extends B, C`.
- Java provides **interfaces** to achieve a form of multiple inheritance without ambiguity. Interfaces don't have state, so the Diamond Problem is avoided (and Java 8+ resolves default method conflicts explicitly).

### Example:

```java
// If Java allowed this (it DOESN'T), the following would be ambiguous:
class A {
    void show() { System.out.println("A's show()"); }
}

class B extends A {
    @Override
    void show() { System.out.println("B's show()"); }
}

class C extends A {
    @Override
    void show() { System.out.println("C's show()"); }
}

// COMPILE ERROR: class D extends B, C { }  // ILLEGAL IN JAVA
// Java would not know whether to call B's show() or C's show()

// ------- Java's Solution: Use Interfaces -------
interface Printable {
    default void print() {
        System.out.println("Printable print()");
    }
}

interface Showable {
    default void print() {
        System.out.println("Showable print()");
    }
}

class MyClass implements Printable, Showable {
    // MUST override print() to resolve ambiguity
    @Override
    public void print() {
        Printable.super.print();  // Explicitly choose which
        System.out.println("MyClass resolved the conflict.");
    }
}

class MultipleInheritanceDemo {
    public static void main(String[] args) {
        MyClass obj = new MyClass();
        obj.print();  // No ambiguity - explicitly resolved
    }
}
```

**Output:**
```
Printable print()
MyClass resolved the conflict.
```

---

## Q28. What is an abstract method? Explain with a Java example.

### Concept:
An **abstract method** is a method that:
- Is declared with the `abstract` keyword.
- Has **no body/implementation** (no `{ }`).
- Must be declared inside an **abstract class** or an **interface**.
- **Must be overridden** by any concrete (non-abstract) subclass.

### Purpose:
Abstract methods define a **contract** — they tell subclasses "you must implement this." They enable **polymorphism** by allowing different implementations of the same method signature in different subclasses.

### Syntax:
```java
abstract returnType methodName(parameters);  // No body
```

### Example:

```java
abstract class Employee {
    String name;
    int id;

    Employee(String name, int id) {
        this.name = name;
        this.id = id;
    }

    // Abstract method - no body
    abstract double calculateSalary();

    // Concrete method
    void displayInfo() {
        System.out.println("Employee: " + name + " (ID: " + id + ")");
        System.out.println("Salary: Rs." + calculateSalary());
    }
}

class FullTimeEmployee extends Employee {
    double monthlySalary;

    FullTimeEmployee(String name, int id, double monthlySalary) {
        super(name, id);
        this.monthlySalary = monthlySalary;
    }

    @Override
    double calculateSalary() {   // Must implement abstract method
        return monthlySalary;
    }
}

class PartTimeEmployee extends Employee {
    double hourlyRate;
    int hoursWorked;

    PartTimeEmployee(String name, int id, double hourlyRate, int hoursWorked) {
        super(name, id);
        this.hourlyRate = hourlyRate;
        this.hoursWorked = hoursWorked;
    }

    @Override
    double calculateSalary() {   // Different implementation
        return hourlyRate * hoursWorked;
    }
}

class AbstractMethodDemo {
    public static void main(String[] args) {
        // Employee e = new Employee("X", 1);  // ERROR: Cannot instantiate abstract class

        Employee e1 = new FullTimeEmployee("Alice", 101, 50000);
        Employee e2 = new PartTimeEmployee("Bob", 102, 200, 120);

        e1.displayInfo();
        System.out.println();
        e2.displayInfo();
    }
}
```

**Output:**
```
Employee: Alice (ID: 101)
Salary: Rs.50000.0

Employee: Bob (ID: 102)
Salary: Rs.24000.0
```

---

## Q29. Create abstract class `BankAccount` with abstract methods `deposit()` and `withdraw()`. Implement `CurrentAccount`.

### Concept:
An abstract class acts as a **template**. `BankAccount` defines the blueprint (attributes + abstract behavior), and `CurrentAccount` provides the concrete implementation.

```java
// Abstract class BankAccount
abstract class BankAccount {
    protected double balance;
    protected String accountId;
    protected String holderName;

    BankAccount(String accountId, String holderName, double initialBalance) {
        this.accountId = accountId;
        this.holderName = holderName;
        this.balance = initialBalance;
    }

    // Abstract methods - must be implemented by subclasses
    abstract void deposit(double amount);
    abstract void withdraw(double amount);

    // Concrete method
    void displayDetails() {
        System.out.println("-----------------------------");
        System.out.println("Account ID  : " + accountId);
        System.out.println("Holder Name : " + holderName);
        System.out.println("Balance     : Rs." + balance);
        System.out.println("-----------------------------");
    }
}

// Concrete subclass: CurrentAccount
class CurrentAccount extends BankAccount {
    private double overdraftLimit;  // Current accounts allow overdraft

    CurrentAccount(String accountId, String holderName, double initialBalance, double overdraftLimit) {
        super(accountId, holderName, initialBalance);
        this.overdraftLimit = overdraftLimit;
    }

    @Override
    void deposit(double amount) {
        if (amount <= 0) {
            System.out.println("Deposit amount must be positive.");
            return;
        }
        balance += amount;
        System.out.println("Deposited: Rs." + amount + " | New Balance: Rs." + balance);
    }

    @Override
    void withdraw(double amount) {
        if (amount <= 0) {
            System.out.println("Withdrawal amount must be positive.");
            return;
        }
        if (balance - amount < -overdraftLimit) {
            System.out.println("Withdrawal of Rs." + amount + " denied! Overdraft limit exceeded.");
            return;
        }
        balance -= amount;
        System.out.println("Withdrawn: Rs." + amount + " | New Balance: Rs." + balance);
        if (balance < 0) {
            System.out.println("[Warning: Account is in overdraft by Rs." + (-balance) + "]");
        }
    }
}

// Test/Driver class
class BankTest {
    public static void main(String[] args) {
        CurrentAccount ca = new CurrentAccount("CA-001", "Raj Sharma", 10000, 5000);

        System.out.println("Initial Account Details:");
        ca.displayDetails();

        ca.deposit(5000);
        ca.withdraw(3000);
        ca.withdraw(15000);   // Overdraft
        ca.withdraw(20000);   // Exceeds overdraft limit
        ca.deposit(-100);     // Invalid deposit

        System.out.println("\nFinal Account Details:");
        ca.displayDetails();
    }
}
```

**Output:**
```
Initial Account Details:
-----------------------------
Account ID  : CA-001
Holder Name : Raj Sharma
Balance     : Rs.10000.0
-----------------------------
Deposited: Rs.5000.0 | New Balance: Rs.15000.0
Withdrawn: Rs.3000.0 | New Balance: Rs.12000.0
Withdrawn: Rs.15000.0 | New Balance: Rs.-3000.0
[Warning: Account is in overdraft by Rs.3000.0]
Withdrawal of Rs.20000.0 denied! Overdraft limit exceeded.
Deposit amount must be positive.

Final Account Details:
-----------------------------
Account ID  : CA-001
Holder Name : Raj Sharma
Balance     : Rs.-3000.0
-----------------------------
```

---

## Q30. Describe the use of the `super` keyword in inheritance with example.

### Concept:
The `super` keyword in Java refers to the **immediate parent class**. It is used in three contexts:

1. **`super()`** — Call parent class constructor.
2. **`super.variable`** — Access parent class variable (when hidden by child).
3. **`super.method()`** — Call parent class method (when overridden by child).

### Rules:
- `super()` must be the **first statement** in a child constructor.
- Can only be used inside a **subclass**.
- Cannot be used in `static` methods.

### Example:

```java
class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
        System.out.println("Person constructor called");
    }

    void display() {
        System.out.println("Name: " + name + ", Age: " + age);
    }

    String getRole() {
        return "Person";
    }
}

class Student extends Person {
    String course;
    int rollNo;
    String name;  // Hides parent's name (for demo)

    Student(String name, int age, String course, int rollNo) {
        super(name, age);  // 1. Calls parent constructor
        this.name = "Student: " + name;  // Child's own name
        this.course = course;
        this.rollNo = rollNo;
        System.out.println("Student constructor called");
    }

    @Override
    void display() {
        super.display();   // 3. Calls parent's display() method
        System.out.println("Course: " + course + ", Roll No: " + rollNo);
        System.out.println("Child name: " + name);          // Child's name
        System.out.println("Parent name: " + super.name);   // 2. Access parent's name
    }

    @Override
    String getRole() {
        return super.getRole() + " -> Student";  // Extends parent method result
    }
}

class SuperKeywordDemo {
    public static void main(String[] args) {
        Student s = new Student("Ankit", 20, "Computer Science", 101);
        System.out.println("\n--- Display ---");
        s.display();
        System.out.println("\nRole: " + s.getRole());
    }
}
```

**Output:**
```
Person constructor called
Student constructor called

--- Display ---
Name: Ankit, Age: 20
Course: Computer Science, Roll No: 101
Child name: Student: Ankit
Parent name: Ankit

Role: Person -> Student
```

---

## Q31. Differentiate between `final`, `finally`, and `finalize` with examples.

### Concept:
These three keywords/methods in Java sound similar but serve completely different purposes.

### `final`:
- A **keyword** used to restrict modification.
- Applied to: **variable** (constant), **method** (cannot be overridden), **class** (cannot be inherited).

### `finally`:
- A **block** used in exception handling.
- Always executes after try-catch, used for **cleanup** (closing resources).

### `finalize`:
- A **method** of the `Object` class.
- Called by the **Garbage Collector** just before an object is destroyed.
- Used for cleanup of resources before object is collected.
- Deprecated since Java 9.

### Differences (Table):

| Feature     | `final`               | `finally`             | `finalize`              |
|-------------|----------------------|----------------------|-------------------------|
| Type        | Keyword              | Block                | Method                  |
| Purpose     | Prevent modification  | Cleanup in exception handling | Pre-GC cleanup     |
| Applied to  | Variable/Method/Class | try-catch blocks     | Objects                 |
| Execution   | At definition         | Always after try-catch | When GC runs           |

### Example:

```java
class Resource {
    String name;

    Resource(String name) {
        this.name = name;
        System.out.println(name + " created.");
    }

    // finalize() - called by GC before destroying the object
    @Override
    protected void finalize() throws Throwable {
        System.out.println(name + " is being garbage collected.");
        super.finalize();
    }
}

final class Demonstration {      // final class - cannot be inherited
    final int MAX = 100;          // final variable - constant

    final void show() {           // final method - cannot be overridden
        System.out.println("Max value: " + MAX);
    }

    void exceptionDemo(int divisor) {
        try {
            int result = MAX / divisor;
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {               // finally block - always executes
            System.out.println("finally block: cleanup done.");
        }
    }
}

class FinalFinallyFinalizeDemo {
    public static void main(String[] args) throws Exception {
        Demonstration d = new Demonstration();
        d.show();

        System.out.println("\n--- finally demo (no exception) ---");
        d.exceptionDemo(5);

        System.out.println("\n--- finally demo (with exception) ---");
        d.exceptionDemo(0);

        System.out.println("\n--- finalize demo ---");
        Resource r = new Resource("FileConnection");
        r = null;  // Make eligible for GC
        System.gc();  // Request GC (not guaranteed to run immediately)
        Thread.sleep(1000);  // Give GC a chance
    }
}
```

**Output:**
```
Max value: 100

--- finally demo (no exception) ---
Result: 20
finally block: cleanup done.

--- finally demo (with exception) ---
Caught: / by zero
finally block: cleanup done.

--- finalize demo ---
FileConnection created.
FileConnection is being garbage collected.
```

---

## Q32. Compare abstract classes and interfaces. Can one replace the other? Justify with example.

### Concept:
Both abstract classes and interfaces are tools for **abstraction**, but they serve different design purposes.

### Comparison (Table):

| Feature               | Abstract Class                           | Interface                                     |
|-----------------------|------------------------------------------|-----------------------------------------------|
| Instantiation         | Cannot instantiate                        | Cannot instantiate                            |
| Methods               | Abstract + concrete                       | Abstract + default + static (Java 8+)         |
| Instance variables    | Yes (any type)                            | No (only public static final constants)       |
| Constructors          | Yes                                       | No                                            |
| Inheritance           | Single (`extends`)                        | Multiple (`implements`)                       |
| Access modifiers      | Any                                       | Public by default                             |
| State (instance vars) | Can maintain state                        | Cannot maintain state                         |
| Use case              | Shared code + common state               | Pure capability/contract definition           |

### Can one replace the other?
**No, they cannot always replace each other.** Here's why:

- An **interface cannot replace abstract class** when you need:
  - Instance variables (non-constant state)
  - Constructors
  - Protected/private methods

- An **abstract class cannot replace interface** when you need:
  - A class to inherit from multiple "contracts" (multiple inheritance)
  - You want to add capability to unrelated classes

### Example:

```java
// Abstract class - maintains state (balance), has constructors
abstract class Account {
    protected double balance;  // Instance variable (state)

    Account(double balance) {
        this.balance = balance;
    }

    abstract void calculateInterest();

    void displayBalance() {
        System.out.println("Balance: Rs." + balance);
    }
}

// Interface - defines capability (can be applied to any class)
interface Taxable {
    double TAX_RATE = 0.18;  // constant only
    double calculateTax();   // abstract by default
}

interface Printable {
    void printStatement();
}

// SavingsAccount extends Account AND implements multiple interfaces
class SavingsAccount extends Account implements Taxable, Printable {
    double interestRate;

    SavingsAccount(double balance, double interestRate) {
        super(balance);  // Abstract class constructor
        this.interestRate = interestRate;
    }

    @Override
    public void calculateInterest() {
        double interest = balance * interestRate / 100;
        System.out.println("Interest: Rs." + interest);
        balance += interest;
    }

    @Override
    public double calculateTax() {
        return balance * TAX_RATE;
    }

    @Override
    public void printStatement() {
        System.out.println("=== Statement ===");
        displayBalance();
        System.out.println("Tax: Rs." + calculateTax());
    }
}

class AbstractVsInterfaceDemo {
    public static void main(String[] args) {
        SavingsAccount sa = new SavingsAccount(50000, 8);
        sa.calculateInterest();
        sa.printStatement();
    }
}
```

**Output:**
```
Interest: Rs.4000.0
=== Statement ===
Balance: Rs.54000.0
Tax: Rs.9720.0
```

**Conclusion:** Neither can fully replace the other. Use **abstract class** for shared state/behavior; use **interface** for defining capabilities across unrelated class hierarchies.

---

## Q33. Demonstrate the concept of method overloading using a real-world example.

### Concept:
**Method Overloading** is defining multiple methods with the **same name** but **different parameter lists** in the same class. The compiler decides which method to call based on the **number, type, and order of arguments** at compile time.

### Real-world Example: ATM / Bank Calculator
A bank calculator that can compute interest in different ways — with different inputs.

```java
class BankCalculator {
    // Overloaded method 1: Simple interest (int years)
    double calculateInterest(double principal, double rate, int years) {
        return (principal * rate * years) / 100;
    }

    // Overloaded method 2: Simple interest (double years - fractional)
    double calculateInterest(double principal, double rate, double years) {
        return (principal * rate * years) / 100;
    }

    // Overloaded method 3: Fixed default rate (only principal and years)
    double calculateInterest(double principal, int years) {
        double DEFAULT_RATE = 7.5;
        return (principal * DEFAULT_RATE * years) / 100;
    }

    // Overloaded method 4: Monthly calculation
    double calculateInterest(double principal, double rate, int years, boolean monthly) {
        if (monthly) {
            return (principal * rate * (years * 12)) / 1200;
        }
        return (principal * rate * years) / 100;
    }
}

class PrintHelper {
    // Overloaded print methods (real-world: like System.out.println)
    static void print(String label, double value) {
        System.out.printf("%-30s: Rs.%.2f%n", label, value);
    }

    static void print(String label, String value) {
        System.out.printf("%-30s: %s%n", label, value);
    }
}

class OverloadingDemo {
    public static void main(String[] args) {
        BankCalculator bc = new BankCalculator();

        System.out.println("======= Bank Interest Calculator =======");

        double interest1 = bc.calculateInterest(100000, 8.5, 3);   // integer years
        PrintHelper.print("SI (100000, 8.5%, 3 yrs)", interest1);

        double interest2 = bc.calculateInterest(100000, 8.5, 2.5); // fractional years
        PrintHelper.print("SI (100000, 8.5%, 2.5 yrs)", interest2);

        double interest3 = bc.calculateInterest(100000, 5);        // default rate
        PrintHelper.print("SI (100000, default rate, 5 yrs)", interest3);

        double interest4 = bc.calculateInterest(100000, 6.0, 2, true); // monthly
        PrintHelper.print("SI monthly (100000, 6%, 2 yrs)", interest4);

        System.out.println("=========================================");
        PrintHelper.print("Account Type", "Savings");  // String overload
    }
}
```

**Output:**
```
======= Bank Interest Calculator =======
SI (100000, 8.5%, 3 yrs)      : Rs.25500.00
SI (100000, 8.5%, 2.5 yrs)    : Rs.21250.00
SI (100000, default rate, 5 yrs): Rs.37500.00
SI monthly (100000, 6%, 2 yrs) : Rs.12000.00
=========================================
Account Type                   : Savings
```

---

## Q34. Write a Java program to demonstrate passing objects as method parameters.

### Concept:
In Java, **objects are passed by reference** (technically, the reference/address is passed by value). This means:
- Changes made to the **object's fields** inside a method **are reflected** outside.
- Reassigning the reference inside the method **does not affect** the original reference.

This is different from primitive types, where a copy of the value is passed (changes don't reflect outside).

### Example:

```java
class Student {
    String name;
    int marks;
    String grade;

    Student(String name, int marks) {
        this.name = name;
        this.marks = marks;
        this.grade = "Not Assigned";
    }

    void display() {
        System.out.println("Name: " + name + " | Marks: " + marks + " | Grade: " + grade);
    }
}

class Processor {
    // Method 1: Modify object fields - changes ARE reflected outside
    static void assignGrade(Student s) {
        if (s.marks >= 90) s.grade = "A+";
        else if (s.marks >= 75) s.grade = "A";
        else if (s.marks >= 60) s.grade = "B";
        else if (s.marks >= 40) s.grade = "C";
        else s.grade = "F";

        System.out.println("Inside assignGrade: " + s.name + " -> " + s.grade);
    }

    // Method 2: Calculate total marks of two students (takes two objects)
    static int totalMarks(Student s1, Student s2) {
        return s1.marks + s2.marks;
    }

    // Method 3: Swap students (reassigning ref - does NOT affect original)
    static void trySwap(Student s1, Student s2) {
        Student temp = s1;
        s1 = s2;
        s2 = temp;
        System.out.println("Inside trySwap: s1=" + s1.name + ", s2=" + s2.name);
    }

    // Method 4: Return modified object
    static Student createTopperCopy(Student s) {
        Student topper = new Student(s.name + " (Topper)", s.marks + 5);
        topper.grade = "A+";
        return topper;
    }
}

class PassObjectDemo {
    public static void main(String[] args) {
        Student s1 = new Student("Arjun", 85);
        Student s2 = new Student("Priya", 92);
        Student s3 = new Student("Ravi", 55);

        System.out.println("=== Before Processing ===");
        s1.display();
        s2.display();
        s3.display();

        // Method 1: Modify object's fields
        System.out.println("\n=== After assignGrade ===");
        Processor.assignGrade(s1);
        Processor.assignGrade(s2);
        Processor.assignGrade(s3);
        s1.display();   // Grade changed!
        s2.display();
        s3.display();

        // Method 2: Multiple objects as parameters
        System.out.println("\n=== Total Marks ===");
        int total = Processor.totalMarks(s1, s2);
        System.out.println("Total of " + s1.name + " and " + s2.name + ": " + total);

        // Method 3: Swap (references NOT swapped outside)
        System.out.println("\n=== Before Swap ===");
        System.out.println("s1=" + s1.name + ", s2=" + s2.name);
        Processor.trySwap(s1, s2);
        System.out.println("After trySwap (outside): s1=" + s1.name + ", s2=" + s2.name);
        // Still Arjun and Priya - local swap doesn't affect original refs

        // Method 4: Return new object
        System.out.println("\n=== Topper Copy ===");
        Student topper = Processor.createTopperCopy(s2);
        topper.display();
    }
}
```

**Output:**
```
=== Before Processing ===
Name: Arjun | Marks: 85 | Grade: Not Assigned
Name: Priya | Marks: 92 | Grade: Not Assigned
Name: Ravi  | Marks: 55 | Grade: Not Assigned

=== After assignGrade ===
Inside assignGrade: Arjun -> A
Inside assignGrade: Priya -> A+
Inside assignGrade: Ravi -> C
Name: Arjun | Marks: 85 | Grade: A
Name: Priya | Marks: 92 | Grade: A+
Name: Ravi  | Marks: 55 | Grade: C

=== Total Marks ===
Total of Arjun and Priya: 177

=== Before Swap ===
s1=Arjun, s2=Priya
Inside trySwap: s1=Priya, s2=Arjun
After trySwap (outside): s1=Arjun, s2=Priya

=== Topper Copy ===
Name: Priya (Topper) | Marks: 97 | Grade: A+
```

---

*End of All 34 Java Questions and Answers*
