/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { RectInfo } from '@ohos/basicutils';
import { LayoutViewModel, StyleConstants } from '../TsIndex';
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';
import { AppItemInfo } from '../bean/AppItemInfo';

const TAG = 'MenuCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ANIMATION_SCALE: number = StyleConstants.MENU_ANIMATION_TO - 1;
const GROUP_GAP: number = StyleConstants.DEFAULT_8;

// arkui菜单规格: 上下侧默认规避状态栏与导航条后, 上方距状态栏额外有16vp安全边距，下方距导航条额外有4vp安全边距
const SAFE_TOP_MARGIN: number = StyleConstants.DEFAULT_16;
const SAFE_BOTTOM_MARGIN: number = StyleConstants.DEFAULT_4;
// arkui菜单规格: 左右方向的margin为16vp
const SAFE_BOTTOM_LEFT: number = StyleConstants.DEFAULT_16;
const SAFE_BOTTOM_RIGHT: number = StyleConstants.DEFAULT_16;

const PLACEMENT_DICT = [[Placement.TopRight, Placement.BottomRight], [Placement.TopLeft, Placement.BottomLeft]];

export class MenuCommonUtil {
  /**
   * 获取菜单的弹出方向
   *
   * @param event 触摸事件
   * @param componentRect 触摸组件的Rect
   * @param menuItemNum 菜单项总数
   * @param groupNum 菜单的group数
   * @returns Placement 菜单的弹出方向
   */
  public static getMenuPlacement(event: TouchEvent, componentRect: RectInfo, menuItemNum: number,
    groupNum: number): Placement {
    return MenuCommonUtil.getMenuPlacementByTouchX(event?.touches?.[0]?.displayX, componentRect);
  }

  /**
   * 通过按压点获取菜单的弹出方向
   *
   * @param touches 按压信息
   * @param componentRect 触摸组件的Rect
   * @returns Placement 菜单的弹出方向
   */
  public static getMenuPlacementByTouchX(touchX: number, componentRect: RectInfo): Placement {
    if (MenuCommonUtil.isInValidRect(componentRect)) {
      log.showWarn('invalid rect, default show bottom');
      // 默认显示左下
      return Placement.BottomLeft;
    }

    let isShowBottom: number = MenuCommonUtil.setIsMenuShowBottom(componentRect) ? 1 : 0;
    let isShowLeft: number = MenuCommonUtil.setIsMenuShowLeft(touchX, componentRect) ? 1 : 0;
    return PLACEMENT_DICT[isShowLeft][isShowBottom];
  }

  /**
   * 获取外屏菜单的弹出方向
   *
   * @param bundleName 外屏弹出菜单的bundleName
   * @returns Placement 外屏菜单的弹出方向
   */
  public static getOuterMenuPlacement(itemInfo: AppItemInfo, hasDynamicItem: boolean): Placement {
    let row = LaunchLayoutCacheManager.getInstance().findSameOuterAppIcon(itemInfo)?.[0]?.row ?? 0;
    if ((row === 2 && hasDynamicItem) || row === 3) {
      return Placement.TopRight;
    } else {
      return Placement.BottomLeft;
    }
  }

  /**
   * 菜单是否往下弹
   *
   * @param menuPlacement 菜单的placement
   * @returns boolean 是否向下弹
   */
  public static isShowBottom(menuPlacement: Placement): boolean {
    return menuPlacement === Placement.Bottom || menuPlacement === Placement.BottomLeft ||
      menuPlacement === Placement.BottomRight;
  }

  private static isInValidRect(rect: RectInfo): boolean {
    return rect.left === 0 && rect.top === 0 && rect.right === 0 && rect.bottom === 0;
  }

  private static setIsMenuShowLeft(touchX: number, componentRect: RectInfo): boolean {
    if (!touchX) {
      log.showWarn('invalid touchX, default show left');
      // 菜单默认显示在左方
      return true;
    }
    let componentCenterX: number = (componentRect.right + componentRect.left) / 2;
    // 触摸点在组件左边，菜单显示在左侧，反之在右侧
    let isShowLeft: boolean = touchX < componentCenterX;

    // 镜像时需要左右反向
    isShowLeft = RTLUtil.isRTL() ? !isShowLeft : isShowLeft;
    log.showInfo(`touchX: ${touchX}, componentCenterX: ${componentCenterX}, isShowLeft: ${isShowLeft}`);

    let screenWidth: number = LayoutViewModel.getInstance().getScreenWidth();
    let menuWidth: number = StyleConstants.CONTEXT_MENU_WIDTH + GROUP_GAP;

    // 菜单靠组件右侧时, 菜单的空余宽度
    let blankRight: number = componentRect.right - SAFE_BOTTOM_LEFT;
    // 菜单靠组件左侧时, 菜单的空余宽度
    let blankLeft: number = screenWidth - componentRect.left - SAFE_BOTTOM_RIGHT;
    if ((isShowLeft && menuWidth > blankLeft) || (!isShowLeft && menuWidth > blankRight)) {
      isShowLeft = !isShowLeft;
      log.showInfo(`no enough space, show on the opposite side, showLeft: ${isShowLeft} blankRight: ${blankRight} blankLeft: ${blankLeft}`);
    }
    return isShowLeft;
  }

