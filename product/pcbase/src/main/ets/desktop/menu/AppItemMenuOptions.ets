/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { MenuInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DeskTopMenuType } from '../../common/viewmodel/RightMenuOptionsCalc';
import { DesktopBaseMenuOptions } from './DesktopBaseMenuOptions';

const TAG = 'AppItemMenuOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面元素之应用图标,AppItem -> AppIconCommonView -> AppIconMenu -> AppMenu
 */
const APP_MENU_HEIGHT_ADD_FOLD = px2vp(14);
const APP_MENU_HEIGHT_ADD = APP_MENU_HEIGHT_ADD_FOLD + 20;
const APP_MENU_WIDTH_ADD = px2vp(14);
const MENU_WIDTH = 160;
export class AppItemMenuOptions extends DesktopBaseMenuOptions {

  getMenuWidth(menuInfoList: MenuInfo[]): number {
    return MENU_WIDTH - 2 * StyleConstants.DEFAULT_4 + APP_MENU_WIDTH_ADD;
  }

  getMenuHeight(menuInfoList: MenuInfo[]): number {
    const heightAdd = APP_MENU_HEIGHT_ADD;
    return super.getDefaultMenuHeight(menuInfoList, DeskTopMenuType.appItem) + heightAdd;
  }

}