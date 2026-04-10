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
import { CommonConstants, MenuInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBSceneSessionManager, SCBSessionRect, SCBSystemSceneSession, SystemBarType } from '@ohos/windowscene';
import { DeskTopMenuType } from '../../common/viewmodel/RightMenuOptionsCalc';
import { DesktopMenuOptionsInterface, DistanceRect } from './DesktopMenuOptionsInterface';

const DEFAULT_MENU_WIDTH = 160;
const DIVIDER_HEIGHT = px2vp(1);
const MENU_ITEM_HEIGHT = 40;
const TAG = 'DesktopBaseMenuOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面元素菜单默认处理类
 */
export class DesktopBaseMenuOptions implements DesktopMenuOptionsInterface {

  getMenuWidth(menuInfoList: MenuInfo[]): number {
    return DEFAULT_MENU_WIDTH;
  }

  getMenuHeight(menuInfoList: MenuInfo[]): number {
    return this.getDefaultMenuHeight(menuInfoList, DeskTopMenuType.appItem);
  }

  getItemHeight(baseEvent: BaseEvent): number {
    let height: number = 0;
    const isTouchEvent = this.isTouchEvent(baseEvent);
    if (!isTouchEvent) {
      log.showWarn('getDesktopItemHeight support touch only');
      return height;
    }
    height = Number(baseEvent.target.area.height);
    log.showInfo(`getDesktopItemHeight height ${height}`);
    return height;
  }

  getItemWidth(baseEvent: BaseEvent): number {
    let width: number = 0;
    const isTouchEvent = this.isTouchEvent(baseEvent);
    if (!isTouchEvent) {
      log.showWarn('getDesktopItemWidth support touch only');
      return width;
    }
    width = Number(baseEvent.target.area.width);
    log.showInfo(`getDesktopItemWidth width ${width}`);
    return width;
  }

  getEventPosition(baseEvent: BaseEvent): Position {
    let position: Position = { x: 0, y: 0 };
    const isTouchEvent = this.isTouchEvent(baseEvent);
    if (isTouchEvent) {
      position.x = Number(baseEvent.target.area.globalPosition.x);
      position.y = Number(baseEvent.target.area.globalPosition.y);
    } else {
      const event = (baseEvent) as MouseEvent;
      position.x = Number(event.windowX);
      position.y = Number(event.windowY);
    }
    log.showInfo(`getEventPosition isTouchEvent: ${isTouchEvent} x: ${position.x} y: ${position.y}`);
    return position;
  }

