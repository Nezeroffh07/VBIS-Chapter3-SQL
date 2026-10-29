# Izahat (Explanation)

**Qrup:** KOM24B — Chapter 3 Practice Assignment

## 1. Ən çətin hesab etdiyim SQL sorğusu hansı oldu?

Mənim üçün ən çətini 3.15(a) oldu: "Brooklyn-də yerləşən hər bir filialda hesabı olan müştərilər".
Əvvəlcə sadə bir JOIN yazıb işi bitirdim sandım, amma nəticədə Brooklyn-də yalnız bir filialda
hesabı olan müştərilər də çıxdı. Sonra başa düşdüm ki, sualda "ən azı bir" yox, "hər bir" sözü
var və bu, başqa məntiq tələb edir. SQL-də "hamısı üçün" deyə hazır operator olmadığı üçün
`NOT EXISTS` ilə `EXCEPT` birləşdirdim: Brooklyn filiallarının siyahısından müştərinin hesabı
olan filialları çıxırıq, əgər heç nə qalmırsa, deməli müştəri hamısında hesab açıb. Eyni üsulu
3.28-də də işlətdim.

## 2. Hansı sorğu üçün alt sorğu (subquery) istifadə etdim?

Bir neçə yerdə işlətdim. 3.11(b)-də 2017-dən əvvəl kurs götürənlərin ID-lərini alt sorğu ilə
tapıb `NOT IN` ilə kənarlaşdırdım. 3.25-də Philosophy departamentinin büdcəsini alt sorğu ilə
götürüb digər departamentlərlə müqayisə etdim. Ən çox 3.11(d)-də lazım oldu: orada əvvəlcə hər
departamentin maksimum maaşını tapmaq, sonra onların ən kiçiyini seçmək lazım idi. `MIN(MAX(...))`
yazmaq mümkün olmadığı üçün birinci hesablamanı `FROM` içində alt sorğu kimi yazdım.
3.35-də isə `WITH` ilə bölmələrin tələbə sayını ayrıca hesablayıb, `MAX` ilə müqayisə etdim.

## 3. JOIN istifadə etdiyim bir nümunəni izah edin

3.24 JOIN-in yaxşı nümunəsidir. Tələbənin adı `student` cədvəlindədir, onun məsləhətçisi
`advisor` cədvəlindədir, məsləhətçinin departamenti isə `instructor` cədvəlindədir. Yəni üç
cədvəli zəncir kimi bağlamaq lazım idi: `student.ID = advisor.s_ID`, sonra
`advisor.i_ID = instructor.ID`. Bundan sonra `WHERE` ilə tələbənin departamentinin Accounting,
müəllimin departamentinin Physics olduğunu yoxladım. Hər iki cədvəldə `dept_name` sütunu
olduğu üçün qarışmasın deyə `s` və `i` alias-larından istifadə etdim.

## 4. Qarşılaşdığım problem və onun həlli

Ən çox vaxtımı NULL dəyərlər apardı (3.31 və 3.32). "A qiyməti verməyən müəllimlər" üçün ilk
ağlıma gələn `grade <> 'A'` oldu, amma qiyməti NULL olan sətirlərdə bu müqayisə nə doğru, nə də
yalan olur, nəticədə həmin sətirlər sadəcə itir. `NOT IN` də alt sorğuda NULL olarsa, gözlənilməz
şəkildə boş nəticə verə bilər. Buna görə `NOT EXISTS` ilə yazdım, 3.32-də isə qeyri-null qiymət
şərtini `IS NOT NULL` ilə ayrıca yoxladım. Sonra test məlumatlarına qiyməti NULL olan bir tələbə
əlavə etdim və yoxladım: onun müəllimi 3.31-də görünür, 3.32-də görünmür. Bu, mənim üçün NULL-un
SQL-də necə davrandığını başa düşməyə kömək etdi.
