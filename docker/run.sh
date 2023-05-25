#!/usr/bin/env sh

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

CONF=${CONF:-/var/lib/kvrocks/kvrocks.conf}

escape() {
  printf '%s\n' "$@" | sed 's/[][()*\.]/\\&/g'
}

conf() {
  echo $@
  key=$(escape $1)
  val=$(escape $2)
  sed -i -e "s/^$key .*/$key $val/" $CONF
}

env | while IFS='=' read -r name value; do
  case "$name" in
  KVROCKS_*)
    key=$(echo ${name#KVROCKS_} | tr '[:upper:]' '[:lower:]')
    key=$(echo "$key" | sed 's/__/\./g')
    conf $key $value
    ;;
  esac
done

echo "> $@"
exec $@
