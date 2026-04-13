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

    phone_notification_management_hap_old = os.path.join(
        args.path, 'SceneBoard_app-default_notificationmanagement-default-signed.hap')
    phone_notification_management_hap = os.path.join(args.path, 'SceneBoard_NotificationManagement.hap')

    phone_engineservice_hap_old = os.path.join(
        args.path, 'SceneBoard_app-engineservice-default-signed.hap')
    phone_engineservice_hap = os.path.join(args.path, 'SceneBoard_EngineService.hap')

    phone_themecomponent_hap_old = os.path.join(
        args.path, 'SceneBoard_app-themecomponent-default-signed.hap')
    phone_themecomponent_hap = os.path.join(args.path, 'SceneBoard_ThemeComponent.hap')

    phone_themeservice_hap_old = os.path.join(
            args.path, 'SceneBoard_app-themeservice_core-default-signed.hap')
    phone_themeservice_hap = os.path.join(args.path, 'SceneBoard_ThemeServiceCore.hap')

    phone_onekeylock_hap_old = os.path.join(
        args.path, 'SceneBoard_app-onekeylock-default-signed.hap')
    phone_onekeylock_hap = os.path.join(args.path, 'SceneBoard_onekeylock.hap')

    pad_hap_old = os.path.join(args.path, 'SceneBoard_app-pad_sceneboard-default-signed.hap')
    pad_hap = os.path.join(args.path, 'SceneBoard.hap')

    pc_hap_old = os.path.join(args.path, 'SceneBoard_app-pc_sceneboard-default-signed.hap')
    pc_hap = os.path.join(args.path, 'SceneBoard.hap')

    pcresourcesoverlay_hsp_old = os.path.join(args.path, 'SceneBoard_app-pcresourcesoverlay-default-signed.hsp')
    pcresourcesoverlay_hsp = os.path.join(args.path, 'pcresourcesoverlay.hsp')

    pc_notification_management_hap_old = os.path.join(
        args.path, 'SceneBoard_app-default_notificationmanagement-default-signed.hap')
    pc_notification_management_hap = os.path.join(args.path, 'SceneBoard_NotificationManagement.hap')

    pc_engineservice_hap_old = os.path.join(
        args.path, 'SceneBoard_app-engineservice-default-signed.hap')
    pc_engineservice_hap = os.path.join(args.path, 'SceneBoard_EngineService.hap')

    pc_themecomponent_hap_old = os.path.join(
        args.path, 'SceneBoard_app-themecomponent-default-signed.hap')
    pc_themecomponent_hap = os.path.join(args.path, 'SceneBoard_ThemeComponent.hap')

    pc_themeservice_hap_old = os.path.join(
                args.path, 'SceneBoard_app-themeservice_core-default-signed.hap')
    pc_themeservice_hap = os.path.join(args.path, 'SceneBoard_ThemeServiceCore.hap')
    pc_onekeylock_hap_old = os.path.join(
        args.path, 'SceneBoard_app-onekeylock-default-signed.hap')
    pc_onekeylock_hap = os.path.join(args.path, 'SceneBoard_onekeylock.hap')

    basecommon_hsp_old = os.path.join(
        args.path, 'SceneBoard_app-basecommon-default-signed.hsp')
    basecommon_hsp = os.path.join(args.path, 'basecommon.hsp')

    collaborationfwkdialog_hsp_old = os.path.join(
            args.path, 'SceneBoard_app-collaborationfwkdialog-default-signed.hsp')
    collaborationfwkdialog_hsp = os.path.join(args.path, 'SceneBoard_CFWKSystemDialog.hsp')

    phone_coverthemecomponent_hap_old = os.path.join(
        args.path, 'SceneBoard_app-coverthemecomponent-default-signed.hap')
    phone_coverthemecomponent_hap = os.path.join(args.path, 'SceneBoard_CoverThemeComponent.hap')

    car_hap_old = os.path.join(args.path, 'SceneBoard_app-car_sceneboard-default-signed.hap')
    car_hap = os.path.join(args.path, 'SceneBoard.hap')

    tv_hap_old = os.path.join(args.path, 'SceneBoard_app-tv_sceneboard-default-signed.hap')
    tv_hap = os.path.join(args.path, 'SceneBoard.hap')

    return [phone_hap_old, phone_hap,
            phone_notification_management_hap_old, phone_notification_management_hap,
            phone_engineservice_hap_old, phone_engineservice_hap,
            phone_themecomponent_hap_old, phone_themecomponent_hap, phone_themeservice_hap_old, phone_themeservice_hap,
            phone_coverthemecomponent_hap_old, phone_coverthemecomponent_hap, pad_hap_old, pad_hap,
            pcresourcesoverlay_hsp_old, pcresourcesoverlay_hsp, pc_hap_old, pc_hap,
            pc_notification_management_hap_old, pc_notification_management_hap,
            phone_onekeylock_hap_old, phone_onekeylock_hap,
            pc_engineservice_hap_old, pc_engineservice_hap, pc_themecomponent_hap_old, pc_themecomponent_hap,
            pc_themeservice_hap_old, pc_themeservice_hap, pc_onekeylock_hap_old, pc_onekeylock_hap,
            basecommon_hsp_old, basecommon_hsp, car_hap_old, car_hap, tv_hap_old, tv_hap, collaborationfwkdialog_hsp_old,
            collaborationfwkdialog_hsp]


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
     phone_notification_management_hap_old, phone_notification_management_hap,
     phone_engineservice_hap_old, phone_engineservice_hap,
     phone_themecomponent_hap_old, phone_themecomponent_hap, phone_themeservice_hap_old, phone_themeservice_hap,
     phone_coverthemecomponent_hap_old, phone_coverthemecomponent_hap, pad_hap_old, pad_hap,
     pcresourcesoverlay_hsp_old, pcresourcesoverlay_hsp, pc_hap_old, pc_hap,
     pc_notification_management_hap_old, pc_notification_management_hap,
     phone_onekeylock_hap_old, phone_onekeylock_hap,
     pc_engineservice_hap_old, pc_engineservice_hap, pc_themecomponent_hap_old, pc_themecomponent_hap,
     pc_themeservice_hap_old, pc_themeservice_hap, pc_onekeylock_hap_old, pc_onekeylock_hap,
     basecommon_hsp_old, basecommon_hsp,  car_hap_old, car_hap, tv_hap_old, tv_hap, collaborationfwkdialog_hsp_old,
     collaborationfwkdialog_hsp] = get_hap_path(args)

    hsps_dir = os.path.join(args.path, '..', 'SceneBoard_hsp')
    hsps_files = os.listdir(hsps_dir)
    for f in hsps_files:
        os.remove(os.path.join(hsps_dir, f))

    unsigned_hap_path_list = os.path.join(args.path, 'unsigned_hap_path_list.json')
    if os.path.exists(unsigned_hap_path_list):
        os.remove(unsigned_hap_path_list)

    if args.product == 'pc':
        move_hap(pc_hap, pc_hap_old)
        move_hap(pc_notification_management_hap, pc_notification_management_hap_old)
        move_hap(pc_engineservice_hap, pc_engineservice_hap_old)
        move_hap(pc_themecomponent_hap, pc_themecomponent_hap_old)
        move_hap(pc_themeservice_hap, pc_themeservice_hap_old)
        move_hap(pc_onekeylock_hap, pc_onekeylock_hap_old)
        remove_hap(basecommon_hsp_old)
        remove_hap(phone_hap_old)
        remove_hap(pad_hap_old)
        remove_hap(phone_notification_management_hap_old)
        remove_hap(phone_engineservice_hap_old)
        remove_hap(phone_themecomponent_hap_old)
        remove_hap(phone_themeservice_hap_old)
        remove_hap(phone_onekeylock_hap_old)
        remove_hap(phone_coverthemecomponent_hap_old)
        remove_hap(tv_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)
    elif (args.product == 'phone'):
        move_hap(phone_hap, phone_hap_old)
        move_hap(phone_notification_management_hap, phone_notification_management_hap_old)
        move_hap(phone_engineservice_hap, phone_engineservice_hap_old)
        move_hap(phone_themecomponent_hap, phone_themecomponent_hap_old)
        move_hap(phone_onekeylock_hap, phone_onekeylock_hap_old)
        move_hap(phone_themeservice_hap, phone_themeservice_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        move_hap(collaborationfwkdialog_hsp, collaborationfwkdialog_hsp_old)
        move_hap(phone_coverthemecomponent_hap, phone_coverthemecomponent_hap_old)
        remove_hap(pad_hap_old)
        remove_hap(pc_hap_old)
        remove_hap(pc_notification_management_hap_old)
        remove_hap(pc_engineservice_hap_old)
        remove_hap(pc_themecomponent_hap_old)
        remove_hap(pc_themeservice_hap_old)
        remove_hap(pc_onekeylock_hap_old)
        remove_hap(tv_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)
    elif (args.product == 'pad'):
        move_hap(pcresourcesoverlay_hsp, pcresourcesoverlay_hsp_old)
        move_hap(pad_hap, pad_hap_old)
        move_hap(phone_notification_management_hap, phone_notification_management_hap_old)
        move_hap(phone_engineservice_hap, phone_engineservice_hap_old)
        move_hap(phone_themecomponent_hap, phone_themecomponent_hap_old)
        move_hap(phone_onekeylock_hap, phone_onekeylock_hap_old)
        move_hap(phone_themeservice_hap, phone_themeservice_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        move_hap(phone_coverthemecomponent_hap, phone_coverthemecomponent_hap_old)
        remove_hap(phone_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)
        remove_hap(pc_hap_old)
        remove_hap(pc_notification_management_hap_old)
        remove_hap(pc_engineservice_hap_old)
        remove_hap(pc_themecomponent_hap_old)
        remove_hap(pc_themeservice_hap_old)
        remove_hap(pc_onekeylock_hap_old)
        remove_hap(tv_hap_old)
    elif (args.product == 'car'):
        move_hap(car_hap, car_hap_old)
        remove_hap(basecommon_hsp_old)
        remove_hap(pc_hap_old)
        remove_hap(pc_notification_management_hap_old)
        remove_hap(pc_engineservice_hap_old)
        remove_hap(pc_themecomponent_hap_old)
        remove_hap(pc_themeservice_hap_old)
        remove_hap(pc_onekeylock_hap_old)
        remove_hap(phone_hap_old)
        remove_hap(pad_hap_old)
        remove_hap(phone_notification_management_hap_old)
        remove_hap(phone_engineservice_hap_old)
        remove_hap(phone_themecomponent_hap_old)
        remove_hap(phone_themeservice_hap_old)
        remove_hap(phone_onekeylock_hap_old)
        remove_hap(phone_coverthemecomponent_hap_old)
        remove_hap(tv_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)
    elif (args.product == 'tv'):
        move_hap(tv_hap, tv_hap_old)
        move_hap(phone_notification_management_hap, phone_notification_management_hap_old)
        move_hap(phone_engineservice_hap, phone_engineservice_hap_old)
        move_hap(phone_themecomponent_hap, phone_themecomponent_hap_old)
        move_hap(phone_themeservice_hap, phone_themeservice_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        move_hap(phone_coverthemecomponent_hap, phone_coverthemecomponent_hap_old)
        remove_hap(phone_hap_old)
        remove_hap(pad_hap_old)
        remove_hap(pc_hap_old)
        remove_hap(pc_notification_management_hap_old)
        remove_hap(pc_engineservice_hap_old)
        remove_hap(pc_themecomponent_hap_old)
        remove_hap(pc_themeservice_hap_old)
        remove_hap(pc_onekeylock_hap_old)
        remove_hap(car_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)
    else:
        move_hap(phone_hap, phone_hap_old)
        move_hap(phone_notification_management_hap, phone_notification_management_hap_old)
        move_hap(phone_engineservice_hap, phone_engineservice_hap_old)
        move_hap(phone_themecomponent_hap, phone_themecomponent_hap_old)
        move_hap(phone_onekeylock_hap, phone_onekeylock_hap_old)
        move_hap(phone_themeservice_hap, phone_themeservice_hap_old)
        move_hap(basecommon_hsp, basecommon_hsp_old)
        move_hap(phone_coverthemecomponent_hap, phone_coverthemecomponent_hap_old)
        remove_hap(pc_hap_old)
        remove_hap(pc_notification_management_hap_old)
        remove_hap(pc_engineservice_hap_old)
        remove_hap(pc_themecomponent_hap_old)
        remove_hap(pc_themeservice_hap_old)
        remove_hap(pc_onekeylock_hap_old)
        remove_hap(tv_hap_old)
        remove_hap(pcresourcesoverlay_hsp_old)

if __name__ == '__main__':
    sys.exit(main())