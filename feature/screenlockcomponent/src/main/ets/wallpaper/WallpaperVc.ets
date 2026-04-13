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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AnimationType, themeWallpaperAniMgr } from '@ohos/themeservice';
import { slWallpaperMgr, SLWallpaperState } from '@ohos/screenlockcommon';
import { SlViewController, StateTransferAction } from '@ohos/screenlockcommon/Index';
import {
  MirrorScene,
  MirrorSceneUtils,
  OneMirrorListener,
  OneMirrorService
} from '../onemirror/service/OneMirrorService';

const TAG = 'WallpaperViewControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const WALLPAPER_LIGHT_UP_EFFECT_START = 0;
const WALLPAPER_LIGHT_UP_EFFECT_END = 1;
const WALLPAPER_SCALE_DEFAULT = 1;
const WALLPAPER_RATE = 1.05;

const SCREEN_ON_ANIMATION_DURATION = 400;

const IS_PAD: boolean = DeviceHelper.isPadOr2in1PcType();

/**
 * View Control里用于操作渲染界面的对象
 */
export interface WallpaperOperateParams {
  slWallpaperState: SLWallpaperState;
}

/**
 * wallpaper view control
 *
 * @since 2024-08-31
 */
export class WallpaperVc extends SlViewController<MirrorScene> {
  private slWallpaperState: SLWallpaperState;

  private readonly _oneMirrorListener: OneMirrorListener = {
    onMirrorScene: (fromScene: MirrorScene, toScene: MirrorScene): boolean => {
      this.triggerStateTransferAction(fromScene, toScene);
      return false;
    }
  }

  private readonly _screenOnTransferAction: StateTransferAction<MirrorScene> = {
    isStateTransferMatched: (oldState: MirrorScene, newState: MirrorScene): boolean => {
      return MirrorSceneUtils.isScreenOffScene(oldState) && !MirrorSceneUtils.isScreenOffScene(newState);
    },
    prepareAction: () => {
      this.resetWallpaperParams();
    },
    targetAction: () => {
      this.startScreenOnAnimation();
      if (IS_PAD) {
        log.showInfo('pad screenlock receive screen on');
        themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
          animationType: AnimationType.WALLPAPER_SCREEN_ON_PAD
        });
      }
    }
  };

  private readonly _screenOffTransferAction: StateTransferAction<MirrorScene> = {
    isStateTransferMatched: (oldState: MirrorScene, newState: MirrorScene): boolean => {
      return MirrorSceneUtils.isScreenOffScene(newState) && !MirrorSceneUtils.isScreenOffScene(oldState);
    },
    prepareAction: () => {
      this.resetWallpaperParams();
    },
    targetAction: () => {
      if (IS_PAD) {
        log.showInfo('pad screenlock receive screen off end');
        themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
          animationType: AnimationType.WALLPAPER_SCREEN_OFF_PAD
        });
      }
    }
  };

  constructor(params: WallpaperOperateParams) {
    super();
    this.slWallpaperState = params.slWallpaperState;
  }

  protected doInit(): void {
    // 监听一镜到底
    OneMirrorService.getInstance().registerObserver(this._oneMirrorListener);
    this.registerStateTransferAction(this._screenOnTransferAction);
    this.registerStateTransferAction(this._screenOffTransferAction);
    super.doInit();
  }

  protected doRelease(): void {
    super.doRelease();
    this.unRegisterStateTransferAction(this._screenOnTransferAction);
    this.unRegisterStateTransferAction(this._screenOffTransferAction);
    // 取消监听一镜到底
    OneMirrorService.getInstance().unRegisterObserver(this._oneMirrorListener);
  }

  private resetWallpaperParams(): void {
    log.showInfo(`reset wallpaper params`);
    animateTo({ duration: 0 }, () => {
      this.slWallpaperState.light = OneMirrorService.getInstance().isAodShowing()
        ? WALLPAPER_LIGHT_UP_EFFECT_END : WALLPAPER_LIGHT_UP_EFFECT_START;
      this.slWallpaperState.wallpaperScale = WALLPAPER_SCALE_DEFAULT * WALLPAPER_RATE;
      slWallpaperMgr.setSlWallpaperBlurByAnimStart();
    })
  }

  private startScreenOnAnimation(): void {
    log.showInfo('ScreenOnAnimation start.');
    Trace.start(Trace.CORE_METHOD_SCREEN_ON_ANIMATION);
    animateTo({
      duration: SCREEN_ON_ANIMATION_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        log.showInfo('ScreenOnAnimation end.');
        Trace.end(Trace.CORE_METHOD_SCREEN_ON_ANIMATION);
      }
    }, () => {
      this.slWallpaperState.light = WALLPAPER_LIGHT_UP_EFFECT_END;
      this.slWallpaperState.wallpaperScale = WALLPAPER_SCALE_DEFAULT;
      slWallpaperMgr.setSlWallpaperBlurByAnimEnd();
    })
  }
}
