# cordic_ip


## Introduction

The CORDIC (COordinate Rotation DIgital Computer) was developed by Jack Volder in 1959 as an iterative algorithm algorithm to convert between polar and cartesian coordinates using shift, add and subtract operations only:

- Implemented with a Shift-Add/Subtract type algorithm
- Can be used to compute trigonometric, hyperbolic, linear and logarithmic functions
    - Examples: sine, cosine, polar to rectangular coordinates, etc
- CORDIC algorithm generally produce one additional bit of accuracy for each iteration
- Applications
    - Math co-processor, calculators, radar signal processors, robotics

## Circular rotation mode

In the circular rotation mode a CORDIC fuction could compute the cartisian coordinates of the target vector $\mathbf{v_{n}}$ by rotating the input vector $\mathbf{v_{0}}$ by an arbitrary angle $\phi$. So how do we calculate $x_{n}$ and $y_{n}$ based on the input vector and angle?
    
We start from the idea that we have a vector $\mathbf{v_{0}}$, a rotation matrix $\mathbf{M}$ and that by multiplying them we generate a vector $\mathbf{v_{n}}$.

<p align="center" width="100%">
  <img width="33%" src="images/vector_diagram.png" />
</p>

```math
\mathbf{v_{0}} = 
\left[ 
  \begin{array}{c}
    x_{0}\\
    y_{0}
  \end{array}
\right] 

\quad \mathrm{,} \quad

\mathbf{M} = 
\left[
  \begin{array}{cc}
    \cos \phi & -\sin \phi \\
    \sin \phi & \cos \phi
  \end{array}
\right]

\quad \mathrm{,} \quad

\mathbf{v_{n}} = 
\left[
  \begin{array}{c}
    x_{n} \\
    y_{n}
  \end{array}
\right]
```

then 

```math
\mathbf{v_{0}} \mathbf{M} = \mathbf{v_{n}} 

\quad \text{or} \quad

\left[ 
  \begin{array}{cc}
    \cos \phi & -\sin \phi \\
    \sin \phi & \cos \phi
  \end{array}
\right]

\left[ 
  \begin{array}{c}
    x_{0} \\
    y_{0}
  \end{array}
\right] = 

\left[ 
  \begin{array}{c}
    x_{n} \\
    y_{n}
  \end{array}
\right]
```

so that 

```math
\begin{array}{lll}
  x_{n} & = & x_{0} \cos \phi - y_{0} \sin \phi \\
  y_{n} & = & x_{0} \sin \phi + y_{0} \cos \phi
\end{array}
```

It is important to remember that to obtain the rotation matrix you have to locate the final position to which the unit vectors of the reference plane move, in this particular case the unit vector $\hat{x}$ which originally was at $<1, 0>$ ends in $< \cos \phi, \sin \phi>$, and for the unit vector $\hat{y}$, $<0,1>$ ends in $< \cos \phi + 90^{\circ}, \sin \phi + 90^{\circ} >$ but using the following figure they can be converted to $< -\sin \phi, \cos \phi>$. 

<p align="center" width="100%">
  <img width="33%" src="images/property_sine_and_cosine.png" />
</p>

if we factor $\cos{\phi}$ we get

```math
\begin{array}{lll}
  x_{n} & = & \cos \phi(x_{0} - y_{0} \tan \phi) \\
  y_{n} & = & \cos \phi(y_{0} + x_{0} \tan \phi)
\end{array}
```

If the rotation angles are restricted so that $\tan \phi = \pm 2^{-i}$, the multiplication by the tangent term is reduced to a simple shift operation.

<div align="center">

| $i$      | $\phi$  $=\arctan{(2^{-i})}$ | $\phi \text{ deg}$ | $\phi \text{ rad}$ | $\tan \phi = \pm 2^{i}$ |
| -------- | ---------------------------- | ------------------ | ------------------ | ----------------------- |
| $0$      | $\arctan(1/1)$               | $45.0000$          | $0.7854$           | $1/1$                   |
| $1$      | $\arctan(1/2)$               | $26.5651$          | $0.4636$           | $1/2$                   |
| $2$      | $\arctan(1/4)$               | $14.0362$          | $0.2450$           | $1/4$                   |
| $3$      | $\arctan(1/8)$               | $7.1250$           | $0.1244$           | $1/8$                   |
| $4$      | $\arctan(1/16)$              | $3.5763$           | $0.0624$           | $1/16$                  |
| $5$      | $\arctan(1/32)$              | $1.7899$           | $0.0312$           | $1/32$                  |
| $6$      | $\arctan(1/64)$              | $0.8952$           | $0.0156$           | $1/64$                  |
| $7$      | $\arctan(1/128)$             | $0.4476$           | $0.0078$           | $1/128$                 |
| $8$      | $\arctan(1/256)$             | $0.2238$           | $0.0039$           | $1/256$                 |
| $\vdots$ | $\vdots$                     | $\vdots$           | $\vdots$           | $\vdots$                |

