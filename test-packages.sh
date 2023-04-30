#!/usr/local/bin/bash

# TODO: the 3k+1 package
# 1. Doesn't exist
# 2. Has a broken link in the documentation

set -e

PARI_PACKAGES="alnuth \
        polenta \
        radiroot \
        guarana \
        "

SINGULAR_PACKAGES="liepring \
        sglppow \
        singular \
        gradedringforhomalg \
        examplesforhomalg \
        modulepresentationsforcap \
        ringsforhomalg \
\
        gradedmodules \
        hap \
        hapcryst \
        localizeringforhomalg \
"

OTHER_4ti2_REQ="4ti2interface \
        help \
"

XGAP_REQ="\
        xgap\
        itc \
"

ZEROMQ_REQ="\
        jupyterkernel \
        jupyterviz \
"
MERCURIAL_REQ="\
        packagemanager \
"
POLYMAKE_REQ="\
        polymaking \
"
LIBCDD_REQ="\
        nconvex \
        toricvarieties \
"

PASSED_PACKAGES="aclib \
        agt \
        automata \
        automgrp \
        autpgrp \
        circle \
        classicpres \
        congruence \
        corelg \
        crime \
        crisp \
        cryst \
        crystcat \
        ctbllib \
        cubefree \
        design \
        difsets \
        factint \
        fga \
        fining \
        forms \
        fr \
        fwtree \
        gbnp \
        genss \
        groupoids \
        grpconst \
        hecke \
        idrel \
        images \
        intpic \
        irredsol \
        kan \
        laguna \
        liealgdb \
        liering \
        loops \
        lpres \
        majoranaalgebras \
        mapclass \
        matgrp \
        modisom \
        nilmat \
        nock \
        numericalsgps \
        openmath \
        patternclass \
        primgrp \
        qpa \
        quagroup \
        rcwa \
        rds \
        recog \
        repndecomp \
        repsn \
        resclasses \
        sgpviz \
        sl2reps \
        sla \
        smallgrp \
        smallsemi \
        sonata \
        sophus \
        autodoc \
        cap \
        gaussforhomalg \
        generalizedmorphismsforcap \
        homalg \
        homalgtocas \
        io_forhomalg \
        linearalgebraforcap \
        matricesforhomalg \
        modules \
        monoidalcategories \
        sco \
        toolsforhomalg \
        anupq \
        caratinterface \
        crypting \
        curlinterface \
        cvec \
        datastructures \
        deepthought \
        digraphs \
        ferret \
        float \
        gauss \
        grape \
        io \
        json \
        nq \
        orb \
        profiling \
        cohomolo \
        example \
        kbmag \
        format \
        permut \
"

FAILED_PACKAGES="\
        francy \
"

DIDNT_EXIT_PACKAGES="\
        ace \
        browse \
        edim \
        gapdoc \
        guava \
        scscp \
        simpcomp \
        spinsym \
"
#I  simpcomp: package `homology' not installed or its binaries are not available, falling back to (slower) internal homology algorithms.
#I  simpcomp: package `GRAPE' not installed or its binaries are not available, falling back to (slower) internal algorithms for automorphism group computation.


SLOW_PACKAGES="
        polycyclic \
        fplsa \
"

# PACKAGES="$FAILED_PACKAGES $PACKAGES $SINGULAR_PACKAGES $PARI_PACKAGES"
PACKAGES="$PACKAGES $PARI_PACKAGES"

for package in $PACKAGES; do
    echo "Testing package $package"
    # gap -r -c 'SetInfoLevel(InfoPackageLoading,4); if TestPackage("'$package'") <> true then FORCE_QUIT_GAP(2); else FORCE_QUIT_GAP(0); fi; FORCE_QUIT_GAP(1);'
    gap -r -c 'if TestPackage("'$package'") <> true then FORCE_QUIT_GAP(2); else FORCE_QUIT_GAP(0); fi; FORCE_QUIT_GAP(1);'
    echo "Tested package $package"
done
