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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AccountMgr, EventManager, EvtBus } from '@ohos/frameworkwrapper';
// import privacyManager from '@hms.security.privacyIndicatorManager';
import { componentUtils, display } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene/src/main/ets/events/SCBFoldStatePropertyChangeEvent';
import { DisplayMgr } from '@ohos/windowscene/src/main/ets/utils/DisplayManager';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { BigScreenStatus } from '../common/BigScreenStatus';

const TAG = 'batteryPicVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const ANIMATE_FROM_BIG_TO_SMALL = 2;
const ANIMATE_FROM_SMALL_TO_BIG = 1;
const NO_ANIMATE = 0;
const REFRESH_PRIVACY_STAGE_EVENT = 'refreshPrivacyStageEvent';

enum AnimationStage {
  // 无动效阶段
  initStage = 0,
  // 相机动效阶段
  cameraStage = 1,
  // 麦克风动效阶段
  microphoneStage = 2,
  // 相机关闭
  cameraClose = 3,
  // 麦克风关闭
  microphoneClose = 4,
  // 重启所有
  reopenAll = 5
}

class AnimationStageQueue extends Array<AnimationStage> {
  push(...items: AnimationStage[]): number {
    const result = super.push(...items);
    emitter.emit(REFRESH_PRIVACY_STAGE_EVENT);
    return result;
  }

  shift(): AnimationStage | undefined {
    const result = super.shift();
    emitter.emit(REFRESH_PRIVACY_STAGE_EVENT);
    return result;
  }
}

@Observed
export class BatteryPicVM {
  private readonly defaultBatteryTranslateX: number = 0;
  private readonly iconStayTime: number = 500;
  private readonly batteryWidth: number = 24;
  private readonly circleTranslate: number = 18;
  private readonly circleTranslateWithSoc: number = 20;
  private readonly circleSize: number = 6;
  private readonly circleOffsetY: number = 0.5;
  private readonly circleImmersiveMarginRight = 16; // 沉浸模式灯的右边距
  private readonly circleImmersiveMarginTop = 24; // 沉浸模式灯的上边距
  private readonly circleLockMarginRight = 6 + this.circleSize / 2; // 锁屏界面灯的右边距
  private readonly circleLockMarginTop = 17 + this.circleSize / 2; // 锁屏界面灯的上边距

  private getCircleTranslate() {
    return this.showBatterySoc ? this.circleTranslateWithSoc : this.circleTranslate;
  }

  /**
   * 锁屏场景隐藏的指示器，接触锁屏后需要重新显示
   */
  private cachedLockIndicator: ESObject[] = [];
  private isLock: boolean = false; // 是否锁屏
  private smartDockVisible: boolean = true;
  private showBatterySoc: boolean = false;
  /**
   * 是否是镜像语言
   */
  private _isRTL: boolean = false;
  /**
   * 已经开启了麦克风隐私指示器
   */
  private microphoneActive: boolean = false;
  /**
   *已经开启了相机隐私指示器
   */
  private cameraActive: boolean = false;
  // 当前是否在执行动效
  private _isCurAnimating: boolean = false;
  // 动效执行阶段
  private animationStage: AnimationStage = AnimationStage.initStage;
  private stageQueue: AnimationStageQueue = new AnimationStageQueue();
  private reOpenDelay?: number;
  private readonly needListenType: ESObject[] = [];
  private privacyChangedCallback: (stage: AnimationStage) => void = (animationStage: AnimationStage) => {
    log.showInfo(`add stage: ${animationStage}`);
    this.stageQueue.push(animationStage);
  };
  private sensorStateChangeCallback: Callback<Array<ESObject>> =
    (data: ESObject[]) => {
      this.processPrivacyRemindInfos(data);
    }
  public batteryHeight: number = 24;
  public batteryTranslateX: number = 0;
  public batteryOpacity: number = 1;
  public batteryScale: number = 1;
  public isClip: boolean = false;
  // 相机动效属性
  public privacyCameraTranslateX: number = -this.batteryHeight;
  public privacyCameraOpacity: number = 0;
  public privacyCameraScale: number = 0.5;
  // 相机圆点属性
  public privacyCameraCircleTranslateX: number = 0;
  public privacyCameraCircleOpacity: number = 0;
  public privacyCameraCircleScale: number = 1;
  // 麦克风动效属性
  public privacyMicrophoneTranslateX: number = -this.batteryHeight;
  public privacyMicrophoneOpacity: number = 0;
  public privacyMicrophoneScale: number = 0.5;
  // 麦克风圆点动效属性
  public privacyMicrophoneCircleTranslateX: number = 0;
  public privacyMicrophoneCircleOpacity: number = 0;
  public privacyMicrophoneCircleScale: number = 1;
  public batteryId: string = '';
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 形态变化时状态管理
   */
  private bigScreenStatus: BigScreenStatus = BigScreenStatus.getInstance();
  /**
   * 变化后屏幕的高度
   */
  private adaptiveScreenHeight: number | undefined = undefined;
  /**
   * 变化后屏幕的宽度
   */
  private adaptiveScreenWidth: number | undefined = undefined;
  /**
   * 变化后屏幕的旋转
   */
  private adaptiveScreenRotation: number | undefined = undefined;
  /**
   * 退出键盘状态
   */
  private isKeyBoardStatusOUt = false;
  /**
   * 进入键盘状态
   */
  private isKeyBoardStatusIn = false;

