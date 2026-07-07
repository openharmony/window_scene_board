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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon';
import { OneMirrorState } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/anim/OneMirrorState';
import { MirrorsScene } from '../constants/MirrorToEndConst';
import IAodProxy from '../model/IAodProxy';
import { ImmersiveAni } from '../model/ImmersiveAni';
import MirrorAniConfig from '../model/MirrorAnimationConf';
import { FinishCallback, MirrorScene } from '../service/OneMirrorService';

const TAG = 'OneMirrorParaUtil'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 布局类型
 */
export enum OneMirrorLayoutType {
  NotificationConf,
  LowPostionConf,
  FingerPrintConf,
  ImmersiveConf
}

/**
 * 一镜到底布局参数
 */
export class OneMirrorLayoutPara {
  public type?: OneMirrorLayoutType;
  public scale: number = 0;
  public alpha: number = 0;
  public blur?: number;
}

/**
 * 一镜到底动效参数
 */
export class OneMirrorAnimationPara {
  public layoutPara?: OneMirrorLayoutPara;
  public needAnimation: boolean = true;
  public delay: number = 0;
  public duration: number = 0;
}

/**
 * 一镜到底动效参数类
 */
export class OneMirrorScenePara {
  public from?: MirrorScene;
  public to?: MirrorScene;
  public fromLayout?: OneMirrorLayoutPara[];
  public toLayoutAnimPara?: OneMirrorAnimationPara[];
}

/**
 * 一镜到底参数
 */
export class OneMirrorSceneParaData {
  // AOD场景布局
  private static readonly LAYOUT_PARA_AOD: OneMirrorLayoutPara[] = [
    {
      type: OneMirrorLayoutType.FingerPrintConf,
      scale: 1,
      alpha: 1,
      blur: 0
    },
    { type: OneMirrorLayoutType.NotificationConf, scale: 1, alpha: 1 },
    { type: OneMirrorLayoutType.LowPostionConf, scale: 0, alpha: 0 },
  ];

  // AOD到ScreenLock动效
  private static readonly ANI_AOD_TO_SCREEN_LOCK: OneMirrorAnimationPara[] = [
    {
      layoutPara: { type: OneMirrorLayoutType.LowPostionConf, scale: 1, alpha: 1 },
      delay: 50,
      duration: 0,
      needAnimation: true
    },
    {
      layoutPara: { type: OneMirrorLayoutType.FingerPrintConf, scale: 1, alpha: 1 },
      delay: 100,
      duration: 0,
      needAnimation: true
    },
  ];

  // AOD到Unlock动效
  private static readonly ANI_AOD_TO_UNLOCK: OneMirrorAnimationPara[] = [
    {
      layoutPara: { type: OneMirrorLayoutType.FingerPrintConf, scale: 1.2, alpha: 0 },
      delay: 0,
      duration: 0,
      needAnimation: true
    },
    {
      layoutPara: { type: OneMirrorLayoutType.NotificationConf, scale: 1.2, alpha: 0 },
      delay: 50,
      duration: 0,
      needAnimation: true
    }
  ];

  // ScreenLock场景布局
  private static readonly LAYOUT_PARA_SCREENLOCK: OneMirrorLayoutPara[] = [
    {
      type: OneMirrorLayoutType.FingerPrintConf,
      scale: 1,
      alpha: 1,
      blur: 0
    },
    { type: OneMirrorLayoutType.NotificationConf, scale: 1, alpha: 1 },
    { type: OneMirrorLayoutType.LowPostionConf, scale: 1, alpha: 1 },
  ];

  // ScreenLock --> AOD动效
  private static readonly ANI_SCREENLOCK_TO_AOD: OneMirrorAnimationPara[] = [
    {
      layoutPara: { type: OneMirrorLayoutType.LowPostionConf, scale: 0, alpha: 0 },
      delay: 50,
      duration: 0,
      needAnimation: true
    },
  ];

  // Unlock布局
  private static readonly LAYOUT_PARA_FROM_UNLOCK: OneMirrorLayoutPara[] = [
    { type: OneMirrorLayoutType.NotificationConf, scale: 1.2, alpha: 0 },
    {
      type: OneMirrorLayoutType.FingerPrintConf,
      scale: 1.2,
      alpha: 0,
      blur: 300
    },
    { type: OneMirrorLayoutType.LowPostionConf, scale: 0, alpha: 0 },
  ];

  // Unlock --> AOD动效
  private static readonly ANI_UNLOCK_TO_AOD: OneMirrorAnimationPara[] = [
    {
      layoutPara: { type: OneMirrorLayoutType.NotificationConf, scale: 1, alpha: 1 },
      delay: 100,
      duration: 0,
      needAnimation: true
    },
    {
      layoutPara: {
        type: OneMirrorLayoutType.FingerPrintConf,
        scale: 1,
        alpha: 1,
        blur: 0
      },
      delay: 100,
      duration: 0,
      needAnimation: true
    },
  ];

