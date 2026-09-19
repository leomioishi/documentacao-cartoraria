# DOCUMENTAÇÃO CARTORÁRIA — DC

> Conversa gera ideias. DC transforma ideias em patrimônio registrado.

## 1. O que é

A Documentação Cartorária (DC) é o procedimento do ecossistema para registrar formalmente uma Jornada, preservando endereço, histórico, estrutura e evolução.

A analogia central é a de um Cartório de Registro de Imóveis.

## 2. Cadeia cartorária

**Conversa / Insights → Minuta → Escritura → Registro → Matrícula → Averbações**

- **Conversa / Insights**: matéria-prima ainda fluida.
- **Minuta**: planejamento / briefing da Jornada.
- **Escritura**: projeto consolidado da Jornada.
- **Registro**: formalização técnica por DC.
- **Matrícula**: ficha registral que identifica onde e como a Jornada está registrada.
- **Averbações**: commits e alterações posteriores que registram sua evolução.

## 3. Analogia imobiliária

- **Jornada** = imóvel intelectual
- **Pasta local** = endereço físico / terreno
- **Git** = matrícula e histórico registral
- **Commit** = averbação
- **Branch** = desmembramento / linha independente de desenvolvimento
- **Merge** = incorporação
- **GitHub** = Cartório Cloud, onde o registro fica preservado e acessível
- **README** = capa explicativa / identificação principal do imóvel intelectual
- **MINUTA.md** = planejamento / briefing
- **ESCRITURA.md** = projeto formal consolidado
- **MATRICULA.md** = ficha registral

## 4. Estados

### DC-PC
Registro local:
- pasta local;
- estrutura de diretórios;
- repositório Git;
- histórico local.

### DC-CD
Registro em Cloud:
- repositório GitHub;
- branches;
- commits remotos;
- histórico sincronizado.

### DC-OK
Somente quando:
- DC-PC está íntegra;
- DC-CD está íntegra;
- local e Cloud estão sincronizados.

## 5. Regra operacional

Antes de criar qualquer estrutura nova, a DC deve verificar se já existem:
- pasta local;
- `.git`;
- remote `origin`;
- repositório GitHub;
- branch principal;
- arquivos registrários;
- alterações pendentes;
- divergências entre local e remoto.

A DC preserva o existente e cria apenas o que estiver faltando.

## 6. Estrutura do Cartório

```text
00 - DOCUMENTAÇÃO CARTORÁRIA/
├── README.md
├── 00-livro-de-registro/
│   └── LIVRO-DE-REGISTRO.md
├── 01-matriculas/
├── 02-procedimentos/
│   └── PROCEDIMENTO-DC.md
├── 03-scripts/
│   └── dc.ps1
├── 04-modelos/
│   ├── MODELO-MINUTA.md
│   ├── MODELO-ESCRITURA.md
│   └── MODELO-MATRICULA.md
└── .git/
```

## 7. Princípio

**Primeiro planejamos na Minuta. Depois consolidamos o Projeto na Escritura. Então registramos. Depois de registrada, toda evolução relevante é averbada.**