  /**
   * 菜单是否在元素下侧
   *
   * @param componentRect 组件大小
   * @param menuItemNum 菜单项数量
   * @param groupNum 菜单组数量
   * @returns boolean 是否向下弹
   */
  public static setIsMenuShowBottom(componentRect: RectInfo): boolean {
    let screenHeight: number = LayoutViewModel.getInstance().getScreenHeight();
    let marginTop: number = LayoutViewModel.getInstance().getSysUITopHeight();
    let marginBottom: number = LayoutViewModel.getInstance().getDockMarginBottom();
    let componentHeight = componentRect.bottom - componentRect.top;
    let blankTop: number = componentRect.top - ANIMATION_SCALE * componentHeight - marginTop;
    let blankBottom: number = screenHeight - componentRect.bottom - ANIMATION_SCALE * componentHeight - marginBottom;
    let isShowBottom: boolean = blankBottom >= blankTop;
    log.showInfo(`screenHeight: ${screenHeight}, marginTop ${marginTop}, marginBottom ${marginBottom}, componentHeight: ${componentHeight} ` +
      `blankTop: ${blankTop}, blankBottom: ${blankBottom}, isShowBottom ${isShowBottom}`);
    return isShowBottom;
  }


  /**
   * 获取最长的菜单高度
   *
   * @param placement 菜单弹出的位置
   * @param componentRect 组件坐标
   * @returns 此位置能容许的最大菜单高度
   */
  public static getMaxMenuHeight(placement: Placement, componentRect: RectInfo): number {
    let screenHeight: number = LayoutViewModel.getInstance().getScreenHeight();
    let marginTop: number = LayoutViewModel.getInstance().getSysUITopHeight();
    let marginBottom: number = LayoutViewModel.getInstance().getDockMarginBottom();

    let componentHeight = componentRect.bottom - componentRect.top;
    log.showInfo(`marginBottom: ${marginBottom}, marginTop: ${marginTop}, componentHeight: ${componentHeight}, ` +
      `componentRect.bottom: ${componentRect.bottom}, componentRect.top: ${componentRect.top}`);

    let maxMenuHeight: number = 0;
    if (placement === Placement.TopRight || placement === Placement.TopLeft || placement === Placement.Top) {
      maxMenuHeight = componentRect.top - ANIMATION_SCALE * componentHeight - marginTop -
        GROUP_GAP - SAFE_TOP_MARGIN;
      log.showInfo(`Top MaxMenuHeight: ${maxMenuHeight}`);
      return maxMenuHeight;
    }
    if (placement === Placement.BottomLeft || placement === Placement.BottomRight || placement === Placement.Bottom) {
      maxMenuHeight = screenHeight - componentRect.bottom - ANIMATION_SCALE * componentHeight - marginBottom -
        GROUP_GAP - SAFE_BOTTOM_MARGIN;
      log.showInfo(`Bottom MaxMenuHeight: ${maxMenuHeight}`);
      return maxMenuHeight;
    }
    log.showWarn(`Placement: ${placement} is not supported`);
    return maxMenuHeight;
  }

  /**
   * 获取动态菜单最大高度
   *
   * @param placement 菜单弹出的位置
   * @param componentRect 组件坐标
   * @returns 此位置能容许的最大动态菜单高度
   */
  public static getMaxDynamicMenuHeight(menuHeight: number, fixItemNum: number): number {
    // 动态菜单的高度： 菜单总高度 - 固定菜单项数 * 菜单项高度 - 菜单项首尾padding - 固定菜单与动态菜单间的GAP
    let maxDynamicMenuHeight: number = menuHeight - fixItemNum * StyleConstants.DEFAULT_44 -
      StyleConstants.DEFAULT_4 * 2 - GROUP_GAP
    log.showInfo(`getMaxDynamicMenuHeight: ${maxDynamicMenuHeight}`);
    return maxDynamicMenuHeight > 0 ? maxDynamicMenuHeight : Infinity;
  }
}