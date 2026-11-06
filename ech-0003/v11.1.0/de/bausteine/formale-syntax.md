# Formale Syntax für die Versionierung {#sec-formale-syntax .appendix bb="ech-0003-bb-formale-syntax" typ="rule" original-seite="36"}

Die formale Syntax in EBNF-Form für das von eCH verwendete Schema ohne optionale Ergänzungen lautet wie folgt:

```
<valid semver> ::= <version core>
           | <version core> "-" <pre-release>
           | <version core> "+" <build>
           | <version core> "-" <pre-release> "+" <build>
<version core> ::= <major> "." <minor> "." <patch>
<major> ::= <numeric identifier>
<minor> ::= <numeric identifier>
<patch> ::= <numeric identifier>
<numeric identifier> ::= "0"
                | <positive digit>
                | <positive digit> <digits>
<digits> ::= <digit>
       | <digit> <digits>
<digit> ::= "0"
      | <positive digit>
<positive digit> ::= "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
):
```
