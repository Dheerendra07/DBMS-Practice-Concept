# DBMS Deadlock

A simple beginner-friendly guide to understand **Deadlock in DBMS** with SQL examples, conditions, prevention methods, detection, and recovery.

---

## 1. What is Deadlock?

A **Deadlock** happens when two or more transactions are waiting for each other to release resources.

Because everyone is waiting, no transaction can continue.

### Simple Example

Suppose we have two accounts:

```text
Account 1
Account 2
```

And two transactions:

```text
Transaction 1 → locks Account 1 → wants Account 2

Transaction 2 → locks Account 2 → wants Account 1
```

Now:

```text
T1 → Account 1 🔒 → waiting for Account 2

T2 → Account 2 🔒 → waiting for Account 1
```

T1 is waiting for T2.

T2 is waiting for T1.

So nobody can continue.

**This is Deadlock.**

---

# 2. Real-Life Example

Imagine two people:

```text
Person A has Pen
Person B has Book
```

A needs the Book to continue.

B needs the Pen to continue.

```text
A → has Pen → waiting for Book
B → has Book → waiting for Pen
```

Nobody gives their resource.

**Deadlock!**

The same concept happens with database transactions and locks.

---

# 3. SQL Example

Suppose we have an `Accounts` table:

```sql
CREATE TABLE Accounts (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    balance INT
);

INSERT INTO Accounts VALUES
(1, 'Aman', 10000),
(2, 'Raj', 10000);
```

---

## Transaction 1

Run this in SQL Session 1:

```sql
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 1000
WHERE id = 1;
```

Transaction 1 now holds a lock on Account 1.

Then it tries to update Account 2:

```sql
UPDATE Accounts
SET balance = balance + 1000
WHERE id = 2;
```

---

## Transaction 2

Run this in another SQL Session:

```sql
START TRANSACTION;

UPDATE Accounts
SET balance = balance - 500
WHERE id = 2;
```

Transaction 2 now holds a lock on Account 2.

Then it tries to update Account 1:

```sql
UPDATE Accounts
SET balance = balance + 500
WHERE id = 1;
```

Now:

```text
Transaction 1:
Account 1 🔒
        ↓
Waiting for Account 2

Transaction 2:
Account 2 🔒
        ↓
Waiting for Account 1
```

This creates a **Deadlock**.

The database detects the situation and normally rolls back one transaction so the other can continue.

---

# 4. Four Necessary Conditions of Deadlock

Deadlock can occur when these **four conditions exist together**.

Remember:

## M H N C

```text
M → Mutual Exclusion
H → Hold and Wait
N → No Preemption
C → Circular Wait
```

---

## 4.1 Mutual Exclusion

A resource can be used by only one transaction at a time.

Example:

```text
Account 1 🔒 → Transaction 1
```

Transaction 2 cannot use the same locked resource at that moment.

### Easy meaning:

> One resource → one transaction at a time.

---

## 4.2 Hold and Wait

A transaction is holding one resource and waiting for another resource.

Example:

```text
T1:
Account 1 🔒
Account 2 ⏳
```

T1 is **holding Account 1** while **waiting for Account 2**.

### Easy meaning:

> Hold one resource + wait for another.

---

## 4.3 No Preemption

A resource cannot simply be taken away from a transaction.

Example:

```text
T1 → Account 1 🔒
```

The system cannot simply forcefully take that lock from T1 whenever it wants.

The transaction normally has to release it.

### Easy meaning:

> Resource cannot be forcibly taken away.

---

## 4.4 Circular Wait

Transactions form a circular waiting relationship.

Example:

```text
T1 → waiting for T2

T2 → waiting for T1
```

Or:

```text
T1 → R2
↑       ↓
R1 ← T2
```

### Easy meaning:

> Everyone is waiting in a circle.

This is the condition that is often prevented using **resource ordering**.

---

# 5. How to Prevent Deadlock?

The main idea is:

> **Break at least one of the four necessary conditions.**

There are different approaches.

---

# 6. Approach 1 — Break Mutual Exclusion

If a resource can safely be shared, make it shareable.

For example, some resources can be read by multiple transactions simultaneously.

But this is **not always possible**.

### Easy idea:

```text
Exclusive resource ❌

Shared resource ✅
```

### Interview point:

> Mutual exclusion can be avoided when the resource is sharable.

---

# 7. Approach 2 — Break Hold and Wait

Instead of allowing a transaction to hold one resource while waiting for another, make it request all required resources together.

Example:

Instead of:

```text
T1:
Get R1
↓
Hold R1
↓
Wait for R2
```

Request:

```text
T1:
Request R1 + R2 together
```

If both are not available, the transaction waits without holding one.

### Easy trick:

> **Don't hold one resource while waiting for another.**

---

# 8. Approach 3 — Break No Preemption

Allow the system to take/release a resource when necessary.

Example:

```text
T1 → holding R1
T1 → waiting for R2
```

If R2 cannot be obtained, the system may make T1 release its resources and retry later.

### Easy meaning:

