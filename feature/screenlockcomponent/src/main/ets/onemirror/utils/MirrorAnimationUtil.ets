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
import curves from '@ohos.curves';
import thermal from '@ohos.thermal';
import { performanceMonitor } from '@kit.ArkUI';
import { slStateHelper } from '../../screenlockstate/model/helper/SlStateHelper'
import {
  CardWgBindStateType,
  CapWgBindStateType,
  ListStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { NotificationStateManager } from '@ohos/screenlockcommon';
import { SlStateBaseMgr, SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  immersiveKgMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { VerifyDataManager, VerifyInfo } from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { SlV2StateHelper } from '../../screenlockstate/model/helper/v2/SlV2StateHelper';
import { DomainName, TraceUtil } from '@ohos/basicutils';
import { ThermalStateManager } from '@ohos/screenlockcommon/src/main/ets/manager/ThermalStateManager';

/**
 * 桌面有时钟场景进沉浸态动效延迟时间，可按需调整
 */
const DELAY_IMMERSIVE_WITHLOCK = 80;

export interface MirrorAnimateParam {
  delay: number;
  duration: number;
  finish: Function;
  callback: Function;
  scene: string;
}

export default class MirrorAnimationUtil {
  public static createMirrorBezier(creatAnimParam: MirrorAnimateParam) {
    let finishCallback = () => {
      creatAnimParam.finish();
    }

    const aniParam: AnimateParam = {
      duration: creatAnimParam.duration,
      delay: creatAnimParam.delay,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        finishCallback();
      },
    };
    animateTo(aniParam, () => {
      creatAnimParam.callback();
    })
  }

  public static createMirrorAnimateTo(creatAnimParam: MirrorAnimateParam, isTrace?: boolean) {
    let finishCallback = () => {
      creatAnimParam.finish();
      if (isTrace) {
        performanceMonitor.end(creatAnimParam.scene);
        TraceUtil.endTrace(DomainName.SCB, creatAnimParam.scene, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      }
    }

    const aniParam: AnimateParam = {
      delay: creatAnimParam.delay,
      duration: creatAnimParam.duration,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        finishCallback();
      },
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      expectedFrameRateRange: ThermalStateManager.getInstance().getThermalLevel() >= thermal.ThermalLevel.HOT ?
        { expected: 60, min: 60, max: 60 } : undefined
    };
    animateTo(aniParam, () => {
      if (isTrace) {
        performanceMonitor.begin(creatAnimParam.scene, performanceMonitor.ActionType.LAST_UP);
        TraceUtil.startTrace(DomainName.SCB, creatAnimParam.scene, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      }
      creatAnimParam.callback();
    })
  }

  public static createSimpleAnimateTo(callback: Function): void {
    const aniParam: AnimateParam = {
      duration: 0
    };
    animateTo(aniParam, () => {
      callback();
    })
  }

  public static createAnimateToImmediately(callback: Function): void {
    const aniParam: AnimateParam = {
      duration: 0
    };
    animateToImmediately(aniParam, () => {
      callback();
    })
  }

  public static creatMirrorSpring(creatAnimParam: MirrorAnimateParam, isTrace: boolean = false): void {

    const aniParam: AnimateParam = {
      duration: creatAnimParam.duration,
      delay: creatAnimParam.delay,
      curve: curves.interpolatingSpring(10, 1, 228, 30),
      onFinish: () => {
        creatAnimParam.finish();
        if (isTrace) {
          performanceMonitor.end(creatAnimParam.scene);
        }
      },
    };
    animateTo(aniParam, () => {
      if (isTrace) {
        performanceMonitor.begin(creatAnimParam.scene, performanceMonitor.ActionType.LAST_UP);
      }
      creatAnimParam.callback();
    })
  }

  public static createMirrorImmersiveAnimateTo(): void {
    const scaleParam: AnimateParam = {
      delay: DELAY_IMMERSIVE_WITHLOCK,
      duration: 400,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        MirrorAnimationUtil.setImmCardScale();
      },
    };
    const alphaParam: AnimateParam = {
      delay: DELAY_IMMERSIVE_WITHLOCK,
      duration: 150,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
      onFinish: () => {
        MirrorAnimationUtil.setImmCapAlpha();
        MirrorAnimationUtil.setImmCardAlpha();
      },
    };

    animateTo(scaleParam, () => {
      MirrorAnimationUtil.setImmCardScale(1);
    });
    animateTo(alphaParam, () => {
      MirrorAnimationUtil.setImmCapAlpha(1);
      MirrorAnimationUtil.setImmCardAlpha(1);
    });
  }

  public static createMirrorImmersiveAnimateToWithoutClock(delay: number = 0): void {
    const scaleParam: AnimateParam = {
      delay: delay,
      duration: 380,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        MirrorAnimationUtil.setImmCapAlpha();
        MirrorAnimationUtil.setImmCardScale();
      },
    };
    const alphaParam: AnimateParam = {
      delay: delay,
      duration: 150,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
      onFinish: () => {
        MirrorAnimationUtil.setImmCapAlpha();
        MirrorAnimationUtil.setImmCardAlpha();
      },
    };
    MirrorAnimationUtil.setImmCapScale(1.1);
    animateTo(scaleParam, () => {
      MirrorAnimationUtil.setImmCapScale(1);
      MirrorAnimationUtil.setImmCardScale(1);
    });
    animateTo(alphaParam, () => {
      MirrorAnimationUtil.setImmCapAlpha(1);
      MirrorAnimationUtil.setImmCardAlpha(1);
    });
  }

  /**
   * 校验是否需要默认进沉浸态, 平板，直扳机AOD，直扳机非AOD共用该接口进行判断
   */
  public static checkShouldDefaultImmersive(isForceOuterHomeFold: boolean = false): boolean {
    if (!immersiveKgMgr.getDefaultImmersiveSwitch(isForceOuterHomeFold)) {
      return false;
    }
    // V2默认允许进沉浸态，由沉浸态自身判断数据合法性
    if (MirrorAnimationUtil.isV2()) {
      slStateHelper.getOneMirrorStaticState()?.setIsDesktopToSL(true);
      return true;
    }
    let verifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN);
    let isHide = verifyInfo.isSupportUnlock && NotificationStateManager.getHideLiveViewFlag();
    if (isHide && !slStateHelper.getOneMirrorStaticState()?.getIsHasBoardCastingCenter()) {
      slStateHelper.getOneMirrorStaticState()?.setIsDesktopToSL(false);
      return false;
    }
    slStateHelper.getOneMirrorStaticState()?.setIsDesktopToSL(true);
    slStateHelper.getImmersiveListStaticState()?.setSlState(ListStaticStateType.NTF_LIST_HIDE_FLAG, isHide);
    return true;
  }

  /**
   * 沉浸态V2判断
   *
   * @returns true V2
   */
  public static isV2(): boolean {
    // v2判断
    return SlStateBaseMgr.isV2Enable();
  }

  /**
   * 赋值沉浸大卡透明度
   *
   * @param alpha 透明度
   */
  public static setImmCardAlpha(alpha?: number): void {
    // 内外屏同时设置
    if (MirrorAnimationUtil.isV2()) {
      SlV2StateHelper.getInstance().getImmCardStyle()?.setAlpha(alpha);
      SlV2StateHelper.getInstance(SlStateMgr.MGR_OUTER_SCREEN)
        .getImmCardStyle()?.setAlpha(alpha);
      return;
    }
    slStateHelper.getImmersiveCardBindState()?.setSlState(CardWgBindStateType.CARD_ALPHA, alpha);
  }

  /**
   * 赋值沉浸大卡缩放度
   *
   * @param scale 缩放度
   */
  public static setImmCardScale(scale?: number): void {
    // 内外屏同时设置
    if (MirrorAnimationUtil.isV2()) {
      SlV2StateHelper.getInstance()
        .getImmCardStyle()?.setScaleX(scale).setScaleY(scale);
      SlV2StateHelper.getInstance(SlStateMgr.MGR_OUTER_SCREEN)
        .getImmCardStyle()?.setScaleX(scale).setScaleY(scale);
      return;
    }
    slStateHelper.getImmersiveCardBindState()?.setSlState(CardWgBindStateType.CARD_SCALE, scale);
  }

  /**
   * 赋值沉浸胶囊透明度
   *
   * @param alpha 透明度
   */
  public static setImmCapAlpha(alpha?: number): void {
    // 内外屏同时设置
    if (MirrorAnimationUtil.isV2()) {
      SlV2StateHelper.getInstance().getImmCapStyle()?.setAlpha(alpha);
      SlV2StateHelper.getInstance(SlStateMgr.MGR_OUTER_SCREEN)
        .getImmCapStyle()?.setAlpha(alpha);
      return;
    }
    slStateHelper.getImmersiveCapBindState()?.setSlState(CapWgBindStateType.CAPSULE_ALPHA, alpha);
  }

  /**
   * 赋值沉浸胶囊缩放度
   *
   * @param scale 缩放度
   */
  public static setImmCapScale(scale?: number): void {
    // 内外屏同时设置
    if (MirrorAnimationUtil.isV2()) {
      SlV2StateHelper.getInstance()
        .getImmCapStyle()?.setScaleX(scale).setScaleY(scale);
      SlV2StateHelper.getInstance(SlStateMgr.MGR_OUTER_SCREEN)
        .getImmCapStyle()?.setScaleX(scale).setScaleY(scale);
      return;
    }
    slStateHelper.getImmersiveCapBindState()?.setSlState(CapWgBindStateType.CAPSULE_SCALE, scale);
  }
}