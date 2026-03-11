/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBScreenProperty, SCBSceneContainerSession, ScenePanelState, SCBSpecificSession,
  SCBSplitParam, INVALID_PID,
  SCBSceneSession} from '@ohos/windowscene';
import { SCBSpecificScene } from './SCBSpecificScene';
import { SplitState, NeedTrackSplitState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { SingleContext } from '@ohos/basicutils';

@Component
export struct SCBSpecificSceneRefresh {
  @ObjectLink specificSession: SCBSpecificSession;
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @Link screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @ObjectLink needTrackSplitState: NeedTrackSplitState;
  @ObjectLink parentSceneSession: SCBSceneSession | null;
  getScreenDpiDensity: Function = (): number => 0;

  private showSubWindow(): boolean {
    let isShow: boolean = this.specificSession.isActive || this.needTrackSplitState.state !== SplitState.EXIT_SPLIT;
    return isShow;
  }

  build() {
    if (this.showSubWindow()) {
      SCBSpecificScene({
        specificSession: this.specificSession,
        screenProperty: $screenProperty,
        singleContext: this.singleContext,
        rect: this.specificSession.currRect,
        parentRect: this.parentSceneSession?.currRect,
        parentSceneSession: this.parentSceneSession,
        getScreenDpiDensity: this.getScreenDpiDensity,
        subWindowAnchorInfo: this.specificSession.subWindowAnchorInfo,
      })
    }
  }
}