  /**
   * 电池位置变化（切换语言等原因），重新计算隐私指示器位置
   */
  batteryPositionChange() {
    log.showInfo('batteryPositionChange:');
    this.stageQueue.push(AnimationStage.reopenAll);
  }

  setIsLock(value: boolean) {
    log.showInfo(`setIsLock:${value}`);
    let valueChange = this.isLock !== value;
    this.isLock = value;
    if (!valueChange) {
      log.showInfo(`isLock value not change`);
      return;
    }
    log.showInfo(`setIsLock push reopenAll stage`);
    this.reOpenDelay = 1000;
    this.stageQueue.push(AnimationStage.reopenAll);
  }

  private setIsCurAnimating(value: boolean): void {
    log.showInfo(`setIsCurAnimating: ${value}`);
    this._isCurAnimating = value;
  }

  public isCurAnimating(): boolean {
    return this._isCurAnimating;
  }

  /**
   * 设置是否显示电量百分比
   * @param value
   */
  public setShowBatterySoc(value: boolean) {
    log.showDebug(`setShowBatterySoc ${this.showBatterySoc} ${value}`);
    let valueChange = this.showBatterySoc !== value;
    this.showBatterySoc = value;
    if (!valueChange) {
      return;
    }
    /*this.getActiveIndicators().then(indicators => { // 已经有隐私指示器存在的情况下，关掉后重新计算位置后打开
      for (const indicator of indicators) {
        this.turnOffIndicator(indicator, NO_ANIMATE)
        setTimeout(() => {
          this.turnOnIndicator(indicator, NO_ANIMATE);
        }, 500);
      }
    })*/
  }

  /**
   * 设置是否显示电量百分比
   * @param value
   */
  public setSmartDockVisible(value: boolean) {
    log.showDebug(`setSmartDockVisible ${this.smartDockVisible} ${value}`);
    if (this.smartDockVisible === value) {
      return;
    }
    this.smartDockVisible = value;
    log.showInfo(`setSmartDockVisible push reopenAll stage`);
    this.reOpenDelay = 500;
    this.stageQueue.push(AnimationStage.reopenAll);
  }

  public set isRTL(value: boolean) {
    log.showInfo(`set isRTL: ${value}`);
    const valueChange = this._isRTL !== value;
    this._isRTL = value;
    if (!valueChange) {
      return;
    }
    log.showInfo(`isRTL push reopenAll stage`);
    this.reOpenDelay = 500;
    this.stageQueue.push(AnimationStage.reopenAll);
  }

  public get isRTL(): boolean {
    return this._isRTL;
  }

  public init(refreshPrivacyStage: Callback<emitter.EventData>): void {
    log.showInfo('init');
    emitter.on(REFRESH_PRIVACY_STAGE_EVENT, refreshPrivacyStage);
    this.eventMgr
      .on(SCBFoldStatePropertyChangeEvent, this.onBigScreenStatusChange);
    this.registerPrivacyStateChangeListener();
  }

  private onBigScreenStatusChange = async (bigScreenStateProperty: SCBFoldStatePropertyChangeEvent) => {
    log.showInfo(`onBigScreenStatusChange property, bSideHeight: ${bigScreenStateProperty.bSideHeight}, ` +
      `curState: ${bigScreenStateProperty.curState}, tarState: ${bigScreenStateProperty.tarState}`);
    this.updateScreenInfo(bigScreenStateProperty);
    this.updateAnimationStage(bigScreenStateProperty);
  }

