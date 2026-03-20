This folder contains CDDL structures.

The Makefile of this folder is used to validate and compile the CDDL files into a single one (collected.cddl).
It uses the following tool:  
cddlc:
```
gem install cddlc
```

A CDDL structure is included in the document by using:

```
~~~ cddl
{::include cddl/cddl-example.cddl}
~~~
{: #cddlexample title="Example of CDDL"}
```