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

import { SingletonHelper, LogHelper, LogDomain } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import { uiAppearance } from '@kit.ArkUI';
import { taskpool } from '@kit.ArkTS';
import Constants from '../Constants';
import { RTLUtil } from '@ohos/componenthelper';

const TAG = 'FontScaleUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
// 字体比例的默认值
const FONT_SCALE_DEFAULT: number = 1;

// 可变字体大小
@Observed
export class DynamicFontSize {
  // 锁屏锁头提示语
  @Track public lockIconFontSize: string = '0';
  // 锁屏解锁，锁头提示语
  @Track public unlockIconFontSize: string = '0';
  // 底部字母字符行高
  @Track public letterTextLineHeight: string = '0';
  // 卡片详情半模态弹框
  @Track public panelButtonFontSize: string = '0';
  // 锁屏小模块的字体大小
  @Track public serviceFormNameLineHeight: string = '0';
  // 签名弹框输入框字体大小
  @Track public searchComponentFontSize: string = '0';
  // 签名弹框确认按钮的字体大小
  @Track public confirmButtonFontSize: string = '0';
  // 签名弹框取消按钮的字体大小
  @Track public cancelButtonFontSize: string = '0';
  // 提示语的行高
  @Track public simDialogLineHeight: string = '0';
  // SIM卡PIN密码输入框字体
  @Track public scrollFontSize: string = '0';
  // SIM卡弹窗的文本的大小
  @Track public simCustomDialogFontSize: string = '0';
  // 密码上部数字的偏移量
  @Track public numButtonOffset: number = -3.3;
  // 密码特殊字符的偏移量
  @Track public numButtonOffsetSpecialKey: number = -2.5;
  // 底部字母的偏移量
  @Track public numButtonOEngLetterOffset: number = 38.3;
  // 底部单个加号的偏移量
  @Track public plusSingOffset: number = 40.8;
}

/**
 * 字体放大倍数辅助类
 */
export class FontScaleUtil {
  public maxLockIconFontSize: number = 1.15;
  private maxTipFontSize: number = 2;
  public maxToastFontSize: number = 1;
  public maxFontSize: number = 1.45;
  public maxPwdFontSize: number = 1.1;
  public maxArtTextFontSize: number = 1.3;
  public minFontSize: number = 0.85;
  // 时钟字体最大缩放
  public maxClockFontSize: number = 1;
  // 新形态小折叠外屏字体缩放
  public smallOuterScreenFontSize: number = 1;

  // 字体比例
  public fontScale: number = 1;
  // 可变字号原字号大小
  public oriDynamicSize: DynamicFontSize = new DynamicFontSize();
  // 可变字号真实放大大小
  public realDynamicSize: DynamicFontSize = new DynamicFontSize();

  private isFreshFontScale: boolean = true;
  private pendingTask: boolean[] = [];
  private fontScaleCallback: Callback<void> | null = null;

  /**
   * 初始化数据
   */
  public init(): void {
    this.refresh();
    if (this.fontScaleCallback === null) {
      this.fontScaleCallback = () => {
        this.isFreshFontScale = true;
        log.showInfo('font scale change');
        this.refresh();
      };
      DataShareManager.getInstance().registerUserSettingsDataShareListener('font_scale', this.fontScaleCallback);
    }
  }

  /**
   * 释放数据
   */
  public release(): void {
    DataShareManager.getInstance().unregisterUserSettingsDataShareListener('font_scale');
    this.fontScaleCallback = null;
    this.isFreshFontScale = true;
    this.pendingTask = [];
  }

  private setFontScale(fontScale: number): void {
    this.fontScale = fontScale;
  }

  private changeFontScale(fontSize: number, maxFontSize: number): string {
    return fontSize * (this.fontScale > maxFontSize ? maxFontSize : this.fontScale) + 'vp';
  }

  private changeFontScaleByResource(fontSize: Resource, maxFontSize: number): string {
    return ResUtils.getNumber(fontSize) * (this.fontScale > maxFontSize ? maxFontSize : this.fontScale) + 'vp';
  }

  private changeLineHeight(lineHeight: number, maxFontSize: number): string {
    return lineHeight * (this.fontScale > maxFontSize ? maxFontSize : this.fontScale) + 'vp';
  }