  private updateScreenInfo(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): void {
    // 虚拟键盘和磁吸键盘存在
    if (this.bigScreenStatus.isKeyBoardExist(bigScreenStateProperty)) {
      this.adaptiveScreenHeight = bigScreenStateProperty.bSideHeight;
      this.adaptiveScreenWidth = bigScreenStateProperty.bSideWidth;
    } else {
      // 获取的整个屏幕的宽高
      let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      // px
      this.adaptiveScreenHeight = screenSession.scbScreenProperty.height;
      this.adaptiveScreenWidth = screenSession.scbScreenProperty.width;
      log.showInfo('onBigScreenStatusChange, other state');
    }
    log.showInfo(`screenHeight: ${this.adaptiveScreenHeight}, screenWidth: ${this.adaptiveScreenWidth}`);
  }

  private updateAnimationStage(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): void {
    this.updateKeyBoardStatus(bigScreenStateProperty);
    if (this.isKeyBoardStatusIn || this.isKeyBoardStatusOUt) {
      log.showInfo(`isKeyBoardStatusOUt: ${this.isKeyBoardStatusOUt}, isKeyBoardStatusIn: ${this.isKeyBoardStatusIn}`);
      this.stageQueue.push(AnimationStage.reopenAll);
    }
  }

  private updateKeyBoardStatus(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): void {
    this.isKeyBoardStatusOUt = false;
    this.isKeyBoardStatusIn = false;
    if (this.bigScreenStatus.isKeyBoardConvert(bigScreenStateProperty)) {
      log.showWarn(`no need change!`);
      return;
    }
    if (this.bigScreenStatus.isKeyBoardExist(bigScreenStateProperty)) {
      this.isKeyBoardStatusIn = true;
      this.reOpenDelay = 500;
    } else {
      // 键盘退出时位置位置变化
      if (this.bigScreenStatus.isKeyBoardOut(bigScreenStateProperty)) {
        this.isKeyBoardStatusOUt = true;
        this.reOpenDelay = 200;
      }
    }
  }

  /**
   *  注册监听相机和麦克风权限变化
   */
  private registerPrivacyStateChangeListener(): void {
    try {
      log.showInfo('registerPrivacyStateChangeListener');
      // privacyManager.on('sensorStateChange', this.sensorStateChangeCallback);
    } catch (e) {
      log.showError('registerPrivacyStateChangeListener error');
    }
  }

  private processPrivacyRemindInfos(data: ESObject[]): void {
    data.forEach(async (privacyEventRemindInfo: ESObject) => {
      /*if (this.needListenType.includes(privacyEventRemindInfo.privacySensorType)) {
        log.showInfo(`bundleName:${JSON.stringify(privacyEventRemindInfo)}`);
        // 监听到权限关闭
        if (privacyEventRemindInfo.accessState === privacyManager.AccessState.ACCESSED) {
          log.showInfo(`close light:${privacyEventRemindInfo.privacySensorType}`);
          this.privacyChangedCallback(privacyEventRemindInfo.privacySensorType ===
          ESObject.CAMERA ?
          AnimationStage.cameraClose : AnimationStage.microphoneClose);
        }
        // 检测到麦克风或者相机调用权限
        if (privacyEventRemindInfo.accessState === privacyManager.AccessState.ACCESSING) {
          // 统一应用5秒内重新调用权限，简单动效直接开灯
          if (privacyEventRemindInfo.remindFlags & 1) {
            log.showInfo('five seconds reopen');
            this.turnOnIndicator(privacyEventRemindInfo.privacySensorType, ANIMATE_FROM_SMALL_TO_BIG);
          } else {
            log.showInfo(`privacySensorType ${privacyEventRemindInfo.privacySensorType} animate start`);
            this.privacyChangedCallback(privacyEventRemindInfo.privacySensorType ===
            ESObject.CAMERA ?
            AnimationStage.cameraStage : AnimationStage.microphoneStage);
          }
        }
      }*/
    });
  }

  /**
   *  取消注册
   */
  private unregisterPrivacyStateChangeListener(): void {
    try {
      log.showInfo('unregisterPrivacyStateChangeListener');
      // privacyManager.off('sensorStateChange', this.sensorStateChangeCallback);
    } catch (e) {
      log.showError('unregisterPrivacyStateChangeListener error');
    }
  }

