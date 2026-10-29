# Izahat (Explanation)

**Qrup:** KOM24B — Chapter 3 Practice Assignment

## 1. Ən çətin hesab etdiyim SQL sorğusu hansı oldu?

Ən çətin sorğu **3.15(a)** oldu: "Brooklyn-də yerləşən *hər bir* filialda hesabı olan müştərilər".
Burada "ən azı bir filialda" yox, "bütün filiallarda" şərti var, yəni relyasion bölmə (division)
məsələsidir. SQL-də birbaşa "for all" operatoru olmadığı üçün `NOT EXISTS (... EXCEPT ...)`
üsulundan istifadə etdim: Brooklyn filialları çoxluğundan müştərinin hesabı olan filialları
çıxırıq. Fərq boş çoxluqdursa, deməli müştərinin hər filialda hesabı var. Eyni məntiqi
3.28-də də ("öz departamentindəki bütün kursları tədris edən müəllimlər") tətbiq etdim.

## 2. Hansı sorğu üçün alt sorğu (subquery) istifadə etdim?

Alt sorğunu bir neçə tapşırıqda işlətdim:

- **3.11(b)** — `NOT IN (SELECT ID FROM takes WHERE year < 2017)`: 2017-dən əvvəl kurs almış
  tələbələri alt sorğu ilə tapıb xaric etdim.
- **3.11(d)** — `FROM` bəndində alt sorğu: əvvəlcə hər departamentin maksimum maaşını hesabladım,
  sonra onların arasından `MIN` götürdüm. Aqreqat funksiyanın üstündə birbaşa aqreqat yazmaq
  olmadığı üçün bu üsul lazım idi.
- **3.25** — skalyar alt sorğu ilə Philosophy departamentinin büdcəsini əldə edib müqayisə etdim.
- **3.35** — `WITH` ilə müvəqqəti nəticə yaradıb, `MAX(num)` üçün skalyar alt sorğu işlətdim.

## 3. JOIN istifadə etdiyim bir nümunə

**3.24**-də üç cədvəli birləşdirdim: `student`, `advisor` və `instructor`.
`student.ID = advisor.s_ID` şərti ilə tələbəni onun məsləhətçisinə, sonra
`advisor.i_ID = instructor.ID` şərti ilə məsləhətçini müəllim məlumatlarına bağladım. Bundan
sonra `WHERE` ilə tələbənin departamentinin Accounting, müəllimin departamentinin isə Physics
olduğunu yoxladım. Tələbə və müəllim fərqli departamentləri təmsil etdiyi üçün
`student.dept_name` və `instructor.dept_name` sütunlarını ayrı-ayrı alias ilə fərqləndirmək
vacib idi.

## 4. Qarşılaşdığım problem və onun həlli

Ən çox problem **NULL qiymətlərlə** bağlı oldu (3.31 və 3.32). Əvvəlcə "A qiyməti verməyən
müəllimlər" üçün `grade <> 'A'` kimi yazmağa çalışdım, amma qiyməti `NULL` olan sətirlərdə
müqayisə `unknown` verir və həmin sətirlər itirilir. Bundan əlavə, `NOT IN` alt sorğusunda
`NULL` olarsa, bütün nəticə boş çıxa bilər. Həlli: "heç vaxt A verməyən" şərtini
`NOT EXISTS` ilə, "ən azı bir qeyri-null qiymət" şərtini isə `EXISTS ... grade IS NOT NULL`
ilə yazdım. Test məlumatlarında qiyməti `NULL` olan bir tələbə əlavə edib yoxladım:
həmin tələbənin müəllimi 3.31-də görünür, amma 3.32-də görünmür, yəni sorğu gözlədiyim kimi
işləyir.