> Resource can be taken back/released when necessary.

This approach depends on the type of resource and system.

---

# 9. Approach 4 — Break Circular Wait

This is one of the easiest approaches to understand.

Give every resource a fixed order.

Example:

```text
R1 → R2 → R3
```

Every transaction must request resources in this order.

### Wrong:

```text
T1 → R1 → R2

T2 → R2 → R1
```

This can create circular wait.

### Correct:

```text
T1 → R1 → R2

T2 → R1 → R2
```

Now both follow the same order.

Circular waiting cannot be formed in the same way.

### SQL-style example

If working with account IDs:

```text
Always access smaller ID first.

Account 1 → Account 2
```

Instead of allowing:

```text
T1 → Account 1 → Account 2

T2 → Account 2 → Account 1
```

make both follow:

```text
T1 → Account 1 → Account 2

T2 → Account 1 → Account 2
```

### Interview line:

> We can prevent circular wait by assigning a fixed ordering to resources and requiring every transaction to acquire them in that order.

---

# 10. Deadlock Prevention vs Avoidance

These two terms are slightly different.

## Deadlock Prevention

We design the system so that at least one necessary condition of deadlock never occurs.

Example:

```text
Fixed resource ordering
        ↓
Circular Wait prevented
        ↓
Deadlock prevented
```

---

## Deadlock Avoidance

The system checks whether granting a resource could lead to an unsafe state.

A famous algorithm is:

**Banker's Algorithm**

The system grants resources only when the resulting state remains safe.

### Easy difference:

```text
Prevention → Stop deadlock conditions

Avoidance → Check before giving resources
```

---

# 11. Deadlock Detection

Sometimes a system allows deadlock to happen and then checks for it.

A common concept is a **Wait-For Graph**.

Example:

```text
T1 → waiting for T2

T2 → waiting for T1
```

Graph:

```text
T1 → T2
↑     ↓
└─────┘
```

If there is a cycle, it can indicate deadlock.

### Easy trick:

> **Cycle in waiting relationship → possible deadlock.**

---

# 12. Deadlock Recovery

If deadlock is detected, the database/system needs to recover.

Common approaches:

### 1. Rollback a transaction

```text
T1 ❌ rollback

T2 ✅ continues
```

The locks held by T1 are released.

---

### 2. Abort a transaction

One transaction may be terminated so that resources become available.

---

### 3. Retry the transaction

After the deadlock is resolved, the failed transaction can be attempted again.

### Easy idea:

```text
Detect Deadlock
      ↓
Choose transaction
      ↓
Rollback / Abort
      ↓
Release resources
      ↓
Other transaction continues
```

---

# 13. Prevention vs Detection vs Recovery

| Concept    | Meaning                                        |
| ---------- | ---------------------------------------------- |
| Prevention | Deadlock ko hone hi nahi dena                  |
| Avoidance  | Resource dene se pehle safe state check karna  |
| Detection  | Deadlock hua ya nahi check karna               |
| Recovery   | Deadlock milne ke baad system ko recover karna |

---

# 14. Deadlock vs Starvation

These are different.

### Deadlock

Transactions wait for each other forever.

```text
T1 → T2
↑     ↓
└─────┘
```

### Starvation

A transaction keeps waiting because other transactions keep getting the resource first.

```text
T1 → waiting
T2 → gets resource
T3 → gets resource
T4 → gets resource
...
```

### Easy difference:

> **Deadlock = waiting for each other**

> **Starvation = one transaction keeps getting ignored**

---

# 15. Interview Answer

If interviewer asks:

### "What is Deadlock?"

You can answer:

> **Deadlock is a situation where two or more transactions are permanently waiting for resources held by each other, so none of them can proceed. It generally occurs when Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait conditions exist together. We can prevent it by breaking at least one of these conditions, for example by using a fixed ordering of resources to prevent Circular Wait.**

---

# 16. Quick Revision

Remember this:

```text
DEADLOCK
   ↓
4 Conditions
   ↓
M H N C

M → Mutual Exclusion
H → Hold and Wait
N → No Preemption
C → Circular Wait
```

### Prevention

```text
Break any one condition
        ↓
Deadlock Prevention
```

### Most easy example

```text
T1 → R1 🔒 → waits for R2

T2 → R2 🔒 → waits for R1

        ↓

     DEADLOCK
```

### Simple solution

```text
Fixed order:

R1 → R2

Every transaction follows:

R1 → R2

        ↓

Circular Wait ❌
        ↓
Deadlock prevented ✅
```

---

## Interview Cheat Sheet

**Deadlock:** Transactions waiting for each other.

**4 conditions:** Mutual Exclusion, Hold and Wait, No Preemption, Circular Wait.

**Prevention:** Break one necessary condition.

**Avoidance:** Maintain a safe state.

**Detection:** Find deadlock/cycles.

**Recovery:** Rollback/abort a transaction.

**Best beginner example:** Two transactions locking two accounts in opposite order.

**Easy prevention:** Always acquire resources in the same order.