  public unInit(refreshPrivacyStage: Callback<emitter.EventData>): void {
    log.showInfo('unInit');
    emitter.off(REFRESH_PRIVACY_STAGE_EVENT, refreshPrivacyStage);
    this.eventMgr.offAll();
    this.unregisterPrivacyStateChangeListener();
  }

  /**
   * 待执行动效队列发生变化触发
   */
  public refreshPrivacyStage(): void {
    log.showInfo(`refreshPrivacyStage ${this.stageQueue.length}`);
    if (!this.isCurAnimating()) {
      if (this.stageQueue.length > 0) {
        this.animationStage = this.stageQueue[0];
        // 设置执行动画需要的属性
        this.setProperties();
        this.executeAnimate();
      }
    } else {
      log.showInfo(`now is animating, pls wait`);
    }
  }

  private setProperties(): void {
    this.privacyCameraTranslateX = this.isRTL ? this.batteryWidth : -this.batteryWidth;
    this.privacyMicrophoneTranslateX = this.isRTL ? this.batteryWidth : -this.batteryWidth;
  }

  private async executeAnimate(): Promise<void> {
    log.showInfo(`executeAnimate, statusBarVisible:${this.smartDockVisible}, stage: ${this.animationStage}`);
    switch (this.animationStage) {
      case AnimationStage.cameraStage:
        this.setIsCurAnimating(true);
        if (!this.smartDockVisible) { // 沉浸式只执行开灯简单动效
          this.processImmersiveCameraOpen();
        } else {
          this.cameraAppear();
        }
        break;
      case AnimationStage.microphoneStage:
        this.setIsCurAnimating(true);
        if (!this.smartDockVisible) { // 沉浸式只执行开灯简单动效
          this.processImmersiveMicroPhoneOpen();
        } else {
          this.microphoneAppear();
        }
        break;
      case AnimationStage.cameraClose:
        this.setIsCurAnimating(true);
        // this.turnOffIndicator(ESObject.CAMERA, ANIMATE_FROM_BIG_TO_SMALL);
        await this.waitFor(1000);
        this.setIsCurAnimating(false);
        this.stageQueue?.shift();
        break;
      case AnimationStage.microphoneClose:
        this.setIsCurAnimating(true);
        // this.turnOffIndicator(ESObject.MICROPHONE, ANIMATE_FROM_BIG_TO_SMALL);
        this.setIsCurAnimating(false);
        this.stageQueue?.shift();
        break;
      case AnimationStage.reopenAll:
        this.setIsCurAnimating(true);
        await this.reOpenAllLights();
        this.setIsCurAnimating(false);
        this.stageQueue?.shift();
        break;
      default:
        log.showWarn('executeAnimate unknown animationStage');
        break;
    }
  }

  /**
   * 把所有现存的隐私指示器关掉后重新打开
   */
  private async reOpenAllLights() {
    let reopenIndicators: ESObject[] = [];
    /*this.getActiveIndicators().then((indicators:ESObject) => { // 已经有隐私指示器存在的情况下，关掉
      reopenIndicators = indicators;
      for (const indicator of indicators) {
        this.turnOffIndicator(indicator, NO_ANIMATE);
      }
    });*/
    await this.waitFor(this.reOpenDelay ?? 50);
    this.reOpenDelay = undefined;
    /*this.getActivePrivacySensors().then((indicators:ESObject) => {
      for (const indicator of indicators) {
        if (reopenIndicators.includes(indicator)) {
          this.turnOnIndicator(indicator, NO_ANIMATE);
        }
      }
    });*/
  }

  private async waitFor(milliseconds: number): Promise<void> {
    return new Promise<void>(resolve => {
      setTimeout(() => {
        resolve();
      }, milliseconds);
    });
  }

  private processImmersiveCameraOpen() {
    // this.turnOnIndicator(ESObject.CAMERA, ANIMATE_FROM_SMALL_TO_BIG);
    this.setIsCurAnimating(false);
    this.stageQueue?.shift();
  }

  private processImmersiveMicroPhoneOpen() {
    // this.turnOnIndicator(ESObject.MICROPHONE, ANIMATE_FROM_SMALL_TO_BIG);
    this.setIsCurAnimating(false);
    this.stageQueue?.shift();
  }

