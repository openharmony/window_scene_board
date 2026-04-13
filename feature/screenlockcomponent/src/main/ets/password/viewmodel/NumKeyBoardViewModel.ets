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

import curves from '@ohos.curves';
import PasswordConstants from '../../password/common/PasswordConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { Alarm } from '@ohos/componenthelper';
import { AccessibilityUtil, VerifyDataManager } from '@ohos/screenlockcommon';
import { ScreenLockPasswordVm } from './PasswordVm'
import Constants from '../../common/Constants';
import { DigitalKeyboardItem } from '../../password/common/DigitalKeyboardItem';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { GlobalStatusCache } from '@ohos/screenlockcommon/src/main/ets/base/GlobalStatusCache';
import { AuthSubType, AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { RtlCalculateUtils } from '../../utils/RtlCalculateUtils';
import { PasswordLayoutConfig } from '../common/PasswordLayoutConfig';
import { PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';

const TAG = 'NumKeyBoardViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const TOUCH_TYPE_DOWN: number = 0;
const TOUCH_TYPE_UP: number = 1;
const TOUCH_TYPE_CANCEL: number = 3;
const LONG_PRESS_MILL_SECONDS: number = 500;
const PIN_TYPE_SIX_PASSWORD_LENGTH: number = 6;
const PIN_TYPE_FOUR_PASSWORD_LENGTH: number = 4;

/**
 * 动画开始停止回调
 */
export interface AniCallback {
  onAnimationPre?: Function,
  onAnimationGoing?: Function;
}

/**
 * num key board view model
 *
 * @since 2024-08-21
 */
export default class NumKeyBoardViewModel {
  private moveMatchState: boolean = false;
  private touchAnis: Map<boolean, Map<boolean, Function>> = new Map();
  private passWordWidth: number = 0;
  private passwordVm?: ScreenLockPasswordVm;
  private numKeyboard: DigitalKeyboardItem[] = RtlCalculateUtils.getNumberKeyBoard();
  private onKeyBackPress: Function = () => {};
  private onEmergencyKeyClick: Function = () => {};
  private animationKeyUp: AniCallback = {
    onAnimationGoing: (index: number) => {}
  }
  private animationKeyDown: AniCallback = {
    onAnimationPre: (index: number) => {},
    onAnimationGoing: (index: number) => {}
  }
  private initNumKeyPress: Function = () => {};
  private hasTouchDownNum: number = 0;
  private touchDownTime: number = 0;
  private currentFocusBtnItem: DigitalKeyboardItem | null = null;
  private keyDownTime: number = 0;
  private keyUpTime: number = 0;
  private alarm: Alarm | null = null;
  private EMERGENCY_CALL: string = ResUtils.getInnerString($r('app.string.emergency_call_accessible'));
  private GO_BACK: string = ResUtils.getInnerString($r('app.string.sim_unlock_num_keyboard_cancel_accessible'));
  private PSD_BACK: string = ResUtils.getInnerString($r('app.string.psd_back_accessible'));
  private DEL_PWD: string = ResUtils.getInnerString($r('app.string.del_pwd_accessible'));
  private passwordLayoutConfig: PasswordLayoutConfig = new PasswordLayoutConfig();

  public initAuthCallback(onKeyBackPress: Function, onEmergencyKeyClick: Function): void {
    this.onKeyBackPress = onKeyBackPress;
    this.onEmergencyKeyClick = onEmergencyKeyClick;
  }

  public initParam(passWordWidth: number, passwordVm: ScreenLockPasswordVm | undefined,
    passwordLayoutConfig: PasswordLayoutConfig): void {
    this.passWordWidth = passWordWidth;
    this.passwordVm = passwordVm;
    this.passwordLayoutConfig = passwordLayoutConfig;
  }

  public set numberKeyboard(numberKeyboard: DigitalKeyboardItem[]) {
    this.numKeyboard = numberKeyboard;
  }

  public initTouchAni(animationKeyUp: AniCallback, animationKeyDown: AniCallback, initNumKeyPress: Function): void {
    this.animationKeyUp = animationKeyUp;
    this.animationKeyDown = animationKeyDown;
    this.initNumKeyPress = initNumKeyPress;

    this.touchAnis.set(true, new Map<boolean, Function>([[true,
      (index: number, aniCallbackUp: AniCallback, aniCallbackDown: AniCallback) => {
        this.onKeyTouchAnimate(index, TouchType.Up, aniCallbackUp);
      }]]));
    this.touchAnis.set(false, new Map<boolean, Function>([[false,
      (index: number, aniCallbackUp: AniCallback, aniCallbackDown: AniCallback) => {
        this.onKeyTouchAnimate(index, TouchType.Down, aniCallbackDown);
      }]]));
  }

  public getHotZoneWith(): number {
    return this.passwordLayoutConfig.layoutConfig.numBoardHeight +
      (DeviceHelper.isPadOr2in1PcType() ? (this.passWordWidth -
      PasswordConstants.NUM_POSITION_GROUP_ALIGN.size * PasswordConstants.NUM_KEYBOARD_HEIGHT) /
      (PasswordConstants.NUM_POSITION_GROUP_ALIGN.size - 1) :
    this.passwordLayoutConfig.layoutConfig.numBoardLeftMarginPhone);
  }

  public getHotZoneHeight(): number {
    return PasswordConstants.NUM_KEYBOARD_HEIGHT + this.getHotZoneHeightMargin()
  }

  public getHotZoneHeightMargin(): number {
    return DeviceHelper.isPadOr2in1PcType() ?
    PasswordConstants.NUM_KEYBOARD_TOP_MARGIN_PAD : this.passwordLayoutConfig.layoutConfig.numBoardTopMarginPhone;
  }

  public setPasswordLayoutConfig(passwordLayoutConfig: PasswordLayoutConfig): void {
    log.showInfo('setPasswordLayoutConfig');
    this.passwordLayoutConfig = passwordLayoutConfig;
  }
  /**
   * 取消触摸按键输入
   *
   * @param event 触摸事件信息
   * @return 是否取消触摸按键输入
   */
  public cancelTouch(event: TouchEvent): boolean {
    if (event.touches[0]?.x < (-this.getHotZoneHeightMargin() / 2) || event.touches[0]?.x > this.getHotZoneWith()) {
      return true;
    }
    if (event.touches[0]?.y < (-this.getHotZoneHeightMargin() / 2) || event.touches[0]?.y > this.getHotZoneHeight()) {
      return true;
    }
    return false;
  }

  private isSkipDevice(event: BaseEvent): boolean {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return false;
    }
    if (event.sourceTool == SourceTool.MOUSE || event.sourceTool == SourceTool.TOUCHPAD) {
      return true;
    }
    return false;
  }

  public handleTouchMove(
    event: TouchEvent, index: number, aniCallbackUp: AniCallback, aniCallbackDown: AniCallback): void {
    const touchState = this.cancelTouch(event);
    this.touchAnis.get(touchState)?.get(this.moveMatchState)?.(index, aniCallbackUp, aniCallbackDown);
    this.moveMatchState = !touchState;
  }

  public onKeyTouchAnimate(index: number, eventState: TouchType, aniCallback: AniCallback) {
    aniCallback?.onAnimationPre?.(index);
    animateToImmediately({
      delay: eventState === TouchType.Up ? 30 : 0,
      duration: 400,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {},
    }, () => { aniCallback?.onAnimationGoing?.(index); });
  }

  public getHotZoneOffset(item: DigitalKeyboardItem): number {
    return this.isSpecialKey(item.value) ? 0 : (-this.getHotZoneHeightMargin() / 2);
  }

  /**
   * 绘制时判断是否为特殊按键
   *
   * @param value 按键类型
   * @return 是否为非数字按键
   */
  public isSpecialKey(value: number, deleteRowValue?: number): boolean {
    return [Constants.GO_BACK, Constants.DEL_PWD, Constants.EMERGENCY_CALL, deleteRowValue].includes(value);
  }

  /**
   * 无障碍屏幕朗读绘制判断播报当前特殊按键
   *
   * @param value 按键类型
   * @return 当前特殊按键
   */
  public specialKey(value: number, backKeyboardItem: DigitalKeyboardItem | null): string {
    if (value == Constants.DEL_PWD) {
      return this.DEL_PWD;
    }
    if (value == Constants.GO_BACK) {
      if (backKeyboardItem !== null) {
        return this.GO_BACK;
      } else {
        return this.PSD_BACK;
      }
    }
    if (value == Constants.EMERGENCY_CALL) {
      return this.EMERGENCY_CALL;
    }
    return '';
  }

  private onKeyTouchDown(event: TouchEvent, initNumKeyPress: Function,
    item: DigitalKeyboardItem, setNumKeyPressStatus: Function): void {
    log.showInfo('onNumKeyTouchDown');
    if (event.touches.length === 1 && event.touches[0]?.id === 0) {
      initNumKeyPress();
      this.hasTouchDownNum = 1;
    } else {
      this.hasTouchDownNum++;
    }
    if (this.isSpecialKey(item.value)) {
      setNumKeyPressStatus(item);
    }
    this.touchDownTime = Date.now();
  }

  private onKeyTouchUp(event: TouchEvent, index: number): void {
    log.showInfo('onNumKeyTouchUp');
    if (this.hasTouchDownNum-- && this.hasTouchDownNum !== 0) {
      log.showInfo('Two-finger touch!');
      return;
    }
    if (this.cancelTouch(event) || this.isSkipDevice(event)) {
      log.showInfo('cancel touch!');
      return;
    }
    this.handleKeyPress(index);
  }

  private handleKeyPress(index: number, isPsdAccessAccessibility: boolean = false): void {
    if (index < 0 || index > this.numKeyboard.length) {
      log.showInfo('invalid index!');
      return;
    }
    let value: number = this.numKeyboard[index].value;
    switch (value) {
      case Constants.EMERGENCY_CALL:
        if (AppStorage.get('hasVoiceCapability') === true) {
          this.onEmergencyKeyClick();
        }
        break;
      case Constants.GO_BACK:
        if (Date.now() - this.touchDownTime < LONG_PRESS_MILL_SECONDS) {
          this.onKeyBackPress();
        }
        break;
      case Constants.DEL_PWD:
        this.passwordVm?.delPassword();
        if (isPsdAccessAccessibility) {
          this.onKeyDelPressCallback(isPsdAccessAccessibility);
        }
        break;
      default:
        if (value >= 0) {
          this.passwordVm?.addPassword(value.toString());
        } else {
          log.showInfo('Out of range, cancel entry');
        }
        break;
    }
  }

  private getKeyboardIndex(keyCode: number): number {
    let numKeyboard: DigitalKeyboardItem[] = AppStorage.get<DigitalKeyboardItem[]>('numKeyboard') as DigitalKeyboardItem[];
    if (!numKeyboard) {
      log.showError('numKeyboard is null');
      return -1;
    }
    if (keyCode === KeyCode.KEYCODE_DEL) {
      const delPwdIndex: number = RtlCalculateUtils.getDelPwdIndex();
      if (delPwdIndex >= 0 && delPwdIndex < numKeyboard.length) {
        return numKeyboard[delPwdIndex].index;
      }
      log.showError('numKeyboard delPwdIndex error');
      return -1;
    }
    for (let item of numKeyboard) {
      if ((keyCode - KeyCode.KEYCODE_0) === item.value || (keyCode - KeyCode.KEYCODE_NUMPAD_0) === item.value) {
        return item.index;
      }
    }
    return -1;
  }

  private onKeyUp(event: KeyEvent) {
    this.keyUpTime = Date.now();
    this.alarm?.cancelAlarm();
    const index: number = this.getKeyboardIndex(event.keyCode);
    if (index < 0) {
      return;
    }
    this.handleKeyPress(index);
  }

  private onKeyDelPressCallback(isPsdAccessAccessibility: boolean): void {
    log.showInfo(`isPsdAccessAccessibility ${isPsdAccessAccessibility}`);
    if (isPsdAccessAccessibility) {
      let passwordTypeLength: number =
        (VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).authSubType === AuthSubType.PIN_SIX ?
        PIN_TYPE_SIX_PASSWORD_LENGTH : PIN_TYPE_FOUR_PASSWORD_LENGTH);
      let passwordTypeText = ResUtils.getInnerPluralByResource($r('app.plural.psd_totle_length'), passwordTypeLength);
      let digitalPsdPasswordLengthText =
        ResUtils.getInnerPluralByResource($r('app.plural.psd_entered_length'), this.passwordVm?.passwordLength);
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.keyboard_delete_remainder'),
        passwordTypeText, digitalPsdPasswordLengthText));
    } else {
      let currentSimpleDelete: string =
        ResUtils.getInnerString($r('app.string.keyboard_simple_delete_remainder_accessible'));
      AccessibilityUtil.sendAccessibility(currentSimpleDelete);
    }
  }

  /**
   * 无障碍下触摸按键输入解锁
   *
   * @param item 键盘输入信息
   */
  public onKeyClickItem(item: DigitalKeyboardItem, isPsdAccessAccessibility: boolean): void {
    this.initNumKeyPress();
    this.touchDownTime = Date.now();
    this.handleKeyPress(item.index, isPsdAccessAccessibility);
  }

  /**
   * 数字按键输入解锁Up事件
   *
   * @param event 键盘按键输入Up事件
   *
   */
  private NumKeyOnKeyEventUp(shouldLetteFocus: boolean, callback: Function, unlockCallback: Function,
    event?: KeyEvent): void {
    switch (event?.keyCode) {
      case KeyCode.KEYCODE_TAB:
        callback();
        break;
      case KeyCode.KEYCODE_ENTER:
      case KeyCode.KEYCODE_NUMPAD_ENTER:
        if (!shouldLetteFocus && this.currentFocusBtnItem !== null) {
          this.handleKeyPress(this.currentFocusBtnItem.index);
        } else if (VerifyDataManager.getInstance().isUnfixedPwdType &&
          (shouldLetteFocus || this.currentFocusBtnItem === null)) {
          this.passwordVm?.authPassword(true);
        } else if (this.passwordVm?.isSimCardAuth) {
          unlockCallback?.();
        }
        return;
    }
    this.onKeyUp(event as KeyEvent);
  }

  public setCurrentFocusBtnItem(value: DigitalKeyboardItem | null) {
    this.currentFocusBtnItem = value;
  }

  /**
   * 数字按键输入解锁Down事件
   *
   * @param event 键盘按键输入Down事件
   *
   */
  private NumKeyOnKeyEventDown(event?: KeyEvent): void {
    this.keyDownTime = Date.now();
    const index: number = this.getKeyboardIndex((event as KeyEvent).keyCode);
    if (index !== RtlCalculateUtils.getDelPwdIndex()) {
      return;
    }
    this.alarm = new Alarm();
    this.alarm.setHandler({
      onAlarm: () => {
        if (this.keyUpTime < this.keyDownTime) {
          this.passwordVm?.clearPassword();
        }
      }
    });
    this.alarm.setAlarm(LONG_PRESS_MILL_SECONDS);
    this.alarm.run();
  }

  /**
   * 数字按键输入解锁
   *
   * @param event 键盘按键输入事件
   *
   */
  public NumKeyOnKeyEvent(shouldLetteFocus: boolean, callback: Function, unlockCallback: Function,
    event?: KeyEvent): void {
    if (event) {
      if (event.type == KeyType.Up) {
        this.NumKeyOnKeyEventUp(shouldLetteFocus, callback, unlockCallback, event)
      } else if (event.type == KeyType.Down) {
        this.NumKeyOnKeyEventDown(event)
      }
    }
  }

  /**
   * 数字按键触摸输入解锁
   *
   * @param event 键盘触摸输入事件
   *
   */
  public NumKeyOnTouchEvent(item: DigitalKeyboardItem, numKeyPress: boolean[],
    setNumKeyPressStatus: Function, event?: TouchEvent): void {
    if (!event) {
      log.showWarn('touchEvent is null.');
      return;
    }
    // 阻止事件冒泡
    if (event.stopPropagation) {
      event.stopPropagation();
    }
    if (event.type === TouchType.Move) {
      this.handleTouchMove(event, item.index, this.animationKeyUp, this.animationKeyDown);
    }
    if (event.type == TOUCH_TYPE_UP || event.type == TOUCH_TYPE_CANCEL) {
      this.onKeyTouchUp(event, item.index);
      if (!numKeyPress[item.index]) {
        return;
      }
      this.onKeyTouchAnimate(item.index, TouchType.Up, this.animationKeyUp);
    } else if (event.type == TOUCH_TYPE_DOWN) {
      this.onKeyTouchDown(event, this.initNumKeyPress, item, setNumKeyPressStatus);
      if (numKeyPress[item.index]) {
        return;
      }
      this.onKeyTouchAnimate(item.index, TouchType.Down, this.animationKeyDown);
    }
  }

  /**
   * 是否禁止pad的紧急呼叫按键
   * pad不支持通话时，紧急呼叫禁止选中获焦
   *
   * @param item 按键信息
   */
  public isForbiddenEmergencyCallOnPad(item: DigitalKeyboardItem): boolean {
    return DeviceHelper.isPadOr2in1PcType() && item.value === Constants.EMERGENCY_CALL &&
      !AppStorage.get<boolean>('hasVoiceCapability') as boolean;
  }
}