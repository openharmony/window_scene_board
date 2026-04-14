/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import {
  SCBSceneContainerSession,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { SingletonHelper } from '@ohos/basicutils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG = 'RecentForegroundBlurAniMgr';

export class RecentForegroundBlurAniMgr {
  // 产品配置，多任务进入退出是否需要支持前景模糊效果
  private supportForegroundBlur: boolean = systemParameterEnhance.getSync('const.recent.support_foregroundblur',
    'false') === 'true';
  private isFoldExpand: boolean = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();

  private disableForegroundBlur: boolean =
    SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.FOREGROUND_BLUR_DISABLE);

  public static getInstance(): RecentForegroundBlurAniMgr {
    return SingletonHelper.getInstance(RecentForegroundBlurAniMgr, TAG);
  }

  public isForegroundEffectSupport(): boolean {
    return !this.isFoldExpand && this.supportForegroundBlur;
  }

  public startForegroundBlurAnimation(containerSession: SCBSceneContainerSession | undefined,
    startBlurRadius: number, dependsConfig: boolean): void {
    if (!this.disableForegroundBlur && (!dependsConfig || this.isForegroundEffectSupport())) {
      containerSession?.needRenderBlurRadius.setBlurRadiusWithDfx(startBlurRadius, TAG, 'setForegroundBlurRadius', '');
    }
  }

  public stopForegroundBlurAnimation(containerSession: SCBSceneContainerSession | undefined): void {
    if (this.isForegroundEffectSupport()) {
      containerSession?.needRenderBlurRadius.reset();
    }
  }

  public updateFoldExpandStatus(expandStatus: boolean) {
    this.isFoldExpand = expandStatus;
  }
}