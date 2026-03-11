#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright (c) 2023 Huawei Device Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import shutil
import os
import sys
import argparse
import subprocess


def get_hap_path(args):
    phone_hap_old = os.path.join(args.path, 'SceneBoard_app-phone_sceneboard-default-signed.hap')
    phone_hap = os.path.join(args.path, 'SceneBoard.hap')

    pad_hap_old = os.path.join(args.path, 'SceneBoard_app-pad_sceneboard-default-signed.hap')
    pad_hap = os.path.join(args.path, 'SceneBoard.hap')

    pc_hap_old = os.path.join(args.path, 'SceneBoard_app-pc_sceneboard-default-signed.hap')
    pc_hap = os.path.join(args.path, 'SceneBoard.hap')

    basecommon_hsp_old = os.path.join(
        args.path, 'SceneBoard_app-basecommon-default-signed.hsp')
    basecommon_hsp = os.path.join(args.path, 'basecommon.hsp')

    return [phone_hap_old, phone_hap,
            pad_hap_old, pad_hap,
            pc_hap_old, pc_hap,
            basecommon_hsp_old, basecommon_hsp
            ]


def move_hap(new_hap_path, old_hap_path):
    if os.path.exists(new_hap_path):
        os.remove(new_hap_path)
    subprocess.run(['mv', old_hap_path, new_hap_path])


def remove_hap(hap_path):
    if os.path.exists(hap_path):
        os.remove(hap_path)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', help='path of haps')
    parser.add_argument('--product', help='product')
    args = parser.parse_args()

    [phone_hap_old, phone_hap,
     pad_hap_old, pad_hap,
     pc_hap_old, pc_hap,
     basecommon_hsp_old, basecommon_hsp] = get_hap_path(args)

    hsps_dir = os.path.join(args.path, '..', 'SceneBoard_hsp')
    hsps_files = os.listdir(hsps_dir)
    for f in hsps_files:
        os.remove(os.path.join(hsps_dir, f))

    unsigned_hap_path_list = os.path.join(args.path, 'unsigned_hap_path_list.json')
    if os.path.exists(unsigned_hap_path_list):
        os.remove(unsigned_hap_path_list)

    if args.product == 'pc':
        move_hap(pc_hap, pc_hap_old)
        remove_hap(basecommon_hsp_old)
        remove_hap(phone_hap_old)
        remove_hap(pad_hap_old)
    elif (args.product == 'phone'):
        move_hap(phone_hap, phone_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        remove_hap(pad_hap_old)
        remove_hap(pc_hap_old)
    elif (args.product == 'pad'):
        move_hap(pad_hap, pad_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        remove_hap(phone_hap_old)
        remove_hap(pc_hap_old)
   else:
        move_hap(phone_hap, phone_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        remove_hap(pc_hap_old)

if __name__ == '__main__':
    sys.exit(main())