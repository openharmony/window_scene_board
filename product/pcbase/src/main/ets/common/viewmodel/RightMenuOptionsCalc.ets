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
import { MenuInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  LogHelper,
  LogDomain } from '@ohos/basicutils';
import { SCBSessionRect } from '@ohos/windowscene';
import { DesktopBaseMenuOptions } from '../../desktop/menu/DesktopBaseMenuOptions';
import { FileFolderMenuOptions } from '../../desktop/menu/FileFolderMenuOptions';
import { FormMenuOptions } from '../../desktop/menu/FormMenuOptions';
import { PageDesktopMenuOptions } from '../../desktop/menu/PageDesktopMenuOptions';
import { AppItemMenuOptions } from '../../desktop/menu/AppItemMenuOptions';
import { DesktopMenuOptionsInterface } from '../../desktop/menu/DesktopMenuOptionsInterface';


export enum DeskTopMenuType {
  default = 'Default',
  appItem = 'Desktop-AppItem',
  fileFolderComponent = 'FileFolderComponent',
  formMenuEvent = 'FormMenuEvent',
  PageDesktopLayout = 'PageDesktopLayout',
}

const TAG = 'RightMenuOptionsCalc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * PC 桌面 菜单参数计算类
 */
export default class RightMenuOptionsCalc {

  // 主屏Rect
  private screenRect: SCBSessionRect | undefined = undefined;
  // 折叠屏副屏Rect, 非折叠屏设备为空
  private fakeScreenRect?: SCBSessionRect | undefined = undefined;

  private menuOptions: Map<DeskTopMenuType | string, DesktopMenuOptionsInterface> = new Map();

  public constructor() {
    this.menuOptions.set(DeskTopMenuType.default, new DesktopBaseMenuOptions());
    this.menuOptions.set(DeskTopMenuType.appItem, new AppItemMenuOptions());
    this.menuOptions.set(DeskTopMenuType.fileFolderComponent, new FileFolderMenuOptions());
    this.menuOptions.set(DeskTopMenuType.formMenuEvent, new FormMenuOptions());
    this.menuOptions.set(DeskTopMenuType.PageDesktopLayout, new PageDesktopMenuOptions());
  }

  /**
   * 更新屏幕属性，用于菜单弹出位置判定
   * @param screenRect
   * @param fakeScreenRect
   */
  public updateScreenRect(screenRect: SCBSessionRect, fakeScreenRect?: SCBSessionRect): void {
    this.screenRect = screenRect;
    this.fakeScreenRect = fakeScreenRect;
    log.showInfo('updateScreenRect screenRect: [%{public}d, %{public}d] fakeScreenRect: [%{public}d, %{public}d]',
      this.screenRect.width.getVp(), this.screenRect.height.getVp(),
      this.fakeScreenRect?.top.getVp(), this.fakeScreenRect?.height.getVp());
  }

  /**
   * 获取菜单方位,文件文件夹、图标、卡片;长按菜单场景
   * @param event  事件
   * @param menuInfoList
   * @param menuType
   * @returns
   */
  public getMenuPlacement(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Placement | undefined {
    return this.getDesktopItemMenu(menuType).getMenuPlacement(event, menuInfoList,
      this.screenRect, this.fakeScreenRect);
  }

  /**
   * 获取菜单方位,文件文件夹、图标、卡片;长按和右键菜单场景
   * @param event  事件
   * @param menuInfoList
   * @param menuType
   * @returns
   */
  public getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Position {
    return this.getDesktopItemMenu(menuType).getMenuOffset(event, menuInfoList,
      this.screenRect, this.fakeScreenRect);
  }

  private getDesktopItemMenu(menuType: string): DesktopMenuOptionsInterface {
    log.showInfo(`getDesktopItemMenu ${menuType}`);
    if (this.menuOptions.has(menuType)) {
      return this.menuOptions.get(menuType) as DesktopMenuOptionsInterface;
    }
    return this.menuOptions.get(DeskTopMenuType.default) as DesktopMenuOptionsInterface;
  }
}
