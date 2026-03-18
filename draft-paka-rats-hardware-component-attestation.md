---
title: "Attestation of Hardware Components"
abbrev: "HW-attest"
category: std

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

# ipr: trust200902 # ? todo: check with legal team

docname: draft-paka-rats-hardware-component-attestation-latest
submissiontype: IETF  # also: "independent", "editorial", "IAB", or "IRTF"
number:
date:
consensus: true
v: 3
area: "Security"
workgroup: "Remote ATtestation ProcedureS"
keyword:
 - attestation
 - hardware
 - root of trust
venue:
  group: "Remote ATtestation ProcedureS"
  type: "Working Group"
  mail: "rats@ietf.org"
  arch: "https://mailarchive.ietf.org/arch/browse/rats/"
  github: "antoinepoulain/hardware-component-attestation"
  latest: "https://antoinepoulain.github.io/hardware-component-attestation/draft-paka-rats-hardware-component-attestation.html"

author:
  - ins: A. Poulain
    name: Antoine Poulain
    org: Secure-IC
    email: antoine.poulain@secure-ic.com
  - ins: A. Kaci
    name: Abdellah Kaci
    org: Secure-IC
    email: abdellah.kaci@secure-ic.com

normative:
  RFC9334:
  RFC9711:

informative:
  ISO5891:
    target: "https://www.iso.org/fr/standard/81806.html"
    title: "ISO/IEC TR 5891:2024, Information security, cybersecurity and privacy protection — Hardware monitoring technology for hardware security assessment"
    date: 2024-04
    author:
       org: "International Standards Organization"

...

--- abstract

TODO Abstract


--- middle

# Introduction

TODO Introduction

# Terminology

The terminology defined in {{RFC9334}} is reused.

## Requirements Notation

{::boilerplate bcp14-tagged}


# Security Considerations

TODO Security

~~~~ aasvg
{::include diagrams/abstract-measurement-circuitry.asciio}
~~~~
{: #abstract_meas_circuit artwork-align="center" title="Abstract Measurement Circuitry"}

~~~~ aasvg
{::include diagrams/basic-figure.asciio}
~~~~
{: #basic_figure artwork-align="center" title="Basic Figure for Testing"}



# IANA Considerations

This document has no IANA actions.


--- back

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
