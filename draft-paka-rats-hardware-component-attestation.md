---
title: "Attestation of Hardware Components"
abbrev: "HW-attest"
category: std

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

# ipr: trust200902 # ? todo: check with legal team

docname: draft-paka-rats-hardware-component-attestation-latest
submissiontype: IETF
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
  I-D.ietf-rats-eat-measured-component: eat-mc
  I-D.ietf-rats-corim: rats-corim

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

## Requirements Notation

{::boilerplate bcp14-tagged}

## Definitions

The terminology defined in {{RFC9334}} is reused throughout this document. Some of the definitions from RATS specifications are refined here to fit the context presented in this document.

+ Measurement: Term introduced by RATS (quote document). here it can mean a representation (a value, an encoding, etc.) of a physical property, the result of a test etc.

+ Measurement Circuitry: can be hardware logic (really a circuit) or software logic. Software logic used to trigger a measurement is not considered measurement circuitry but rather the Attesting Environment end-point of the trigger interface. See {{abstract-representation}} for details on the trigger interface.

+ Target Hardware Component: A hardware component which is a Target Environment for an Attesting Environment.

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

This document focuses on claims used to represent the state of a target hardware component. Said claims can be related to physical properties (electromagnetic or thermal signature, timing values, power consumption, etc.), results of integrated self-tests or collected traces.

The goal of this section is to propose standard interfaces to trigger the computation of the measurement and to collect the computed measurement. Also, this section presents a mapping of Attesting Environments and Target Environments in different integration models for these measurement mechanisms.

## Abstract Representation {#abstract-representation}

Mechanisms for collecting measurements of hardware components may highly depend of the type of hardware component and on the desired type of measurement. Therefore, this document proposes an abstract representation of such mechanisms. Considering a measurement mechanism as a black boxe with common interfaces, allows the content of this document to remain agnostic of the underlying mechanism and of the type of measurement collected while promoting interoperability with different real world implementations.

This document uses the following abstract objects:

+ Measurement circuitry

Black box used to represent logic capable of computing measurements of a target. The measurement circuitry is part of the Attesting Environment.

+ Trigger interface

To start the computation of a measurement, the measurement circuitry must be triggered. The trigger can follow an external request, a watchdog or any event set to trigger a measurement. The measurement circuitry receives a signal to start the computation of a measurement through the "trigger" interface.

Note: This interface may not be used in case of continuous monitoring.

+ Export interface

The "export" interface allows a measurement to be exported from the measurement circuitry to a controlled memory region in the trust boundary of the Attesting Environment.

+ Data collection channel

The measurement mechanism needs to have physical access on the property that it is in charge of measuring. The flow of data exchanged between the measurement circuitry and the target hardware component is represented by the "data collection" channel. This channel is not accessible by the Attesting Environment.

## Integration Models

The following subsections present possible layouts for integrating measurement circuitry between the Attesting Environment and the target hardware component.

### Coupled Measurement Circuitry

In this integration model, the measurement circuitry is part of the target hardware component. The separation between measurement circuitry (part of the Attesting Environment) and the Target Environment is only logical. The target hardware component and the measurement circuitry are part of the same die. Due to the proximity between the measurement circuitry and the target hardware component, the data collection channel is not represented.