  /**
   * 1.右侧空间足够，优先右侧，RightTop > RightBottom,上下空间都不够，RightTop和偏移量组合使用
   * 2.右侧空间不够，左侧空间足够，LeftTop > LeftBottom,上下空间都不够，LeftTop和偏移量组合使用
   * 3.左右空间都不够，返回undefined
   * @param event
   * @param menuInfoList
   * @param screenRect
   * @param fakeScreenRect
   * @returns
   */
  getMenuPlacement(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Placement | undefined {
    let placement: Placement | undefined = undefined;
    if (!screenRect) {
      log.showError('getMenuPlacement screenRect invalid');
      return placement;
    }
    const isTouchEvent = this.isTouchEvent(event);
    if (!isTouchEvent) {
      log.showInfo('getMenuPlacement support only touch');
      return placement;
    }
    const distanceRect = this.getDistanceRect(event, menuInfoList, screenRect, fakeScreenRect);
    const menuWidth = this.getMenuWidth(menuInfoList);
    const menuHeight = this.getMenuHeight(menuInfoList);
    if (menuWidth < distanceRect.toLeft) {
      placement = Placement.LeftTop;
      if (menuHeight > distanceRect.toBottom && menuHeight < distanceRect.toTop) {
        placement = Placement.LeftBottom;
      }
    }
    //右侧优先级更高
    if (menuWidth < distanceRect.toRight) {
      placement = Placement.RightTop;
      if (menuHeight > distanceRect.toBottom && menuHeight < distanceRect.toTop) {
        placement = Placement.RightBottom;
      }
    }
    log.showInfo(`getMenuPlacement,placement: ${placement}`);
    return placement;
  }

  getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Position {
    let offset: Position = { x: 0, y: 0 };
    if (!screenRect) {
      log.showError('getMenuOffset screenRect invalid');
      return offset;
    }
    const isTouchEvent = this.isTouchEvent(event);
    if (!isTouchEvent) {
      offset = this.getClickMenuOffset(event, menuInfoList, screenRect, fakeScreenRect);
    } else {
      offset = this.getLongPressMenuOffset(event, menuInfoList, screenRect, fakeScreenRect);
    }
    if (isTouchEvent) {
      offset.x = 5;
    }
    log.showInfo('getMenuOffset, [%{public}d, %{public}s], [%{public}d, %{public}d]',
      menuInfoList.length, isTouchEvent, offset.x, offset.y);
    return offset;
  }


  /**
   * 长按菜单的offset,菜单优先显示在组件的右侧，右侧空间不够，显示在左侧，处理跨中轴和底部空间不够的场景
   * @param event
   * @param menuInfoList
   * @param screenRect
   * @param fakeScreenRect
   * @returns
   */
  protected getLongPressMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Position {
    let offset: Position = { x: 0, y: 0 };
    if (!screenRect) {
      log.showError('getLongPressMenuOffset screenRect invalid');
      return offset;
    }
    const placement = this.getMenuPlacement(event, menuInfoList, screenRect, fakeScreenRect);
    if (placement === Placement.RightBottom || placement === Placement.LeftBottom) {
      log.showInfo('getLongPressMenuOffset lower side alignment');
      return offset;
    }
    const yPosition = this.getEventPosition(event).y as number;
    let menuHeight = this.getMenuHeight(menuInfoList);
    let distanceRect: DistanceRect = new DistanceRect();
    log.showInfo('getLongPressMenuOffset [%{public}d, %{public}d], [%{public}d, %{public}d]', screenRect.width.getVp(),
    screenRect.height.getVp(), fakeScreenRect?.top.getVp(), fakeScreenRect?.height.getVp());
    const screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
    const dockHeight = this.getStatusbarOrDockHeightVp(SystemBarType.SMART_DOCK, screenId);
    distanceRect.toBottom = screenRect.height.getVp() - dockHeight - yPosition;
    offset.y = Math.min(distanceRect.toBottom - menuHeight, 0);
    log.showInfo('getLongPressMenuOffset, [%{public}d, %{public}d], [%{public}d, %{public}d]',
      menuInfoList.length, yPosition, offset.x, offset.y);

    return offset;
  }

  /**
   * 右键菜单跟手的offset, 右键菜单，默认菜单默认在下方，仅处理跨中轴场景，其他场景使用arkui的自动避让
   * @param event
   * @param menuInfoList
   * @param screenRect
   * @param fakeScreenRect
   * @returns
   */
  protected getClickMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Position {
    let offset: Position = { x: 0, y: 0 };
    if (!screenRect) {
      log.showError('getClickMenuOffset screenRect invalid');
      return offset;
    }
    const yPosition = this.getEventPosition(event).y as number;
    log.showInfo('getClickMenuOffset, [%{public}d, %{public}d], [%{public}d], [%{public}d]',
      menuInfoList.length, yPosition, offset.x, offset.y);
    return offset;
  }

  protected getStatusbarOrDockHeightVp(type: SystemBarType, screenId: number): number {
    const statusBarOrDock: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithSystemBarType(type, screenId);
    log.showInfo(`getStatusbarOrDockHeightVp ${type} ${statusBarOrDock?.currRect?.height.getVp()}`);
    return statusBarOrDock ? statusBarOrDock.currRect.height.getVp() : 0;
  }

  /**
   * BaseEvent 识别出是触屏长按还是鼠标
   * touchEvent和gestureEvent都属于触屏
   * MouseEvent 属于鼠标
   * @param event
   * @returns
   */
  protected isTouchEvent(event: BaseEvent): boolean {
    return event && event.source === SourceType.TouchScreen;
  }

  protected isMouseEvent(event: BaseEvent): boolean {
    return event && event.source === SourceType.Mouse;
  }

  /**
   * menuItem之间的gap，单位vp
   * @param menuType
   * @returns
   */
  private getItemGap(menuType: DeskTopMenuType): number {
    if (menuType === DeskTopMenuType.formMenuEvent) {
      return 2;
    } else if (menuType === DeskTopMenuType.appItem) {
      return 1;
    } else {
      return 0;
    }
  }

  protected getDefaultMenuHeight(menuInfoList: MenuInfo[], menuType: DeskTopMenuType): number {
    if (!menuInfoList || menuInfoList.length === 0) {
      return 0;
    }
    let itemGap: number = this.getItemGap(menuType);
    let fixedMenuList: MenuInfo[] = [];
    let dynamicMenuList: MenuInfo[] = [];
    let fixedHeight = 0;
    let dividerHeight = 0;
    let dynamicHeight = 0;
    let sumHeight = 0;
    for (let menuInfo of menuInfoList) {
      if (menuInfo.menuType === CommonConstants.MENU_TYPE_FIXED) {
        fixedMenuList.push(menuInfo);
      } else {
        dynamicMenuList.push(menuInfo);
      }
    }
    const fixedLength: number = fixedMenuList.length;
    const dynamicLength: number = dynamicMenuList.length;
    if (fixedLength > 0 ) {
      const fixedDividerHeight = DIVIDER_HEIGHT + StyleConstants.MENU_MARGIN * 2;
      const fixedMenuHeight = MENU_ITEM_HEIGHT * fixedLength + (fixedLength - 1) * itemGap
      fixedHeight = fixedDividerHeight + fixedMenuHeight;
    }
    if (fixedLength > 0 && dynamicLength > 0) {
      dividerHeight = DIVIDER_HEIGHT + StyleConstants.MENU_MARGIN * 2;
    }
    if (dynamicLength > 0) {
      dynamicHeight = MENU_ITEM_HEIGHT * dynamicLength + (dynamicLength - 1) * itemGap
    }
    sumHeight = fixedHeight + dividerHeight + dynamicHeight;
    log.showInfo('getMenuHeight [%{public}d, %{public}s], [%{public}d, %{public}d, %{public}d, %{public}d]',
      menuInfoList.length, menuType, fixedHeight, dividerHeight, dynamicHeight, sumHeight);
    return sumHeight;
  }

  protected getDistanceRect(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect,
    fakeScreenRect: SCBSessionRect | undefined): DistanceRect {
    let distanceRect = new DistanceRect();
    const xPosition: number = this.getEventPosition(event).x as number;
    const yPosition: number = this.getEventPosition(event).y as number;
    const itemWidth = this.getItemWidth(event);
    const itemHeight = this.getItemHeight(event);
    const screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
    const dockHeight = this.getStatusbarOrDockHeightVp(SystemBarType.SMART_DOCK, screenId);
    const statusBarHeight = this.getStatusbarOrDockHeightVp(SystemBarType.STATUS_BAR, screenId);
    distanceRect.toRight = screenRect.width.getVp() - xPosition - itemWidth;
    distanceRect.toLeft = xPosition;
    distanceRect.toTop = yPosition + itemHeight - statusBarHeight;
    distanceRect.toBottom = screenRect.height.getVp() - dockHeight - yPosition;
    log.showInfo('getDistanceRect [%{public}d, %{public}d, %{public}d, %{public}d,]',
      distanceRect.toLeft, distanceRect.toTop, distanceRect.toRight, distanceRect.toBottom);
    return distanceRect;
  }

}