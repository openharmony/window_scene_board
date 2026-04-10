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

import settings from '@ohos.settings';
import { inputMethod } from '@kit.IMEKit';
import { promptAction } from '@kit.ArkUI';
import sceneSessionManager from '@ohos.sceneSessionManager';
import CommonEventManager from '@ohos.commonEventManager';
import { GlobalContext, SettingsUtil, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { Logger, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { StartAbilityUtil, SCBKeyboardManager } from '@ohos/windowscene';

const TAG: string = 'CentralPersonalizationViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE: string = 'settings.centralAxis.holidayEffects.enable';
const CENTRAL_AXIS_CUSTOMER_TEXT_PREVIEW_EVENT: string = 'settings.centralAxis.customerText.previewEvent';
const CENTRAL_AXIS_CUSTOMER_TEXT: string = 'settings.centralAxis.customerText';
const MAX_RESOURCE_COUNT: number = 150;
const EMOJI_REGEX: RegExp = /((?:\p{Extended_Pictographic}|\p{Emoji_Component})(?:\p{Emoji_Modifier})?(?:\uFE0F|\uFE0E)?(?:\u200d(?:\p{Extended_Pictographic}|\p{Emoji_Component})(?:\p{Emoji_Modifier})?(?:\uFE0F|\uFE0E)?)+)|(\p{Extended_Pictographic}(?:\p{Emoji_Modifier})?(?:\uFE0F|\uFE0E)?)/gu;
const REGEX: RegExp = /([0-9#*]\uFE0F?\u20E3|\p{Regional_Indicator}{2}|(?:[\p{Extended_Pictographic}\u200D\uFE0F\p{Emoji_Modifier}]+)|[\p{Extended_Pictographic}\uFE0F]|\p{Regional_Indicator}|.)/gu;
const EMOJI_TEST_REGEX: RegExp = /[\p{Extended_Pictographic}]/u;

@Observed
export class CentralPersonalizationData {
  @Track public customerText: Array<string> = [];
  @Track public oldCustomerText: Array<string> = [];
  @Track public enableHolidayEffects: boolean = false; // 判断是否开启节日特效开关
  @Track public isPreviewInHolidayEffectsState: boolean = false; // 标记位节日动效预播放是不是因为自定义文字中断
  @Track public isPlayHolidayEffects: boolean = true; // 判断是否已播放过节日特效
  @Track public isInVirtualKeyboard: boolean = false; // 判断是否在虚拟键盘状态
  @Track public oldCustomerTextOpacity: number = 1;
  @Track public doReplaceAnimate = false;
}

export class CentralPersonalizationViewModel {
  private personalizationData_: CentralPersonalizationData = new CentralPersonalizationData();
  private subscriber?: CommonEventManager.CommonEventSubscriber;
  private localCustomerText_: Array<string> = [];
  private doTextAnimation?: Function;
  private isWaitCentralLogoShow: boolean = false;
  // 预览时等待虚拟键盘拉起再播放文字动效
  private previewAnimationCb?: Function;
  private images: ImageFrameInfo[] = [];

  get personalizationData(): CentralPersonalizationData {
    return this.personalizationData_;
  }

  get localCustomerText(): string[] {
    return this.localCustomerText_;
  }

  public getImages(): ImageFrameInfo[] {
    return this.images;
  }

  public onCentralLogoShow(): void {
    log.showInfo(TAG, `onCentralLogoShow, isWaitCentralLogoShow: ${this.isWaitCentralLogoShow}`);
    if (this.isWaitCentralLogoShow) {
      this.isWaitCentralLogoShow = false;
      this.previewAnimationCb?.();
      this.previewAnimationCb = undefined;
    }
  }

  public onCentralLogoHide(): void {
    if (!this.personalizationData_.enableHolidayEffects) {
      return;
    }
    log.showInfo(TAG, `onCentralLogoHide ${this.personalizationData_.isPlayHolidayEffects}-${this.personalizationData_.isPreviewInHolidayEffectsState}`);
    if (this.personalizationData_.isPlayHolidayEffects) {
      if (this.personalizationData_.isPreviewInHolidayEffectsState) {
        this.personalizationData_.isPreviewInHolidayEffectsState = false;
      } else {
        this.personalizationData_.isPlayHolidayEffects = false;
      }
    }
  }

  /**
   * 初始化
   * @param doTextAnimation 文字动效回调
   */
  public doInit(doTextAnimation: Function): void {
    log.showInfo(TAG, 'doInit');
    this.doTextAnimation = doTextAnimation;
    this.registerSettingsChange();
    this.subscribeCustomerTextPreviewEvent();
    this.initHolidayEffectsResource();
  }

  public deInit(): void {
    this.unregisterSettingsChange();
    this.unSubscribeCustomerTextPreviewEvent();
    this.images = [];
  }

  private initHolidayEffectsResource(): void {
    const tempImages: ImageFrameInfo[] = [];
    for (let index = 0; index < MAX_RESOURCE_COUNT; index++) {
      const frameInfo: ImageFrameInfo = {
        src: $rawfile(`holiday_effects/holiday_effects${index.toString().padStart(3, '0')}.png`),
      }
      tempImages.push(frameInfo);
    }
    this.images = tempImages;
  }

  /**
   * 自定义文字变化SettingData回调
   */
  private onCustomerTextSettingsChange = (): void => {
    const tmpText: string = SettingsUtil.getSystemValue(CENTRAL_AXIS_CUSTOMER_TEXT, '');
    log.showInfo(TAG, `receive key change tmpText: ${tmpText}`);
    this.onCustomerTextChange(tmpText, false);
  }

  /**
   * 节日特效开关变化SettingData回调
   */
  private onHolidayEffectsChange = (): void => {
    const ret = SettingsUtil.getSystemValue(CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE, 'false');
    this.personalizationData_.enableHolidayEffects = (ret === 'true');
    log.showInfo(TAG, 'receive key change enableHolidayEffects: ' + this.personalizationData_.enableHolidayEffects);
    this.personalizationData_.isPlayHolidayEffects = this.personalizationData_.enableHolidayEffects;
    if (this.personalizationData_.enableHolidayEffects) {
      if (this.isShowToast()) {
        return;
      }
      // 正在执行文字动效, 打断文字动效
      if (this.personalizationData_.isPreviewInHolidayEffectsState) {
        this.personalizationData_.isPreviewInHolidayEffectsState = false;
      }
      // 虚拟键盘在前台, 无需拉起虚拟键盘
      if (viewMgrPolicy.isViewShowing(ViewType.CENTRAL_LOGO_MASK)) {
        return;
      }
      this.invokeVirtualKeyboard();
    }
  }

  private registerSettingsChange(): void {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), CENTRAL_AXIS_CUSTOMER_TEXT,
        settings.domainName.USER_PROPERTY, this.onCustomerTextSettingsChange);
      // 初始化
      const tmp: string = SettingsUtil.getSystemValue(CENTRAL_AXIS_CUSTOMER_TEXT, '');
      this.localCustomerText_ = this.convertStringToArray(tmp);
    } catch (err) {
      log.error(TAG, 'register CENTRAL_AXIS_CUSTOMER_TEXT failed', err)
    }
    // 节日特效设置项
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE,
        settings.domainName.USER_PROPERTY, this.onHolidayEffectsChange);
      // 初始化
      const ret = SettingsUtil.getSystemValue(CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE, 'false');
      this.personalizationData_.enableHolidayEffects = (ret === 'true');
    } catch (err) {
      log.error(TAG, 'register CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE failed', err)
    }
  }

  private unregisterSettingsChange() {
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(), CENTRAL_AXIS_CUSTOMER_TEXT,
        settings.domainName.USER_PROPERTY);
      settings.unregisterKeyObserver(GlobalContext.getContext(), CENTRAL_AXIS_HOLIDAY_EFFECTS_ENABLE,
        settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showWarn(TAG, 'unregisterColorSettingCallback fail');
    }
  }

  private subscribeCustomerTextPreviewEvent(): void {
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [CENTRAL_AXIS_CUSTOMER_TEXT_PREVIEW_EVENT],
    };
    log.showInfo(TAG, 'creating subscriber.');
    CommonEventManager.createSubscriber(subscribeInfo).then((commonEventSubscriber) => {
      this.subscriber = commonEventSubscriber;
      this.subscribeEvent();
      log.showInfo(TAG, 'Succeeded in creating subscriber.');
    }).catch((err: Error) => {
      log.showInfo(TAG, `Failed to create subscriber. ${err.message}`);
    });
  }

  private subscribeEvent(): void {
    try {
      CommonEventManager.subscribe(this.subscriber, (err, data: CommonEventManager.CommonEventData) => {
        if (err) {
          log.showInfo(TAG, `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(TAG, `event subscribe --- ${data.event}-${data.data}`);
        if (data.event === CENTRAL_AXIS_CUSTOMER_TEXT_PREVIEW_EVENT) {
          this.onCustomerTextChange(data.data ?? '', true);
        }
      });
    } catch (error) {
      log.showError(TAG, `subscribe failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }

  private onCustomerTextChange(customerText: string, isPreview: boolean): void {
    const tempCustomerTextArray: string[] = this.convertStringToArray(customerText);
    if (this.isShowToast()) {
      if (!isPreview) {
        // settings回调更新文字缓存
        this.localCustomerText_ = tempCustomerTextArray;
      }
      return;
    }
    // 正在播放节日动效, 停止播放
    const isPlayingHolidayEffects: boolean = viewMgrPolicy.isViewShowing(ViewType.CENTRAL_LOGO_MASK) &&
      this.personalizationData_.enableHolidayEffects && this.personalizationData_.isPlayHolidayEffects &&
      !this.personalizationData_.isPreviewInHolidayEffectsState && this.personalizationData.isInVirtualKeyboard;
    if (isPlayingHolidayEffects) {
      log.showWarn(TAG, 'onCustomerTextChange show Holiday Effects');
      this.personalizationData_.isPlayHolidayEffects = false;
    }
    // 下一次拉起虚拟键盘准备播放节日动效, 则拉起虚拟键盘不播放节日动效
    const isPlayingHolidayEffectsNextTime: boolean = !viewMgrPolicy.isViewShowing(ViewType.CENTRAL_LOGO_MASK) &&
    this.personalizationData_.enableHolidayEffects && this.personalizationData_.isPlayHolidayEffects &&
      !this.personalizationData_.isPreviewInHolidayEffectsState;
    if (isPlayingHolidayEffectsNextTime) {
      log.showWarn(TAG, 'onCustomerTextChange show Holiday Effects NextTime');
      this.personalizationData_.isPreviewInHolidayEffectsState = true;
    }
    // 动效播放回调
    this.previewAnimationCb = () => {
      // 判断是否要播放文字替换动效
      this.personalizationData_.doReplaceAnimate = !isPlayingHolidayEffects &&
        this.personalizationData_.customerText.length !== 0 &&
        this.localCustomerText_.length !== 0 && !this.isEqual(customerText, this.personalizationData_.customerText);
      if (this.personalizationData_.doReplaceAnimate) {
        // 记录旧的文字
        this.personalizationData_.oldCustomerText = this.personalizationData_.customerText;
        this.personalizationData_.oldCustomerTextOpacity = 0;
      }
      // 刷新新文字
      this.personalizationData_.customerText = tempCustomerTextArray;
      this.doTextAnimation?.(this.personalizationData_.doReplaceAnimate);

      if (!isPreview) {
        // settings回调更新缓存
        this.localCustomerText_ = tempCustomerTextArray;
      }
    }
    // 虚拟键盘在前台, 直接播放动效
    if (viewMgrPolicy.isViewShowing(ViewType.CENTRAL_LOGO_MASK)) {
      this.previewAnimationCb?.();
      return;
    }
    const ret: boolean = this.invokeVirtualKeyboard();
    if (ret) {
      this.isWaitCentralLogoShow = true;
      // 避免虚拟键盘异常拉不起, 重置等待状态
      setTimeout(() => {
        this.isWaitCentralLogoShow = false;
        this.previewAnimationCb = undefined;
      }, 1500);
    }
    if (!ret && !isPreview) {
      // 虚拟键盘拉起失败, settings回调更新文字缓存
      this.localCustomerText_ = tempCustomerTextArray;
    }
  }

  private isShowToast(): boolean {
    if (!viewMgrPolicy.isViewShowing(ViewType.CENTRAL_LOGO_MASK)) {
      log.showInfo(TAG, 'isShowToast');
      try {
        promptAction.showToast({
          message: $r('app.string.central_log_tips'),
          showMode: promptAction.ToastShowMode.TOP_MOST
        });
      } catch (err) {
        log.showError(TAG, 'invokeVirtualKeyboard showToast failed, error -> ', err);
      }
      return true;
    }
    return false;
  }

  private invokeVirtualKeyboard(): boolean {
    const isFloat = SCBKeyboardManager.getInstance().getSystemKeyboardSession()?.isFloatGravity();
    const keyboardState = SCBKeyboardManager.getInstance().getSystemKeyboardSession()?.sessionState;
    log.showInfo(TAG, `invokeVirtualKeyboard, keyboardState: ${keyboardState}, isFloat: ${isFloat}`);
    let isNeedHide: boolean = false;
    if (keyboardState === sceneSessionManager.SessionState.STATE_FOREGROUND && isFloat) {
      isNeedHide = true;
      // 隐藏悬浮虚拟键盘
      if (!this.startVirtualKeyboardAbility()) {
        return false;
      }
    }
    if (isNeedHide) {
      // 悬浮键盘先关闭再拉起虚拟键盘
      setTimeout(() => {
        this.startVirtualKeyboardAbility();
      }, 300)
    } else {
      this.startVirtualKeyboardAbility();
    }
    return true;
  }

  private startVirtualKeyboardAbility(): boolean {
    try {
      StartAbilityUtil.startServiceExtensionAbility({
        bundleName: 'com.ohos.virtualkeyboard',
        abilityName: 'ServiceExtAbility',
      });
      return true;
    } catch (error) {
      log.showError(TAG, `virtual keyboard ability error, code: ${error?.code}, message: ${error?.message}`);
    }
    return false;
  }

  /**
   * 将连续的emoji按照emoji的普通类型、组合类型单独拆分
   * @param str
   * @returns
   */
  private splitEmojis(str: string): string[] {
    return Array.from(str.matchAll(EMOJI_REGEX), (match: RegExpMatchArray) => {
      if (match.length > 0) {
        return match[0];
      }
      return '';
    });
  }

  /**
   * 拆分出key caps表情、旗帜表情、普通字符串、所有连续的emoji拆分
   * @param str
   * @returns
   */
  private convertStringToArray(str: string): string[] {
    const arr: string[] = [];
    const iterator: IterableIterator<RegExpMatchArray> = str.matchAll(REGEX);
    for (const match of iterator) {
      if (match.length === 0) {
        continue;
      }
      const tempStr: string = match[0];
      if (EMOJI_TEST_REGEX.test(tempStr)) {
        arr.push(...this.splitEmojis(tempStr));
      } else {
        arr.push(tempStr);
      }
    }
    return arr;
  }

  private isEqual(str: string, arr: string[]): boolean {
    return str === arr.join('');
  }

  /**
   *  反注册公共事件订阅
   */
  private unSubscribeCustomerTextPreviewEvent(): void {
    if (CheckEmptyUtils.isEmpty(this.subscriber)) {
      return;
    }
    try {
      CommonEventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    } catch (error) {
      log.showError(TAG, `Failed to unSubscribeBackEvent. Code is ${error?.code}, message is ${error?.message}`);
    }
  }
}