  // 一镜到底配置
  private static readonly ONE_MIRROR_SCENE_DATA: OneMirrorScenePara[] = [
    // 亮屏
    {
      from: MirrorScene.AOD,
      to: MirrorScene.SCREEN_LOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_AOD,
      toLayoutAnimPara: OneMirrorSceneParaData.ANI_AOD_TO_SCREEN_LOCK
    },
    {
      from: MirrorScene.AOD,
      to: MirrorScene.UNLOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_AOD,
      toLayoutAnimPara: OneMirrorSceneParaData.ANI_AOD_TO_UNLOCK
    },
    {
      from: MirrorScene.SCREEN_OFF,
      to: MirrorScene.SCREEN_LOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_SCREENLOCK,
    },
    {
      from: MirrorScene.SCREEN_OFF,
      to: MirrorScene.UNLOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_FROM_UNLOCK,
    },
    // 灭屏
    {
      from: MirrorScene.SCREEN_LOCK,
      to: MirrorScene.AOD,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_SCREENLOCK,
      toLayoutAnimPara: OneMirrorSceneParaData.ANI_SCREENLOCK_TO_AOD
    },
    {
      from: MirrorScene.SCREEN_LOCK,
      to: MirrorScene.SCREEN_OFF,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_SCREENLOCK,
    },
    {
      from: MirrorScene.UNLOCK,
      to: MirrorScene.AOD,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_FROM_UNLOCK,
      toLayoutAnimPara: OneMirrorSceneParaData.ANI_UNLOCK_TO_AOD
    },
    {
      from: MirrorScene.UNLOCK,
      to: MirrorScene.SCREEN_OFF,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_SCREENLOCK,
    },
    // 其它场景
    {
      from: MirrorScene.SCREEN_LOCK,
      to: MirrorScene.UNLOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_FROM_UNLOCK,
    },
    {
      from: MirrorScene.UNLOCK,
      to: MirrorScene.SCREEN_LOCK,
      fromLayout: OneMirrorSceneParaData.LAYOUT_PARA_SCREENLOCK,
    },
  ];

  /**
   * 获取一镜到底动效
   *
   * @param from 初始状态
   * @param to 目标状态
   * @returns 动效内容
   */
  public static getOneMirrorScene(from: MirrorScene, to: MirrorScene): OneMirrorScenePara | undefined {
    return OneMirrorSceneParaData.ONE_MIRROR_SCENE_DATA.find(item => {
      return item.from === from && item.to === to;
    });
  }
}

export class OneMirrorAnimateCallback {
  private finishCallback?: FinishCallback;
  private animateTimes: number = 0;
  private id: number = 0;

  constructor(finishCallback?: FinishCallback) {
    this.finishCallback = finishCallback;
    this.id = finishCallback?.getId() ?? 0;
  }

  public get isWaiting(): boolean {
    return this.animateTimes > 0;
  }

  public animateStart(): void {
    this.animateTimes++;
    log.info('animateStart:' + this.animateTimes);
  }

  public finish(): void {
    this.animateTimes--;
    if (this.animateTimes <= 0) {
      this.finishCallback?.finish(this.id);
    }
    log.info('finish id:' + this.id + ', times:' + this.animateTimes);
  }
}

export class ImmersiveOneMirror {
  private aodStyle?: ImmersiveAodStyle;
  
  private immersiveConfImpl: ImmersiveAni;

  constructor(immersiveConf: MirrorAniConfig, aodProxy: IAodProxy, aodStyle?: ImmersiveAodStyle) {
    this.aodStyle = aodStyle;
    this.immersiveConfImpl = new ImmersiveAni(immersiveConf, aodProxy);
  }

