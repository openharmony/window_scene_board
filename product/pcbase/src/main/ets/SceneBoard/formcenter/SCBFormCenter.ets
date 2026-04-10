/**
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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewType, viewMgrPolicy, ViewCallback, ViewArea, } from '@ohos/frameworkwrapper';
import {
  FormCenterLocation,
  FormCenterViewManager,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormManagerView } from '@ohos/form/src/main/ets/formcenter/view/FormManagerView';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'SCBFormCenter'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SEARCH, TAG);
const DELAY_SKIP_DRAW: number = 50;
const SCENE_PANEL_ZINDEX: number = 1998;

@Component
export struct SCBFormCenter {
  private persistentId: number = 0;
  private childSet: Set<string> = new Set();
  private timeoutId: number = CommonConstants.INVALID_VALUE;
  private hotAreaMap: Map<string, number> = new Map();
  private childViewCallback: ViewCallback = {
    onShow: (component: string) => {
      log.showInfo(`${component} onShow`);
      this.childSet.add(component);
      this.mViewController.setTouchable(true);
      if (this.timeoutId >= 0) {
        clearTimeout(this.timeoutId);
        this.timeoutId = CommonConstants.INVALID_VALUE;
      }
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(false);
    },
    onHide: (component: string) => {
      log.showInfo(`${component} onHide`);
      this.childSet.delete(component);
      this.hotAreaMap.delete(component);
      if (this.childSet.size === 0) {
        this.mViewController.setTouchable(false);
        this.timeoutId = setTimeout(() => {
          this.timeoutId = CommonConstants.INVALID_VALUE;
          if (this.childSet.size === 0) {
            SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(true);
          }
        }, DELAY_SKIP_DRAW);
      }
    },
  };
  private screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screen width: ${screenProperty.width}, screen height: ${screenProperty.height}`);
    let newRect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    };

    this.mViewController.updateRect(newRect);
  };
  @Link screenProp: SCBScreenProperty;
  @State mViewController: BaseViewController = new BaseViewController(ViewType.FORM_CENTER);

  aboutToAppear() {
    log.showInfo(`aboutToAppear ${this.persistentId}`);
    this.mViewController.updateId(this.persistentId);
    this.mViewController.show();
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    this.mViewController.setTouchable(false);
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)?.setSkipDraw(true);
    viewMgrPolicy.registerViewController(ViewType.FORM_CENTER, this.mViewController);
    FormCenterViewManager.getInstance().updateZIndexOfLocation(FormCenterLocation.SCENE_PANEL, SCENE_PANEL_ZINDEX);
  }

  aboutToDisappear() {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    viewMgrPolicy.unregisterViewController(ViewType.FORM_CENTER);
    log.showInfo('aboutToDisappear');
  }

  build() {
    Stack() {
      FormManagerView({ mViewStateChangeCallback: this.childViewCallback })
    }
    .id(`${TAG}_Stack`)
    .height('100%')
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .backgroundColor(Color.Transparent)
  }
}
