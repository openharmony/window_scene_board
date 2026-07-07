/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { SCBSystemSceneSession, SCBScenePanelManager, SCBBackgroundBlurSession } from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon';
import { UIExceptionDetection, UIExceptionType } from '@ohos/windowscene/Index';
import {
  UIExceptionParams,
  BackgroundBlurExceptionParams
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { CommonUtils } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'BackgroundBlurView';

@Component
export struct BackgroundBlurView {
  private panelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
  @State session: SCBBackgroundBlurSession = this.panelManager.getBackgroundBlurSession();
  getBlurSceneSession?: () => SCBSystemSceneSession;
  onDisappear?: () => void;
  blurSceneSession?: SCBSystemSceneSession;
  @Link isBgGrayScaleDisable: boolean;

  aboutToAppear(): void {
    this.blurSceneSession = this.getBlurSceneSession?.();
    UIExceptionDetection.getInstance().registerUIExceptionCallback(UIExceptionType.BACKGROUND_BLUR, {
      exceptionDetection: () => {
        // scale不为0且颜色不是透明
        return !CommonUtils.equals(this.session.bgBlurScale, 0) &&
          this.session.bgBlurColor !== SCBConstants.DEFAULT_SCENE_BG_COLOR;
      },
      exceptionRestore: (): void => {
        let callerName: string = 'exceptionRestore';
        this.panelManager.disableBlurComponent(callerName);
        this.panelManager.onBlurTransitionInactive(callerName);
      },
      getExceptionParams: (): UIExceptionParams => {
        let param: BackgroundBlurExceptionParams = {
          BLUR_SCALE: this.session.bgBlurScale,
          BLUR_COLOR: this.session.bgBlurColor
        };
        return param;
      },
    });
  }

  aboutToDisappear(): void {
    UIExceptionDetection.getInstance().unRegisterUIExceptionCallback(UIExceptionType.BACKGROUND_BLUR);
    this.onDisappear?.();
  }

  build() {
    WindowScene(this.blurSceneSession?.session.persistentId) {
      Stack()
        .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
        .backgroundEffect({
          policy: 1,
          radius: StyleConstants.STYLE_BG_LARGE_LIGHT * this.session.bgBlurScale,
          saturation: 1.0 + 0.2 * this.session.bgBlurScale,
          brightness: 1,
          color: this.session.bgBlurColor,
          blurOptions: {
            grayscale: this.isBgGrayScaleDisable ? [0, 0] :
              [38 * this.session.bgBlurScale, 64 * this.session.bgBlurScale]
          }
        }, { disableSystemAdaptation: true })
    }
    .focusable(false)
    .enabled(false)
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
  }
}