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

informative:
  RFC9711:

  I-D.ietf-rats-eat-measured-component: eat-mc

  I-D.ietf-rats-corim: rats-corim

  I-D.richardson-rats-composite-attesters: composite-attest

  I-D.fossati-tls-attestation: attested-tls

  ISO5891:
    target: "https://www.iso.org/fr/standard/81806.html"
    title: "ISO/IEC TR 5891:2024, Information security, cybersecurity and privacy protection — Hardware monitoring technology for hardware security assessment"
    date: 2024-04
    author:
       org: "International Standards Organization"

  TCG-DICE:
    target: "https://trustedcomputinggroup.org/wp-content/uploads/DICE-Attestation-Architecture-r23-final.pdf"
    title: "DICE Attestation Architecture, Version 1.00, Revision 0.23"
    date: 2021-03
    author:
       org: "Trusted Computing Group"

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

TODO Add references to sections of this document

# Terminology

## Requirements Notation

{::boilerplate bcp14-tagged}

## Definitions

The terminology defined in {{RFC9334}} is reused throughout this document. Some of the definitions from RATS specifications are refined here to fit the context presented in this document.

+ Measurement Unit: can be a hardware mechanism (a circuit) or software logic (e.g., FIPS KAT). Software logic used to trigger a measurement is not considered a Measurement Unit but rather the Attesting Environment end-point of the Trigger interface. See {{abstract-representation}} for details on the Trigger interface.
TODO rename Measurement Unit

+ Measurement: Term introduced by RATS (quote document). here it can mean a representation of a physical property (an encoded value), the result of a test etc.

+ Target Hardware Component: A hardware component which is a Target Environment for an Attesting Environment.

# Scope and Limitations

TODO Scope and Limitations

# Use Cases

The solution presented in this document aims at mitigating two threats on hardware.

+ Defective hardware components

Malfunctions of hardware components may be caused by environment and/or aging. Detection of such malfunctions is critical when relying on systems evolving in hazardous environments such as high pressure, extreme temperatures, contact with water or chemical substances or space radiations.

+ Attacks on hardware components

Gaining control of the hardware of a system is particularly interesting for an attacker as it allows to tamper with the correct functioning of the system at a priviledged level. Such control can be obtained by abusing software mechanisms or by having physical access to the system (particularly relevant for embedded systems) and using physical attack techniques.

TODO small summary on why this is important for security and safety

# Attester Model

The RATS architecture presented in {{RFC9334}} introduces two types of environments in an Attester. The Attesting Environment (AE) and the Target Environment (TE). The Attesting Environment is in charge of collecting claims about a Target Environment. The Attesting Environment is then responsible for embedding those claims in an Evidence Conceptual Message.

This document focuses on claims used to represent the state of a target hardware component. Said claims can be related to physical properties (electromagnetic or thermal signature, timing values, power consumption, etc.), results of integrated self-tests or collected traces.

The goal of this section is to propose standard interfaces to trigger the computation of the measurement and to collect the computed measurement. Also, this section presents a mapping of Attesting Environments and Target Environments in different integration models of measurement mechanisms.

## Abstract Representation {#abstract-representation}

Mechanisms for collecting measurements of hardware components may highly depend of the type of hardware component and on the desired type of measurement. Therefore, this document proposes an abstract representation of such mechanisms. Considering a measurement mechanism as a black box with common interfaces, allows the content of this document to remain agnostic of the underlying mechanism and of the type of measurement collected while promoting interoperability with different real world implementations.

This document uses the following abstract objects:

+ Measurement Unit

Black box used to represent a mechanism capable of computing measurements over a target. The Measurement Unit is part of the Attesting Environment.

+ Trigger interface

To start the computation of a measurement, the Measurement Unit must be triggered. The trigger can follow an external request, a watchdog or any event set to trigger a measurement. The Measurement Unit receives a signal to start the computation of a measurement through the "Trigger" interface.

This interface is optionnal. For instance, it may not be used in case of continous monitoring.

+ Export interface

The "Export" interface allows a measurement to be exported from the Measurement Unit to a controlled memory region in the trust boundary of the Attesting Environment.

+ Data Exchange channel

The measurement mechanism needs to have physical access on the property that it is in charge of measuring. The flow of data exchanged between the Measurement Unit and the target hardware component is represented by the "Data Exchange" channel. This channel is not accessible by the Attesting Environment.

## Integration Models

The following subsections present possible layouts for integrating a Measurement Unit between the Attesting Environment and the target hardware component.

