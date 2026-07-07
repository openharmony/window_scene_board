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
import { RectInfo, LogDomain, Logger } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ItemUtils, desktopUtil, SceneSessionUIContextManager } from '@ohos/componenthelper';
import { AppMenu } from '../../uicomponents/AppMenu';
import { KeyConstants } from '../../constants/CommonConstants';
import { StyleConstants } from '../../constants/StyleConstants';
import { AppIconMenuVm } from '../viewmodel/AppIconMenuVm';
import { AppIconMenuEvent } from '../viewmodel/AppIconMenuEvent';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { GridLayoutItemInfo, MenuInfo } from '../../TsIndex';
import { AppIconConfig } from '../config/AppIconConfig';
import measure from '@ohos.measure';


const TAG = 'AppIconMenu';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);
const DEFAULT_FONT_SIZE: number = 16;
const DEFAULT_MENU_ITEM_SIDE_PADDING: number = 17;

/**
 * context menu最大宽度为6个栅格，最小宽度为2个栅格（默认），根据build组件的宽度自适应调整宽度
 * 桌面的右键菜单宽度固定为2个栅格，根据不同的设备类型设置不同的宽度大小
 * 栅格参数：margin 24, gutter 24, pc 栅格数量 12, phone 栅格数量 4
 */
@Component
export struct AppIconMenu {
  iconMenuEvent?: AppIconMenuEvent;
  isLongPressShow: boolean = false;
  appIconId: string = '';
  private iconRect: RectInfo = ItemUtils.getRectById(this.appIconId);
  private iconSize: number = 0;
  private iconRadius: number = 0;
  private dragStart?: Function;
  private appItem?: AppItemInfo;
  private menuWidth: number = this.getMenuWidth();
  private isOuterDesktop: boolean = false;
  private appIconConfig: AppIconConfig = new AppIconConfig();
  private isDisAppear: boolean = false;
  @ObjectLink iconMenuVm: AppIconMenuVm;

  private getMenuWidth(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return desktopUtil.getSmallFoldAppMenuWidthColumns();
    }
    return DeviceHelper.isPC() ? StyleConstants.MENU_WIDTH_COLUMNS_PC : StyleConstants.APP_MENU_WIDTH_COLUMNS_PHONE;
  }

  private measureMenuWidth(menuItem: MenuInfo): number {
    let menuWidth: number = Math.ceil(px2vp(measure.measureText({
      textContent: menuItem.menuText,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'medium',
    })));
    log.showInfo(TAG, `measureMenuWidth ${menuWidth}`);
    return menuWidth + DEFAULT_MENU_ITEM_SIDE_PADDING * 2 + StyleConstants.DEFAULT_24;
  }

  private updateMenuWidth(): void {
    if (!DeviceHelper.isPC()) {
      return;
    }
    this.iconMenuVm.getMenuInfo().forEach((menuItem) => {
      let currItemWidth = this.measureMenuWidth(menuItem);
      if (currItemWidth > this.menuWidth) {
        this.menuWidth = currItemWidth;
      }
    })
  }


  private prepareMenu(): RectInfo {
    if (DeviceHelper.isPC()) {
      SceneSessionUIContextManager.getInstance().setUiContext(undefined);
      this.iconRect = ItemUtils.getFrameNodeRectById(this.appIconId);
    }
    return this.iconRect;
  }

  private getMixedMenuList(): MenuInfo[] | undefined {
    const externCb = this.appIconConfig.externCb;
    return externCb && typeof externCb.getMixMenuInfo === 'function' ? externCb.getMixMenuInfo() : undefined;
  }

  private getCurrentSelectItemLength(): boolean {
    const externCb = this.appIconConfig.externCb;
    return externCb && typeof externCb.isMultiselect === 'function' ? externCb.isMultiselect() : false;
  }

  aboutToAppear(): void {
    log.showWarn(TAG, 'Menu aboutToAppear');
    this.updateMenuWidth();
  }

  aboutToDisappear(): void {
    // 添加生命周期打印,用于判断控件是否已下树,用于佐证isDisAppear属性没有影响正常的菜单显示
    log.showWarn(TAG, 'Menu aboutToDisappear');
  }

  build() {
    if (this.iconMenuVm.getMenuInfo()?.length > 0) {
      AppMenu({
        menuInfoList: this.iconMenuVm.getMenuInfo(),
        closeMenu: () => {
          AppStorage.setOrCreate('contextMenuState', false);
        },
        menuWidth: this.menuWidth,
        appParams: new Map<string, Object>([[KeyConstants.ITEM_RECT, this.prepareMenu()]]),
        menuPlacement: this.iconMenuVm.getMenuPlacement(this.isLongPressShow),
        iconSize: this.iconSize,
        iconRadius: this.iconRadius,
        dragStart: this.dragStart,
        appItem: this.appItem as Object as GridLayoutItemInfo,
        isOuterDesktop: this.isOuterDesktop,
        mixedMenuList: this.getMixedMenuList(),
        currentSelectItemLength: this.getCurrentSelectItemLength(),
        maxDynamicMenuHeight: this.iconMenuVm.getMaxScrollMenuHeight(),
        keepMenuOrder: this.appIconConfig.keepMenuOrder,
      })
        .id(`${TAG}_AppMenu_longPressMenu`)
        .borderRadius(StyleConstants.DEFAULT_16)
        .onAppear(() => {
          log.showWarn(TAG, 'Menu onAppear, isDisAppear: %{public}s', this.isDisAppear);
          if (this.isDisAppear) {
            // 由于onAppear接口在arkui中属于异步接口,可能存在onAppear晚于onDisAppear执行,这时候就会出现图标透明现象
            // 所以需要在此处判断下onDisAppear是否已执行
            return;
          }
          this.iconMenuEvent?.onAppear(this.isLongPressShow);
        })
        .onDisAppear(() => {
          log.showWarn(TAG, 'Menu onDisAppear');
          this.isDisAppear = true;
          this.iconMenuEvent?.onDisAppear(this.isLongPressShow);
        })
    }
  }
}