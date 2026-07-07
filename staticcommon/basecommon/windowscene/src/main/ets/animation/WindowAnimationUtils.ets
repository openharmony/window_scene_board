/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use inputConfig file except in compliance with the License.
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
  SCBInputAnimationConfig,
  SCBInputWindowConfig, SubWindowAnimationConfig } from '../scene/session/SCBSceneSession';
import curves from '@ohos.curves'
import { AnimationConstants } from '@ohos/commonconstants/Index';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBSessionRect } from '../scene/session/SCBSessionRect';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBSpecificSession } from '../scene/session/SCBSpecificSession';
import { SCBKeyboardSession } from '../scene/session/SCBKeyboardSession';
import { SCBKeyboardManager } from '../scene/session/SCBKeyboardManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '../screen/session/SCBScreenSessionManager';
import { WinLog, WinLogDomain } from '../utils/WinLog';

const TAG = 'WindowAnimationUtils';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class WindowAnimationUtils {
  private static instance: WindowAnimationUtils;
  private readonly inputConfig: SCBInputWindowConfig = new SCBInputWindowConfig();
  private readonly subWindowAnimationConfig: SubWindowAnimationConfig = new SubWindowAnimationConfig();
  private readonly windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;

  private constructor() {
    this.initSpecialWindowConfig();
  }

  static getInstance(): WindowAnimationUtils {
    if (WindowAnimationUtils.instance == null) {
      WindowAnimationUtils.instance = new WindowAnimationUtils();
    }
    return WindowAnimationUtils.instance;
  }

  private initSpecialWindowConfig(): void {
    this.setInputWindowConfig();
    this.setSpecialSubWindowAnimationConfig();
  }

  private setInputWindowConfig(): void {
    log.showDebug(' begin to set the input window config ');
    log.showDebug('windowSceneConfig: ' + `${JSON.stringify(this.windowSceneConfig)}`);
    let keyboardAnimationIn = this.windowSceneConfig?.keyboardAnimationIn;
    let keyboardAnimationOut = this.windowSceneConfig?.keyboardAnimationOut;
    if (keyboardAnimationIn !== null && keyboardAnimationIn !== undefined) {
      this.inputConfig.animationIn.curveType = keyboardAnimationIn.curveType;
      this.inputConfig.animationIn.ctrlX1 = keyboardAnimationIn.ctrlX1;
      this.inputConfig.animationIn.ctrlY1 = keyboardAnimationIn.ctrlY1;
      this.inputConfig.animationIn.ctrlX2 = keyboardAnimationIn.ctrlX2;
      this.inputConfig.animationIn.ctrlY2 = keyboardAnimationIn.ctrlY2;
      this.inputConfig.animationIn.duration = keyboardAnimationIn.duration;
    }
    if (keyboardAnimationOut !== null && keyboardAnimationOut !== undefined) {
      this.inputConfig.animationOut.curveType = keyboardAnimationOut.curveType;
      this.inputConfig.animationOut.ctrlX1 = keyboardAnimationOut.ctrlX1;
      this.inputConfig.animationOut.ctrlY1 = keyboardAnimationOut.ctrlY1;
      this.inputConfig.animationOut.ctrlX2 = keyboardAnimationOut.ctrlX2;
      this.inputConfig.animationOut.ctrlY2 = keyboardAnimationOut.ctrlY2;
      this.inputConfig.animationOut.duration = keyboardAnimationOut.duration;
    }
  }

  private setSpecialSubWindowAnimationConfig(): void {
    log.showDebug('windowSceneConfig: ' + `${JSON.stringify(this.windowSceneConfig)}`);
    let windowAnimationConfig = this.windowSceneConfig?.windowAnimation;
    if (windowAnimationConfig !== null && windowAnimationConfig !== undefined) {
      this.subWindowAnimationConfig.duration = windowAnimationConfig.duration;
      this.subWindowAnimationConfig.curveType = windowAnimationConfig.curveType;
      this.subWindowAnimationConfig.ctrlX1 = windowAnimationConfig.ctrlX1;
      this.subWindowAnimationConfig.ctrlX2 = windowAnimationConfig.ctrlX2;
      this.subWindowAnimationConfig.ctrlY1 = windowAnimationConfig.ctrlY1;
      this.subWindowAnimationConfig.ctrlY2 = windowAnimationConfig.ctrlY2;
      this.subWindowAnimationConfig.scaleX = windowAnimationConfig.scaleX;
      this.subWindowAnimationConfig.scaleY = windowAnimationConfig.scaleY;
      this.subWindowAnimationConfig.rotationX = windowAnimationConfig.rotationX;
      this.subWindowAnimationConfig.rotationY = windowAnimationConfig.rotationY;
      this.subWindowAnimationConfig.rotationZ = windowAnimationConfig.rotationZ;
      this.subWindowAnimationConfig.angle = windowAnimationConfig.angle;
      this.subWindowAnimationConfig.translateX = windowAnimationConfig.translateX;
      this.subWindowAnimationConfig.translateY = windowAnimationConfig.translateY;
      this.subWindowAnimationConfig.opacity = windowAnimationConfig.opacity;
    }
    log.showDebug('subWindowAnimationConfig: ' + `${JSON.stringify(this.subWindowAnimationConfig)}`);
  }

  public getInputAnimationCurve(animationType: string) : ICurve | Curve {
    if (animationType === 'enter') {
      return this.getInputWindowCurve(this.inputConfig.animationIn, animationType);
    } else {
      return this.getInputWindowCurve(this.inputConfig.animationOut, animationType);
    }
  }

  public getInputAnimationDuration(animationType: string) : number {
    log.showDebug('getInputAnimationDuration, animateType: ' + animationType);
     if (animationType === 'enter') {
       return this.inputConfig.animationIn.duration;
     } else if (animationType === 'exit') {
       return this.inputConfig.animationOut.duration;
     }
     return 0;
  }

  private getInputWindowCurve(inputConfig: SCBInputAnimationConfig, animationType: string): ICurve | Curve {
    log.showDebug('the input window config value , curveType: ' + inputConfig.curveType +
      ' durationIn is : ' + inputConfig.duration +
      ' ctrlX1 is : ' + inputConfig.ctrlX1 + ' ctrlY1 is : ' + inputConfig.ctrlY1 +
      ' ctrlX2 is : ' + inputConfig.ctrlX2 + ' ctrlY2 is : ' + inputConfig.ctrlY2);
    let curvesMap = new Map([
      ['easeOut', Curve.EaseOut],
      ['ease', Curve.Ease],
      ['easeIn', Curve.EaseIn],
      ['easeInOut', Curve.EaseInOut],
      ['linear', Curve.Linear]
    ]);
    let parameterCurvesMap = new Map([
      ['spring', curves.springCurve(inputConfig.ctrlX1, inputConfig.ctrlY1, inputConfig.ctrlX2, inputConfig.ctrlY2)],
      ['interactiveSpring', curves.springMotion(inputConfig.ctrlX1, inputConfig.ctrlY1, inputConfig.ctrlX2)],
      ['interpolatingSpring', curves.interpolatingSpring(inputConfig.ctrlX1, inputConfig.ctrlY1, inputConfig.ctrlX2, inputConfig.ctrlY2)],
      ['cubic', curves.cubicBezierCurve(inputConfig.ctrlX1, inputConfig.ctrlY1, inputConfig.ctrlX2, inputConfig.ctrlY2)]
    ]);
    if (curvesMap.has(inputConfig.curveType)) {
      return curvesMap.get(inputConfig.curveType)!;
    } else if (parameterCurvesMap.has(inputConfig.curveType)) {
      return parameterCurvesMap.get(inputConfig.curveType)!;
    } else {
      if (animationType === 'enter') {
        return AnimationConstants.SHOW_INPUT_WINDOW_CURVE;
      } else {
        return AnimationConstants.HIDE_INPUT_WINDOW_CURVE;
      }
    }
  }

  private getSubWindowAnimateCurve(subWindowAnimationConfig: SubWindowAnimationConfig): Curve | ICurve {
    if (subWindowAnimationConfig.curveType === SCBConstants.CUBIC) {
      let ctrlX1 = subWindowAnimationConfig.ctrlX1;
      let ctrlX2 = subWindowAnimationConfig.ctrlX2;
      let ctrlY1 = subWindowAnimationConfig.ctrlY1;
      let ctrlY2 = subWindowAnimationConfig.ctrlY2;
      const cubicCurve: ICurve = curves.cubicBezierCurve(ctrlX1, ctrlX2, ctrlY1, ctrlY2);
      return cubicCurve;
    } else {
      return Curve.EaseOut;
    }
  }

  private getSubWindowTransitionEffect(subWindowAnimationConfig: SubWindowAnimationConfig): TransitionEffect {
    log.showInfo(`getSubWindowTransitionEffect start`);
    const transitionEffect = TransitionEffect
      .scale({ x: subWindowAnimationConfig.scaleX,
        y: subWindowAnimationConfig.scaleY, })
      .animation({ curve: this.getSubWindowAnimateCurve(subWindowAnimationConfig),
        duration: subWindowAnimationConfig.duration})
      .combine(TransitionEffect.rotate({
        x: subWindowAnimationConfig.rotationX,
        y: subWindowAnimationConfig.rotationY,
        z: subWindowAnimationConfig.rotationZ,
        angle: subWindowAnimationConfig.angle }))
      .combine(TransitionEffect.translate({
        x: subWindowAnimationConfig.translateX,
        y: subWindowAnimationConfig.translateY, }))
      .combine(TransitionEffect.opacity(subWindowAnimationConfig.opacity))
    return transitionEffect;
  }

  /**
   * get Touchpad Keyboard Transition
   * @param height
   * @returns TransitionEffect
   */
  private getTouchpadKeyboardTransitionEffect(height: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: height })
        .animation(AnimationConstants.SHOW_TOUCHPAD_KEYBOARD_ANIM_CONFIG)
        .combine(TransitionEffect.OPACITY.animation(AnimationConstants.KEYBOARD_OPACITY_ANIM_CONFIG)),
      TransitionEffect.translate({ y: height }).animation({
        curve: this.getInputWindowCurve(this.inputConfig.animationOut, 'exit'),
        duration: this.inputConfig.animationOut.duration
      })
    );
  }

  /**
   * get Fixed Keyboard Transition
   * @param height
   * @returns TransitionEffect
   */
  private getFixedKeyboardTransitionEffect(height: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: height })
        .animation(AnimationConstants.FIXED_KEYBOARD_ANIM_CONFIG)
        .combine(TransitionEffect.OPACITY.animation(AnimationConstants.SHOW_FIXED_KEYBOARD_OPACITY_ANIM_CONFIG)),
      TransitionEffect.translate({ y: height })
        .animation(AnimationConstants.FIXED_KEYBOARD_ANIM_CONFIG)
        .combine(TransitionEffect.OPACITY.animation(AnimationConstants.HIDE_FIXED_KEYBOARD_OPACITY_ANIM_CONFIG))
    );
  }

  /**
   * get Floating Keyboard Transition
   * @returns TransitionEffect
   */
  private getFloatingKeyboardTransitionEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.scale({ x: 0.8, y: 0.8 })
        .animation({
          curve: AnimationConstants.FLOATING_SYSTEM_KEYBOARD_CURVE,
        })
        .combine(TransitionEffect.OPACITY.animation(AnimationConstants.KEYBOARD_OPACITY_ANIM_CONFIG)),
      TransitionEffect.scale({ x: 0.9, y: 0.9 }).animation({
        curve: AnimationConstants.FLOATING_SYSTEM_KEYBOARD_CURVE,
      })
        .combine(TransitionEffect.OPACITY.animation(AnimationConstants.KEYBOARD_OPACITY_ANIM_CONFIG))
    );
  }

  /**
   * get System Keyboard Transition (Includes Touchpad Keyboard, Fixed Keyboard And Floating Keyboard)
   * @param rect
   * @returns TransitionEffect
   */
  getSystemKeyboardTransitionEffect(rect: SCBSessionRect): TransitionEffect {
    let transitionEffect = TransitionEffect.IDENTITY;
    const screenWidth = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty.width;
    const keyboardWidth = rect?.width.getPx() ?? 0;
    const keyboardHeight = rect?.height.getVp() ?? 0;
    if (keyboardWidth === screenWidth) {
      // 触控板键盘转场动效
      transitionEffect = this.getTouchpadKeyboardTransitionEffect(keyboardHeight);
    } else {
      // 悬浮小键盘转场动效
      transitionEffect = this.getFloatingKeyboardTransitionEffect();
    }
    return transitionEffect;
  }

  getTransitionEffect(specificSession: SCBSpecificSession, rect: SCBSessionRect): 
    TransitionEffect {
    let type = specificSession?.session.type;
    if (type !== undefined && type === sceneSessionManager.SessionType.TYPE_SUB_APP && 
      (specificSession as SCBSpecificSession).isWindowShowAnimate &&
      !(specificSession as SCBSpecificSession).sessionData.isDragging) {
      return this.getSubWindowTransitionEffect(this.subWindowAnimationConfig);
    } else {
      return TransitionEffect.IDENTITY;
    }
  }

  setSystemKeyboardSnapshotAnimate(keyboardSession: SCBKeyboardSession): void {
    keyboardSession.setAnimSceneVisible(true);
    animateTo({
      curve: Curve.Sharp,
      delay: 50,
      duration: 100,
      onFinish: () => {
        keyboardSession.setAnimSnapshot(undefined);
      }
    }, () => {
      keyboardSession.setAnimSceneVisible(false);
    })
  }

  setSystemKeyboardCommonAnimate(keyboardSession: SCBKeyboardSession): void {
    animateToImmediately({
      curve: this.getInputWindowCurve(this.inputConfig.animationIn, 'enter'),
      duration: this.inputConfig.animationIn.duration,
    }, () => {
      keyboardSession.initSystemKeyboardState();
    })
  }

  public getFadeInAnimateParam(onFinish: ()=>void): AnimateParam {
    let param: AnimateParam = {};
    param.duration = 300;
    param.onFinish = onFinish;
    param.curve = Curve.FastOutSlowIn;
    return param;
  }

  public getFadeOutAnimateParam(onFinish: ()=>void): AnimateParam {
    let param: AnimateParam = {};
    param.duration = 300;
    param.onFinish = onFinish;
    param.curve = Curve.FastOutLinearIn;
    return param;
  }

  transWindowAnimationOptionsToAnimationParam(option: sceneSessionManager.WindowAnimationOptions, onFinish: ()=>void)
    : AnimateParam {
    let param: AnimateParam = {};
    param.duration = option.duration;
    param.onFinish = onFinish;
    param.curve = Curve.Linear;
    if (option.curve == sceneSessionManager.WindowAnimationCurve.LINEAR) {
      param.curve = Curve.Linear;
    } else if (option.curve == sceneSessionManager.WindowAnimationCurve.INTERPOLATION_SPRING) {
      if (option.param == null || option.param.length !== 4) {
        log.showError('[SCBAnimation]trans Interpolation spring failed');
        return param;
      }
      param.curve = curves.interpolatingSpring(
        option.param[0], option.param[1],
        option.param[2], option.param[3]);
    } else if (option.curve == sceneSessionManager.WindowAnimationCurve.CUBIC_BEZIER) {
      if (option.param == null || option.param.length !== 4) {
        log.showError('[SCBAnimation]trans Cubic bezier failed');
        return param;
      }
      param.curve = curves.cubicBezierCurve(option.param[0], option.param[1], option.param[2], option.param[3]);
    }
    return param;
  }

  executeRotationAnimate(rotateDuration: number, event: () => void, onFinish: () => void, curve?: Curve): void {
    animateTo({
      duration: rotateDuration,
      curve: curve ?? Curve.EaseInOut,
      onFinish: () => {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[executeRotationAnimate] onFinish start');
        onFinish();
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[executeRotationAnimate] onFinish end');
      }
    }, () => {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[executeRotationAnimate] do event start');
      event();
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[executeRotationAnimate] do event end');
    });
  }
}