  /**
   * 沉浸式一镜到底处理
   *
   * @param para
   */
  public doImmersiveOneMirror(fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean,
    oneMirrorAnimateCallback?: OneMirrorAnimateCallback) {
    // AOD --> ScreenLock
    if (fromScene === MirrorScene.AOD && toScene === MirrorScene.SCREEN_LOCK) {
      this.immersiveAodToScreenLock(hasAnim, oneMirrorAnimateCallback)
    }
    // AOD --> Unlock
    if (fromScene === MirrorScene.AOD && toScene === MirrorScene.UNLOCK) {
      this.doImmersiveAodToUnlock(hasAnim, oneMirrorAnimateCallback);
    }
    // ScreenOff --> ScreenLock
    if (fromScene === MirrorScene.SCREEN_OFF && toScene === MirrorScene.SCREEN_LOCK) {
      if (this.aodStyle) {
        this.aodStyle.isOneMirror++;
        this.aodStyle.isKgWallpaperScale = true;
      }
      animateTo({
        duration: 400,
        delay: 50,
        onFinish: () => {
          if (this.aodStyle) {
            this.aodStyle.isOneMirror--;
          }
          oneMirrorAnimateCallback?.finish();
        },
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      }, () => {
        oneMirrorAnimateCallback?.animateStart();
        this.immersiveConfImpl.doWhenOffScreen2ScreenLockEnd();
      });
    }
    // ScreenOff --> Unlock
    if ((fromScene === MirrorScene.SCREEN_OFF) && toScene === MirrorScene.UNLOCK) {
      if (this.aodStyle) {
        this.aodStyle.isKgNtfHidden = true;
      }
      animateTo({
        duration: 400,
        delay: 0,
        onFinish: () => {
          this.immersiveConfImpl.doWhenAODToDesktop();
          if (this.aodStyle) {
            this.aodStyle.isKgNtfHidden = false;
          }
          oneMirrorAnimateCallback?.finish();
        },
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      }, () => {
        oneMirrorAnimateCallback?.animateStart();
      });
    }
    // ScreenLock --> AOD
    if (fromScene === MirrorScene.SCREEN_LOCK && toScene === MirrorScene.AOD) {
      this.immersiveScreenLockToAod(hasAnim, oneMirrorAnimateCallback);
    }
    // Unlock --> AOD
    if (fromScene === MirrorScene.UNLOCK && toScene === MirrorScene.AOD) {
      this.immersiveConfImpl.doWhenDesktopToAOD();
      if (hasAnim) {
        animateTo({
          duration: 400,
          delay: 0,
          onFinish: () => {
            oneMirrorAnimateCallback?.finish();
          },
          curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
        }, () => {
          oneMirrorAnimateCallback?.animateStart();
          this.immersiveConfImpl.doWhenOffScreen();
        });
      } else {
        this.immersiveConfImpl.doWhenOffScreen();
      }

    }

    // UNLOCK --> SCREEN_OFF,
    if (fromScene === MirrorScene.UNLOCK && toScene === MirrorScene.SCREEN_OFF) {
      this.immersiveConfImpl.doWhenOffScreen();
    }
    // SCREEN_LOCK --> SCREEN_OFF
    if (fromScene === MirrorScene.SCREEN_LOCK && toScene === MirrorScene.SCREEN_OFF) {
      this.immersiveScreenLockToAod(hasAnim, oneMirrorAnimateCallback);
    }
  }

  private doImmersiveAodToUnlock(hasAnim: boolean, oneMirrorAnimateCallback?: OneMirrorAnimateCallback) {
    if (this.aodStyle) {
      this.aodStyle.isKgNtfHidden = true;
    }
    if (!hasAnim) {
      this.immersiveConfImpl.doWhenAODToDesktop();
      if (this.aodStyle) {
        this.aodStyle.isKgNtfHidden = false;
      }
      return;
    }
    animateTo({ duration: 400, delay: 0,
      onFinish: () => {
        this.immersiveConfImpl.doWhenAODToDesktop();
        if (this.aodStyle) {
          this.aodStyle.isKgNtfHidden = false;
        }
        oneMirrorAnimateCallback?.finish();
      },
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    }, () => {
      oneMirrorAnimateCallback?.animateStart();
    });
  }

  private immersiveScreenLockToAod(hasAnim: boolean, oneMirrorAnimateCallback?: OneMirrorAnimateCallback): void {
    if (this.aodStyle) {
      this.aodStyle.isOneMirror++;
    }
    if (!hasAnim) {
      this.immersiveConfImpl?.doWhenOffScreen();
      if (this.aodStyle) {
        this.aodStyle.isOneMirror--;
      }
      return;
    } else {
      animateTo({ duration: 400, delay: 0, finishCallbackType: FinishCallbackType.LOGICALLY,
        onFinish: () => {
          if (this.aodStyle) {
            this.aodStyle.isOneMirror--;
          }
          oneMirrorAnimateCallback?.finish();
          log.info('immersiveConfImpl?.doWhenOffScreen onFinish');
        },
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      }, () => {
        oneMirrorAnimateCallback?.animateStart();
        this.immersiveConfImpl?.doWhenOffScreen();
      });
    }

    animateTo({
      duration: 0
    }, () => {
      if (this.aodStyle) {
        this.aodStyle.isKgWallpaperScale = false;
      }
    });
  }