~~~~ aasbbvg
{::include diagrams/coupled-measurement-circuitry.asciio}
~~~~
{: #coupled_meas_circuit artwork-align="center" title="Abstract Representation of Coupled Measurement Circuitry"}

TODO detail
Ex: Different types of BIST, KAT

Note: As shown in {{coupled_meas_circuit}}, the measurement circuitry and target hardware component share the same die. This may have an impact on the trust model (see {{supply-chain-attacks}}).

### External Measurement Circuitry

In this integration model, the measurement circuitry is not part of the target hardware component, it is external. The separation between measurement circuitry (part of the Attesting Environment) and the Target Environment is physical. The target hardware component and measurement circuitry can come from different foundries.

~~~~ aasvg
{::include diagrams/external-measurement-circuitry.asciio}
~~~~
{: #external_meas_circuit artwork-align="center" title="Abstract Representation of External Measurement Circuitry"}

TODO detail
Ex: Sensors added on top of hardware component, Power Management IC (PMIC), Baseboard Management Controller (BMC)



composite attester, can be many attesting env (and many target envs of course)
An AE may collect on multiple TE

Of course, both coupled and external measurement circuitries can be found in the same system and possibly, they can be used to measure a single Target Envrionment.
TODO this implies that a TE can have multiple measurement fields in claim and reference values (I think already supported in RATS)

## Measurement Journey

TODO should this section be moved before Coupled and External Measurement Circuitry ?

Measurements of hardware components must be included in the Evidence to be sent to a Verifier. This implies that the Attesting Environment possesses a way to start the computation of the measurement (trigger), to securely retrieve the measurement (collection) and to securely embed the measurement in Evidence. During the completion of all these steps, the attacker has many opportunities to tamper with the integrity of the measurement or the execution logic (hardware or software).

Below are the identified steps of the journey of a measurement at the hardware level.

TODO at each step describe attacker opportunity (attacker may be phsycial event) goal is to include in Evidence a measurement that is trusted.

1. trigger computation

    Measurement computation is triggered by something (boot, external request, watchdog) or continuous. The Attesting Environment is able to trigger the computation of the measurement through the trigger interface.

1. compute measurement

    The measurement of the target hardware component is computed by the measurement circuitry.

1. export measurement

    Once the measurement has been computed, it must be exported in order to be accessible by the Attesting Environment. The measurement transists from the measurement circuitry to the Attesting Environment through the export interface.

1. \[optional\] store measurement

    It is possible that the measurement will not be directly included in Evidence but instead stored until it is effectively included in Evidence by the Attesting Environment.

    The measurement must be securely stored in the boundary of the Attesting Environment. An attacker must not be able of tampering with the measurement while it is at rest.

1. include in Evidence

    The Attesting Environment is responsible for including the measurement data in Evidence. This operation must be carried out securely. An attacker must not be able to tamper with this logic.

    Note: At that point, the Evidence is not signed yet and could still be tampered by an attacker, possibly without being detected.

1. sign Evidence

    The signature opearation must be carried out securely. An attacker must not be able of modifying the content of the Evidence or forging signature for compromised data.

    For instance, if the signature operation is offloaded to a remote hardware component and Evidence content must transit on a bus to reach this component, the bus must be protected.

    Once stored in signed Evidence, the measurement is considered safe from unauthorized modification. This is because the cryptographic signature of the Evidence ensures integrity protection.



Interactions models between the Attester system and external entities such as the Verifier are already presented in other documents (TODO specify which ones).

## Practical Examples

This section is for informational purposes only.

TODO maybe this section should be after claims defintion that way, there could also be claim examples

Some may be only usable at Boot times, other could be usable during runtime.

Mapping to BIST, KAT, Sensors and Traces

# Inclusion in Conceptual Messages

This section introduces standard claims to be included in RATS Conceptual Messages. Conceptual Messages are defined in {{Section 8 of RFC9334}}.

Endorsements and Reference Values used to verify measurements of hardware components can be included in a CoRIM instance (see {{endorsements}} and {{reference-values}}). The CoRIM is defined in {{-rats-corim}}.

## Endorsement {#endorsements}

CDDL

TODO Endorsement format is not mandated by RFC9334 ? Custom is possible ?

Possible standard formats (CoRIM with CoMID), endorsed-triples

Endorsements can be written inside a CoMID Endorsed Values triple of a CoRIM (see {{Section 5.1.6 of -rats-corim}}). The Endorsed Values triple holds one or more measurement-map that are used to write the Endorsements.

TODO use case for endorsements in the scope of this document

## Reference Value {#reference-values}

Reference Values must be computed in a secure environment.

The Reference Value computed must correspond to the value that will be outputted in the expected environment of the system once in mission mode. For instance, a measurement might be dependent of the environmental conditions surrounding the system. This must be taken into account as a different measurement does not necessarily mean bad behavior. If such parameters cannot be foreseen, it is possible to include additional data in the Reference Values to give details on the
context in which the measurement has been computed.
(kind of conditional Reference Values)

TODO Reference Values format is not mandated by RFC9334 ? Custom is possible ?

Possible standard formats (CoRIM with CoMID), reference-triples

TODO one CoMID tag per hardware component ?

Reference Values can be written inside a CoMID Reference Values triple of a CoRIM (see {{Section 5.1.5 of -rats-corim}}). The Reference Values triple holds one or more measurement-map that are used to write the Reference Values.

Depending on the type of measurement and target hardware component, the Reference Value can be a value or a range and can correspond to a class, a group or an instance of the target hardware component.

## Evidence

TODO Evidence format is not mandated by RFC9334 ? Custom is possible ?

Possible standard formats (EAT, X.509)

### EAT Claims {#eat-claims}

The current version of this document proposes several possible approaches for including hardware component measurements in Evidence. For now, these options are present as brainstorming, to explore the different possibilities and may be removed in future versions of this document.

#### Using EAT Measured Component Claim

To promote interoperability, it is possible for some measurements to be represented in an already existing EAT Measured Component. The EAT Measured Component is defined in {{-eat-mc}}.

For instance, a custom measurement structure can be used to hold hardware component measurement in the "measurement" field of the "measure-component" structure from {{-eat-mc}}. Also, the flag field can be used to extend the measured-component base type with profile-defined semantics.

#### Using EAT Measurement Result Claim

To promote interoperability, it is possible for some measurements to be represented in an already existing EAT Measurement Result. The EAT Measurement Result is defined in {{Section 4.2.17 of RFC9711}}.

This claim could be well-suited for measurements with on-device comparisons with reference values. For instance, self-tests (e.g., BIST, KAT) verify that the computed measurement corresponds to an expected value and output results such as "success" or "failure". In that case, a Measurement Result claim can be used.

#### Using Hardware Component Claims

This section proposes new claims related to what is described in this document.
<!-- The following claims are defined according to the guidelines presented in {{Appendix E of RFC9711}}. -->

The CDDL in {{mhwc_claims}} extends the $measurements-body-cbor and $measurements-body-json EAT sockets to add support for the measured-hw-component to the Measurements claim ({{Section 4.2.16 of RFC9711}}).

~~~ cddl
{::include cddl/mhwc-claims.cddl}
~~~
{: #mhwc_claims title="Measured Hardware Component Claims"}


### X.509 Claims

{{Appendix C.3 of RFC9711}} desribes methods to encode EAT claims in an X.509 certificate. These methods can be used for the claims defined in {{eat-claims}}.

TODO Particular case for DICE X.509 certificates (DiceTcbInfo)

# Security Considerations

The security considerations of RATS architecture apply ({{Section 12 of RFC9334}}). This section also mentions protection against physical attacks. These attacks are particularly relevant for this draft as collecting claims about hardware components implies a risk of physical compromissions. Aging and action of environment on the system are also considered threats.

The following subsections are mainly focused on security considerations regarding the Attester.

## Root of Trust Components

Some components are essential for attestation, if these are tampered with, there is no way to build meaningful Evidence (storage of attestation key, signature component, etc.). These are considered the Root of Trust (RoT) for attestation because their correct functioning cannot be proved through attestation.

These are to be put in contrast with other components that are not critical for attestation (altough they can be critical for the security system itself !).

## Measurement Soundness

It is possible that some measurement mechanisms may not be fully deterministic or may fail on rare occurences or raise false positives. These considerations must be taken into account and mitigated to a sufficient level by the designer.

## Threat Model

### Software Attacks

There exist software attacks that can have a direct impact on hardware components’ behavior. These are ideally mitigated by good and secure development practices but in case they happen, these attacks can be detected by monitoring physical properties of the component (such as power consumption, thermal and electromagnetic signatures, timing).

Ex: Software-induced Denial-of-Service (DoS).

Ex: Manipulation of priviledged power control interface.

### Physical Attacks

Physical attacks target the hardware of the system. They imply physical access to the system during its mission mode or while it is in the supply chain.

#### Passive Attacks

Passive physical attacks are used by attackers to leak information through analysis of system physical properties. Passive attacks, by definition, do not modify behavior of the system and therefore cannot alter the correct functioning of the attestation flow.

Ex: Side channel analysis of physical properties (EM emissions, power consumption, timing, temperature, probing, etc.)

The danger with passive attacks resides in the extraction of sensitive assets and particularly attestation key used to sign Evidence, which can be used for impersonation and Evidence forgery. This is already tackled in {{Section 12.1.1 of RFC9334}}.

#### Active Attacks

Active physical attacks are the main problem since they allow an attacker (or a “natural” physical event) to tamper with the integrity of assets and execution flows of the system. These may therefore modify measurements in transit or at rest, inject arbitrary data in Evidence or bypass sensitive operations.

Ex: Attacks on bus (Active man-in-the-middle (MITM), injection, probing) or anywhere measurements are in transit before being integrated in a structure that cannot be tampered or spoofed (signed Evidence).

Ex: Glitching, fault injections to induce malicious behavior. May tamper with the target hardware component itself or the measurement circuitry or the logic used to build Evidence.

Ex: Memory tampering attacks to modify stored measurements.

Some techniques to mitigate physical attacks are usage of a TPM or secure element for storage and correct execution of protected logic, bus protections, redundancy, sensors, active meshes, nose injection, etc. Note that some of these mitigations cannot directly prevent attacks but can be used for detection.

### Supply Chain Attacks {#supply-chain-attacks}

Each stage of the supply chain introduces a new opportunity for an attacker to tamper with the produced system.

Supply chains attacks may lead to the injection of Trojans. Once a Trojan has been triggered, its activity will be reflected on the physical properties of the component (modified timing, different power consumption). It is therefore possible, in some cases, to detect an active Trojan by comparing the physical properties of the component when the Trojan is active against the reference physical properties of the component. Note that, if the measurement circuitry is part of the component itself, which means that it has been integrated by the foundry that introduced the Trojan, then it cannot be trusted.

# Privacy Considerations

TODO for reused claims privacy considerations are probably specified in other documents (refer to them)

TODO for new claims, some fields may be dangerous for privacy. Some fields may enable tracking.

# IANA Considerations

This document has no IANA actions.
TODO need IANA actions for claims defined in this document ?

--- back

# Collected CDDL

This appendix contains all the CDDL definitions included in this document.

<!-- ~~~ cddl
{::include-fold cddl/collected.cddl}
~~~ -->

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