  /**
   * 相机隐私指示器动效
   */
  private async cameraAppear(): Promise<void> {
    this.isClip = true;
    // this.microphoneActive = await this.existOtherIndicator(ESObject.CAMERA);
    animateTo({
      duration: 500, curve: Curve.Friction, onFinish: () => {
        this.cameraStage1OnFinish();
      }
    }, () => {
      this.cameraStage1();
    })
  }

  // stage1. 电池消失，麦克风图标出现
  private cameraStage1(): void {
    // 电池变化
    this.batteryTranslateX = this.isRTL ? -this.batteryWidth : this.batteryWidth;
    this.batteryOpacity = 0;
    this.batteryScale = 0.8;
    this.privacyCameraTranslateX = 0;
    this.privacyCameraOpacity = 1;
    this.privacyCameraScale = 1;
  }

  private cameraStage1OnFinish(): void {
    this.isClip = false;
    // 如果已经存在了麦克风，麦克风圆点关掉真正的灯，使用自己的灯过渡
    if (this.microphoneActive) {
      this.privacyMicrophoneCircleTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
      this.privacyMicrophoneCircleOpacity = 1;
      this.privacyMicrophoneCircleScale = this.circleSize / this.batteryHeight;
      // this.turnOffIndicator(ESObject.MICROPHONE, ANIMATE_FROM_BIG_TO_SMALL);
    }
    animateTo({
      duration: 50, curve: Curve.Friction, onFinish: () => {
        this.cameraStage2OnFinish();
      }
    }, () => {
      this.cameraStage2();
    })
  }

  // stage2. 电池隐藏
  private cameraStage2(): void {
    // 电池隐藏
    this.batteryTranslateX = this.isRTL ? this.getCircleTranslate() : -this.getCircleTranslate();
    this.batteryOpacity = 0;
    this.batteryScale = 0.8;
  }

  private cameraStage2OnFinish(): void {
    animateTo({
      duration: 550,
      curve: Curve.Friction,
      delay: this.iconStayTime,
      onFinish: () => {
        this.cameraStage3OnFinish();
      }
    }, () => {
      this.cameraStage3();
    })
  }

  // stage3. 图标消失，电池出现
  private cameraStage3(): void {
    // 电池最终状态
    this.batteryTranslateX = this.defaultBatteryTranslateX;
    this.batteryOpacity = 1;
    this.batteryScale = 1;
    // 图标最终状态
    this.privacyCameraTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
    this.privacyCameraScale = this.circleSize / this.batteryHeight; // 同步变化成原点大小否则会突变
    // 圆点偏移和缩放
    this.privacyCameraCircleTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
    this.privacyCameraCircleScale = this.circleSize / this.batteryHeight;
    this.privacyCameraCircleOpacity = 1;
  }

  private cameraStage3OnFinish(): void {
    // this.turnOnIndicator(ESObject.CAMERA, NO_ANIMATE);
    if (this.microphoneActive) {
      // this.turnOnIndicator(ESObject.MICROPHONE, NO_ANIMATE);
      // 麦克风圆点初始化
      setTimeout(() => {
        // 状态初始化
        this.privacyMicrophoneCircleOpacity = 0;
        this.privacyMicrophoneCircleScale = 1;
        this.privacyMicrophoneCircleTranslateX = 0;
      }, 50);
      this.microphoneActive = false;
    }
    // 设置延时，防止圆点和开灯切换时跳变
    setTimeout(() => {
      // 状态初始化
      this.privacyCameraCircleOpacity = 0;
      this.privacyCameraOpacity = 0;
    }, 50);
    // 延时，防止左移时有模糊
    setTimeout(() => {
      // 动效结束 状态置为false，删除头部元素触发下一次动效
      this.setIsCurAnimating(false);
      this.stageQueue.shift();
      this.privacyCameraCircleTranslateX = 0;
      this.privacyCameraTranslateX = this.isRTL ? this.batteryWidth : -this.batteryWidth;
    }, 100);
  }

  /**
   * 麦克风隐私指示器动效
   */
  private async microphoneAppear(): Promise<void> {
    this.isClip = true;
    // this.cameraActive = await this.existOtherIndicator(ESObject.MICROPHONE);
    animateTo({
      duration: 500, curve: Curve.Friction, onFinish: () => {
        this.microphoneStage1OnFinish();
      }
    }, () => {
      this.microphoneStage1();
    })
  }

