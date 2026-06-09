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

import { PoweroffLayout } from './PoweroffLayout';
import display from '@ohos.display';
import { i18n } from '@kit.LocalizationKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon';
import PowerOffStyleConstants from '../common/PoweroffStyleConstants';
import { poweroffController } from '../controller/PoweroffController';
import { ResourceUtil } from '../common/ResourceUtil';
import { DisplayAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DisplayAdapter';

const TAG = 'PowerOff-Main';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Component
export struct PowerOffIndex {
  @State isExpand: boolean = false;
  /**
   * 是否进入热安全模式或者应急模式
   */
  @State isInEmergencyOrThermalSafeMode: boolean = false;
  /**
   * 是否显示关机查找复选框
   */
  @State isOffFindEnabled: boolean = true;
  @State isLandscape: boolean = DeviceHelper.isLandscape();
  private isBigFontLevel: boolean = false;
  @State blankTopHeight: Length = $r('app.string.poweroff_blank_top_height');
  @State blankBottomHeight: Resource = $r('app.float.poweroff_blank_bottom_height');
  @State foldBlankBottomHeight: Resource = $r('app.float.poweroff_fold_blank_bottom_height');
  @State tipsWidth: string = this.isLandscape ? PowerOffStyleConstants.POWEROFF_TIPS_SECTION_WIDTH :
  PowerOffStyleConstants.POWEROFF_TIPS_SECTION_WIDTH_FULL;
  @State tipsHeight: number | string = this.isLandscape ? PowerOffStyleConstants.POWEROFF_TIPS_SECTION_HEIGHT : '';
  @State foldDisplayMode: display.FoldDisplayMode = LayoutUtils.getFoldDisplayMode();
  @State displayWidth: number = DisplayAdapter.getDefaultDisplaySync().width;

  aboutToAppear() {
    if (display.isFoldable() && !DeviceHelper.isSmallFoldProduct() && !LayoutUtils.isXTProductType()) {
      this.isExpand = this.getExpandVal(display.getFoldStatus());
      log.showInfo(TAG, 'init isExpand is ' + this.isExpand);
      // 注册折叠屏展开状态监听
      try {
        display.on('foldStatusChange', this.folderStatusChangeCallback);
        display.on('change', this.displayChangeCallback);
      } catch (error) {
        log.showError(TAG, 'foldStatusChange on error', error);
      }
    }

    // 订阅屏幕变化事件
    log.showInfo(TAG, 'ScreenOnOffEvent register');
    poweroffController.registerCommentEvent();
    // 查询是否进入热安全模式或者应急模式
    this.isInEmergencyOrThermalSafeMode = poweroffController.getEmergencyAndThermalSafeMode();
    log.showInfo(TAG, `isInEmergencyOrThermalSafeMode ${this.isInEmergencyOrThermalSafeMode}`);
    this.initBlankTopAndBottomHeight();

    if (LayoutUtils.isXTProductType()) {
      // 监听XT屏幕显示事件
      this.handleDisplayModeEvent();
      this.setXTConfig();
    }
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'ScreenOnOffEvent unregister');
    poweroffController.unRegisterCommonEvent();

    if (LayoutUtils.isXTProductType()) {
      // 取消监听XT屏幕显示事件
      this.handleDisplayModeEvent(false);
    }

    try {
      if (!display.isFoldable() || DeviceHelper.isSmallFoldProduct() || LayoutUtils.isXTProductType()) {
        return;
      }
      display.off('foldStatusChange', this.folderStatusChangeCallback);
      display.off('change', this.displayChangeCallback);
    } catch (err) {
      log.showError(TAG, `off fold display listener failed: ${err?.code}`);
    }
  }

  /**
   * 注册显示模式事件
   * @param isRegister 是否为注册操作
   */
  private handleDisplayModeEvent(isRegister: boolean = true) {
    try {
      if (isRegister) {
        display.on('foldDisplayModeChange', this.onFoldDisplayModeCallback);
      } else {
        display.off('foldDisplayModeChange', this.onFoldDisplayModeCallback);
      }
    } catch (error) {
      log.showError(TAG, `handleDisplayModeEvent ${isRegister} on error ${error}`);
    }
  }

  private onFoldDisplayModeCallback = (data: display.FoldDisplayMode): void => {
    log.showInfo(TAG, `XT displaymode changed to: ${data}`);
    this.foldDisplayMode = data;
    this.setXTConfig();
  }

  private setXTConfig() {
    try {
      this.isExpand = LayoutUtils.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
      this.isLandscape = DeviceHelper.isLandscape();
      this.tipsWidth = this.isLandscape ? PowerOffStyleConstants.POWEROFF_TIPS_SECTION_WIDTH :
      PowerOffStyleConstants.POWEROFF_TIPS_SECTION_WIDTH_FULL;
      this.tipsHeight = this.isLandscape ? PowerOffStyleConstants.POWEROFF_TIPS_SECTION_HEIGHT : '';
      log.showInfo(TAG, `XT current layout: isExpand=${this.isExpand},isLandscape=${this.isLandscape}`);
      this.blankTopHeight = $r('app.string.poweroff_blank_top_height');
      this.blankBottomHeight = $r('app.float.poweroff_blank_bottom_height');
      if (LayoutUtils.getFoldDisplayMode() === XTLayoutType.F) {
        this.initBlankTopAndBottomHeight();
      }
    } catch (e) {
      log.showError(TAG, `getDefaultDisplaySync error ${e}`);
    }
  }

  private folderStatusChangeCallback = (newFoldStatus: display.FoldStatus) => {
    log.showInfo(TAG, 'newFoldStatus is ' + newFoldStatus);
    this.isExpand = this.getExpandVal(newFoldStatus);
    // 折叠屏从横屏展开态切换为竖屏折叠态，这里获取 isLandscape 不准确
    this.isLandscape = DeviceHelper.isLandscape();
    // 折叠态重置顶部和底部边距
    if (this.isLandscape && newFoldStatus === PowerOffStyleConstants.FOLD_STATUS_FOLDED) {
      this.resetBlankTopAndBottom();
    } else {
      this.blankTopHeight = $r('app.string.poweroff_blank_top_height');
    }
    this.checkSetOuterHomeConfig(true);
  };

  private displayChangeCallback = (data: number): void => {
    const isLandscape: boolean = DeviceHelper.isLandscape();
    // 折叠屏从横屏展开态切换为竖屏折叠态，需要重新获取计算按钮到屏幕顶部的高度
    if (!isLandscape && isLandscape !== this.isLandscape) {
      this.isLandscape = isLandscape;
      this.blankTopHeight = $r('app.string.poweroff_blank_top_height');
    }
    this.displayWidth = DisplayAdapter.getDefaultDisplaySync().width;
  };

  private getConfiguration = (): void => {
    // 维文 藏文适配外屏文本,调整文本上边距
    const newLanguage: string = i18n.System.getSystemLanguage();
    // 判断当前字体放大倍数
    const fontSizeScale = ResourceUtil.getFontScale();
    log.showInfo(TAG, `change fontSizeScale ${fontSizeScale}`);

    if (fontSizeScale >= PowerOffStyleConstants.OUTER_HOME_FONT_LIMIT_LEVEL) {
      this.isBigFontLevel = true;
    }
    this.checkSetOuterHomeConfig();
  }

  private checkSetOuterHomeConfig(isFromfold?: boolean): void {
  }

  handleOffFindEnabledStatus(status: boolean): void {
    log.showInfo(TAG, `index handleOffFindEnabledStatus ${status}`);
    this.isOffFindEnabled = status;
  }

  getExpandVal(foldStatus: display.FoldStatus): boolean {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN || foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      return false;
    }
    return true;
  }

  /**
   * 关机页面提示信息
   */
  private getTipContent(): Resource {
    log.showInfo(TAG, `getTipContent`)
    return $r('app.string.poweroff_tips', PowerOffStyleConstants.POWEROFF_TIMEOUT);
  }

  /**
   * 适配大字体下动态调整提示信息距离底部高度
   */
  private initBlankTopAndBottomHeight(): void {
    // 动态适配直板机横屏
    if (poweroffController.isPhoneLandScape()) {
      this.resetBlankTopAndBottom();
    }
  }

  private resetBlankTopAndBottom(): void {
    const fontSizeScale = ResourceUtil.getFontScale();
    log.showInfo(TAG, `current fontSizeScale ${fontSizeScale}`);
    // 横屏适老化大字体需要调整界面布局避免重叠
    if (fontSizeScale >= PowerOffStyleConstants.XT_FOLD_LARGE_FONT_SCALE_LIMIT) {
      this.blankTopHeight = $r('app.float.poweroff_blank_top_height_phone_landscape_large_font');
      this.blankBottomHeight = $r('app.float.poweroff_blank_bottom_height_large_landscape');
    } else {
      this.blankTopHeight = $r('app.float.poweroff_blank_top_height_phone_landscape');
      this.blankBottomHeight = $r('app.float.poweroff_blank_bottom_height');
    }
  }

  build() {
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%')
      .position({
        x: 0,
        y: 0
      })

      .backgroundEffect({
        policy: 1,
        radius: PowerOffStyleConstants.POWEROFF_BACKGROUND_RADIUS,
        saturation: PowerOffStyleConstants.POWEROFF_BACKGROUND_SATURATION,
        brightness: PowerOffStyleConstants.POWEROFF_BACKGROUND_BRIGHTNESS,
        color: this.isInEmergencyOrThermalSafeMode ? '#000000' : `rgba(0,0,0, 0.67)`
      })

      // 关机界面
      if (display.isFoldable() && this.isExpand) {
        PoweroffLayout({
          blankTopHeight: this.isLandscape ?
            '60%' :
          $r('app.string.poweroff_fold_blank_top_height'),
          buttonMinSpace: PowerOffStyleConstants.POWEROFF_FOLD_BUTTON_MIN_SPACE,
          tipsWidth: PowerOffStyleConstants.POWEROFF_TIPS_SECTION_WIDTH,
          blankBottomHeight: this.blankBottomHeight,
          tipsInfo: this.getTipContent(),
          tipsLineHeight: $r('app.float.poweroff_tips_line_height'),
          tipsHeight: 'auto',
          indexHandleOffFindEnabledStatus: (status: boolean): void => this.handleOffFindEnabledStatus(status),
          isOffFindEnabled: this.isOffFindEnabled,
          isExpand: this.isExpand,
          foldDisplayMode: this.foldDisplayMode,
          displayWidth: this.displayWidth,
          isLandscape: this.isLandscape,
        })
      } else {
        PoweroffLayout({
          blankTopHeight: this.blankTopHeight,
          buttonMinSpace: PowerOffStyleConstants.POWEROFF_BUTTON_MIN_SPACE,
          tipsWidth: this.tipsWidth,
          blankBottomHeight: this.blankBottomHeight,
          tipsInfo: this.getTipContent(),
          tipsLineHeight: $r('app.float.poweroff_tips_line_height'),
          tipsHeight: this.tipsHeight,
          indexHandleOffFindEnabledStatus: (status: boolean): void => this.handleOffFindEnabledStatus(status),
          isOffFindEnabled: this.isOffFindEnabled,
          isExpand: this.isExpand,
          foldDisplayMode: this.foldDisplayMode,
          displayWidth: this.displayWidth,
          isLandscape: this.isLandscape,
        })
      }
    }
  }
}