  protected changeOffset(value: number): number {
    if (this.fontScale === this.maxLockIconFontSize) {
      return value > 0 ? value + 2 : value - 2;
    } else if (this.fontScale > this.maxLockIconFontSize) {
      return value > 0 ? value + 2 : value - 4;
    } else {
      return value;
    }
  }

  private setLockIconFontSize(value: number, maxLockIconFontSize: number): void {
    this.realDynamicSize.lockIconFontSize = this.changeFontScale(value, maxLockIconFontSize);
  }

  private setUnlockIconFontSize(value: number, maxLockIconFontSize: number): void {
    this.realDynamicSize.unlockIconFontSize = this.changeFontScale(value, maxLockIconFontSize);
  }

  private setPanelButtonFontSize(value: number): void {
    this.realDynamicSize.panelButtonFontSize = this.changeFontScale(value, this.maxFontSize);
  }

  private setServiceFormNameLineHeight(value: number): void {
    this.realDynamicSize.serviceFormNameLineHeight = this.changeLineHeight(value, this.maxFontSize);
  }

  private setScrollFontSize(value: number): void {
    this.realDynamicSize.scrollFontSize = this.changeFontScale(value, this.maxFontSize);
  }

  private setSIMCustomDialogFontSize(value: Resource): void {
    this.realDynamicSize.simCustomDialogFontSize = this.changeFontScaleByResource(value, this.maxFontSize);
  }

  private setSIMDialogLineHeight(value: number): void {
    this.realDynamicSize.simDialogLineHeight = this.changeLineHeight(value, this.maxFontSize);
  }

  private setLetterTextLineHeight(value: number): void {
    this.realDynamicSize.letterTextLineHeight = this.changeLineHeight(value, this.maxPwdFontSize);
  }

  private setSearchComponentFontSize(value: Resource): void {
    this.realDynamicSize.searchComponentFontSize = this.changeFontScaleByResource(value, this.maxFontSize);
  }

  private setConfirmButtonFontSize(value: Resource): void {
    this.realDynamicSize.confirmButtonFontSize = this.changeFontScaleByResource(value, this.maxFontSize);
  }

  private setCancelButtonFontSize(value: Resource): void {
    this.realDynamicSize.cancelButtonFontSize = this.changeFontScaleByResource(value, this.maxFontSize);
  }

  private setNumButtonOffset(value: number): void {
    this.realDynamicSize.numButtonOffset = this.changeOffset(value);
  }

  private setNumButtonOffsetSpecialKey(value: number): void {
    this.realDynamicSize.numButtonOffsetSpecialKey = this.changeOffset(value);
  }

  private setNumButtonOEngLetterOffset(value: number): void {
    this.realDynamicSize.numButtonOEngLetterOffset = this.changeOffset(value);
  }

  private setPlusSingOffset(value: number): void {
    this.realDynamicSize.plusSingOffset = this.changeOffset(value);
  }

  private async getFontScale(): Promise<number> {
    try {
      return await taskpool.execute(refreshToGetFontScale) as number
    } catch (err) {
      log.showError('get font scale taskPool err');
    }
    return FONT_SCALE_DEFAULT;
  }

  /**
   * 更新数据
   */
  public async refresh(isSmallOuterScreen: boolean = false): Promise<void> {
    log.showDebug(`refresh fontScale isSmallOuterScreen: ${isSmallOuterScreen}`);
    if (this.pendingTask.length > 0) {
      this.pendingTask.push();
      return;
    }
    this.pendingTask.push();
    if (this.isFreshFontScale) {
      let fontScale = await this.getFontScale();
      this.setFontScale(fontScale);
      this.isFreshFontScale = false;
    }
    log.showInfo(`onFontScaleChange ${this.fontScale}, isSmallOuterScreen: ${isSmallOuterScreen}`);
    this.setPanelButtonFontSize(16);
    this.setServiceFormNameLineHeight(16);
    this.setSearchComponentFontSize($r('sys.float.ohos_id_text_size_body1'));
    this.setConfirmButtonFontSize($r('sys.float.ohos_id_text_size_button1'));
    this.setCancelButtonFontSize($r('sys.float.ohos_id_text_size_button1'));
    this.setScrollFontSize(16);
    this.setSIMCustomDialogFontSize($r('sys.float.Body_L'));
    this.setSIMDialogLineHeight(21);
    this.setScreenChangeKeyBoardLayout(isSmallOuterScreen);
    this.setScreenChangeKeyBoardLayout(this.pendingTask.pop());
    this.pendingTask = [];
  }