  // stage1. 电池消失，麦克风图标出现
  private microphoneStage1(): void {
    // 电池变化
    this.batteryTranslateX = this.isRTL ? -this.batteryWidth : this.batteryWidth;
    this.batteryOpacity = 0;
    this.batteryScale = 0.8;
    // 麦克风图标变化
    this.privacyMicrophoneOpacity = 1;
    this.privacyMicrophoneScale = 1;
    this.privacyMicrophoneTranslateX = 0;
  }

  private microphoneStage1OnFinish(): void {
    this.isClip = false;
    // 如果已经存在了麦克风，麦克风圆点关掉真正的灯，使用自己的灯过渡
    if (this.cameraActive) {
      this.privacyCameraCircleTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
      this.privacyCameraCircleOpacity = 1;
      this.privacyCameraCircleScale = this.circleSize / this.batteryHeight;
      // this.turnOffIndicator(ESObject.MICROPHONE, ANIMATE_FROM_BIG_TO_SMALL);
    }
    animateTo({
      duration: 50, curve: Curve.Friction, onFinish: () => {
        this.microphoneStage2OnFinish();
      }
    }, () => {
      this.microphoneStage2();
    })
  }

  // stage2. 电池隐藏
  private microphoneStage2(): void {
    // 电池隐藏
    this.batteryTranslateX = this.isRTL ? this.getCircleTranslate() : -this.getCircleTranslate();
    this.batteryOpacity = 0;
    this.batteryScale = 0.8;
  }

  private microphoneStage2OnFinish(): void {
    animateTo({
      duration: 550,
      curve: Curve.Friction,
      delay: this.iconStayTime,
      onFinish: () => {
        this.microphoneStage3OnFinish();
      }
    }, () => {
      this.microphoneStage3();
    })
    if (this.cameraActive) {
      // 相机变大再变小效果
      animateTo({
        duration: 300, curve: Curve.Sharp, delay: this.iconStayTime, onFinish: () => {
          animateTo({ duration: 250, curve: Curve.Sharp }, () => {
            this.privacyCameraCircleScale = this.circleSize / this.batteryHeight;
          })
        }
      }, () => {
        this.privacyCameraCircleScale = (this.circleSize / this.batteryHeight) * 1.4;
      })
    }
  }

  // stage3. 图标消失，电池出现
  private microphoneStage3(): void {
    // 电池最终状态
    this.batteryTranslateX = this.defaultBatteryTranslateX;
    this.batteryOpacity = 1;
    this.batteryScale = 1;
    // 图标最终状态
    this.privacyMicrophoneTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
    this.privacyMicrophoneScale = this.circleSize / this.batteryHeight;
    // 圆点偏移和缩放
    this.privacyMicrophoneCircleTranslateX = this.isRTL ? -this.getCircleTranslate() : this.getCircleTranslate();
    this.privacyMicrophoneCircleScale = this.circleSize / this.batteryHeight;
    this.privacyMicrophoneCircleOpacity = 1;
  }

  private microphoneStage3OnFinish(): void {
    if (this.cameraActive) {
      // this.turnOnIndicator(ESObject.CAMERA, NO_ANIMATE);
      // 相机圆点初始化
      setTimeout(() => {
        // 状态初始化
        this.privacyCameraCircleOpacity = 0;
        this.privacyCameraCircleScale = 1;
        this.privacyCameraCircleTranslateX = 0;
      }, 50);
      this.cameraActive = false;
    }
    // this.turnOnIndicator(ESObject.MICROPHONE, NO_ANIMATE);
    // 设置延时，防止圆点和开灯切换时跳变
    setTimeout(() => {
      // 状态初始化
      this.privacyMicrophoneCircleOpacity = 0;
      this.privacyMicrophoneOpacity = 0;
    }, 50);
    // 延时，防止左移时有模糊
    setTimeout(() => {
      // 动效结束 状态置为false，删除头部元素触发下一次动效
      this.setIsCurAnimating(false);
      this.stageQueue.shift();
      this.privacyMicrophoneCircleTranslateX = 0;
      this.privacyMicrophoneTranslateX = this.isRTL ? this.batteryWidth : -this.batteryWidth;
    }, 100);
  }