</div>

The desired angle of rotation is obtained by performing a series of successively smaller and smaller elementary rotations. Where:

```math
i = 0, 1, 2, \ldots ,n-1, \;\; \tan \phi = \pm 2 ^{-i}
```

and we define an auxiliary variable to define the direction of rotation as:

```math
Z_{i+1} = Z_{i} - \arctan(d_{i}2^{-i})
```

Lets say our desired rotation is $20$ degrees:

We start at iteration $0$ with an angle of $Z_{0} = 20$. 
- If the angle $Z_{i} > 0$ then we subtract the $\tan \phi$ angle, in other words $d_{i} = 1$, 
- otherwise we add the $\tan \phi$ angle, in other words $d_{i} = -1$,  and also make our appropriate $\mathbf{x_{n}}$ y $\mathbf{y_{n}}$.


<div align="center">

| Iteration | $\arctan(d_{i} 2^{-i})$ | $\tan \phi$ | $Z_{i+1} = Z_{i} - \arctan(d_{i} 2^{-i})$ | ($d_{i}$) |
| --------- | ----------------------- | ----------- | ----------------------------------------- | --------- |
| $0$       | $45.0000$               | $1/1$       | $20.0000 - 45.0000 = -25.0000$            | $+$       |
| $1$       | $26.5651$               | $1/2$       | $-25.0000 + 26.5651 =  1.5651$            | $-$       |
| $2$       | $14.0362$               | $1/4$       | $1.5651 - 14.0362 = -12.4712$             | $+$       |
| $3$       | $7.1250$                | $1/8$       | $-12.4712 +  7.1250 = -5.3462$            | $-$       |
| $4$       | $3.5763$                | $1/16$      | $-5.3462 +  3.5763 = -1.7698$             | $-$       |
| $5$       | $1.7899$                | $1/32$      | $-1.7698 +  1.7899 =  0.0201$             | $-$       |
| $6$       | $0.8952$                | $1/64$      | $0.0201 -  0.8952 = -0.8751$              | $+$       |
| $7$       | $0.4476$                | $1/128$     | $-0.8751 +  0.4476 = -0.4275$             | $-$       |
| $8$       | $0.2238$                | $1/256$     | $-0.4275 +  0.2238 = -0.2037$             | $-$       |
| $\vdots$  | $\vdots$                | $\vdots$    | $\vdots$                                  | $\vdots$  |
| $19$      | $0.0001$                | $1/524288$  | $-0.0002 +  0.0001 = -0.0001$             | $-$       |

</div>

If we add all the angles with the corresponding sign we get:

```math
-45.0000 + 26.5651 - 14.0362 - 7.1250 + 3.5763 + 1.7899 - 0.8952 \approx -20
```

So summarizing the above we can generate an iterative equation if we define the following:

```math
\tan \phi_{i} = 
\left\{
\begin{array}{lcl}
-  2 ^{-i}& \text{ si } & Z_{i} < 0 \\
+  2 ^{-i}& \text{ si } & Z_{i} \geq 0
\end{array}
\right. 
```

written another way:

```math
\tan \phi_{i} =   d_{i}2 ^{-i}
\quad \text{where} \quad

d_{i} = 
\left\{ 
  \begin{array}{lcl}
    -1  & \text{ if } & Z_{i} < 0 \\
    +1  & \text{ if } & Z_{i} \geq 0
  \end{array}
\right.
```

With $i = 0, 1, 2, \ldots ,n-1$, 

Using the cosine property:

```math
\cos (\phi_{i} )=  \cos (-\phi_{i})
```

this means that cosine is independent of the direction of rotation, then we can rewrite our equation $\mathbf{x_{n}}$ y $\mathbf{y_{n}}$ as follows:

```math
\begin{array}{lll}
  x_{i+1} & = & K_{i} (x_{i} - y_{i}  d_{i} 2 ^{-i}) \\
  y_{i+1} & = & K_{i} (y_{i} + x_{i}  d_{i} 2 ^{-i})
\end{array}
```

where:


```math
K_{i} = \cos( \arctan(2^{-i})) = \frac{1}{\sqrt{1 + 2^{-2i}}}
```

note that

```math
\sec \theta = \pm \sqrt{ 1 +\tan^{2} \theta } \quad \text{and} \quad \tan \theta = x \quad  \iff \quad \theta = \arctan x
```

then

```math
\cos \theta = \cos( \arctan(x)) = \pm \frac{1}{\sqrt{1 + x^{2}}}
```



## References

- [1] CORDIC design in Verilog to produce sine and cosine functions, (Nov. 12, 2013). Accessed: Jul. 07, 2024. [Online Video]. Available: <https://www.youtube.com/watch?v=pTgmySlijAs>
