#!/bin/sh

if [ $# -lt 3 ]; then
    echo Usage: $0 cluster domain node [node ...]
    exit 1
fi

create_principal() {
    principal=$1
    passwd=$2

    if [ "x$passwd" != "x" ]; then
        passwd="-pw $passwd"
    else
        passwd="-randkey"
    fi

    if kadmin.local -q 'listprincs' | grep -q ${principal}@; then
        echo principal $principal aleady exits
    else
        kadmin.local -q "addprinc $passwd $principal"
    fi
}

CLUSTER_NAME=$1
DOMAIN_NAME=$2

create_principal mapr/$CLUSTER_NAME mapr

shift
shift

for node in $*; do
    node=$node.$DOMAIN_NAME
    create_principal mapr/$node
    create_principal HTTP/$node

    rm -fr $node
    mkdir $node
    kadmin.local -q "ktadd -norandkey -k $node/mapr.keytab mapr/$CLUSTER_NAME"
    kadmin.local -q "ktadd -norandkey -k $node/mapr.keytab mapr/$node"
    kadmin.local -q "ktadd -norandkey -k $node/mapr.keytab HTTP/$node"
done

