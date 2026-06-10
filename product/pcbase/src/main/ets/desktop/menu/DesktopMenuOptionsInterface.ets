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
import { SCBSessionRect } from '@ohos/windowscene';
import { MenuInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

export class DistanceRect {
  public toTop: number = 0;
  public toBottom: number = 0;
  public toLeft: number = 0;
  public toRight: number = 0;
}

// 桌面元素菜单接口
export interface DesktopMenuOptionsInterface {
  /**
   * 获取菜单的宽度
   * @param menuInfoList 菜单列表
   * @param menuType 菜单类型
   * @returns
   */
  getMenuWidth(menuInfoList: MenuInfo[]): number;

  /**
   * 获取菜单的高度
   * @param menuInfoList 菜单列表
   * @param menuType 菜单类型
   * @returns
   */
  getMenuHeight(menuInfoList: MenuInfo[]): number;

  /**
   * 获取桌面元素的高度
   * @param baseEvent 事件
   * @returns
   */
  getItemHeight(baseEvent: BaseEvent): number;

  /**
   * 获取桌面元素的宽度
   * @param baseEvent 事件
   * @returns
   */
  getItemWidth(baseEvent: BaseEvent): number;

  /**
   * 获取桌面元素事件位置
   * @param baseEvent
   * @returns
   */
  getEventPosition(baseEvent: BaseEvent): Position;

  /**
   * 获取桌面元素菜单方位
   * @param event
   * @param menuInfoList
   * @returns
   */
  getMenuPlacement(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Placement | undefined;

  /**
   * 获取桌面元素菜单偏移量
   * @param event
   * @param menuInfoList
   * @returns
   */
  getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], screenRect: SCBSessionRect | undefined,
    fakeScreenRect: SCBSessionRect | undefined): Position;
}