TODO add MU in AE
TODO the measurement unit is in Attesting Environment ?

### Embedded Measurement Unit

In this integration model, the Measurement Unit is part of the target hardware component. The separation between Measurement Unit (part of the Attesting Environment) and the Target Environment is only logical. The target hardware component and the Measurement Unit are part of the same die. Due to the proximity between the Measurement Unit and the target hardware component, the Data Exchange channel is not represented.

~~~~ aasbbvg
{::include diagrams/embed-measurement-unit.asciio}
~~~~
{: #embed_meas_unit artwork-align="center" title="Abstract Representation of Embedded Measurement Unit"}

Ex: Different types of BIST, KAT

Note: As shown in {{embed_meas_unit}}, the Measurement Unit and target hardware component share the same die. This may have an impact on the trust model (see {{supply-chain-attacks}}).

### External Measurement Unit

In the following integration models, the Measurement Unit is external to the target hardware component.

#### Discrete Component

The Measurement Unit is a discrete component external to the target hardware component and to the Attesting Environment.

~~~~ aasvg
{::include diagrams/discrete-measurement-unit.asciio}
~~~~
{: #discrete_meas_unit artwork-align="center" title="Abstract Representation of Discrete Measurement Unit"}

Ex: Sensors added on top of hardware component, Power Management IC (PMIC), Baseboard Management Controller (BMC)

In this integration model, the target hardware component and Measurement Unit can come from different sources (e.g., foundries). That can be leveraged to draw trust boundaries between the AE, TE and Measurement Unit.
Using a discret component implies the existence of physical communication channels between the AE, TE and Measurement Unit on which data such as measurement will transit. This introduces attack vectors. Refer to {{seccons}}.

#### Integrated in Attesting Environment

The Measurement Unit is physically integrated in the Attesting Environment. It can take the form of hardware circuitry or be a software component. As the Measurement Unit is integrated in the Attesting Environment, the Trigger and Export interfaces are not represented in {{integrated_meas_unit}}.

~~~~ aasvg
{::include diagrams/external-integrated-measurement-unit.asciio}
~~~~
{: #integrated_meas_unit artwork-align="center" title="Abstract Representation of Measurement Unit Integrated in AE"}

Ex: Software logic (e.g., FIPS KAT)

Note: This integration model can be limiting in terms of what it is possible to measure.



A single Attesting Environment can be responsible for one or more target hardware components. The Attesting Environment is therefore responsible for building Evidence for all of its target hardware components.

In addition to that, there may be multiple Attesting Environments. That case is discussed in {{-composite-attest}}.

Of course, both embedded and external Measurement Units can be found in the same system and possibly, a combination of embedded and external can be used to measure a single Target Envrionment.
TODO this implies that a TE can have multiple measurement fields in claim and reference values (already supported in RATS standar data models ?)

## Measurement Journey

TODO should this section be moved before Embedded and External Measurement Unit ?

Measurements of hardware components must be included in the Evidence to be sent to a Verifier. This implies that the Attesting Environment possesses a way to start the computation of the measurement (trigger), to securely retrieve the measurement (collection) and to securely embed the measurement in Evidence. During the completion of all these steps, the attacker has many opportunities to tamper with the integrity of the measurement or the execution logic (hardware or software).

Below are the identified steps of the journey of a measurement at the hardware level. These are important as this document implies a security model in which the attacker can tamper with hardware.

TODO at each step describe attacker opportunity (attacker may be phsycial event i.e., not malicious) goal is to include in Evidence a measurement that is trusted.

1. Trigger computation

    Measurement computation is triggered by an event (boot, external request, watchdog) or continuous. The Attesting Environment is able to trigger the computation of the measurement through the Trigger interface.

1. Compute measurement

    The measurement of the target hardware component is computed by the Measurement Unit.

1. Export measurement

    Once the measurement has been computed, it must be exported in order to be accessible by the Attesting Environment. The measurement transits from the Measurement Unit to the Attesting Environment through the export interface.

    TODO measurement in transit can be tampered etc.

1. \[optional\] Store measurement

    It is possible that the measurement will not be directly included in Evidence but instead stored until it is effectively included in Evidence by the Attesting Environment.

    The measurement must be securely stored in the boundary of the Attesting Environment. An attacker must not be able of tampering with the measurement while it is at rest.

1. Include measurment in Evidence

    The Attesting Environment is responsible for including the measurement data in Evidence. This operation must be carried out securely. An attacker must not be able to tamper with this logic.

    Note: At that point, the Evidence is not signed yet and could still be tampered by an attacker, possibly without being detected.

1. Sign Evidence

    The signature operation must be carried out securely. An attacker must not be able of modifying the content of the Evidence or forging signature for compromised data.

    For instance, if the signature operation is offloaded to a remote hardware component and Evidence content must transit on a bus to reach this component, the bus must be protected.

    Once stored in signed Evidence, the measurement is considered safe from unauthorized modification. This is because the cryptographic signature of the Evidence ensures integrity protection.

{{meas_journey}} represents the steps of the measurement journey described above.

~~~~ aasvg
{::include diagrams/measurement-journey.asciio}
~~~~
{: #meas_journey artwork-align="center" title="Measurement Journey"}

# Inclusion in Conceptual Messages {#conceptual-messages}

This section introduces standard claims to be included in RATS Conceptual Messages. Conceptual Messages are defined in {{Section 8 of RFC9334}}. The RATS architecture does not mandate the usage of standard data formats for Conceputal Messages but protocols may require specific formats. Nonetheless, RATS proposed CoRIM for Endorsements and Reference Values and EAT for Evidence as standard data models. The CoRIM is defined in {{-rats-corim}} and the EAT is defined in {{RFC9711}}.

To promote interoperability, the following sections showcase how to use the CoRIM and EAT data models in the context of this document.

## Endorsement {#endorsements}

TODO use case for endorsements in the scope of this document. Ex: endorsmeent for sensor that take measurement: (environment resistance (extremely cold and hot temperatures), measurement precision and incertitude, etc..), any system-specific characteristics that have an impact on how the Evidence appraisal.

### Concice Reference Integrity Manifest (CoRIM)

Endorsements can be written inside a CoMID Endorsed Values triple of a CoRIM (see {{Section 5.1.6 of -rats-corim}}). The Endorsed Values triple holds one or more measurement-map that are used to write the Endorsements.

## Reference Value

Reference Values must be computed in a secure environment.

The Reference Value computed must correspond to the value that will be outputted in the expected environment of the system once in mission. For instance, a measurement might be dependent of the environmental conditions surrounding the system. This must be taken into account as a measurement different from the Reference Value does not necessarily mean bad behavior. If such context-dependent parameters cannot be foreseen, it is possible to include additional data in Evidence to give details about the context in which the measurement has been computed. The Verifier will then use these additionnal data to select the Reference Value that should be used in the context described by the additional data. (kind of conditional Reference Values). This implies that attacker cannot modify these additional data otherwise, an attacker would be able to fool a Verifier into choosing Reference Values that don't ocrrespond to the actual context of the system.

Depending on the type of measurement and target hardware component, the Reference Value can be a value or a range or a function* of the operational context of the system and can correspond to a class, a group or an instance of target hardware component.

*even a ML model to detect abnormal physical properties depending on operational context of the system.

### Concice Reference Integrity Manifest (CoRIM)

TODO one CoMID tag per hardware component ?
Reference Values can be written inside a CoMID Reference Values triple of a CoRIM (see {{Section 5.1.5 of -rats-corim}}). The Reference Values triple holds one or more measurement-map that are used to write the Reference Values.

## Evidence

The current version of this document proposes several approaches for including hardware component measurements in Evidence. For now, these options are present as brainstorming, to explore the different possibilities and may be removed in future versions of this document.

### Entity Attestation Token (EAT) {#eat-claims}

#### Using EAT Measured Component Claim

It is possible for some measurements to be represented in an already existing EAT Measured Component. The EAT Measured Component is defined in {{-eat-mc}}.

For instance, a custom measurement structure can be used to hold hardware component measurement in the "measurement" field of the "measured-component" structure from {{-eat-mc}}. Also, the flag field can be used to extend the measured-component base type with profile-defined semantics.

#### Using EAT Measurement Result Claim

It is possible for some measurements to be represented in an already existing EAT Measurement Result. The EAT Measurement Result is defined in {{Section 4.2.17 of RFC9711}}.

This claim could be well-suited for measurements with on-device comparisons with reference values. For instance, self-tests (e.g., BIST, KAT) verify that the computed measurement corresponds to an expected value and output results such as "success" or "failure". In that case, a Measurement Result claim can be used.

#### Using EAT Submodule Claim

TODO it seems EAT Submodule can be used to embed hardware components claims (maybe only more complete subsystems not simple hardware components). Research if it could be extended to include measurements. Especially relevant if the submodule does not have its own Attesting Environment ({{Section 4.2.18 of RFC9711}}).

#### Using Hardware Component Claims

This section proposes a new claim, the "measured hardware component", to represent what is described in this document. This claim is presented in case the already existing claims mentioned above are not sufficent to correctly report measurements of hardware components.

The "measured hardware component" claim is inspired from the "measured component" claim introduced in {{-eat-mc}}.

<!-- The resemblance is beneficial for comprehension and makes implementation easier. -->

<!-- The following claims are defined according to the guidelines presented in {{Appendix E of RFC9711}}. -->

##### Information Model

This section presents the information model of a "measured hardware component".

The information elements (IEs) that constitute a "measured hardware component" are described in {{tab-mhwc-info-elems}}.

| IE | Description | Requirement Level |
|----|-------------|-------------------|
| Component Name | The name given to the target hardware component. | REQUIRED |
| Operational Context | Additional information on the operational context of the component. | OPTIONAL |
| Measurement List| List of measurements for the target hardware component. Each element of the list is composed of a Measurement Type and of a Measurement Value. | REQUIRED |
{: #tab-mhwc-info-elems title="Measured Hardware Component Information Elements"}

###### Component Name

###### Operational Context

Additional information on the operational context of the component. These can be used by the Verifier to appraise measurements.

By being placed at this level of the Measured Hardware Component claim, the operational context is shared by every measurement of the target hardware component. It is important that the operational context sampled corresponds to the actual operational context at the time of measurement computations (i.e., sampling of the operational context and computation of the measurements must be executed simultaneously (approximately). Otherwise, TOCTOU attcks would be possible).

| Field Name | Description | Requirement Level |
|------------|-------------|-------------------|
| | | |
{: #tab-op-ctx-fields title="Fields of the Operational Context"}

Use case example: the measurement may be subject to variations depending on environmental context such as temperature. A measurement value might acceptable when computed in a context of extreme cold but not if computed at room temperature. The Verifier must therefore be aware of the temperature surrounding the component to decide if the measurement corresponds to good behavior or not. The Verifier will therefore base its appraisal on the environmental context reported in Operational Context.

Note: The content of the operational context is sensitive and must have the same level of protection as the measurements.

###### Measurement List

| Field Name | Description | Requirement Level |
|------------|-------------|-------------------|
| Measurement Unit Identifier | Identifier for the Measurement Unit used to obtain the measurement | REQUIRED |
| Measurement Type | The type of the measurement. | REQUIRED |
| Measurement Value | The Value of the measurement. The content of this field depends on the Measurement Type. | REQUIRED |
{: #tab-meas-list-elem-fields title="Content of Elements of the Measurement List"}

* Measurement Unit Identifier:

Identifier for the Measurement Unit used to compute the measurement.

For instance there may be multiple sensors used to measure a single propertie of the target hadrware component. in that case, the Measurement Unit Identifier allows to identify the Measurement Unit that was used.

* Measurement Type:

Specifier for the type of the measurement.

For example, the type can be used to specify if the measurement is the result of a self-test or the sampling of a physical property.

* Measurement Value:

The structure that holds the actual measurement. The structure of the Measurement Value depends on the Measurement Type.

TODO additional structures could be defined in a profile. Simply, the Measurement Value could be raw bytes that the Verifier would understand (based on a profile).

### X.509 Certificate

{{Appendix C.3 of RFC9711}} describes methods to encode EAT claims in an X.509 certificate. These methods can be used for the claims presented in {{eat-claims}}.

Ex: DICE uses X.509 certificates with a custom extension to carry Evidence {{TCG-DICE}}. TLS and DTLS extended with remote attestation also use X.509 certificates with an attestion extension {{-attested-tls}}.

# CDDL Definitions

This sections presents CDDL definitions for the Measured Hardware Component claim to be included in EAT Measurement claim.

## Measured Hardware Component Claim {#meas-hw-comp-claim}

~~~ cddl
{::include cddl/meas-hw-comp.cddl}
~~~
{: #meas_hw_comp title="CDDL of Measured Hardware Component Claim"}

### Measurement Value: Self-Test

CDDL defintion of the structure of measurement-value when measurement-type = mt-self-test.

~~~ cddl
{::include cddl/mv-self-test.cddl}
~~~
{: #mv_self_test title="CDDL of Self-Test Measurement Value"}

### Measurement Valut: Physical Property

CDDL defintion of the structure of measurement-value when measurement-type = mt-phys-prop.

~~~ cddl
{::include cddl/mv-phys-prop.cddl}
~~~
{: #mv_phys_prop title="CDDL of Physical Property Measurement Value"}

## Inclusion in EAT Measurement Claim

The CDDL defined in {{meas-hw-comp-claim}} extends the $measurements-body-cbor and $measurements-body-json EAT sockets to add support for the measured-hw-component to the Measurements claim ({{Section 4.2.16 of RFC9711}}).

~~~ cddl
{::include cddl/mhwc-claims.cddl}
~~~
{: #mhwc_claims title="CDDL Extension of EAT Measurement Body"}

# Practical Examples

This section is for informational purposes only.

TODO Practical Examples

Some may be only usable at Boot time, other could be usable during runtime.

Mapping to BIST, KAT, Sensors and Traces

## Monitoring Physical Properties

Usage of sensors
External or Embedded ?
Examples of existing technologies
action of Endorser, RVP (compute refrence values, compute range, prepare behavioral model (ML) in secure environment)
action Verifier appraise (can Verifier use behavioral model prepared by RVP ?)


on-die sensors (integrated in silicon)
-> Embedded Measurement Unit
TODO Existing technologies: sensors present in CPUs
Security Sensors (tamper detection)
light, EM, voltage sensors

on-board sensors (external components)
-> external Measurement Unit
PMIC

## Detection by Self-Testing

Usage of BIST or KAT or tamper detection sensors (active mesh, digital sensor)
External or Embedded ?
Examples of existing technologies
action of Endorser (type of test, its properties etc.., identifier, certif ?), RVP and Verifier

# Security Considerations {#seccons}

The security considerations of RATS architecture apply ({{Section 12 of RFC9334}}). This section also mentions protection against physical attacks. These attacks are particularly relevant for this draft as collecting claims about hardware components implies a risk of physical compromission. Aging and action of environment on the system are also considered threats.

TODO The security considerations of EAT Measured Component apply ({{Section 5 of -eat-mc}}) when using EAT Measured Component claim or Measured Hardware Component Claim.

TODO security considerations of CoRIM when using CORIM ?

The following subsections are mainly focused on security considerations regarding the Attester.

## Root of Trust Components

Some components are essential for attestation (storage of attestation key, signature component, etc.), if these are tampered with, there is no way to build trustworthy Evidence. These are considered the Root of Trust (RoT) for attestation because their correct functioning cannot be proved through attestation.

These are to be put in contrast with other components that are not critical for attestation (altough they can be critical for the security of the system itself !).

## Multiple Attesting Environments

In case of multiple Attesting Environments, distribution of freshness and binding of Evidence are discussed in {{-composite-attest}}.

## Invasive Accesses

The Measurement Unit must not allow an attacker to access protected assets. For instance, access to protected assets can happen when computing measurements by using internal debug mechanisms (e.g., TAP controllers).

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

Ex: Glitching, fault injections to induce malicious behavior. May tamper with the target hardware component itself or the Measurement Unit or the logic used to build Evidence.

Ex: Memory tampering attacks to modify stored measurements.

Some techniques to mitigate physical attacks are usage of a TPM or secure element for storage and correct execution of protected logic, bus protections, redundancy, sensors, active meshes, nose injection, etc. Note that some of these mitigations cannot directly prevent attacks but can be used for detection.

### Supply Chain Attacks {#supply-chain-attacks}

Each stage of the supply chain introduces a new opportunity for an attacker to tamper with the produced system.

Supply chains attacks may lead to the injection of Trojans. Once a Trojan has been triggered, its activity may be reflected on the physical properties of the component (modified timing, different power consumption). It is therefore possible, in some cases, to detect an active Trojan by comparing the physical properties of the component when the Trojan is active against the reference physical properties of the component. Note that, if the Measurement Unit is part of the component itself, which means that it has been integrated by the foundry that introduced the Trojan, then it cannot be trusted.

# Privacy Considerations

The privacy considerations of RATS architecture apply ({{Section 11 of RFC9334}}).

TODO The privacy considerations of EAT Measured Component apply ({{Section 6 of -eat-mc}}) when using EAT Measured Component claim or Measured Hardware Component Claim.

TODO privacy considerations of CoRIM when using CORIM ?

TODO for reused claims privacy considerations are probably specified in other documents so refer to them

TODO In new claims, some fields may be dangerous for privacy. Some fields may enable tracking.

# IANA Considerations

This document has no IANA actions.
TODO need IANA actions for claims defined in this document ?

--- back

# Collected CDDL

This appendix contains all the CDDL definitions included in this document.

~~~ cddl
{::include-fold cddl/collected.cddl}
~~~

# Acknowledgments
{:numbered="false"}

TODO acknowledge.
