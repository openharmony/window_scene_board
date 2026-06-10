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

import { Want } from '@kit.AbilityKit';
import { SCBSceneInfo, SCBSceneSession, SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';

@Component
export struct LauncherScene {
  @Prop screenId: number;
  @State launcherSession: SCBSceneSession | undefined = undefined;

  private initLauncher(): void {
    const bundleName = 'com.ohos.visionglass';
    const moduleName = 'entry';
    const abilityName = 'AppCenterAbility';
    const want: Want = {
      bundleName: bundleName,
      abilityName: abilityName,
      moduleName: moduleName,
    };
    const sceneInfo = new SCBSceneInfo(bundleName, moduleName, abilityName);
    sceneInfo.screenId = this.screenId;
    sceneInfo.want = want;
    const session = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
    sceneInfo.persistentId = session.persistentId;
    this.launcherSession = new SCBSceneSession(session, sceneInfo);
    this.launcherSession.session.setZOrder(1000);
    SCBSceneSessionManager.getInstance().requestSceneSessionActivation(this.launcherSession.session, true);
  }

  aboutToAppear(): void {
    this.initLauncher();
  }

  aboutToDisappear(): void {
    this.launcherSession?.requestSessionDestruction(true);
  }

  build() {
    if (this.launcherSession) {
      Stack({ alignContent: Alignment.TopStart }) {
        WindowScene(this.launcherSession.session.persistentId)
          .width(this.launcherSession.width.getPx() === 0 ? '100%' : this.launcherSession.width.getPxStr())
          .height(this.launcherSession.height.getPx() === 0 ? '100%' : this.launcherSession.height.getPxStr())
          .position({
            x: this.launcherSession.positionX.getPxStr(),
            y: this.launcherSession.positionY.getPxStr()
          })
          .id(`session${this.launcherSession.session.persistentId}`)
          .focusable(this.launcherSession.isFocusable)
          .hitTestBehavior(this.launcherSession.isTouchable ? HitTestMode.Default : HitTestMode.None)
          .clip(true)
      }
    }
  }
}