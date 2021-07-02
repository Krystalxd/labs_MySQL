/* compress */

use shop;

select compress(sh_name) from shops;

/* MD5 */

select md5(sh_name) from shops;

/* RANDOM_BYTES */

select random_bytes(sh_id) from shops;

/* SHA1, SHA и SHA2 */

select sha(sh_name) from shops;

/* statement digest */

SET @stmt = 'SELECT * FROM shops';
SELECT STATEMENT_DIGEST(@stmt);


/* uncompress */
SELECT UNCOMPRESS(COMPRESS('any string'));


/* uncompressed_length */
SELECT UNCOMPRESSED_LENGTH(COMPRESS(REPEAT('a',30)));



/*VALIDATE_PASSWORD_STRENGTH*/


select validate_password_strength(sh_number) from shops;
