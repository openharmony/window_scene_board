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

import { Log } from '@ohos/basicutils';
import {
  PluginSlot,
  PluginWindowType,
  EvtBus,
  EventManager,
  ViewArea,
  ViewType,
  viewMgrPolicy,
  ViewCallback
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { LocalWindowManager } from '@ohos/systemuicommon';
import {
  NormalPanelInfo,
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import StyleConfiguration, {
  CameraComponentCommonStyle,
  CameraComponentContentStyle
} from '../common/StyleConfiguration';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'CameraPanel-Index';
const WINDOW_NAME = PluginSlot.SLOT_STATUS_CAMERA;


@Component
export struct SCBCameraPanel {
  @Provide persistentId: number = 0;
  @State cameraCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.CAMERA_PANEL);
  @State commonStyle: CameraComponentCommonStyle = StyleConfiguration.getCameraComponentCommonStyle();
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private viewCallback: ViewCallback = {
    onShow: () => this.onViewShow(),
    onHide: () => this.onViewHide()
  };

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.CAMERA_PANEL, this.cameraCtrl);
    this.cameraCtrl.registerCallback(this.viewCallback);
    this.cameraCtrl.updateId(this.persistentId);
    this.cameraCtrl.registerCallback(this.viewCallback);
    this.cameraCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE),
      height: vp2px(LocalWindowManager.PC_CAMERA_PANEL_HEIGHT)
    };
    this.cameraCtrl.updateArea(rect);
    this.cameraCtrl.updateRect(rect);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    this.cameraCtrl.unRegisterCallback(this.viewCallback);
    this.cameraCtrl.unRegisterFocusCallback();
  }

  private onViewShow(): void {
    this.updateCameraPanelWindow();
    Log.showInfo(TAG, `[onViewShow]:window show!`);
  }

  private onViewHide(): void {
    Log.showInfo(TAG, `[onViewHide]:window hide!`);
  }

  updateCameraPanelWindow() {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let updateRect: ViewArea = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE),
      height: vp2px(LocalWindowManager.PC_CAMERA_PANEL_HEIGHT)
    };
    Log.showInfo(TAG, `[updateCameraPanelWindow]: updateRect: ${JSON.stringify(updateRect)}`);
    windowMgr.updateWindowPosition(WINDOW_NAME, updateRect);
  }

  build() {
    Flex() {
      CameraPanel()
    }
    .width(this.cameraCtrl.getArea().width)
    .height(this.cameraCtrl.getArea().height)
    .borderRadius(this.panelInfo?.panelRadius)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
  }
}


@Component
struct CameraPanel {
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      CenterTitle()
      CameraPanelContent()
    }
    .width('100%')
  }
}

@Component
struct CenterTitle {
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State cameraTitleStyle: CameraComponentCommonStyle = StyleConfiguration.getCameraComponentCommonStyle();

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    Log.showInfo(TAG, `CameraPanelTitle aboutToAppear Start`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `CameraPanelTitle aboutToDisappear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        Text($r('app.string.camera_panel_title')).draggable(false)
          .fontColor(this.panelInfo?.titleTextColor)
          .fontSize(this.panelInfo?.titleTextSize)
          .fontWeight(FontWeight.Bold)
      }
      .width(this.cameraTitleStyle.pcCameraPanelTitleContainerWidth)
      .height(this.cameraTitleStyle.pcCameraPanelTitleContainerHeight)
      .margin({
        left: this.cameraTitleStyle.pcCameraPanelTitleMarginLeft,
      })
    }
    .width('100%')
    .height(this.cameraTitleStyle.pcCameraPanelTitleHeight)
  }
}

@Component
struct CameraPanelContent {
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @StorageLink('useCameraAppName') useCameraAppName: string = '';
  @StorageLink('useCameraAppIcon') useCameraAppIcon: string = '';
  @State cameraTitleStyle: CameraComponentContentStyle = StyleConfiguration.getCameraComponentContentStyle();

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    Log.showInfo(TAG, `CameraPanelContent aboutToAppear Start ${this.useCameraAppName}`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `CameraPanelContent aboutToDisappear Start`);
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Image(this.useCameraAppIcon)
          .draggable(false)
          .width(this.cameraTitleStyle.pcCameraPanelIconWidth)
          .height(this.cameraTitleStyle.pcCameraPanelIconHeight)
          .interpolation(ImageInterpolation.Medium)
          .margin({
            left: this.cameraTitleStyle.pcCameraPanelIconMarginLeft
          })
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text($r('app.string.camera_use_info', `${this.useCameraAppName}`)).draggable(false)
            .fontWeight(FontWeight.Medium)
            .fontSize(this.panelInfo?.listTextSize)
            .fontColor(this.panelInfo?.listTextColor)
        }
        .width(this.cameraTitleStyle.pcCameraPanelTextContainnerWidth)
        .height(this.cameraTitleStyle.pcCameraPanelTextContainnerHeight)
        .margin({
          left: this.cameraTitleStyle.pcCameraPanelTextMarginLeft,
        })
      }
      .width(this.cameraTitleStyle.pcCameraPanelContentContainerWidth)
      .height(this.cameraTitleStyle.pcCameraPanelContentContainerHeight)
      .borderRadius(this.cameraTitleStyle.pcCameraPanelContentContainerRadius)
    }
    .height(this.cameraTitleStyle.pcCameraPanelContentHeight)
    .width('100%')
  }
}