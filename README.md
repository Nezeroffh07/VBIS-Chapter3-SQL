# VBIS-Chapter3-SQL

**Ad Soyad:** Nurlan Nəzərov
**Qrup:** KOM24B
**Chapter 3 Practice Assignment** — SQL sorğuları və GitHub portfoliosu

## Həll edilən tapşırıqlar

### Məcburi tapşırıqlar (`mandatory_queries.sql`)
- 3.11 (a, b, c, d)
- 3.15 (a, b, c)
- 3.24
- 3.25

### Əlavə tapşırıqlar (`additional_queries.sql`)
- 3.26
- 3.27
- 3.28
- 3.31
- 3.32
- 3.33
- 3.34
- 3.35

## Repository strukturu

```
VBIS-Chapter3-SQL
├── README.md
├── mandatory_queries.sql
├── additional_queries.sql
├── explanation.md
├── schema_and_sample_data.sql   # sorğuları yoxlamaq üçün sxem + test məlumatları
└── screenshots/                 # sorğuların icrası, nəticələr, PostgreSQL mühiti
```

## Necə işlətmək olar (PostgreSQL)

```bash
createdb vbis_ch3
psql -d vbis_ch3 -f schema_and_sample_data.sql   # cədvəllər + test məlumatları
psql -d vbis_ch3 -f mandatory_queries.sql
psql -d vbis_ch3 -f additional_queries.sql
```

`schema_and_sample_data.sql` faylında kitabın universitet (university) və bank (banking)
sxemləri PostgreSQL üçün uyğunlaşdırılıb və hər sorğunun nəticə verməsi üçün kiçik test
məlumatları əlavə edilib.
