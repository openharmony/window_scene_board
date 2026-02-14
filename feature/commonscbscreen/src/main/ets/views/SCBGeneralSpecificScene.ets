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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBScreenProperty, SCBSessionRect, SCBSpecificSceneSessionList, SCBSpecificSession } from '@ohos/windowscene';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import { SCBGeneralSpecificSceneViewModel } from '../viewmodel/SCBGeneralSpecificSceneViewModel';

const TAG = 'SCBGeneralSpecificScene';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBGeneralSpecificScene {
  @ObjectLink screenProperty: SCBScreenProperty;
  @ObjectLink specificSession: SCBSpecificSession;
  @State rect: SCBSessionRect = this.specificSession.currRect;
  @State subSessionList: SCBSpecificSceneSessionList = this.specificSession.subSessionList;

  private sceneViewModel = new SCBGeneralSpecificSceneViewModel(this.specificSession, this.screenProperty);

  aboutToAppear(): void {
    log.showInfo(`id:${this.specificSession?.persistentId} aboutToAppear`);
    this.sceneViewModel.uiContext = this.getUIContext();
    this.sceneViewModel.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`id:${this.specificSession?.persistentId} aboutToDisappear`);
    this.sceneViewModel.release();
  }

  enableShow(): boolean {
    log.showInfo(`enableShow id: ${this.specificSession?.session?.persistentId}` +
      `, type: ${this.specificSession?.session?.type} active: ${this.specificSession?.isActive}`);
    return this.specificSession?.isActive;
  }

  getZIndex(): number {
    return 0;
  }

  getSize(): SizeOptions {
    if (this.specificSession.isFollowParentRect) {
      return { width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 };
    }
    return { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() };
  }

  getPosition(): Position | Edges | LocalizedEdges {
    if (this.specificSession.isFollowParentRect) {
      return { x: 0, y: 0 };
    }
    return { x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() };
  }

  @Builder
  specificSceneBuilder($$: SCBSpecificSceneSessionList) {
    ForEach($$, (item: SCBSpecificSession) => {
      if (item !== null) {
        SCBGeneralSpecificScene({
          screenProperty: this.screenProperty,
          specificSession: item,
          subSessionList: item.subSessionList
        })
      }
    }, (item: SCBSpecificSession) => item.session.persistentId.toString())
  }

  build() {
    if (this.enableShow()) {
      WindowScene(this.specificSession?.persistentId)
        .zIndex(this.getZIndex())
        .position(this.getPosition())
        .size(this.getSize())
        .id(`SpecificScene${this.specificSession?.persistentId}`)
        .visibility(this.specificSession?.visibility ? Visibility.Visible : Visibility.Hidden)
        .focusable(this.specificSession?.isFocusable)
        .hitTestBehavior(this.specificSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .borderRadius(this.specificSession?.specialBoarderRadius)
        .clip(this.specificSession?.specialBoarderRadius > 0 ? true : false)
        .shadow({
          radius: this.specificSession?.shadowConfig.radius,
          color: this.specificSession?.shadowConfig.color,
          offsetX: this.specificSession?.shadowConfig.offsetX,
          offsetY: this.specificSession?.shadowConfig.offsetY
        })
        .transition(WindowAnimationUtils.getInstance().getTransitionEffect(this.specificSession, this.rect))
        .opacity(this.specificSession?.opacity)

      if (this.subSessionList.length !== 0) {
        this.specificSceneBuilder(this.subSessionList)
      }
    }
  }
}