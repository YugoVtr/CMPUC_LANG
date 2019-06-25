/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_FLEXBISON_TAB_H_INCLUDED
# define YY_YY_FLEXBISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ADD = 258,
    SUB = 259,
    MULT = 260,
    DIV = 261,
    ADDI = 262,
    SUBI = 263,
    RSUBI = 264,
    MULTI = 265,
    DIVI = 266,
    RDIVI = 267,
    LSHIFT = 268,
    LSHIFTI = 269,
    RSHIFT = 270,
    RSHIFTI = 271,
    AND = 272,
    ANDI = 273,
    OR = 274,
    ORI = 275,
    XOR = 276,
    XORI = 277,
    LOAD = 278,
    LOADAI = 279,
    LOADAO = 280,
    CLOAD = 281,
    CLOADAI = 282,
    CLOADAO = 283,
    LOADI = 284,
    STORE = 285,
    STOREAI = 286,
    STOREAO = 287,
    CSTORE = 288,
    CSTOREAI = 289,
    CSTOREAO = 290,
    I2I = 291,
    C2C = 292,
    C2I = 293,
    I2C = 294,
    CMP_LT = 295,
    CMP_LE = 296,
    CMP_EQ = 297,
    CMP_GE = 298,
    CMP_GT = 299,
    CMP_NE = 300,
    CBR = 301,
    COMP = 302,
    CBR_LT = 303,
    CBR_LE = 304,
    CBR_EQ = 305,
    CBR_GE = 306,
    CBR_GT = 307,
    CBR_NE = 308,
    JUMPI = 309,
    JUMP = 310,
    TBL = 311,
    NUM = 312,
    REG = 313,
    LABEL = 314,
    CARACTERE = 315,
    APAR = 316,
    FPAR = 317,
    DOISPONTOS = 318,
    NOP = 319,
    ERRO = 320,
    OUTPUTI = 321,
    OUTPUTC = 322
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_FLEXBISON_TAB_H_INCLUDED  */
