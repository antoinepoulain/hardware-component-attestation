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

Hardware components form the foundation upon which all computations rely. Therefore, the correctness and integrity of software execution depend on the proper functioning of the underlying hardware, which can be considered a root of trust for computation.

Modern systems increasingly adopt disaggregated architectures, such as chiplet-based designs and large-scale heterogeneous platforms. These systems integrate hardware components from multiple sources, introducing new attack surfaces.

At the same time, zero trust principles encourage reducing reliance on static trust anchors in favor of evidence reflecting the actual runtime state of components. However, current attestation mechanisms for hardware components primarily rely on manufacturer-issued endorsements, which capture properties established prior to deployment but provide limited visibility into runtime hardware behavior.

This document considers a threat model in which hardware components may be affected not only by adversarial actions, but also by physical phenomena such as environmental variations, aging, and natural degradation. These aspects are particularly important in systems with strong safety requirements.

To address these limitations, this document defines a data model and provides guidelines for including hardware component measurements in attestation Evidence, as described in the RATS architecture {{RFC9334}}. By incorporating runtime hardware measurements, attestation can provide improved visibility into the integrity and reliability of systems. This document also outlines a security model for such measurements and provides examples of existing technologies that can be leveraged to obtain them. These examples are informational only and do not mandate specific implementations. Instead, this document remains agnostic to the underlying measurement mechanisms and focuses on defining abstract interfaces and a data model for obtaining and representing such measurements.

# Terminology

The terminology defined in {{RFC9334}} is reused throughout this document.

## Requirements Notation

{::boilerplate bcp14-tagged}

# Scope and Limitations

TODO

# Use Cases

The solution presented in this document aims at mitigating two threats on hardware.

+ Defective hardware components

Malfunction of hardware components may be caused by environment and/or aging. Detection of such malfunctions is critical when relying on systems evolving in hazardous environments such as high pressure, extreme temperatures, contact with water or chemical substances or space radiations.

+ Attacks on hardware components

Gaining control of the hardware of a system is particularly interesting for an attacker as it allows to tamper with the correct functioning of the system at a priviledged level. Such control can be obtained by abusing software mechanisms or by having physical access on the system (particularly relevant for embedded systems).

# Attester Model
The RATS architecture presented in {{RFC9334}} introduces two types of environments in an Attester. The Attesting Environment (AE) is in charge of collecting claims about a Target Environment (TE). The Attesting Environment is then responsible for embedding those claims in an Evidence Conceptual Message.

This document focuses on claims used to represent the state of a target hardware component. Said claims can be related to physical properties (electromagnetic or thermal signature, timing values, power consumption, ...), results of integrated self-tests or collected traces.

## Abstract Representation

Mechanisms for collecting measurements of hardware components may be highly dependent on the type of hardware component and on the desired type of measurement. Therefore, this document proposes an abstract representation of such mechanisms. Considering the measurement mechanism as black boxes with common interfaces, allows the content of this document to remain agnostic of the underlying mechanism and of the type of measurement collected.

The goal of this section is to propose standard interfaces to trigger the computation of the measurement and to collect the computed measurement. Also, this section presents mapping of Attesting Environments and Target Environments in different integration models for these measurement mechanisms.





### Coupled Measurement Circuitry
As shown in {{coupled_meas_circuit}}, a part of the Attesting Environment is located on the Target Component.

