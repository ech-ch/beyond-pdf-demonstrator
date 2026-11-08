// Auswertung der Feedback-Issues (E38, MVP-Spezifikation 6), aufgerufen von
// .github/workflows/feedback-label.yml. Test: node --test .github/scripts/feedback-label.test.js
//
// Titel und Text eines Issues sind fremde Eingaben. Sie werden nur gelesen und
// mit festen Listen verglichen: Ins Label kommen ausschliesslich Werte aus der
// Quelle oder aus dieser Datei, nie Text aus dem Issue. Sie werden auch nicht
// ins Log geschrieben.

'use strict';

const fs = require('node:fs');
const path = require('node:path');

// Überschriften des Formulars in dessen Reihenfolge (.github/ISSUE_TEMPLATE/feedback.yml)
const FELDER = ['Standard', 'Baustein-ID', 'Stand', 'Link zur Stelle', 'Wortlaut', 'Art', 'Kommentar', 'Vorschlag'];
const KEINE_ANTWORT = '_No response_';

const ARTEN = new Map([
  ['Zum Inhalt', 'art:inhalt'],
  ['Zum Zuschnitt oder zu Beziehungen', 'art:zuschnitt'],
  ['Zum Demonstrator', 'art:demonstrator'],
  ['Frage', 'art:frage'],
]);

const STANDARD_ID = /^ech-[0-9]{4}$/;
const ID_MAX = 100;
const LABEL_MAX = 50; // Grenze von GitHub
const UNBEKANNT = 'bb:unbekannt';

// Liest die Felder eines Formular-Issues. Die Überschriften werden nur in der
// Reihenfolge des Formulars anerkannt: Eine Zeile «### Baustein-ID» im
// Kommentar kann das vorbefüllte Feld davor nicht überschreiben. Gibt null
// zurück, wenn der Text nicht aus dem Formular stammt.
function leseFormular(text) {
  const werte = {};
  let feld = null;
  let naechstes = 0;
  for (const zeile of String(text ?? '').split(/\r?\n/)) {
    const treffer = zeile.startsWith('### ') ? FELDER.indexOf(zeile.slice(4).trim(), naechstes) : -1;
    if (treffer >= 0) {
      feld = FELDER[treffer];
      werte[feld] = [];
      naechstes = treffer + 1;
    } else if (feld !== null) {
      werte[feld].push(zeile);
    }
  }
  if (!('Standard' in werte && 'Baustein-ID' in werte && 'Art' in werte)) return null;
  const formular = {};
  for (const [name, zeilen] of Object.entries(werte)) {
    const wert = zeilen.join('\n').trim();
    formular[name] = wert === KEINE_ANTWORT ? '' : wert;
  }
  return formular;
}

// Alle Baustein-IDs eines Standards aus der Quelle (Attribut bb="…"), dazu
// die Kennungen für Feedback ohne Baustein (Attribut feedback-id="…": Anhang A,
// Kap. 2–5 als Text, AP26). Die Standard-ID ist an dieser Stelle bereits gegen
// STANDARD_ID geprüft.
function leseBausteinIds(wurzel, standard) {
  const ordner = path.join(wurzel, standard);
  if (!fs.existsSync(ordner)) return null;
  const ids = new Set();
  const ohneBaustein = new Set();
  const durchsuche = (pfad) => {
    for (const eintrag of fs.readdirSync(pfad, { withFileTypes: true })) {
      const ziel = path.join(pfad, eintrag.name);
      if (eintrag.isDirectory()) {
        durchsuche(ziel);
      } else if (/\.(md|qmd)$/.test(eintrag.name)) {
        const text = fs.readFileSync(ziel, 'utf8');
        for (const m of text.matchAll(/\bbb="([a-z0-9-]+)"/g)) ids.add(m[1]);
        for (const m of text.matchAll(/\bfeedback-id="([a-z0-9-]+)"/g)) ohneBaustein.add(m[1]);
      }
    }
  };
  durchsuche(ordner);
  return { ids, ohneBaustein };
}

function bausteinLabel(id, standard, quelle) {
  if (id === '') return 'bb:gesamt';
  if (standard === null || quelle === null || id.length > ID_MAX) return UNBEKANNT;
  let label;
  if (quelle.ohneBaustein.has(id) && id.startsWith(`${standard}-`)) {
    // ohne Baustein: Anhang A ergibt bb:referenzen (E15), Kap. 2 bb:kapitel-standard (AP26)
    label = `bb:${id.slice(standard.length + 1)}`;
  } else {
    const praefix = `${standard}-bb-`;
    if (!id.startsWith(praefix) || !quelle.ids.has(id)) return UNBEKANNT;
    label = `bb:${id.slice(praefix.length)}`;
  }
  return label.length <= LABEL_MAX ? label : UNBEKANNT;
}

// Labels eines Issues, oder null, wenn es nicht aus dem Formular stammt.
function bestimmeLabels({ titel, text, wurzel }) {
  const formular = leseFormular(text);
  if (formular === null) return null;
  const standard = STANDARD_ID.test(formular['Standard']) ? formular['Standard'] : null;
  const ids = standard === null ? null : leseBausteinIds(wurzel, standard);
  const labels = ['feedback'];
  labels.push(standard !== null && ids !== null ? `standard:${standard}` : 'standard:unbekannt');
  labels.push(bausteinLabel(formular['Baustein-ID'], standard, ids));
  if (ARTEN.has(formular['Art'])) labels.push(ARTEN.get(formular['Art']));
  if (String(titel ?? '').startsWith('[Beispiel]')) labels.push('beispiel');
  return labels;
}

function labelEigenschaften(name) {
  if (name === 'feedback') return { color: '0e8a16', description: 'Feedback über das Formular des Demonstrators' };
  if (name === 'beispiel') return { color: 'cccccc', description: 'Beispiel, kein echtes Feedback (E40)' };
  if (name.startsWith('standard:')) return { color: '1d76db', description: 'Standard, auf den sich das Feedback bezieht' };
  if (name.startsWith('art:')) return { color: 'fbca04', description: 'Art des Feedbacks' };
  return { color: 'd00d28', description: 'Baustein, auf den sich das Feedback bezieht' };
}

async function stelleLabelSicher(github, repo, name) {
  try {
    await github.rest.issues.getLabel({ ...repo, name });
  } catch (fehler) {
    if (fehler.status !== 404) throw fehler;
    try {
      await github.rest.issues.createLabel({ ...repo, name, ...labelEigenschaften(name) });
    } catch (fehlerAnlegen) {
      if (fehlerAnlegen.status !== 422) throw fehlerAnlegen; // gleichzeitig angelegt
    }
  }
}

async function setzeLabels({ github, context, core, wurzel = process.env.GITHUB_WORKSPACE || '.' }) {
  const issue = context.payload.issue;
  const labels = bestimmeLabels({ titel: issue.title, text: issue.body, wurzel });
  if (labels === null) {
    core.info(`Issue #${issue.number} stammt nicht aus dem Formular, keine Labels.`);
    return [];
  }
  for (const name of labels) await stelleLabelSicher(github, context.repo, name);
  await github.rest.issues.addLabels({ ...context.repo, issue_number: issue.number, labels });
  core.info(`Issue #${issue.number}: ${labels.join(', ')}`);
  return labels;
}

module.exports = { leseFormular, bestimmeLabels, setzeLabels };
