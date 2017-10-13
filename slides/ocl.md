# OCL
The Object Constraint Language

Gerson Sunyé

gerson.sunye@univ-nantes.fr

note:
    Speaker notes.

----

## Plan
  1. **Introduction**
  2. Invariants
  2. Model Navigation
  3. Property Definition
  4. Operation Specification
  5. Advanced Topics
  6. Conclusion
  7. Appendix - Language Details

----

## Introduction

----

## What is OCL?

OCL stands for «Object Constraint Language». 

OCL is:
- a OMG standard (see http://www.omg.org/spec/OCL/).
- a formal and unambiguous language, but easy to use (even for non mathematicians).
- a complement to UML (and also to MOF, but that is another history).

----
## Why do I need OCL?
Sometimes, the UML lacks precision. Suppose the following class diagram:

![](resources/png/family.png)


- How do you specify that this class only considers people born after 1900?
- And how do you specify that cycles are not allowed (i.e., that a person cannot be an ancestral of himself)?

----
## What About Comments?
<div style="position:absolute; right:0px;  width:300px;font-size: 24pt;"  align="left">
- Comments, expressed in natural languages, are often very useful.
- But sometimes, they are also ambiguous.
- Still, comments cannot avoid some situations.
</div>
<p style="position:absolute;  left:0px; top:100px;" align="center">
![](resources/png/marriage.png)
</p>
<p style="position:absolute;  left:0px; top:300px;" align="center">
![](resources/png/anna-bob-carol.png)	
</p>







----

## How can OCL add more precision to UML?

- By adding *constraints* to modeling elements:

```ocl
context Person
inv: self.wife->notEmpty() implies self.wife.husband = self and
    self.husband->notEmpty() implies self.husband.wife = self
```

![](resources/png/marriage.png)

----


## Plan
  1. Introduction
  2. **Invariants**
  3. Model Navigation
  3. Property Definition
  4. Operation Specification
  5. Advanced Topics
  6. Conclusion
  7. Appendix - Language Details


----

## Invariants

----
## Class Invariants

- A class invariant is a constraint that must be verified by all instances of a class, when in a **stable state**.

- The notion of stable state is important: an invariant may be broken during the execution of an operation.

- It is commonly accepted that an instance is in a stable state between the execution of two public operations.

----

## Invariants: Graphical Notation

Invariants can be placed directly on the modeling element, between braces ({}) or on a comment attached to it:

![](resources/png/person-inv.png)

![](resources/png/person-inv-note.png)

----
## Invariants: Textual Notation

Invariants may also be placed on a separate document. In this case, the notion of **context** is important.

```ocl
context Person inv: self.age < 150
context Person inv: age < 150
```

----
## «Context»

- Every OCL expression is attached to a specific **context**: a UML modeling element.
- The context may be referenced inside the expression using the `self` keyword.

```ocl
context Person inv: self.age < 150
context Person inv: self.name.size() > 0
```
![](resources/png/person-inv.png)

----

##  Context Properties

- The context allows the access to some properties from the attached modeling element.
- In the case of a UML class, this means: attributes, query operations, and states (from attached state machines).


![](resources/png/person.png)

```ocl
context Person
inv:
  self.name.size() > 1 and
  self.age() >= 0 and
  self.oclInState(Single)
```
note:
  While it is possible to check a state within an invariant, this is not logical.

<!--
## Invariants de classe

[comment]:# (%\item Expression OCL stéréotypée \og invariant \fg.)

- Exemples:

```ocl
context e : Etudiant inv: ageMinimum: e.age > 16
context e : Etudiant inv: e.age > 16
context Etudiant inv: self.age > 16
context Etudiant inv: age > 16
```
-->

----
## Plan
  1. Introduction
  2. Invariants
  3. **Model Navigation**
  3. Property Definition
  4. Operation Specification
  5. Advanced Topics
  6. Conclusion
  7. Appendix - Language Details

----

## Model Navigation

----
## OCL & UML: Basic Principles
<div style="position:absolute; left:0px;  width:300px;font-size: 18pt;"  align="left">
- OCL expressions have no side effect, they cannot modify the model.
- A OCL expression refers to the following constituents:
  - Values of basic types: `Integer`, `Real`, `Boolean`, `String`, `UnlimitedNatural`;
  - Modeling elements, from the associated UML model;
  - Collections of values or modeling elements.
</div>
<p style="position:absolute;  right:0px; top:150px; width:600px;">
![](resources/svg/university.svg)
</p>


----
## Operation Call Syntax


- Operation calls on elements and values use **dots**:
```ocl
'Nantes'.substring(1,3) = 'Nan'
```
- Operation calls on collections use **arrows**:
```ocl
{1, 2, 3, 4, 5}->size() = 5
```


----
## Role Navigation

- An OCL expression can navigate through model associations using the opposite role (association end):

![](resources/svg/univ-department.svg)

```ocl
 context Department
    -- A department's university should not be null.
 	inv: not self.university->oclIsUndefined()

 context University
    -- A university must have at leat one department
 	inv: self.department->notEmpty()
```
note:
	Navigation through private roles is possible. 
	It seems that it is also possible to navigate through non-navigable roles.

----

## Multiplicities
<div style="position:absolute; right:0px;  width:600px;font-size: 24pt;"  align="left">
- Le type of an expression (its return type) depends on the role's maximum multiplicity:
	- If equals to 1, it's a simple element.
	- If > 1, it's a collection.
```ocl
context Course
	-- an objet:
	inv: self.instructor.oclInState(Available)

	-- a collection (Set):
	inv: self.is_mastered_by->notEmpty()
```
</div>
<p style="position:absolute;  left:0px; top:100px;" align="center">
![](resources/svg/course.svg)
</p>




----

## Navigation: Special Cases
<div style="position:absolute; right:0px;  width:600px;font-size: 24pt;"  align="left">
- When there is no role name, the OCL uses the class name (in lower cases).
- Monovalued (max multiplicity = 1) roles may be navigated as a collection.

```ocl
context Department inv: self.chef->size() = 1

context Department inv: self.chef.age > 40

context Person inv: self.wife->notEmpty()
    implies self.wife.gender = Gender::female
```
</div>
<p style="position:absolute;  left:0px; top:100px;" align="center">
![](resources/svg/department-professor.svg)
</p>
<p style="position:absolute;  left:0px; top:400px; width:350px" align="center">
![](resources/svg/wife.svg)
</p>


----

<!--
## Rôles: navigation

- Il est possible de combiner des expressions:


```ocl
context Personne inv:
    self.epouse->notEmpty() implies self.epouse.age >= 18 and

    self.mari->notEmpty() implies self.mari.age >= 18
```
-->

## Navigation through Association-Classes

- To navigate towards an association-class, OCL uses the association-class' name, in lower cases.

```ocl
context Student
inv:
    -- A student average grades is always greater than 4:
    self.grade.value->average() > 4
```
![](resources/svg/grade.svg)


----

##  Navigation through Association-Classes

- To navigate from class-association, OCL uses role names:


```ocl
context Grade inv:
    self.students.age() >= 18
    self.follows.hours > 3
```
![](resources/svg/grade.svg)


----

## Qualified Associations

- To navigate through a qualified association, OCL uses the qualifier name between square brackets:

```ocl
context University
    -- The name of student 8764423 must be "Martin".
    inv: self.students[8764423].name = "Martin"
```
- When the qualifier is not precised, the result is a collection:

```ocl
context University
    -- There is at least one student named "Martin":
    inv: self.students->exists(each | each.name = "Martin")
```

![](resources/svg/qualified-association.svg)


----
## Plan
  1. Introduction
  2. Invariants
  2. Model Navigation
  3. **Property Definition**
  4. Operation Specification
  5. Advanced Topics
  6. Conclusion
  7. Appendix - Language Details

----

## Property Definition, Intialization, and Calculation

----

## Property Definition

- OCL allows the definition of new attributes and new operations, and add them to an existing class.
- These new properties can be used within other OCL constraints.

Syntax:
```ocl
context <class-name>
  def: <attr-name> : <type> = <ocl-expression>
  def: <op-name> (<argument-list) : type = <ocl-expression>
```

----

## Property Definition
<div style="position:absolute; left:0px;  width:500px;font-size: 20pt;"  align="left">
- Useful to decompose complex expressions without overloading the model.

Examples:
```ocl
context Professor
def: students() : Bag(Student) = 
	self.teaches.students

context Department
def: students() : Set(Student) = 
	self.instructors.teaches.student->asSet()
```
</div>
<p style="position:absolute;  right:0px; top:150px; width:400px;" align="center">
![](resources/svg/university.svg)
</p>

<!--
inv: self.titre = Titre::prof implies self.eleves()
    ->forAll(each | each.estAdmis())
    -- un professeur a toujours 100\% de reussite
-->

----

## Property Initialization

- Initial value specification for attributes  and roles.

- The expression type must conform to the attribute or role type.

Syntax:
```ocl
context <class-name>::<prop-name>: <type>
    init: <ocl-expression>
```
Example:
```ocl
context Professor::wage : Integer
    init: 800
```


----

## Derived Property Specification
<div style="position:absolute; left:0px;  width:500px;font-size: 24pt;"  align="left">
- OCL expression defining how a derived property is calculated.

Syntax:
```ocl
context <class-name>::<role-name>: <type>
    derive:  <ocl-expression>
```

Examples:
```ocl
context Professor::service : Integer
    derive: self.teaches.hours->sum()

context Person::single : Boolean
    derive: self.partner->isEmpty()
```
</div>
<p style="position:absolute;  right:0px; top:200px; width:200px;" align="center">
![](resources/svg/course.svg)
</p>

----

## Query Operation Specification

- Specification of query operation body.

Example:
```ocl
context University::instructors() : Set(Professor)
body:
    self.departments.instructors->asSet()
```

----

## Plan
  1. Introduction
  2. Invariants
  2. Model Navigation
  3. Property Definition
  4. **Operation Specification**
  5. Advanced Topics
  6. Conclusion
  7. Appendix - Language Details

----

## Operation Specification

----

## Operation Specification

- OCL can be used to specify class operations:
  - Approach inspired from Abstract Types.
  - An operation is defined by:
    - A signature;
	- A precondition; and
	- A postcondition.
  - The precondition constraints the operation input set.
  - The postcondition specifies the operation semantics. 
  
<!--
- Inspirée des types abstraits: une opération est composée d'une signature, de pré-conditions et de post-conditions.
- Permet de contraindre l'ensemble de valeurs d'entrée d'une opération.
- Permet de spécifier la sémantique d'une opération: ce qu'elle fait et non comment elle le fait.
-->
  

----

## Operation Precondition

- A precondition is a constraint that must be verified **before** the execution of the operation.
- Specifies what clients must respect to call the operation.
- Represented by an OCL expression, preceded by `pre:`

```ocl
-- Only professors older than 30 years can be added to the department:
context Department::add(p : Professor) : Integer
    pre: old: not p.age > 30
```

----

## Postconditions

- A postcondition is a constraint that must be verified **after** the execution of the operation.
- Specifies what the operation must accomplish. 
- Represented by an OCL expression preceded by the keyword `post:`

```ocl
context Student::age() : Integer
post correct: result = (today - birthday).years()
```

- The `result` operator gives access to the operation return value.

----

## Property Values

- Within a postcondition, there are **two** available values for each property:
  - Its value **before** the operation execution.
  - Its value **after** the operation execution.

```ocl
context Person::birthday()
	post: age = age@pre + 1

context Professor::raise(v : Integer)
	post: self.wage = self.wage@pre + v
```

- The `@pre` operator gives access to a property's value **before** the operation execution.

----



## Previous Values (1/2)

When the `@pre` value of a property is an object, all the values reached from this objects are new:


```ocl
a.b@pre.c
		-- the old value of b, say X,
		-- and the new value of c of X

a.b@pre.c@pre   
		-- the old value of b , say X,
		-- and the old value of c of X.
```

----
## Previous Values (2/2)

![](resources/svg/atpre.svg)

```ocl
a.b@pre.c -- the new value of b1.c,  c3		
a.b@pre.c@pre  -- the old value of b1.c, c1
a.b.c -- the new value of b2.c, c2
```

----

## Plan
  1. Introduction
  2. Invariants
  2. Model Navigation
  3. Property Definition
  4. Operation Specification
  5. **Advanced Topics**
  6. Conclusion
  7. Appendix - Language Details

----

## Advanced Topics

Tuples, Messages, Constraint Inheritance

----

## Tuples

Definition

**Tuple:**

 > «A Tuple is a a finite sequence of object or components, where each component is named. The component types are potentially different. »

**Examples:**

```ocl
Tuple {name:String = 'Martin', age:Integer = 42}
Tuple {name:'Colette', grades:Collection(Integer) = Set{12, 13, 9},
     diploma:String = 'Computer Science'}
```

----

## Tuple Syntax

- Types are optionals.
- The component order is not relevant.

**Equivalent expressions:**
```ocl
Tuple {name: String = 'Martin,' age: Integer = 42}
Tuple {name = 'Martin,' age = 42}
Tuple {age = 42, name = 'Martin'}
```

----

## Tuple Component Initialization

- OCL expressions can be used to initialize tuple components:

```ocl
context University def:
statistics : Set(Tuple(dpt : Department, studentNb:Integer,
                               graduated: Set(Student), average: Integer)) =
     department->collect(each |
       Tuple {dpt : Department = each,
           studentNb: Integer = each.students()->size(),
           graduated: Set(Student) = each.students()->select(graduated()),
           average: Integer = each.students()->collect(note)->avg()
          }
      )
```

----

## Tuple Component Access


- Component values are accessible through their names, using the dotted notation:


```ocl
Tuple {name:String='Martin', age:Integer = 42}.age = 42
```

- The attribute `statistics` defined previously can be used within another OCL expression:

```ocl
context University inv:
     statistics->sortedBy(average)->last().dpt.name = 'Computer Science'
	 -- CS department has always the best students.
```

----

<!--
%\section{Messages}
%\frame{\tableofcontents[currentsection,hideothersubsections]}

%        \item  Envoi de messages.
%    \end{itemize}
%\begin{ocl}
%context Subject::hasChanged()
%	-- la post-condition doit assurer que le message update()
%	-- a ete envoye a tous les observateurs:
%	post: observers->forAll( o | o^update() )
%\end{ocl}

% \begin{frame}
% \frametitle{Messages}
% %\framesubtitle{}
% A partir de la version 2.0, OCL introduit la notion de \emph{message}, qui permet de mieux lier la partie structurelle d'un modèle à son comportement.
% \end{frame}
-->

## Messages

OCL expressions can verify that a communication happened, using the «`^`» (hasSent) operator:

```ocl
context Subject::hasChanged()
post:  observer^update(12, 14)
```

note:
    The expression `observer^update(12, 14)` evaluates to true if the message `update`, with the arguments 12 and 14 was sent to the object `observer`.
	The statement `update()` is either an operation from observer's class, or a Signal.
	Obviously, the arguments 12 and 14, must conform to the operation's parameters.


----
## Jokers

- When the arguments are not known, the expression can use the operator «`?`» (joker):


```ocl
context Subject::hasChanged()
post:  observer^update(? : Integer, ? : Integer)
```

----
## The `OclMessage`  Type

- The operator «`^^`» (messages) allows an expression to access a sequence of sent messages:

```ocl
context Subject::hasChanged()
post: let messages : Sequence(OclMessage) =
            observer^^update(? : Integer, ? : Integer) in
      messages->notEmpty() and
      messages->exists( m | m.i > 0 and m.j >= m.i )
```


----
## Returned Values

- The operator `OclMessage::result()` allows an expression to access an operation return value (signals do not return values).
- The operator `OclMessage::hasReturned()` returns true if the operation returned a value.

```ocl
context Person::giveSalary(amount : Integer)
post: let message : OclMessage = company^getMoney(amount) in
      message.hasReturned()
      -- getMoney was sent and returned
      and
      message.result()
      -- the getMoney call returned true
```

note:
    Signal messages are asynchronous by definition, they do not have a return value.


<!--
## Stéréotypes des contraintes

Plusieurs stéréotypes sont définis en standard dans UML:

- Invariants de classe: «invariant»
- Pré-conditions: «precondition»
- Post-conditions: «postcondition»
- Définitions de propriétés: «definition»


## Package context

Il est possible de spécifier explicitement le nom du paquetage auquel appartient une contrainte:

```ocl
package Package::SubPackage
context X inv:
    -- some invariant

context X::operation()
pre:
    -- some precondition
endpackage
```

-->


----



## Constraint Inheritance

**Liskov substitution principle (LSP)**

> «In an object-oriented program, if S is a subtype of T, then objects of type T may be replaced with objects of type S (i.e., an object of type T may be substituted with any object of a subtype S).» 

----
## Invariant Inheritance

- Consequence of the LSP on the invariants:

  - Subclasses always inherit invariants.
  - Subclasses can only reinforce an invariant.


----
## Pre- and Post-Condition Inheritance

- Consequences of the LSP on pre and postconditions:
  - A precondition can only be relaxes (contrevariance)
  - A postcondition can only be reinforced (covariance)


----
## Plan

1. Introduction
2. Invariants
2. Model Navigation
3. Property Definition
4. Operation Specification
5. Advanced Topics
5. **Conclusion**
6. Appendix - Language Details

----

## Conclusion

----
## OCL Goals

- Design by contracts allows designers to:
  - be more precise.
  - improve documentation.
  - keep design independent from implementation.
  - Identify component's responsibilities. 

----

##  OCL Usages

- OCL expression can specify:

  - Class invariants;
  - Class attribute initialization;
  - Class derived attributes;
  - New class properties: attributes and _query_ operations;
  - Class operations pre- and post-conditions;
  - Transition guards;
  - Transition pre and postconditions;

note:
    A _query_ operation is operation with no side effect.

----


## Modeling Advices

- Keep things simple: the goal of constraints is to improve the quality of a specification, and not to make it more complex.
- Always combine constraints with natural language: constraints are used to make comments less ambiguous and not to replace them.
- Use a tool.



----

## Usage

- Code generation
  - Contract generation in Eiffel, Sather, Clojure, etc.
  - Tool specific contract generation:  
    - OVal http://oval.sourceforge.net/
	- Contracts for Java (Cofoja) https://github.com/nhatminhle/cofoja
	- Java Modeling Language (JML)
	- valid4j http://www.valid4j.org

- Enhanced test case generation.

----

## References

- The Object Constraint Language \--- Jos Warmer, Anneke Kleppe.
- OCL home page: http://www.klasse.nl/ocl/
- OCL tools: http://www.um.es/giisw/ocltools
- OMG Specification v2.3.1 http://www.omg.org/spec/OCL/Current/
- OMG UML 2.5 Working Group.   

----

## Tools

- Eclipse OCL. https://projects.eclipse.org/projects/modeling.mdt.ocl

- OCL Checker (Klasse Objecten)

- USE OCL (Mark Richters). http://useocl.sourceforge.net/w/

- Dresden OCL. http://www.dresden-ocl.org
- Octopus (Warmer & Kleppe). http://octopus.sourceforge.net/

----
## Plan

1. Introduction
2. Invariants
2. Model Navigation
3. Property Definition
4. Operation Specification
5. Advanced Topics
5. Conclusion
6. **Appendix - Language Details**


----

## Appendix
Language Details

----
## Access to Class-level Properties
- Class-level properties are accessed through double-colons.

Class-level attributes:

```ocl
context Professor inv:
	self.wage < Professor::maximumWage
```

Class-level query operations:
```ocl
context Professor inv:
	self.age() > Student::minimumAge()
```

----
## Access to Enumeration Literals and Nested States

- To avoid name conflicts, enumeration literals are preceded by the enumeration name and double-colons:

```ocl
context Professor inv:
	self.title = Title::full implies
		self.wage > 10
```

- Nested states (from the attached state machine) are preceded by the container state name and double-colons:

```ocl
context Department::add(p:Professor)
	pre:p.oclInState(Unavailable::Holydays)
	-- nested states
```

----

## Basic Types

Type | Values
--|--
`OclInvalid` | invalid
`OclVoid`   | null, invalid
`Boolean`  |  true, false
`Integer`  |  1, -5, 2, 34, 26524, etc.
`Real`  |  1.5, 3.14, etc.
`String`  |  "To be or not to be..."
`UnlimitedNatural`  |  0, 1, 2, 42, ... , *

----

## Collection Types (1/2)

Type | Description | Obtained from | Examples
--|--|--|--
Set  | unordered set.  | Simple navigation  |  \{1, 2, 45, 4\}
OrderedSet  |  ordered set. | Navigation through an ordered association end (labelled with `{ordered}`)  |  \{1, 2, 4, 45\}

----

## Collection Types (2/2)

Type | Description | Obtained from | Examples
--|--|--|--
Bag  | unordered multiset.  | Combined navigations  |  \{1, 3, 4, 3\}
Sequence  | ordered multiset.  |  Navigation though a ordered association end `{ordered}` |   \{1, 3, 3, 5, 7\}, \{1..10\}

----

## Type Conformity Rules

Type | Conforms to | Condition
--|--|--
Set(T1) | Collection(T2)  | If T1 conforms to T2
Sequence(T1) | Collection(T2) | If T1 conforms to T2
Bag(T1) | Collection(T2) | If T1 conforms to T2
OrderedSet(T1) | Collection(T2) | If T1 conforms to T2
Integer | Real  |

----

## Operations on Basic Types

Type | Operations
--|--
`Integer`  |  =, \*, +, -, /, abs(), div(), mod(),max(), min()
`Real`  |  =, \*, +, -, /, abs(), floor(), round(),max(), min(), >, <, <=, >=, ...
`String`  |  =, size(), concat(), substring(), toInteger(), toReal(), toUpper(), toLower()
`Boolean`  |  or, xor, and, not, implies
`UnlimitedNatural`  |  \*,+,/

----

## Operations on Collections

Operations | Behavior
--|--
`isEmpty()` | True if the collection is empty.
`notEmpty()`| Trues if the collection contains at least one element.
`size()`  |  Number of elements in the collection.
`count(<elem>)`| Number of occurrences of `<elem>` in the collection.

Examples:
```ocl
{}->isEmpty()
{1}->notEmpty()
{1,2,3,4,5}->size() = 5
{1,2,3,4,5}->count(2) = 1
```
----

## Complex Operations on Collections

Operation | Behavior
--|--
`select()` | Selects (filters) a subset of the collection.
`reject()` |
`collect()`| Evaluates an expression for each element in the collection.
`collectNested()` |
- `For All`
- `Exists`
- `Closure`
- `Iterate`

----

## Complex Operations on Collections

Complex operations use an iterator (named `each` by convention), a variable that evaluates to each collection element.

Operation | Behavior
--|--
`select(<boolean-expression>)` | Selects (filters) a subset of the collection.
`collect(<expression>)`| Evaluates an expression for each element in the collection.

Examples:
```ocl
{1,2,3,4,5}->select(each | each > 3) = {4,5}
{'a','bb','ccc','dd'}->collect(each | each.toUpper()) = {'A','BB','CCC','DD'}
```

----

## Select and Reject: Syntax

Selects (respectively rejects) the collection subset to which a boolean expression evaluates to true.

```ocl
Collection(T)->select(elem:T | <bool-expr>) : Collection(T)
```

- The element types of the input and the output collections are always the same.
- The size of the output collection is less than or equal to the size of the input collection.


----

## Select and Reject: Examples

- Possible syntaxes:

```ocl
context Department inv:
    -- no iterator
    self.instructors->select(age > 50)->notEmpty()
    self.instructors->reject(age > 23)->isEmpty()

    -- with iterator
    self.instructors->select(each | each.age > 50)->notEmpty()

    -- with typed iterator
    self.instructors->select(each : Professor | each.age > 50)->notEmpty()
```

----

## Collect: Syntax

Evaluates an expression on each collection element and returns another collection containing the results.

```ocl
Collection<T1>->collect(<expr>) : Bag<T2>
```

- The sizes of the input and the output collection are mandatory the same.
- The result is a multiset (`Bag`).
- If the the result of `<expr>` is a collection, the result will not be a collection of collections. The result is automatically flattened.

----

## Collect: Examples

Possible syntaxes:

```ocl
context Department:
    self.instructors->collect(name)
    self.instructors->collect(each | each.name)
    self.instructors->collect(each: Professor | each.name)

    -- Bag to Set conversion:
    self.instructors->collect(name)->asSet()

    -- shortcut:
    self.instructors.name
```

----

## Property Verification on Collections

Operation | Behavior
--|--
`forAll(<boolean-expression>)`| Verifies that **all** the collection elements respect the expression.
`exists(<boolean-expression>)` | Verifies that **at least** the collection elements respect the expression.

Examples:

```ocl
{1,2,3,4,5}->forAll(each | each > 0 and each < 10)
{1,2,3,4,5}->exists(each | each = 3)
```

----

## For All: Syntax

Evaluates a Boolean expression on all elements of a collection and returns true if all evaluations return true.

```ocl
Collection(T)->forAll(elem:T | <bool-expr>) : Boolean
```

----
## For All: Examples

```ocl
context Department inv:
	-- All instructors are associate professors.
	self.instructors->forAll(title = Title::associate)

	self.instructors->forAll(each | each.titre = Title::associate)

	self.instructors->forAll(each: Professor | each.title = Title::associate)
```

----
## For All

Cartesian product:

```ocl
context Department inv:
    self.instructors->forAll(e1, e2 : Professor |
        e1 <> e2 implies e1.name <> e2.name)

-- equivalent to:
    self.instructors->forAll(e1 | self.instructors->
        forAll(e2 | e1 <> e2 implies e1.name <> e2.name))
```

----
## Exists

Returns true if a boolean expression is true for at least one collection element.

Syntax:
```ocl
collection->exists(<boolean-expression>) : Boolean
```

Example:
```ocl
context: Department inv:
    self.instructors->exists(each: Professor |
        each.name = "Martin")
```

----


## Advanced Operations on Collections

Operation | Behavior
--|--
`collectNested(<exp>)` | Similar to `collect()`, but does not flatten the result if it is a collections of collections.
`closure()` | Recursively evaluates and expression.
`iterate()` | Generic operation that applies to any collection.



----


## Collect Nested

Similar to `collect()`, without flattening collections of collections.

```ocl
context University
	-- All university instructors, grouped by department:
	self.department->collectNested(instructors)
```

Collections of collections can be flattened with the `flatten()` operation:

```ocl
    Set{Set{1, 2}, Set{3, 4}} ->flatten() = Set{1, 2, 3, 4}
```

----

## Closures

- The `closure()` operation recursively invokes an OCL expression over a *source* and adds the successive results to the *source*.
- The iteration finishes when the expression evaluation returns an empty set.

Syntax:
```ocl
source->closure(v : <class-name> | <expression-with-v>)
```

<!--
 [comment]: # (The returned collection of the closure iteration is an accumulation of the source, and the collections resulting from the recursive invocation of expression-with-v in which v is associated exactly once with each distinct element of the returned collection.)
 [comment]: # (The iteration terminates when expression-with-v returns empty collections or collections containing only already accumulated elements. The collection type of the result collection is the unique form \(Set or OrderedSet\) of the original source collection. If the source collection is ordered, the result is in depth first preorder.)
-->

Example:

```ocl
context Person
def descendants() : Set(Person) =
self.children->closure(children)
```

<p style="position:absolute;  right:0px; top:500px; width:250px;" align="center">
![](resources/svg/family.svg)
</p>


----
## Iterate

Generic operation on collections.

Syntax:
```ocl
Collection(<T>)->iterate(<elm>: <T>; answer: T = <value> |
    <expr-with-elm-and-response>)
```

Examples:

```ocl
context Department inv:
    self.instructors->select(age > 50)->notEmpty()

    -- equivalent expression:
    self.instructors->iterate(each: Professor;
        answer: Set(Professor) = Set {} |
            if each.age > 50 then answer.including(each)
            else answer endif) -> notEmpty()
```

----
## Other operations on Collections

Operation | Behavior
--|--
`includes(<elem>)`, `excludes(<elem>)`| Checks if `<elem>` belongs (*resp*. not belongs) to the collection.
`includesAll(<coll>)`, `excludesAll(<coll>)` | Checks if all elements of `<coll>` belong (*resp*. not belong) to the collection.
`union(<coll>)`, `intersection(<coll>)` | Set operations.
`asSet()`, `asBag()`, `asSequence()`| Type conversion.
`including(<elem>)`, `excluding(<elem>)`| Creates a new collection that includes (*resp*. excludes) `<elem>`

----

## Predefined Properties

Operation | Behavior
--|--
`oclIsTypeOf(t : OclType):Boolean` |
`oclIsKindOf(t : OclType):Boolean` |
`oclInState(s : OclState):Boolean` |
`oclIsNew():Boolean` |
`oclIsUndefined():Boolean` | 
`oclIsInvalid():Boolean` | 
`oclAsType(t : Type):Type` | 
`allInstances():Set(T)` | 


Examples:
```
context University
    inv: self.oclIsTypeOf(University)     
    inv: not self.oclIsTypeOf(Department) 
```

----

##  `Let`

When an OCL sub-expression appears several times on a constraint, it is
possible to use an **alias** to replace if:

Syntax:
```ocl
let <alias> : <Type> = <ocl-expression> in <expression-with-alias>
```
Example: 
```ocl
context Person inv:
    let income : Integer = self.job.salary->sum() in
    if isUnemployed then
        income < 100
    else
        income >= 100
    endif
```

- Note that this is only an alias, not an assignment. 

----

## Thank you for your attention!
