%module RUBDD 
%{
#include "BDD.h"
#include "ZBDD.h"
#include "CtoI.h"
#include "BtoI.h"
#include "vsop.h"
%}
%rename(bdd_and) operator&(const BDD&, const BDD&);
%rename(bdd_or) operator|(const BDD&, const BDD&);
%rename(bdd_hat) operator^(const BDD&, const BDD&);
%rename(bdd_eq) operator==(const BDD&, const BDD&);

%rename(bddv_and) operator&(const BDDV&, const BDDV&);
%rename(bddv_or) operator|(const BDDV&, const BDDV&);
%rename(bddv_hat) operator^(const BDDV&, const BDDV&);
%rename(bddv_eq) operator==(const BDDV&, const BDDV&);


%rename(zbdd_and) operator&(const ZBDD&, const ZBDD&);
%rename(zbdd_add) operator+(const ZBDD&, const ZBDD&);
%rename(zbdd_sub) operator-(const ZBDD&, const ZBDD&);
%rename(zbdd_mul) operator*(const ZBDD&, const ZBDD&);
%rename(zbdd_div) operator/(const ZBDD&, const ZBDD&);
%rename(zbdd_mod) operator%(const ZBDD&, const ZBDD&);
%rename(zbdd_eq) operator==(const ZBDD&, const ZBDD&);

%rename(zbddv_and) operator&(const ZBDDV&, const ZBDDV&);
%rename(zbddv_add) operator+(const ZBDDV&, const ZBDDV&);
%rename(zbddv_sub) operator-(const ZBDDV&, const ZBDDV&);
%rename(zbddv_eq) operator==(const ZBDDV&, const ZBDDV&);

%rename(ctoi_eq) operator==(const CtoI&, const CtoI&);
%rename(ctoi_add) operator+(const CtoI&, const CtoI&);
%rename(ctoi_sub) operator-(const CtoI&, const CtoI&);
%rename(ctoi_mul) operator*(const CtoI&, const CtoI&);
%rename(ctoi_div) operator/(const CtoI&, const CtoI&);
%rename(ctoi_mod) operator%(const CtoI&, const CtoI&);

%rename(btoi_eq) operator==(const BtoI&, const BtoI&);
%rename(btoi_add) operator+(const BtoI&, const BtoI&);
%rename(btoi_sub) operator-(const BtoI&, const BtoI&);
%rename(btoi_mul) operator*(const BtoI&, const BtoI&);
%rename(btoi_div) operator/(const BtoI&, const BtoI&);
%rename(btoi_mod) operator%(const BtoI&, const BtoI&);
%rename(btoi_and) operator&(const BtoI&, const BtoI&);
%rename(btoi_bar) operator|(const BtoI&, const BtoI&);
%rename(btoi_hat) operator^(const BtoI&, const BtoI&);

%include BDD.h
%include ZBDD.h
%include CtoI.h
%include BtoI.h
%include vsop.h