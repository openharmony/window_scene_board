/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { SingleBase, SingleContext } from '@ohos/basicutils/src/main/ets/utils/SingleManager';
import { MenuInfo } from '../../bean/MenuInfo';

export class RightMenuViewModel extends SingleBase {
  public static singleName: string = 'RightMenuViewModel';

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public getRightMenuInfoList(): MenuInfo[] {
    return [];
  }

  /**
   * 获取右键菜单自适应宽度
   * @param menuItem 菜单项信息
   * @returns 适应文字的菜单宽度
   */
  public getMenuWidthAdaptive(menuItem: MenuInfo): number {
    return 0;
  }

  /**
   * 右键菜单注册按键事件监听
   */
  public registerKeyEvent(): void {
  }

  /**
   * 右键菜单取消注册按键事件监听
   */
  public unRegisterKeyEvent(): void {
  }

  /**
   * 设置桌面菜单状态
   */
  public setMenuShowStatus(isMenuShow: boolean): void {
  };


  /**
   * 获取桌面元素((文件文件夹、应用图标、卡片、桌面空白处))菜单方位
   * @param event  事件
   * @param menuInfoList
   * @param menuType
   * @returns
   */
  public getMenuPlacement(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Placement | undefined {
    return undefined;
  }

  /**
   * 获取桌面元素(文件文件夹、应用图标、卡片、桌面空白处)菜单offset偏移量
   * @param event 事件
   * @param menuInfoList 菜单列表
   * @param menuType 菜单类型
   * @returns
   */
  public getMenuOffset(event: BaseEvent, menuInfoList: MenuInfo[], menuType: string): Position {
    return { x: 0, y: 0 };
  }

  /**
   * 菜单中文字资源跟随系统语言变化
   * @returns
   */
  public languageChangeRefresh(): void {
  }

  /**
   * 菜单项弹出前置处理
   * @returns
   */
  public async rightMenuShowPreHandler(): Promise<void> {
    return new Promise<void>((resolve) => {
    });
  }
}