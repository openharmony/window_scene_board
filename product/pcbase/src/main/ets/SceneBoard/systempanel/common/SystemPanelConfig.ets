/*
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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { MenuType } from './Constants';

export interface MenuLayout {
  id: number;
  content: string | Resource;
  clickable: boolean;
  hasDivider: boolean;
  needIcon?: boolean;
  iconKey?: string;
}

const PC_MENU_LAYOUT_GROUPS: MenuLayout[] = [
  {
    id: MenuType.SETTINGS_MENU,
    content: $r('app.string.system_settings'),
    clickable: true,
    hasDivider: true
  },
  {
    id: MenuType.SLEEP_MENU,
    content: $r('app.string.sleep'),
    clickable: true,
    hasDivider: false
  },
  {
    id: MenuType.LOCK_MENU,
    content: $r('app.string.lock_screen'),
    clickable: true,
    hasDivider: false,
    needIcon: true,
    iconKey: 'L'
  },
  {
    id: MenuType.REBOOT_MENU,
    content: $r('app.string.reboot_device'),
    clickable: true,
    hasDivider: false
  },
  {
    id: MenuType.SHUTDOWN_MENU,
    content: $r('app.string.shutdown_device'),
    clickable: true,
    hasDivider: false
  }
];

const PC_EMULATOR_MENU_LAYOUT_GROUPS: MenuLayout[] = [
  {
    id: MenuType.SETTINGS_MENU,
    content: $r('app.string.system_settings'),
    clickable: true,
    hasDivider: true
  },
  {
    id: MenuType.LOCK_MENU,
    content: $r('app.string.lock_screen'),
    clickable: true,
    hasDivider: false,
    needIcon: true,
    iconKey: 'L'
  },
];

export class SystemPanelConfig {
  public menuConfig: Array<MenuLayout> = PC_MENU_LAYOUT_GROUPS;

  init(): void {
    if (DeviceHelper.isEmulator()) {
      this.menuConfig = PC_EMULATOR_MENU_LAYOUT_GROUPS;
    }
  }
}