~~~~ aasvg
{::include diagrams/coupled-measurement-circuitry.asciio}
~~~~
{: #coupled_meas_circuit artwork-align="center" title="Abstract Representation of Coupled Measurement Circuitry"}

### External Measurement Circuitry
Another Attester layout is to have

Ex: Sensors added on top of hardware component

----------

composite attester, can be many attesting env (and many target envs of course)
An AE may collect on multiple TE

Of course, both coupled and external measurement circuitries can be found in the same system and possibly, they can be used to measure a single Target Envrionment.
TODO this implies that a TE can have multiple measurmeent fields (I think already supported in RATS)

## Measurement Collection Flow

Measurements of hardware components must be included in the Evidence to be sent to a Verifier. This implies that the Attesting Environment possesses a way to trigger and collect the

Measurement computation is triggered by something (boot, external request, watchdog, ...)


Boot

Runtime

Interactions models between the Attester system and external entities such as the Verifier are already presented in other documents (TODO specify which ones).

## Practical Examples
This section is for informational purposes only.

Mapping to BIST and Traces

# Inclusion in Conceptual Messages
This section introduces standard claims to be included in RATS Conceptual Messages.

## Endorsement and Reference Values

CDDL
Possible formats (CoRIM with CoMID, other ?)

## Evidence

CDDL

~~~ cddl
{::include cddl/cddl-example.cddl}
~~~
{: #cddlexample title="Example of CDDL"}

Possible formats (EAT, DICE X.509, custom ?)

# Security Considerations

The security considerations of RATS architecture apply ({{Section 12 of RFC9334}}). This section also mentions protection against physical attacks. These attacks are particularly relevant for this draft as collecting claims about hardware components implies a risk of physical attacks. Aging and action of environment on the system are also considered threats.

The following subsections are mainly focused on security considerations regarding the Attester.

## Software Attacks

There exist software attacks that can have a direct impact on hardware components’ behavior. These are ideally mitigated by good and secure development practices but in case they happen, these attacks can be detected by monitoring physical properties of the component (such as power consumption, thermal and electromagnetic signatures, timing).

Ex: Software-induced Denial-of-Service (DoS).

Ex: Manipulation of privileged power control interface.

## Physical Attacks

Physical attacks target the hardware of the system. They imply physical access to the system during its mission mode or while it is in the supply chain.

### Passive Attacks

Passive physical attacks are used by attackers to leak information through analysis of system physical properties. Passive attacks, by definition, do not modify behavior of the system and therefore cannot alter the correct functioning of the attestation flow.

Ex: Side channel analysis of physical properties (EM emissions, power consumption, timing, temperature, probing ...)

The danger with passive attacks resides in the extraction of sensitive assets and particularly attestation key used to sign Evidence, which can be used for impersonation and Evidence forgery. This is already tackled in {{Section 12.1.1 of RFC9334}}.

### Active Attacks

Active physical attacks are the main problem since they allow an attacker (or a “natural” physical event) to tamper with the integrity of assets and execution flows of the system. These may therefore modify measurements in transit or at rest, inject arbitrary data in Evidence or bypass sensitive operations.

Ex: Attacks on bus (Active man-in-the-middle (MITM), injection, probing) or anywhere measurements are in transit before being integrated in a structure that cannot be tampered or spoofed (signed Evidence).

Ex: Glitching, fault injections to induce malicious behavior. May tamper with the target hardware component itself or the measurement circuitry or the logic used to build Evidence.

Ex: Memory tampering attacks to modify stored measurements.

Some techniques to mitigate physical attacks are usage of a TPM or secure element for storage and correct execution of protected logic, bus protections, redundancy, sensors, active meshes, nose injection, etc... Note that some of these mitigations cannot directly prevent attacks but can be used for detection.

## Supply Chain Attacks

Each stage of the supply chain introduces a new opportunity for an attacker to tamper with the produced system.

Supply chains attacks may lead to the injection of Trojans. Once a Trojan has been triggered, its activity will be reflected on the physical properties of the component (modified timing, different power consumption). It is therefore possible, in some cases, to detect an active Trojan by comparing the physical properties of the component when the Trojan is active against the reference physical properties of the component. Note that, if the measurement circuitry is part of the component itself, which means that it has been integrated by the foundry that introduced the Trojan, then it cannot be trusted.

# IANA Considerations

This document has no IANA actions.
TODO: need IANA actions for claims defined in this document ?

--- back

# Collected CDDL

This appendix contains all the CDDL definitions included in this document.

~~~ cddl
{::include-fold cddl/collected.cddl}
~~~


# Acknowledgments
{:numbered="false"}

TODO acknowledge.
