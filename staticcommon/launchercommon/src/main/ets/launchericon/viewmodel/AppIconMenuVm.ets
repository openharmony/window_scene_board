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

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { MenuInfo } from '../../bean/MenuInfo';
import { StyleConstants } from '../../TsIndex';

const TAG = 'AppIconMenuVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 以下变量属性变化不触发UI变化
class NoUpdateUiParam {
  public maxScrollMenuHeight: number = Infinity;
  public menuInfo: MenuInfo[] = [];
  public alreadyCleanMenu: boolean = false;
}

@Observed
export class AppIconMenuVm {
  private isShowMenu: boolean = false;
  protected normalParam: NoUpdateUiParam = new NoUpdateUiParam();
  public menuPlacement: Placement = Placement.BottomLeft;
  public isHiddenEffect: boolean = false;
  // 图标的菜单预览出现时会有按压蒙黑效果，此属性控制蒙黑的透明度
  public previewMaskOpacity: number = 1;
  public backgroundBlurStyle: BlurStyle = BlurStyle.NONE;
  public menuOffset: Position | undefined = undefined;
  public layoutRegionMargin: Margin | undefined = undefined;
  protected menuPreviewAnimOptions: ContextMenuAnimationOptions | undefined = {
    scale: [StyleConstants.MENU_ANIMATION_FROM_ICON, StyleConstants.MENU_ANIMATION_TO],
    transition: this.isHiddenEffect ? TransitionEffect.asymmetric(
      TransitionEffect.opacity(0),
      TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
  }
  protected menuTransition: TransitionEffect | undefined =
    this.isHiddenEffect ? TransitionEffect.asymmetric(
      TransitionEffect.opacity(0),
      TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined;

  public isMenuShow(): boolean {
    return this.isShowMenu && this.normalParam.menuInfo.length > 0;
  }

  public getMenuPreviewAnimOptions(): ContextMenuAnimationOptions | undefined {
    return this.menuPreviewAnimOptions;
  }

  public getMenuTransition(isLongPressMenu?: boolean): TransitionEffect | undefined {
    return this.menuTransition;
  }

  public setIsMenuShow(isShow: boolean): void {
    if (this.isShowMenu !== isShow) {
      this.isShowMenu = isShow;
    }
  }

  public setBackgroundBlurStyle(blur: BlurStyle): void {
    log.showInfo(`setBackgroundBlurStyle backgroundBlurStyle ${this.backgroundBlurStyle} blur ${blur}`);
    if (this.backgroundBlurStyle !== blur) {
      this.backgroundBlurStyle = blur;
    }
  }

  public setMenuOffset(offset: Position): void {
    if (!offset) {
      log.showError('setMenuOffset offset invalid');
      return;
    }
    log.showInfo(`setMenuOffset offsetX ${offset.x} offsetY ${offset.y}`);
    if (!CommonUtils.equals(this.menuOffset?.x, offset.x) ||
      !CommonUtils.equals(this.menuOffset?.y, offset.y) ) {
      this.menuOffset = offset;
    }
  }

  public setMaxScrollMenuHeight(maxScrollMenuHeight: number): void {
    this.normalParam.maxScrollMenuHeight = maxScrollMenuHeight;
  }

  public getMaxScrollMenuHeight(): number {
    return this.normalParam.maxScrollMenuHeight;
  }

  public getMenuPlacement(isLongPressMenu?: boolean): Placement | undefined {
    return this.menuPlacement;
  }

  public setMenuPlacement(placement: Placement) : void {
    if (this.menuPlacement !== placement) {
      this.menuPlacement = placement;
    }
  }

  public setLayoutRegionMargin(regionMargin: Margin | undefined) {
    this.layoutRegionMargin = regionMargin;
  }

  public getMenuInfo(): MenuInfo[] {
    return this.normalParam.menuInfo;
  }

  public setMenuInfo(infos: MenuInfo[]) {
    if (CheckEmptyUtils.isEmptyArr(infos)) {
      log.showError('empty menuInfo arr, skip it');
      return;
    }
    this.normalParam.alreadyCleanMenu = this.normalParam.menuInfo.length > 0;
    this.releaseMenuInfo();
    this.normalParam.menuInfo = infos;
  }

  /**
   * 清除菜单缓存
   *
   * @param onDisappear 是否是菜单onDisappear阶段清理
   */
  public cleanMenuInfo(onDisappear: boolean = false): void {
    log.showInfo(`cleanMenuInfo alreadyCleanMenu: ${this.normalParam.alreadyCleanMenu}, onDisappear: ${onDisappear}`);
    // 菜单下树时需要先判断缓存是否已经在setMenuInfo阶段被清理, 是则无需重复清理, 下一次再清理
    // 场景：连续右键出菜单,旧菜单下树新菜单上树,会先清理旧MenuInfo并保存新MenuInfo
    // 因此旧菜单在下树时不能重复清理MenuInfo, 重置标记位, 新菜单下树阶段正常清理MenuInfo
    if (onDisappear && this.normalParam.alreadyCleanMenu) {
      this.normalParam.alreadyCleanMenu = false;
      return;
    }
    this.releaseMenuInfo();
  }

  public releaseMenuInfo(): void {
    log.showInfo(`releaseMenuInfo`);
    for (let i = 0; i < (this.normalParam.menuInfo ?? []).length; i++) {
      this.normalParam.menuInfo[i].onMenuClick = null;
    }
    this.normalParam.menuInfo = [];
  }
}