/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants, DockItemInfo } from '@ohos/launchercommon';

const PresetDockItem: DockItemInfo[] = [
  {
    bundleName: CommonConstants.LAUNCHER_BUNDLE,
    abilityName: CommonConstants.APPCENTER_ABILITY,
    iconId: '/common/pics/ic_allapps.png',
    labelId: $r('app.string.dock_all_app_entry'),
    itemType: CommonConstants.TYPE_FUNCTION,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: false,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.LAUNCHER_BUNDLE,
    abilityName: CommonConstants.RECENT_ABILITY,
    iconId: '/common/pics/ic_multitask.png',
    labelId: $r('app.string.dock_recents_entry'),
    itemType: CommonConstants.TYPE_FUNCTION,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: false,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.FILE_MANAGER_BUNDLE,
    abilityName: 'MainAbility',
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: false,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.LAUNCHER_BUNDLE,
    abilityName: CommonConstants.RECYCLE_BIN_ABILITY,
    iconId: '/common/pics/ic_recycle_bin.png',
    labelId: $r('app.string.dock_recents_entry'),
    itemType: CommonConstants.TYPE_FUNCTION,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: false,
    appIndex: 0,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.BROWSER_BUNDLE,
    abilityName: CommonConstants.BROWSER_ABILITY,
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: 'com.ohos.email',
    abilityName: 'com.ohos.email.MainAbility',
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.PHOTOS_BUNDLE,
    abilityName: CommonConstants.PHOTOS_ABILITY,
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: 'com.ohos.meetime',
    abilityName: 'com.ohos.meetime.MainAbility',
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.MUSIC_BUNDLE,
    abilityName: CommonConstants.MUSIC_ABILITY,
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: 'com.ohos.books',
    abilityName: 'com.ohos.books.MainAbility',
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: 'com.ohos.appgallery',
    abilityName: 'com.ohos.appgallery.MainAbility',
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  },
  {
    bundleName: CommonConstants.SETTINGS_BUNDLE,
    abilityName: CommonConstants.SETTINGS_ABILITY,
    itemType: CommonConstants.TYPE_APP,
    areaType: CommonConstants.TYPE_AREA_DOCK,
    editable: true,
    visible: true,
    borderVisible: false,
    shake: 0,
    missionInfoList: [],
    appIconId: 0,
    appName: ''
  }
];

export default PresetDockItem;