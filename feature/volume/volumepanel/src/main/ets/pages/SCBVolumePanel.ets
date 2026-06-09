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

import lazy PCVolumePanelComponent from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/pages/PCVolumePanelComponent';
import VolumeSidePanelComponent from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/pages/VolumeSidePanelComponent';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  ViewType,
  ViewManagerPolicy,
  ViewCallback
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
} from '@ohos/windowscene';
import {
  BaseViewController,
  PerformanceReporter,
  CurrentMemScene
} from '@ohos/frameworkcommon';
import VolumeWindowController from '@ohos/volumepanelcomponent/src/main/ets/com/ohos/common/VolumeWindowController';


const TAG = 'VolumePanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct SCBVolumePanel {
  persistentId: number = 0;
  private isPhone: boolean = false;
  @State viewController: BaseViewController = new BaseViewController(ViewType.VOLUME);
  private showHideViewCallback: ViewCallback = {
    onShow: () => PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_VOLUME),
    onHide: () => PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_VOLUME)
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear Start persistentId:${this.persistentId}`);
    ViewManagerPolicy.registerViewController(ViewType.VOLUME, this.viewController);
    this.viewController.registerCallback(this.showHideViewCallback);
    this.viewController.updateId(this.persistentId);
    this.isPhone = DeviceHelper.isPhone() || DeviceHelper.isPad();
    VolumeWindowController.getInstance().init();
    this.processTransparentException();
  }

  aboutToDisappear() {
    this.viewController.unRegisterCallback(this.showHideViewCallback);
    log.showInfo(`aboutToDisAppear persistentId:${this.persistentId}`);
    VolumeWindowController.getInstance().destroy();
  }

  build() {
    if (this.isPhone) {
      Column() {
        VolumeSidePanelComponent()
      }
      .width(this.viewController.getArea().width)
      .height(this.viewController.getArea().height)
      .hitTestBehavior(this.isPhone ? HitTestMode.Transparent : HitTestMode.Default)
    } else {
      PCVolumePanelComponent({
        persistentId: this.persistentId,
        volumePanelCtrl: this.viewController
      })
    }
  }

  private processTransparentException(): void {
    // SCBVolumePanel 零层透明异常处理
    let sCBSceneSessionManagertInstance: SCBSceneSessionManager | null = globalThis.SCBSceneSessionManagerInstance;
    let systemSceneSession = sCBSceneSessionManagertInstance?.getSystemSceneSessionWithId(this.persistentId);
    systemSceneSession?.registerContextTransparentCallback(() => {
      log.showInfo('SCBVolumePanel is transparency!!');
    })
  }
}