  /**
   * 设置外屏密码键盘参数
   */
  public setOuterScreenKeyBoardLayout(): void {
    log.showInfo(`setOuterScreenKeyBoardLayout`);
    this.realDynamicSize.letterTextLineHeight = Constants.OUTER_SCREEN_LETTER_TEXT_LINE_HEIGHT;
    this.realDynamicSize.lockIconFontSize = Constants.OUTER_SCREEN_LOCK_ICON_FONT_SIZE;
    this.realDynamicSize.unlockIconFontSize = Constants.OUTER_SCREEN_UNLOCK_ICON_FONT_SIZE;
    this.realDynamicSize.numButtonOffset = Constants.OUTER_SCREEN_NUM_BUTTON_OFFEST;
    this.realDynamicSize.numButtonOffsetSpecialKey = Constants.OUTER_SCREEN_NUM_BUTTON_OFFEST_SPECIALKEY;
    this.realDynamicSize.numButtonOEngLetterOffset = Constants.OUTER_SCREEN_NUM_BUTTON_LETTER_OFFEST;
    this.realDynamicSize.plusSingOffset = Constants.OUTER_SCREEN_PLUS_SING_OFFEST;
  }

  /**
   * 设置默认密码键盘参数
   */
  public setInnerScreenKeyBoardLayout(): void {
    log.showDebug(`setInnerScreenKeyBoardLayout`);
    this.setLockIconFontSize(Constants.SCREENLOCK_LOCK_ICON_FONT_SIZE, this.maxLockIconFontSize);
    this.setUnlockIconFontSize(Constants.SCREENLOCK_UNLOCK_ICON_FONT_SIZE,
      RTLUtil.isRTL() ? 1 : this.maxLockIconFontSize);
    this.setLetterTextLineHeight(Constants.SCREENLOCK_LETTER_TEXT_LINE_HEIGHT);
    this.setNumButtonOffset(Constants.SCREENLOCK_NUM_BUTTON_OFFEST);
    this.setNumButtonOffsetSpecialKey(Constants.SCREENLOCK_NUM_BUTTON_OFFEST_SPECIALKEY);
    this.setNumButtonOEngLetterOffset(Constants.SCREENLOCK_NUM_BUTTON_LETTER_OFFEST);
    this.setPlusSingOffset(Constants.SCREENLOCK_PLUS_SING_OFFEST);
  }

  /**
   * 设置密码键盘参数
   * @param isSmallOuterScreen
   */
  public setScreenChangeKeyBoardLayout(isSmallOuterScreen: boolean = false): void {
    isSmallOuterScreen ? this.setOuterScreenKeyBoardLayout() : this.setInnerScreenKeyBoardLayout();
    if (isSmallOuterScreen) {
      log.showInfo(`setScreenChangeKeyBoardLayout ${isSmallOuterScreen},unLockIconFontSize is ${this.realDynamicSize.unlockIconFontSize}`);
    }
  }

  /**
   * 获取字体最小缩放倍数
   * @param isSmallOuterScreen
   * @returns
   */
  public getMinFontSize(isSmallOuterScreen: boolean = false): number {
    return isSmallOuterScreen ? this.smallOuterScreenFontSize : this.minFontSize;
  }

  /**
   * 获取字体最大缩放倍数
   * @param isSmallOuterScreen
   * @param isSpecialKey
   * @returns
   */
  public getMaxFontSize(isSmallOuterScreen: boolean, isSpecialKey: boolean): number {
    if (isSmallOuterScreen) {
      return this.smallOuterScreenFontSize;
    }
    if (isSpecialKey) {
      return this.maxPwdFontSize
    }
    return this.maxFontSize;
  }
}

function refreshToGetFontScale(): number {
  'use concurrent';
  const TAG = 'SCBScreenLock-refreshToGetFontScale';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
  const FONT_SCALE_DEFAULT: number = 1;
  try {
    return uiAppearance.getFontScale();
  } catch (err) {
    log.showError(`uiAppearance getFontScale err,code:${err?.code}`);
  }
  return FONT_SCALE_DEFAULT;
}

export let sFontScaleUtil: FontScaleUtil = SingletonHelper.getInstance(FontScaleUtil, TAG);