  /**
   * 开灯
   */
  private async turnOnIndicator(privacySensorType: ESObject,
    animationType: number): Promise<void> {
    try {
      let pos:ESObject = this.getLightPosition();
      log.showInfo(`${privacySensorType} turnOnIndicator param: ${JSON.stringify(pos)}`);
      /*await privacyManager.turnOnIndicator(privacySensorType, animationType, {
        positionX: pos.positionX,
        positionY: pos.positionY,
        screenWidth: pos.screenWidth,
        screenHeight: pos.screenHeight,
        screenRotation: pos.screenRotation
      }, { width: vp2px(this.circleSize), height: vp2px(this.circleSize) });*/
    } catch (e) {
      log.showError(`turnOnIndicator error:${(e as Error)?.message}`);
    }
  }

  /**
   * 计算灯的位置
   * @returns
   */
  private getLightPosition(): ESObject {
    log.showInfo(`getLightPosition smartDockVisible:${this.smartDockVisible}, isRTL:${this.isRTL}, isLock:${this.isLock}`);
    const displayClass = display.getDefaultDisplaySync();
    let screenWidth = this.adaptiveScreenWidth ?? (displayClass.width);
    let screenHeight = this.adaptiveScreenHeight ?? (displayClass.height);
    let screenRotation = this.adaptiveScreenRotation ?? (displayClass.rotation);
    log.showInfo(` screenWidth: ${screenWidth}, screenHeight: ${screenHeight}, screenRotation: ${screenRotation}`);
    let positionX: number;
    let positionY: number;
    if (!this.smartDockVisible) {
      positionX = this.isRTL ? vp2px(this.circleImmersiveMarginRight) :
        screenWidth - vp2px(this.circleImmersiveMarginRight);
      positionY = vp2px(this.circleImmersiveMarginTop);
    } else if (this.isLock) {
      positionX = screenWidth - vp2px(this.circleLockMarginRight);
      positionY = vp2px(this.circleLockMarginTop);
    } else {
      let info = componentUtils.getRectangleById(this.batteryId);
      positionX = this.isRTL ? info.screenOffset.x + info.size.width / 2 - vp2px(this.getCircleTranslate()) :
        info.screenOffset.x + info.size.width / 2 + vp2px(this.getCircleTranslate());
      positionY = info.screenOffset.y + info.size.height / 2 + this.circleOffsetY;
    }
    return {
      positionX: positionX,
      positionY: positionY,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      screenRotation: screenRotation
    };
  }

  private async turnOffIndicator(privacySensorType: ESObject,
    animationType: number): Promise<void> {
    log.showInfo(`${privacySensorType} turnOffIndicator`);
    try {
      // await privacyManager.turnOffIndicator(animationType, privacySensorType);
    } catch (e) {
      log.showError(`turnOffIndicator error:${(e as Error)?.message}`);
    }
  }

  private async existOtherIndicator(privacySensorType: ESObject): Promise<boolean> {
    try {
      /*let indicators: ESObject[] = await privacyManager.getActiveIndicators();
      return indicators.some((indicator: ESObject) =>
      this.needListenType.includes(indicator.privacySensorType) && indicator.privacySensorType !== privacySensorType);*/
    } catch (e) {
      log.showError(`getActiveIndicators error:${(e as Error)?.message}`);
      return false;
    }
    return false;
  }

  private async getActiveIndicators(): Promise<ESObject[]> {
    /*try {
      let indicators: ESObject[] = await privacyManager.getActiveIndicators();
      return indicators
        .filter((indicator: ESObject) => this.needListenType.includes(indicator.privacySensorType))
        .map((indicator: ESObject): ESObject => indicator.privacySensorType);
    } catch (e) {
      log.showError(`getActiveIndicators error:${(e as Error)?.message}`);
      return [];
    }*/
    return [];
  }

  private async getActivePrivacySensors(): Promise<ESObject[]> {
    /*try {
      const userId = await AccountMgr.getCurrentAccountId();
      let privacySensors: ESObject[] = await privacyManager.getPrivacyEventDetails(userId);
      return privacySensors
        .filter((detail: ESObject) => detail.showAccessState ===
        privacyManager.AccessState.ACCESSING)
        .map((detail: ESObject): ESObject => detail.privacySensorType);
    } catch (e) {
      log.showError(`getActivePrivacySensors error:${(e as Error)?.message}`);
      return [];
    }*/
    return [];
  }
}