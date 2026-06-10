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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { MenuInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { DeskTopMenuType } from '../../common/viewmodel/RightMenuOptionsCalc';
import { DesktopBaseMenuOptions } from './DesktopBaseMenuOptions';

/**
 * 桌面元素之卡片,FormItemRelative -> FormMenuItem -> AppMenu（isBusinessStyle=true）
 */
const MENU_WIDTH = 160;
const FORM_MENU_WIDTH_ADD = px2vp(14);
const FORM_MENU_HEIGHT_ADD = 10;

const TAG = 'FormMenuOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormMenuOptions extends DesktopBaseMenuOptions {
  private fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();

  getMenuWidth(menuInfoList: MenuInfo[]): number {
    const menuWidth = Math.ceil(MENU_WIDTH * this.fontScaleState.getFontScale() - 2 * StyleConstants.DEFAULT_4 +
      FORM_MENU_WIDTH_ADD);
    log.showInfo(`getMenuWidth ${menuWidth}`);
    return menuWidth;
  }

  getMenuHeight(menuInfoList: MenuInfo[]): number {
    return super.getDefaultMenuHeight(menuInfoList, DeskTopMenuType.formMenuEvent) + FORM_MENU_HEIGHT_ADD;
  }

  getItemHeight(baseEvent: BaseEvent): number {
    return super.getItemHeight(baseEvent);
  }

  getItemWidth(baseEvent: BaseEvent): number {
    return super.getItemWidth(baseEvent);
  }
}