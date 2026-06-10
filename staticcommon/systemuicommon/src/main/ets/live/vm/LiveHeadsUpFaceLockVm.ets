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
import util from '@ohos.util';
import { common } from '@kit.AbilityKit';
import { userAuth } from '@kit.UserAuthenticationKit';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { BusinessError } from '@kit.BasicServicesKit';
import { LiveBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveHeadsUpFaceLockVm } from '../interface/ILiveHeadsUpFaceLockVm';
import { LiveHeadsUpFaceLockAnimation } from '../animation/faceLock/LiveHeadsUpFaceLockAnimation';
import lottie, { AnimationItem } from '@ohos/lottie';
import { DropdownVm } from '../../vm/DropdownVm';
import { EnvVm } from '../../vm/EnvVm';
import { LiveStyle } from '../constants/LiveStyle';
import { TimeoutPromise } from '../../base/common/TimeoutProimse';

const TAG = 'LiveHeadsUpFaceLockVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum FaceLockStageValue {
  DEFAULT = 0,
  FACE_AUTH_INIT = 1, // 人脸认证初始化
  FACE_AUTH_SUCCESS = 2, // 人脸认证成功
}

export enum ShowStage {
  SHOW = 0,
  UPDATE = 1,
  HIDE = 2
}

@ObservedV2
export class LiveHeadsUpFaceLockVm extends LiveBaseVm implements ILiveHeadsUpFaceLockVm {
  public componentId: string = this.vmInjector.getId(TAG);
  @Trace public live?: LiveNotification | undefined;
  @Trace public borderRadius: number = LiveStyle.FACE_LOCK_BANNER_BOARDER_SIZE;
  @Trace public translateY: number = -20;
  @Trace public width: number = 0;
  @Trace public height: number = 0;
  @Trace public successWidth: number = 0;
  @Trace public successHeight: number = 0;
  @Trace public scaleX: number = 1;
  @Trace public scaleY: number = 1;
  @Trace public backgroundColor: boolean = false;
  @Trace public opacity: number = 0;
  @Trace public showScaleX: number = 0;
  @Trace public showScaleY: number = 0;
  @Trace public showOpacity: number = 0;
  @Trace public successScaleX: number = 1;
  @Trace public successScaleY: number = 1;
  @Trace public successOpacity: number = 1;
  @Trace public isSupport3DFace: boolean = false;
  public showRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public showCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.showRenderingSettings);
  public successRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public successCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.successRenderingSettings);
  public showAnimateItem: AnimationItem | null = null;
  public successAnimateItem: AnimationItem | null = null;
  public showStage: ShowStage = ShowStage.SHOW;
  private showAnimateName: string = 'faceLockShowLottieAnimation';
  private successAnimateName: string = 'faceLockSuccessLottieAnimation';
  private appearPromise?: TimeoutPromise<void>;
  private lottieData?: object;

  setCardResponseRegion(isRotate: boolean): void {
    log.showInfo(`start set face lock response region`);
  }

  public async show(live: LiveNotification): Promise<void> {
    this.live = live;
    this.showStage = ShowStage.SHOW;
    this.lottieData = this.geLottieData(this.getLottieJsonName());
    let animation = new LiveHeadsUpFaceLockAnimation(this, this.vmInjector.getCapsuleListVm().position);
    if (!this.appearPromise) {
      this.appearPromise = new TimeoutPromise(TAG + '_show');
      this.appearPromise.startTimeout(500);
    }
    if (live.stage === FaceLockStageValue.FACE_AUTH_INIT) {
      AccessibilityVm.instance.sendEventByResource($r('app.string.face_verifing'));
      await animation.swipeEnterFaceAnimation();
    }
    this.appearPromise.resolve();
    this.appearPromise = undefined;
  }

  public async update(live: LiveNotification): Promise<void> {
    this.live = live;
    this.showStage = ShowStage.UPDATE;
    if (this.appearPromise) {
      await this.appearPromise;
    }
    this.lottieData = this.geLottieData(this.getLottieJsonName());
    let animation = new LiveHeadsUpFaceLockAnimation(this, this.vmInjector.getCapsuleListVm().position);
    if (live.stage === FaceLockStageValue.FACE_AUTH_SUCCESS) {
      AccessibilityVm.instance.sendEventByResource($r('app.string.face_auth_recognize_success'));
      await animation.swipeDoingFaceSuccessAnimation();
    }
  }

  public async hide(): Promise<void> {
    this.showStage = ShowStage.HIDE;
    let animation = new LiveHeadsUpFaceLockAnimation(this, this.vmInjector.getCapsuleListVm().position);
    await animation.swipeHideFaceAnimation();
  }

  public isNeedShow(live: LiveNotification): boolean {
    const isLock = EnvVm.instance.isScreenOff;
    if (isLock) {
      return false;
    }
    if (DropdownVm.instance.isDropDown) {
      return false;
    }
    return true;
  }

  private getLottieJsonName(): string {
    this.getFaceAvailableStatus();
    if (this.showStage === ShowStage.UPDATE) {
      return 'face_lock_success.json';
    }
    if (this.showStage === ShowStage.SHOW) {
      return this.isSupport3DFace ? 'face_lock_3d_detect.json' : 'face_lock_2d_detect.json';
    }
    return '';
  }

  private getFaceAvailableStatus(): void {
    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL4);
      log.showInfo(`current auth trust level is supported`);
      this.isSupport3DFace = true;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      log.error(`current auth trust level is not supported. Code is ${err?.code}`);
      this.isSupport3DFace = false;
    }
  }

  public geLottieData(jsonName: string): object | undefined {
    log.showDebug('loadLottieData, jsonName = ' + jsonName);
    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    try {
      let context = getContext(this) as common.UIAbilityContext;
      let data = context?.resourceManager.getRawFileContentSync(jsonName);
      let lottieStr = resStr.decodeToString(new Uint8Array(data));
      let lottieData: object | undefined = JSON.parse(lottieStr);
      log.showInfo(`loadLottieData, lottieData: ${jsonName}`);
      if (!lottieData) {
        return undefined;
      }
      return lottieData;
    } catch (err) {
      log.showError('context is undefined');
      return undefined;
    }
  }

  public playShowAnimation() {
    log.showInfo('start play faceLock show animation')
    this.destroyAnimation(this.showAnimateName);
    this.showAnimateItem = lottie.loadAnimation({
      container: this.showCanvasRenderingContext,
      renderer: 'canvas', // canvas 渲染模式
      loop: true,
      autoplay: false,
      name: this.showAnimateName,
      contentMode: 'Contain',
      animationData: this.lottieData, // json对象数据
    });
  }

  public playSuccessAnimation() {
    log.showInfo('start play faceLock success animation')
    this.destroyAnimation(this.successAnimateName);
    this.successAnimateItem = lottie.loadAnimation({
      container: this.successCanvasRenderingContext,
      renderer: 'canvas', // canvas 渲染模式
      autoplay: true,
      loop: false,
      name: this.successAnimateName,
      contentMode: 'Contain',
      animationData: this.lottieData, // json对象数据
    });
  }

  public destroyAnimation(name?: string): void {
    if (name === this.showAnimateName) {
      lottie.destroy(name);
      this.showAnimateItem = null;
      return;
    }
    if (name === this.successAnimateName) {
      lottie.destroy(name);
      this.successAnimateItem = null;
      return;
    }
    lottie.destroy(this.showAnimateName);
    lottie.destroy(this.successAnimateName);
    this.showAnimateItem = null;
    this.successAnimateItem = null;
  }
}
