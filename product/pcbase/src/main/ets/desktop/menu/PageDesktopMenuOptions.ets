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
import PcRightMenuViewModel from '../../common/viewmodel/PcRightMenuViewModel';
import { DesktopBaseMenuOptions } from './DesktopBaseMenuOptions';
import { SCBSessionRect } from '@ohos/windowscene';

const DIVIDER_HEIGHT = px2vp(1);
const MENU_ITEM_HEIGHT = 40;
const TAG = 'PageDesktopMenuOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面元素之桌面空白处,PageDeskTopLayout -> RightMenu
 */
const WIDTH_ITEM = 160;
export class PageDesktopMenuOptions extends DesktopBaseMenuOptions {
  private pcRightMenuViewModel: PcRightMenuViewModel = new PcRightMenuViewModel();

  getMenuWidth(menuInfoList: MenuInfo[]): number {
    let menuWidth = WIDTH_ITEM;
    for (const menuItem of menuInfoList) {
      if (!menuItem?.menuText) {
        continue;
      }
      let currItemWidth: number = this.pcRightMenuViewModel.getMenuWidthAdaptive(menuItem);
      if (currItemWidth > menuWidth) {
        menuWidth = currItemWidth;
      }
    }
    log.showInfo(`getMenuWidth ${menuWidth}`);
    return menuWidth;
  }

  getMenuHeight(menuInfoList: MenuInfo[]): number {
    if (!menuInfoList || menuInfoList.length === 0) {
      return 0;
    }
    let separatorList: MenuInfo[] = [];
    let menuItemList: MenuInfo[] = [];
    let separatorHeight = 0;
    let menuItemHeight = 0;
    let sumHeight = 0;
    for (let menuInfo of menuInfoList) {
      if (menuInfo?.menuKeyString === '-') {
        separatorList.push(menuInfo);
      } else {
        menuItemList.push(menuInfo);
      }
    }

    if (separatorList.length > 0 ) {
      separatorHeight = (DIVIDER_HEIGHT + StyleConstants.DEFAULT_4 * 2 +
        StyleConstants.DEFAULT_3 * 2) * separatorList.length;
    }
    if (menuItemList.length > 0) {
      menuItemHeight = (MENU_ITEM_HEIGHT + StyleConstants.DEFAULT_1 * 2) * menuItemList.length;
    }
    sumHeight = separatorHeight + menuItemHeight;
    log.showInfo('getPageDesktopMenuHeight length: %{public}d, [%{public}d, %{public}d, %{public}d]',
      menuInfoList.length, separatorHeight, menuItemHeight, sumHeight);
    return sumHeight;
  }

  getItemHeight(baseEvent: BaseEvent): number {
    //桌面菜单跟手，计算offset偏移量Y时，itemHeight的叠加高度为0
    return 0;
  }

  getItemWidth(baseEvent: BaseEvent): number {
    //桌面菜单跟手，计算offset偏移量X时，itemWidth的叠加高度为0
    return 0;
  }

  getEventPosition(baseEvent: BaseEvent): Position {
    let position: Position = { x: 0, y: 0 };
    const isTouchEvent = this.isTouchEvent(baseEvent);
    if (isTouchEvent) {
      const event = (baseEvent) as TouchEvent;
      position.x = event.touches[0].windowX;
      position.y = event.touches[0].windowY;
    } else {
      const event = (baseEvent) as MouseEvent;
      position.x = Number(event.windowX);
      position.y = Number(event.windowY);
    }
    log.showInfo(`getEventPosition isTouchEvent: ${isTouchEvent} x: ${position.x} y: ${position.y}`);
    return position;
  }

  getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Position {
    let offset: Position = { x: 0, y: 0 };
    if (!screenRect) {
      log.showError('getMenuOffset screenRect invalid');
      return offset;
    }
    offset = super.getClickMenuOffset(event, menuInfoList, screenRect, fakeScreenRect);
    log.showInfo('getMenuOffset, [%{public}d], [%{public}d], [%{public}d]', menuInfoList.length, offset.x, offset.y);
    return offset;
  }

}