  private immersiveAodToScreenLock(hasAnim: boolean, oneMirrorAnimateCallback?: OneMirrorAnimateCallback): void {
    if (!hasAnim) {
      this.immersiveConfImpl?.doWhenEndScreenOn();
      this.immersiveConfImpl?.doWhenAODToScreenLock();
      animateTo({
        duration: 0
      }, () => {
        if (this.aodStyle) {
          this.aodStyle.isKgWallpaperScale = true;
        }
      });
      log.info('immersiveAodToScreenLock no anim');
      return;
    }
    if (this.aodStyle) {
      this.aodStyle.isOneMirror++;
    }
    animateTo({
      duration: 400,
      delay: 0,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        if (this.aodStyle) {
          this.aodStyle.isOneMirror--;
        }
        oneMirrorAnimateCallback?.finish();
        log.info('immersiveAodToScreenLock onFinish');
      },
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    }, () => {
      oneMirrorAnimateCallback?.animateStart();
      this.immersiveConfImpl?.doWhenEndScreenOn();
    });

    animateTo({
      duration: 100,
      delay: 0,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
      },
    }, () => {
      this.immersiveConfImpl?.doWhenAODToScreenLock();
    });

    animateTo({
      duration: 0
    }, () => {
      if (this.aodStyle) {
        this.aodStyle.isKgWallpaperScale = true;
      }
    });
  }
}

class OneMirrorSceneTransfer {
  public fromScene?: MirrorScene;
  public toScene?: MirrorScene;
  public stage?: MirrorsScene;
}

export class OneMirrorSceneData {
  private static readonly transferDataReset: OneMirrorSceneTransfer[] = [
    {
      fromScene: MirrorScene.SCREEN_LOCK,
      toScene: MirrorScene.AOD,
      stage: MirrorsScene.SL_TO_AOD
    },
    {
      fromScene: MirrorScene.UNLOCK,
      toScene: MirrorScene.AOD,
      stage: MirrorsScene.DESKTOP_TO_AOD
    },
    {
      fromScene: MirrorScene.SCREEN_OFF,
      toScene: MirrorScene.UNLOCK,
      stage: MirrorsScene.AOD_TO_DESKTOP
    },
    {
      fromScene: MirrorScene.AOD,
      toScene: MirrorScene.UNLOCK,
      stage: MirrorsScene.AOD_TO_DESKTOP
    },
    {
      fromScene: MirrorScene.SCREEN_LOCK,
      toScene: MirrorScene.UNLOCK,
      stage: MirrorsScene.SCREEN_LOCK_TO_UNLOCK
    },
    {
      fromScene: MirrorScene.AOD,
      toScene: MirrorScene.SCREEN_OFF,
      stage: MirrorsScene.SCREEN_OFF_TO_SL
    }
  ];
  private static readonly transferDataAnim: OneMirrorSceneTransfer[] = [
    {
      fromScene: MirrorScene.SCREEN_LOCK,
      toScene: MirrorScene.AOD,
      stage: MirrorsScene.SL_TO_AOD
    },
    {
      fromScene: MirrorScene.UNLOCK,
      toScene: MirrorScene.AOD,
      stage: MirrorsScene.DESKTOP_TO_AOD
    },
    {
      fromScene: MirrorScene.SCREEN_OFF,
      toScene: MirrorScene.SCREEN_LOCK,
      stage: MirrorsScene.SCREEN_OFF_TO_SL_END
    },
    {
      fromScene: MirrorScene.SCREEN_OFF,
      toScene: MirrorScene.UNLOCK,
      stage: MirrorsScene.AOD_TO_DESKTOP
    },
    {
      fromScene: MirrorScene.AOD,
      toScene: MirrorScene.SCREEN_LOCK,
      stage: MirrorsScene.AOD_TO_SL
    },
    {
      fromScene: MirrorScene.AOD,
      toScene: MirrorScene.UNLOCK,
      stage: MirrorsScene.AOD_TO_DESKTOP
    },
    {
      fromScene: MirrorScene.SCREEN_LOCK,
      toScene: MirrorScene.SCREEN_OFF,
      stage: MirrorsScene.SL_TO_SCREEN_OFF
    },
    {
      fromScene: MirrorScene.UNLOCK,
      toScene: MirrorScene.SCREEN_OFF,
      stage: MirrorsScene.DESKTOP_TO_SCREEN_OFF
    },
    {
      fromScene: MirrorScene.UNLOCK,
      toScene: MirrorScene.SCREEN_LOCK,
      stage: MirrorsScene.DESKTOP_TO_SL
    }
  ];

  public static getResetMirrorsScene(fromScene: MirrorScene, toScene: MirrorScene): MirrorsScene | undefined {
    return OneMirrorSceneData.transferDataReset.find(item => {
      return item.fromScene === fromScene && item.toScene === toScene;
    })?.stage;
  }

  public static getAnimMirrorsScene(fromScene: MirrorScene, toScene: MirrorScene): MirrorsScene | undefined {
    return OneMirrorSceneData.transferDataAnim.find(item => {
      return item.fromScene === fromScene && item.toScene === toScene;
    })?.stage;
  }
}